From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Thu, 15 Jan 2009 21:43:45 +0100
Message-ID: <496FA001.1000501@s5r6.in-berlin.de>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp> <496E4B93.4000507@cybernetics.com> <20090114213917.GB22543@kroah.com> <496E6853.1010005@s5r6.in-berlin.de> <496E6CE1.9040404@cybernetics.com> <496E7993.70307@s5r6.in-berlin.de> <496F4C7B.2030707@cybernetics.com> <496F62CC.8000007@s5r6.in-berlin.de> <496F7DB6.6090506@cybernetics.com> <496F84AA.9060708@s5r6.in-berlin.de> <496F8C91.9050208@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933746AbZAOUoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 15:44:09 -0500
In-Reply-To: <496F8C91.9050208@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Greg KH <greg@kroah.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

Tony Battersby wrote:
> It does work because kref_get_not_zero() must be called while holding a
> lock that prevents the destructor from freeing the memory
[...]
> lock data structure
> find object
> kref_get_not_zero() returns false
> forget object
> unlock data structure

I have three comments to that.  1.:

What are locks for?

They serialize accesses to data, in order to protect the data from
invalid modifications due to concurrent accesses.

The sg_index_lock for example protects the data structures sg_index_idr
and sdp->headfp from invalid modifications.  (This can be seen quickly
from the comment at the definition of sg_index_lock or from looking at
the occurrences of sg_index_lock in the code.)

What are reference counters for?

Well, the name says it.  I'd better ask:  What is reference counting
for?  Of course to prevent premature destruction of objects; IOW to
implement lifetime rules.

Locks don't implement lifetime rules.  They only implement serialization
of accesses.

Now, data structures like sg_index_idr have a possibly confusing
relevance to lifetimes of other objects:  sg_index_idr contains
references to those objects.  Whoever has read access to sg_index_idr
has the ability to copy references.  Due to that, sg_index_lock happens
to influence /when/ such copies can be made.  If you want you can
implement some decisions whether to allow such copies inside the lock.

But note:  The lock's influence is incomplete!  Once a copy of a
reference has it made out of the serialized region, it can be again
copied at will.

Hence, lock's don't implement lifetime rules.  They only implement
serialization of data accesses.

In your case, you want to extend sg_index_lock's purposes to also
serialize access to a state variable of the sg device objects.  Nothing
wrong with that, as long as you and, later on, readers of your code are
aware what is going on.

But I suspect you aren't 100% aware what you are doing:  You are
speaking of "a lock that prevents the destructor from freeing the
memory".  That's not precise.  If anything, the *state variable*
prevents the destructor from doing its thing.  The lock only serializes
accesses to the state variable.

2.:

Your kref_get_not_zero() tries to use private data of struct kref as a
state variable of the object.  That's wrong because kref is a reference
counter, not a bitfield to memorize whatever object-specific states that
could exist.

The kref is the number of existing references.  It's not saying anything
about an object's state.  Its saying something about the state of users
of the object:  There are this many users who aren't done yet.

It can't be a good thing to confuse these independent matters.

3.:

There can be only one correct variant of kref_get...():

void kref_get(struct kref *kref)
{
	WARN_ON(!atomic_read(&kref->refcount));
	atomic_inc(&kref->refcount);
	smp_mb__after_atomic_inc();
}

WARN_ON says:  Here is a kernel bug!  And the above WARN_ON is straight
to the point.

Why is it a bug to call kref_get when the reference count is already 0?
Simple:  If you can kref_get an object, then it's because you got hold
of a reference which you are now trying to copy.  One reference is more
than zero references!  If your code works correctly, then there are no
references lying around anywhere anymore at the moment when the
reference count becomes 0.

A kref_get_not_zero() however would only be a valid thing to do if we
say "well, according to our count there are no references anymore, yet
we have a couple references left somewhere, people still use them
(notably to call kref_get_not_zero() on them) --- we don't care, because
our reference count was only a meaningless approximation in the first
place.  Err, wait, why do we do this refcounting thing anyway?"

So, there can't be any legal usage of a kref_get_not_zero().  If
references are counted correctly, kref_get_not_zero() will never ever
come across refcount == 0.
-- 
Stefan Richter
-=====-==--= ---= -====
http://arcgraph.de/sr/
