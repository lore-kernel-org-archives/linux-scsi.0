From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: updates for -bk
Date: Tue, 25 Jan 2005 07:08:01 +0100
Message-ID: <OF742E510B.8CD3239E-ONC1256F94.001F531F-C1256F94.0021A4A7@de.ibm.com>
References: <1106580673.5513.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:15305 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261827AbVAYGIF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 01:08:05 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0P684vU204946
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 06:08:04 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0P684UF147146
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 07:08:04 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0P684WV002814
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 07:08:04 +0100
In-Reply-To: <1106580673.5513.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, willy@www.linux.org.uk

> > > I thought that having release methods that just called kfree() were
> > > also verboten?
> > We do a kmalloc(sizeof(struce device),...) somewhere and this 
> > is how we get rid of it again.
> > How are we supposed to free this object otherwise? The release
> > function gets called when there is no more reference to this
> > object and that's the earliest point we may free it.
> Right, but we've said before this is the wrong way to do it.

I think I missed something. What Greg objected to was that we had used
kfree as the release function. Also he objected to the point that we
were using the pointer to the struct device, which gets passed to the
release function, to free different (larger) objects by using the simple
hack to place the struct device at the beginning of other structs.
This patch does nothing like this. Actually it cleans just all those
things and leftovers up.

> Originally this generic device was part of your adapter structure.  Now
> you're trying to separate it and causing these problems.  What it's

Could you please elaborate where this patch does cause a problem?

> apparently telling us is that you have some problem with the object
> lifetime rules in your code.
> Why should this generic_services device have different lifetime rules
> from the object in which it used to reside?

It doesn't. And this was not supposed to fix anything. It's just that
Andreas liked the code better with allocating the generic_services
struct device seperately. Please note that the lifetime of the adapter
device this struct device was embedded into is always longer than the
lifetime of the generic_services device.
Therefore I can't see why you complain about this piece of code.

Since I didn't get an answer to this:
http://marc.theaimsgroup.com/?l=linux-scsi&m=110551973013105&w=2
my assumption was that it's that obvious to everyone else that I'm
wrong that it isn't even worth writing an answer.
Now I follow Greg's rules and still get complaints...

Thanks,
Heiko

