From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 11:52:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108121143430.4535@dhcp-27-109.brq.redhat.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com> <4E44E8E5.4040707@computerix.info> <4E44EBF4.8050801@gmail.com>
 <4E44F14F.1020206@computerix.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1HLJwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 05:52:30 -0400
In-Reply-To: <4E44F14F.1020206@computerix.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: Ric Wheeler <ricwheeler@gmail.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Mark Lord <mlord@pobox.com>

On Fri, 12 Aug 2011, Prof. Dr. Klaus Kusche wrote:

> On 2011-08-12 11:01, Ric Wheeler wrote:
> > Lukas has a more generic bulk tool that should do the job and has the
> > advantage that it does not have to fill the file system first (it can
> > lock regions and do its work).
> 
> Any pointers to that?
> 
> Thanks!
> 
> > Note that discard is not just for physical devices like SCSI or ATA, it
> > is also useful for "software" stacks like various device mapper targets,
> > virtual block devices, etc so we should be keeping the abstraction at a
> > high level for our tooling.
> 
> I agree, but wiper.sh has been the first such tool and is widespread
> and well-known. I'm not aware of alternatives using the generic fstrim
> command (which is still missing on some major distributions)
> or FITRIM ioctl.
> 

wiper.sh is just a hack to do rally nasty thing to the filesystam
(allocating all free space), so I have never tried that. But on newer
kernel with FITRIM ioctl and filesystem which implements it, you can
easily use fstrim tool. It is part of the util-linux-ng since
v2.18-165-gd9e2d0d.

Every discard implementation I know of in kernel uses the same
infrastructure so there should be no difference between online (-o
discard) or batched discard (FITRIM) or even between specific file
system implementations. There was some efforts in introducing vectored
discard command support which can batch more extents into the single
command, but IMO it is not anywhere near ready.

Other than that I do no know of any other alternatives.

Thanks!
-Lukas
