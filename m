From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tools support for non-512 byte sector sizes
Date: Wed, 30 Jul 2008 18:24:54 +0100
Message-ID: <20080730182454.25809628@lxorguk.ukuu.org.uk>
References: <488F524F.6020905@redhat.com>
	<20080729182611.GB24924@parisc-linux.org>
	<1217356645.6103.48.camel@localhost.localdomain>
	<yq13alsr0g0.fsf@sermon.lab.mkp.net>
	<20080730135147.GA4513@auslistsprd01.us.dell.com>
	<87zlnzb8ce.fsf@rho.meyering.net>
	<20080730172922.GA20191@auslistsprd01.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345AbYG3RoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 13:44:20 -0400
In-Reply-To: <20080730172922.GA20191@auslistsprd01.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Jim Meyering <jim@meyering.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

>    read/modify/write.  T10 and T13 are looking to add commands to
>    expose this different underlying physical sector size so the OS
>    could be aware of it.  This is primarily being driven to mitigate

The identify bits are already there for reporting both size and offset.

> 3) those that report a 4096-byte sector size, and are really a
>    4096-byte size.  This seems ideal for aware OSs.
> 
> Which of 2) or 3) hit the market in mass remains to be seen.  I want
> Linux to be able to handle either painlessly.

I am expecting 3 to turn up some _minor_ problem cases. Many older ATA
controllers magically know the sector size of media and the internal
state machines and FIFO they use for performance is potentially going to
go gaga in this case when we do a PIO transfer.

Alan
