From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 13:14:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108121309490.3088@dhcp-27-109.brq.redhat.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com> <4E44E8E5.4040707@computerix.info> <4E44EBF4.8050801@gmail.com> <4E44F14F.1020206@computerix.info>
 <4E44F3C9.4030708@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1HLLPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 07:15:14 -0400
In-Reply-To: <4E44F3C9.4030708@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>, dgilbert@interlog.com, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Mark Lord <mlord@pobox.com>

On Fri, 12 Aug 2011, Ric Wheeler wrote:

> On 08/12/2011 10:24 AM, Prof. Dr. Klaus Kusche wrote:
> > On 2011-08-12 11:01, Ric Wheeler wrote:
> > > Lukas has a more generic bulk tool that should do the job and has the
> > > advantage that it does not have to fill the file system first (it can
> > > lock regions and do its work).
> > 
> > Any pointers to that?
> 
> I think that the easiest (and most natural way) to do this is through the
> updated fsck (-K) tool which will discard the unused block ranges when you
> fsck a file system.
> 
> Lukas can add in details about versions, etc :)

Yes, you can use e2fsck to discard unused parst of the file system,
hence reclaiming the space. This feature has been added with
v1.41.12-162-gefa1a35 into e2fsprogs. Note that even though this
operation should be safe, because we do discard at the end of the pass 5
and only if there was not any errors on the file system before, however
this is relatively new feature and has not been extensively tested with
corrupted images.

Hmm, I really should write up this stuff into the web article somewhere
:).

Thanks!
-Lukas


> 
> > 
> > Thanks!
> > 
> > > Note that discard is not just for physical devices like SCSI or ATA, it
> > > is also useful for "software" stacks like various device mapper targets,
> > > virtual block devices, etc so we should be keeping the abstraction at a
> > > high level for our tooling.
> > 
> > I agree, but wiper.sh has been the first such tool and is widespread
> > and well-known. I'm not aware of alternatives using the generic fstrim
> > command (which is still missing on some major distributions)
> > or FITRIM ioctl.
> > 
> 
> FITRIM is somewhat misnamed. It will end up issuing a discard to the storage
> stack, not an ATA specific TRIM command (invoking sb_issue_discard()).
> 
> Anything that uses FITRIM should work if I followed the code correctly,
> 
> Ric
> 
> 
> 
> 
