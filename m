From: Douglas Gilbert <dougg@torque.net>
Subject: Re: /dev/hd* in sg_scan
Date: Tue, 28 Oct 2003 23:35:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9F4393.5060602@torque.net>
References: <1067299763.3469.6.camel@patehci2>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts20.bellnexxia.net ([209.226.175.74]:22928 "EHLO
	tomts20-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S261740AbTJ2Efi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 23:35:38 -0500
In-Reply-To: <1067299763.3469.6.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
>>http://tldp.org/HOWTO/SCSI-Generic-HOWTO/open.html
>>... O_NONBLOCK ... ignored by ioctl(SG_IO)
> 
> 
> As of 2.6, in fact we now need O_NONBLOCK if we want open O_RDONLY to
> let us talk SG_IO to a DVD/CD with no disk present?  Also we discard the
> history of passing thru less commands for O_RDONLY than for O_RDWR?
> 
> Reaching those conclusions inspired me to try the following trivial
> inline patch for sg3_utils-1.05/sg_scan.c.  I see this patch brings much
> of /dev/hd* to the notice of sg utils sg_scan.  However, this patch may
> not be ready for prime-time, some of the code I flowed around I do not
> understand.
> 
> Do we intend to make /dev/hd[a-z] available for passing ioctl SG_IO thru
> to ATAPI DVD/CD, in 2.6?  Or for 2.6 do we recommend ab/using some other
> device name?
> 
> Patched sg_scan success here looks like:
> 
> $ sudo sg_scan -i
> /dev/hda: scsi0 channel=0 id=0 lun=0
> /dev/hdc: scsi0 channel=0 id=0 lun=0 [em]
>     LITE-ON   COMBO LTC-48161H  KH0K [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
> /dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=5
>     Iomega    RRD               01.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
> $
> 
> Perhaps the soft bridge from SCSI to ATA HDD in Linux, like some
> FireWire HDD, is an apparently SCSI device that does not support op x12
> Inquiry.

Pat,
Sg3_utils' sg_map and sg_scan for lk 2.6 still have me
thinking (and waiting). Currently sg devices have no
sysfs presence (yes Christoph, I'm still waiting). My
patch to the sg driver to use cdevs (char devices with
sysfs visibility and > 256 minors) seems to fallen foul
of the latest freeze. So scsi tape robots and enclosures
won't have any sysfs visibility.

Now as for /dev/hd and /dev/sd the situation is complex
and probably going to get worse before it get better.
With either /dev/hd and /dev/sd you may soon want to find
out (or probe) before making any assumptions:
   - what protocol are you using (e.g. ATA, ATAPI, SCSI)
   - what transport (e.g. pATA, sATA, SPI, FC, USB, SAS)

Anyways your patch looks interesting and hope to add it
soon (currently I'm rewriting sginfo).

Doug Gilbert

