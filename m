From: Nathan Scott <nathans@sgi.com>
Subject: Re: Adaptec SCSI oddity
Date: Tue, 7 Dec 2004 15:57:44 +1100
Message-ID: <20041207045744.GC1536@frodo>
References: <20041207022348.GB1536@frodo> <068d01c4dc04$ef190230$540a020a@internal.kbs.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:35235 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261754AbULGFBC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2004 00:01:02 -0500
Content-Disposition: inline
In-Reply-To: <068d01c4dc04$ef190230$540a020a@internal.kbs.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul <paul@kbs.net.au>
Cc: linux-scsi@vger.kernel.org

Hi Paul,

On Tue, Dec 07, 2004 at 01:32:02PM +1100, Paul wrote:
> I have seen this problem before with an adaptec U320 controller. The problem
> was caused by using a Ultra160 cable on a Ultra320 controller and disk. The
> kernel driver for some reason reacted really strange.
> The fix I found was to go into the scsi BIOS and set the bus speed from 320
> (or it might be max/auto) to 160 and it worked fine. Of course this means
> you'll be in Ultra160 mode. Onec the kernel booted (somtimes 10 mintues
> later) disk access worked, just very slow, like you reported 3mb/sec tops.

Yep, I have a U320 controller also and a cable that claims to
be U320 capable as well.  After reading your suggestion, I've
been trying different settings in the BIOS and using 160 on just
the 1st channel seems to completely stop these probes/scans from
happening (for all channels, oddly enough), and gets the drives
both up to doing ~65MB/sec direct reads now (hooray!), which is
more like what I'd expected.

15:04 fsgqa@sheila ~ 111> cat /proc/scsi/aic79xx/0 
Adaptec AIC79xx driver version: 1.3.11
Adaptec AIC7902 Ultra320 SCSI adapter
aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Allocated SCBs: 4, SG List Length: 128

Serial EEPROM:
0x17c9 0x17c9 0x17c9 0x17c9 0x17c9 0x17c9 0x17c9 0x17c9 
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x09f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0400 0xb3cf 

Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Transmission Errors 0
        Channel A Target 0 Lun 0 Settings
                Commands Queued 3390
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
        Transmission Errors 0
        Channel A Target 2 Lun 0 Settings
                Commands Queued 3397
                Commands Active 0
                Command Openings 32
                Max Tagged Openings 32
                Device Queue Frozen Count 0
Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT|IU|QAS, 16bit)
Target 8 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 9 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 10 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 11 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 12 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 13 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 14 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 15 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
15:05 fsgqa@sheila ~ 112> cat /proc/scsi/aic79xx/1
Adaptec AIC79xx driver version: 1.3.11
Adaptec AIC7902 Ultra320 SCSI adapter
aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
Allocated SCBs: 4, SG List Length: 128

Serial EEPROM:
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x09f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0400 0xb3c7 

Target 0 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 1 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 2 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 3 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 4 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 5 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 6 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 7 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 8 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 9 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 10 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 11 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 12 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 13 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 14 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Target 15 Negotiation Settings
        User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
15:05 fsgqa@sheila ~ 113> 

cheers.

-- 
Nathan
