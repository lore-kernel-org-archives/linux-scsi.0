From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Thu, 2 Dec 2010 02:48:59 -0700
Message-ID: <201012020249.00367.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <4CE3912E.6060904@tomt.net> <201012012329.54944.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:42146 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab0LBJtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Dec 2010 04:49:10 -0500
In-Reply-To: <201012012329.54944.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On December 1, 2010, Thomas Fjellstrom wrote:
> On November 17, 2010, you wrote:
> > On 11/17/2010 08:53 AM, Thomas Fjellstrom wrote:
> > [snip]
> > 
> > > Still no fatal errors, but the problem is still happening regularly. It
> > > causes a pause in disk io of a couple seconds at least. Really quite
> > > annoying.
> > > 
> > > One thing thats got me wondering, is could this be a power issue?
> > > It almost seems like (from the messages) that a single drive (any
> > > drive) is freaking out, and returning an error that probably shouldn't
> > > happen (no CHS 0?), which could mean the drive is underpowered and the
> > > firmware is flipping out. I'm not entirely sure. The system has a 750w
> > > decent quality Antec power supply. The total power use of the system
> > > shouldn't come over half that (phenom II x4 810 cpu, gigabyte
> > > ma790fxtud5p mb, low profile nvidia 9400GS gpu, 8 sata hdds, 3 fans,
> > > etc). I'm mostly sure the 12v rails are spread out evenly, but I have
> > > yet to make absolutely sure.
> 
> Made absolute sure. I had been worrying that I was overloading one of the
> rails on the PSU, but it turns out that it isn't a multi 12v rail PSU after
> all. The box and advertising says it is, but the electronics inside all say
> its a single 12v rail device.
> 
> > [snip]
> > 
> > After the mvsas update in 2.6.35 this started happening to me as well;
> > at least its better than the previous state - not working.. ;-) However,
> > after rolling a new 2.6.35 with the following fix that is queued up for
> > the upcoming 2.6.35 and 2.6.36 stable releases, they seem to have
> > dissapeared - 3 days and counting.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_
> > pl
> > ain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c92094
> > d95 ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD
> > 
> > The fix is queued up for the next 2.6.36 and 2.6.35 stable
> > point-releases.
> 
> Ahah. I wonder how I missed that when I first read it. I'll have to give
> the stable .36 kernel a try. Thanks!

No fix so far:

[ 2539.040104] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880222f00000 task=ffff88018b3e2980 slot=ffff880222f265d0 slot_idx=x2
[ 2539.040118] drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
[ 2539.040154] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x89800.
[ 2539.040163] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001001
[ 2539.040176] drivers/scsi/mvsas/mv_sas.c 2111:phy7 Unplug Notice
[ 2539.050220] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 2539.050229] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x1001081
[ 2539.071157] drivers/scsi/mvsas/mv_sas.c 2083:port 7 ctrl sts=0x199800.
[ 2539.071165] drivers/scsi/mvsas/mv_sas.c 2085:Port 7 irq sts = 0x10000
[ 2539.071173] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[7]
[ 2539.081142] drivers/scsi/mvsas/mv_sas.c 1224:port 7 attach dev info is 5000002
[ 2539.081142] drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7
[ 2539.081142] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
[ 2541.270047] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[5]:rc= 0
[ 2541.270066] ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[ 2541.270926] ata14: status=0x01 { Error }
[ 2541.271747] ata14: error=0x04 { DriveStatusError }

That appeared after about 42 minutes of uptime.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
