From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Tue, 25 Jan 2005 19:10:17 +0100
Message-ID: <OF09208441.E1CA6752-ONC1256F94.005CDE81-C1256F94.00647837@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53448 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S262043AbVAYSKW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 13:10:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, Heiko Carstens <Heiko.Carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, willy@www.linux.org.uk





James,

both Heiko and Andreas aren't available for several days.
Let me try to answer your questions.

> You're look to be breaking the simplicity rules.  Object lifetimes are
> very tricky things to manage, so what I want you to explain is why you
> have to make this more difficult buy making the object separately
> managed instead of treating it as a sub object of the adapter which
> shares the adapter's lifetime rules.  What's the justification for
> this?

Actually, you will find the adapter structure be an anchor for several
other objects, or lists of them respectively. We tried to organize
all the driver private data in a sane way. That means there is a tree
of objects representing the SAN topology, including target ports and
subordinate LUNs, many of which have an associated mid-layer structure.
I can't imagine that anybody would ever argue to collapse all that into
the adapter structure. So, why all the fuss about this particular object?
The generic services object has nothing to do with the adapter. It's about
fabric switch services, or certain well-known FC (target) ports, which can
be accessed in the fabric through an adapter. It's not local but remote,
like other targets, so to speak. We might also have chosen to call it
"fabric switch".

> generic devices are supposed to represent existing kernel objects, which
> is why they're usually embedded in existing structures.  It seems to be
> unique within the kernel to allocate a generic device without an
> enveloping structure (like a scsi_device, mca_device, pci_device etc),
> so I was wondering why you need to do it this way?

It gives us a separate subdirectory where to put all the (special)
services ports instead of dumping them all into the adapter's directory
among the other (commonplace) target ports. The latter appear by WWPN
(64 bit, which is supposed to be much more persistent and descriptive),
the former don't even have one, but need to be represented in a different
way, namely by their well-known D_IDs (24 bit, descriptive in their own
way because defined by FC standards).

On the other hand, one might argue that we don't try to group
commonplace target ports by node (which I won't advocate).

Besides, given that the adapter structure is already refcounted, it
might be confusing to have more than one refcount or struct device
within one structure.

> Simplicity says that you want to manage the lifetimes of as few objects
> as you can get away with (SCSI tries to put all lifetime rules in either
> the mid-layer or the transport classes so the driver code doesn't
> usually have to worry about them).  The reason being that lifetime rules
> are very easy to get wrong and have fairly nasty consequences if you do
> get them wrong (pointers into free'd memory etc.).

Agreed. That would be our trade-off.


Martin



|---------+-------------------------------->
|         |           James Bottomley      |
|         |           <James.Bottomley@Stee|
|         |           lEye.com>            |
|         |           Sent by:             |
|         |           linux-scsi-owner@vger|
|         |           .kernel.org          |
|         |                                |
|         |                                |
|         |           25/01/2005 16:20     |
|         |                                |
|---------+-------------------------------->
  >---------------------------------------------------------------------------------------------------------------|
  |                                                                                                               |
  |       To:       Heiko Carstens/Germany/IBM@IBMDE                                                              |
  |       cc:       Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Wilcox      |
  |        <matthew@wil.cx>, willy@www.linux.org.uk                                                               |
  |       Subject:  Re: [PATCH] zfcp: updates for -bk                                                             |
  |                                                                                                               |
  >---------------------------------------------------------------------------------------------------------------|




On Tue, 2005-01-25 at 07:08 +0100, Heiko Carstens wrote:
> > Originally this generic device was part of your adapter structure.  Now
> > you're trying to separate it and causing these problems.  What it's
>
> Could you please elaborate where this patch does cause a problem?

You're look to be breaking the simplicity rules.  Object lifetimes are
very tricky things to manage, so what I want you to explain is why you
have to make this more difficult buy making the object separately
managed instead of treating it as a sub object of the adapter which
shares the adapter's lifetime rules.  What's the justification for
this?

> > apparently telling us is that you have some problem with the object
> > lifetime rules in your code.
> > Why should this generic_services device have different lifetime rules
> > from the object in which it used to reside?
>
> It doesn't. And this was not supposed to fix anything. It's just that
> Andreas liked the code better with allocating the generic_services
> struct device seperately. Please note that the lifetime of the adapter
> device this struct device was embedded into is always longer than the
> lifetime of the generic_services device.
> Therefore I can't see why you complain about this piece of code.

generic devices are supposed to represent existing kernel objects, which
is why they're usually embedded in existing structures.  It seems to be
unique within the kernel to allocate a generic device without an
enveloping structure (like a scsi_device, mca_device, pci_device etc),
so I was wondering why you need to do it this way?

Simplicity says that you want to manage the lifetimes of as few objects
as you can get away with (SCSI tries to put all lifetime rules in either
the mid-layer or the transport classes so the driver code doesn't
usually have to worry about them).  The reason being that lifetime rules
are very easy to get wrong and have fairly nasty consequences if you do
get them wrong (pointers into free'd memory etc.).

James


> Since I didn't get an answer to this:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110551973013105&w=2
> my assumption was that it's that obvious to everyone else that I'm
> wrong that it isn't even worth writing an answer.
> Now I follow Greg's rules and still get complaints...
>
> Thanks,
> Heiko
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



