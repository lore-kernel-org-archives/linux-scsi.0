From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 17:22:36 +0100
Message-ID: <496F62CC.8000007@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53148 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZAOQWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 11:22:38 -0500
In-Reply-To: <496F4C7B.2030707@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> Here is an example the way my patch does it:
> 
> open fd: kref_init(): refcount = 1
> send command: kref_get(): refcount 1 -> 2
> close fd: kref_put(): refcount 2 -> 1
> /proc access begin: idr_find(); kref_get_not_zero(): refcount 1 -> 2
> /proc access end: kref_put(): refcount 2 -> 1
> command completes: kref_put(): refcount 1 -> 0: idr_remove()
> 
> Here is the alternative:
> 
> open fd: kref_init(): refcount = 1
> send command: kref_get(): refcount 1 -> 2
> close fd: idr_remove(); kref_put(): refcount 2 -> 1
> /proc access begin: idr_find(): *** NOT FOUND ***
> command completes: kref_put(): refcount 1 -> 0
> 
> The only obvious places to remove the idr are either from the destructor
> (as done by my patch) or from close (which is what you are probably
> thinking).

I'm not thinking of a particular solution; I'm not familiar with sg.

> If you do it from close, /proc no longer gives information
> about fds that have been closed but still have commands pending.  I
> don't see an obvious way to remove the idr from the command completion
> path before kref_put(), since there can be multiple commands
> outstanding, and we want to leave the idr in place until the last
> command completes.
[...]

I believe your kref_get_not_zero() invention is because you want to
count two unrelated numbers in the same counter.  This won't work, I'm
afraid.

One number is
  - the number of unfinished transactions (request->response)
of an sg device.  (Is that struct sg_device, or struct sg_fd?)

The other number is
  - the number of contexts which peek and poke at the device
representation's memory.  (struct sg_device, or struct sg_fd?)

These two numbers are of course unrelated.  Hence I recommend you count
them in separate counters.

The second counter can be ideally implemented by means of the
<linux/kref.h> API.

The first counter can perhaps be a kref too, or it can be an atomic_t,
or a plain integer which is accessed inside lock-protected regions.
Which of them works best depends on what happens in detail.  Perhaps
kref is a good fit for this as well.

Now, what to do with these counters.

It's entirely obvious how you count the first number:  Inserted a new
request?  ->  t++.  Got a response or timeout or whatever kind of
transaction completion?  ->  t--.

It's also entirely obvious how you count the second number:  The device
representation is created and put into the idr:  ->  ref = 1.  The
reason is of course because there is now one reference to that instance
owned by the idr.  When a /proc user looks into the idr and "borrows"
the instance:  ->  ref++, and when that user is done:  ->  ref--.  The
reason for doing so is that the /proc user did not actually borrow the
reference, it in fact made a copy of the reference.

But that's not all.  A transaction representation obviously refers to
the device instance as well.  So a request gets a ref++ too, and a
response does a ref--.

Well, that's just like what you described above, except that there is
this other independent counter t.

And we need one more thing to finally get all pieces together:  A state
flag which says "device still open? yes/no".  This flag is necessary to
decide when to take the device representation out of the idr:  If the
device is closed _and_ there are no outstanding transactions anymore,
you unregister the device representation from the idr.

You can do a little trick here and combine this flag with the counter t:
Simply say t = 1 for "this device is open and has no outstanding
transactions yet".  Then increment and decrement for requests and
responses.  Also do t-- once on close().  Then t == 0 means "closed and
all transactions completed".  And any t != 0 means of course "there are
t - 1 transactions pending".  You could also shift it all by one and say
"t == -1 means device closed and 0 transactions pending" but the former
way allows you to use the kref API.  (However, if you ever need to know
whether the device is open or closed, independently whether there are
transactions pending or not, then you can't fold this "open?" flag into
the transaction counter t.)

So we already discussed what happens when t drops to 0:  The device
representation is deregistered from the idr.  Of course at this moment
you also do a ref-- because the reference that was owned by the idr has
been deleted now.

And when ref eventually becomes 0, you clean up and kfree() the device
representation, i.e. call its destructor.

(Furthermore, the device representation surely refers to objects of the
SCSI core.  Hence the constructor and destructor of the sg device
representation engage in refcounting of those SCSI core objects.  And I
presume they refcount the sg module, so that sg cannot be unloaded as
long as some context may call sg's functions.)

PS:
In case you need to wait somewhere for a refcount dropping to 0, the
<linux/completion.h> API may be a very good fit.
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
