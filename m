From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Tue, 25 Jan 2005 09:20:37 -0600
Message-ID: <1106666437.6434.19.camel@mulgrave>
References: <OF742E510B.8CD3239E-ONC1256F94.001F531F-C1256F94.0021A4A7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3554 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261978AbVAYPWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 10:22:17 -0500
In-Reply-To: <OF742E510B.8CD3239E-ONC1256F94.001F531F-C1256F94.0021A4A7@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, willy@www.linux.org.uk

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

