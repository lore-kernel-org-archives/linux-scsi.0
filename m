From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: (resend) scsi0: Unexpected busfree while idle - Adaptec 29160N Ultra160 SCSI adapter
Date: Thu, 26 Jul 2007 00:05:46 +0200
Message-ID: <200707260005.46772.jesper.juhl@gmail.com>
References: <200707090040.32726.jesper.juhl@gmail.com> <9a8748490707141904w5ddc6e03r97c7f0909067d50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:8006 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbXGYWGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 18:06:51 -0400
Received: by ug-out-1314.google.com with SMTP id j3so430438ugf
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2007 15:06:50 -0700 (PDT)
In-Reply-To: <9a8748490707141904w5ddc6e03r97c7f0909067d50@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E. J. Bottomley" <James.Bottomley@steeleye.com>, Andrew Morton <akpm@linux-foundation.org>, James Smart <james.smart@emulex.com>, James.Bottomley@hansenpartnership.com, Jesper Juhl <jesper.juhl@gmail.com>


Resending this since all I'm getting is silence and it's quite a problem for 
this box. I did a few google searches and aparently I'm not the only 
one having this problem - I see reports going back for years, but no 
solutions.

I've got heaps of dmesg output if wanted/needed, I'll test patches, 
suggestions etc. 

Any ideas people?


On Sunday 15 July 2007 04:04:50 Jesper Juhl wrote:
> On 09/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > I just experienced a long hang and a lot of unpleasant messages in dmesg
> > while building randconfig kernels in a loop.
> >
> 
> It just happened again without me doing anything special, just normal
> desktop use, surfing the net, reading email etc. This time the kernel
> version was 2.6.22-g1db6178c
> 
> This time the start of the messages look like this (slightly different
> from last time - quoted below):
> 
> [ 8039.510026] scsi0: Unexpected busfree while idle
> [ 8039.510036] SEQADDR == 0x18
> [ 8069.492318] sr 0:0:4:0: Attempting to queue an ABORT message
> [ 8069.492324] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> [ 8069.492342] scsi0: At time of recovery, card was not paused
> [ 8069.492353] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> [ 8069.492357] scsi0: Dumping Card State while idle, at SEQADDR 0x18
> [ 8069.492362] Card was paused
> [ 8069.492371] ACCUM = 0xa, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x2
> [ 8069.492378] HCNT = 0x0 SCBPTR = 0xb
> [ 8069.492384] SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
> [ 8069.492406] SCSIBUSL[0x0] LASTPHASE[0x1] SCSISEQ[0x1a]
> [ 8069.492426] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10]
> [ 8069.492447] SEQ_FLAGS[0xc0] SSTAT0[0x0] SSTAT1[0x0]
> [ 8069.492467] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
> [ 8069.492487] SIMODE1[0xa4] SXFRCTL0[0x80] DFCNTRL[0x0]
> [ 8069.492507] DFSTATUS[0x89]
> [ 8069.492515] STACK: 0x0 0x164 0x179 0x17
> [ 8069.492536] SCB count = 24
> [ 8069.492540] Kernel NEXTQSCB = 12
> [ 8069.492545] Card NEXTQSCB = 17
> [ 8069.492549] QINFIFO entries: 17 18
> [ 8069.492561] Waiting Queue entries: 11:10
> [ 8069.492573] Disconnected Queue entries:
> [ 8069.492581] QOUTFIFO entries:
> [ 8069.492587] Sequencer Free SCB List: 3 1 13 14 5 6 0 17 10 19 4 8 7
> 2 16 20 18 12 15 9 21 22 23 24 25
>  26 27 28 29 30 31
> [ 8069.492694] Sequencer SCB Info:
> [ 8069.492698]   0 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492723] SCB_TAG[0xff]
> [ 8069.492729]   1 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492753] SCB_TAG[0xff]
> [ 8069.492759]   2 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492784] SCB_TAG[0xff]
> [ 8069.492791]   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492816] SCB_TAG[0xff]
> [ 8069.492822]   4 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492845] SCB_TAG[0xff]
> [ 8069.492851]   5 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492875] SCB_TAG[0xff]
> [ 8069.492880]   6 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492904] SCB_TAG[0xff]
> [ 8069.492910]   7 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492934] SCB_TAG[0xff]
> [ 8069.492940]   8 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492964] SCB_TAG[0xff]
> [ 8069.492969]   9 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.492994] SCB_TAG[0xff]
> [ 8069.493000]  10 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493024] SCB_TAG[0xff]
> [ 8069.493030]  11 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
> [ 8069.493054] SCB_TAG[0xa]
> [ 8069.493060]  12 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493085] SCB_TAG[0xff]
> [ 8069.493090]  13 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493114] SCB_TAG[0xff]
> [ 8069.493120]  14 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493145] SCB_TAG[0xff]
> [ 8069.493150]  15 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493175] SCB_TAG[0xff]
> [ 8069.493181]  16 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493206] SCB_TAG[0xff]
> [ 8069.493212]  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493235] SCB_TAG[0xff]
> [ 8069.493241]  18 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493266] SCB_TAG[0xff]
> [ 8069.493272]  19 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493296] SCB_TAG[0xff]
> [ 8069.493302]  20 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493316] SCB_TAG[0xff]
> [ 8069.493323]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493348] SCB_TAG[0xff]
> [ 8069.493354]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493378] SCB_TAG[0xff]
> [ 8069.493383]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493407] SCB_TAG[0xff]
> [ 8069.493413]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493437] SCB_TAG[0xff]
> [ 8069.493443]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493469] SCB_TAG[0xff]
> [ 8069.493475]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493501] SCB_TAG[0xff]
> [ 8069.493507]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493531] SCB_TAG[0xff]
> [ 8069.493537]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493562] SCB_TAG[0xff]
> [ 8069.493568]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493593] SCB_TAG[0xff]
> [ 8069.493599]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493625] SCB_TAG[0xff]
> [ 8069.493631]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff]
> [ 8069.493656] SCB_TAG[0xff]
> [ 8069.493664] Pending list:
> [ 8069.493669]  18 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
> [ 8069.493687]  17 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> [ 8069.493706]  10 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
> [ 8069.493727] Kernel Free SCB list: 23 22 3 13 16 1 11 14 2 9 8 5 21
> 15 19 0 4 7 6 20
> [ 8069.493780] Untagged Q(4): 10
> [ 8069.493788] Untagged Q(5): 18
> [ 8069.493796]
> [ 8069.493797] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> [ 8069.493819] scsi0:0:4:0: Cmd aborted from QINFIFO
> [ 8069.493892] aic7xxx_abort returns 0x2002
> [ 8079.485432] sr 0:0:4:0: Attempting to queue an ABORT message
> [ 8079.485438] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> [ 8079.485455] scsi0: At time of recovery, card was not paused
> ...
> 
> The complete dmesg log is attached in gzip'ed form.
> 
> 
> 
> > Here's the beginning of the messages (full dmesg output attached)
> >
> > ...
> > [ 9997.057000] scsi0: Unexpected busfree while idle
> > [ 9997.057000] SEQADDR == 0x18
> > [10030.588000] sr 0:0:5:0: Attempting to queue an ABORT message
> > [10030.588000] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> > [10030.588000] scsi0: At time of recovery, card was not paused
> > [10030.588000] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> > [10030.588000] scsi0: Dumping Card State while idle, at SEQADDR 0x18
> > [10030.588000] Card was paused
> > [10030.588000] ACCUM = 0x4, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x1
> > [10030.588000] HCNT = 0x0 SCBPTR = 0xf
> > [10030.588000] SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
> > [10030.588000] SCSIBUSL[0x0] LASTPHASE[0x1] SCSISEQ[0x1a]
> > [10030.588000] SBLKCTL[0xa] SCSIRATE[0x0] SEQCTL[0x10]
> > [10030.588000] SEQ_FLAGS[0xc0] SSTAT0[0x0] SSTAT1[0x0]
> > [10030.588000] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
> > [10030.588000] SIMODE1[0xa4] SXFRCTL0[0x80] DFCNTRL[0x0]
> > [10030.588000] DFSTATUS[0x89]
> > [10030.588000] STACK: 0x0 0x164 0x179 0x17
> > [10030.588000] SCB count = 40
> > [10030.588000] Kernel NEXTQSCB = 31
> > [10030.588000] Card NEXTQSCB = 0
> > [10030.588000] QINFIFO entries: 0 9 28 30 13 19 2 21 25 20 16 17 18 32 34 11 22 7
> > [10030.588000] Waiting Queue entries: 15:4
> > [10030.588000] Disconnected Queue entries:
> > [10030.588000] QOUTFIFO entries:
> > [10030.588000] Sequencer Free SCB List: 3 30 19 23 11 16 25 17 18 10 4 6 26 24 7 28 20 27 12 0 2 8 21 14 22 5 1 31 13 29 9
> > [10030.588000] Sequencer SCB Info:
> > [10030.588000]   0 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   1 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   2 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   4 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   5 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   6 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   7 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   8 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]   9 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  10 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  11 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  12 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  13 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  14 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  15 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0x4]
> > [10030.588000]  16 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  18 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  19 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  20 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  21 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  22 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  23 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  24 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  25 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  26 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  27 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  28 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  29 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  30 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000]  31 SCB_CONTROL[0xe0] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000] SCB_TAG[0xff]
> > [10030.588000] Pending list:
> > [10030.588000]   7 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  22 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  11 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  34 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  32 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  18 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  17 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  16 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  20 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  25 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  21 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]   2 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  19 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  13 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  30 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]  28 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]   9 SCB_CONTROL[0x60] SCB_SCSIID[0x67] SCB_LUN[0x0]
> > [10030.588000]   0 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0]
> > [10030.588000]   4 SCB_CONTROL[0x40] SCB_SCSIID[0x57] SCB_LUN[0x0]
> > [10030.588000] Kernel Free SCB list: 24 10 23 5 3 14 33 1 26 15 35 6 29 12 39 27 8 38 37 36
> > [10030.588000] Untagged Q(4): 0
> > [10030.588000] Untagged Q(5): 4
> > [10030.588000]
> > [10030.588000] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> > [10030.588000] scsi0:0:5:0: Cmd aborted from QINFIFO
> > [10030.588000] aic7xxx_abort returns 0x2002
> > [10040.588000] sr 0:0:5:0: Attempting to queue an ABORT message
> > [10040.588000] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> > [10040.588000] scsi0: At time of recovery, card was not paused
> > ...
> > (see attached file for remaining (long) output)
> >
> >
> > Here's output from scripts/ver_linux :
> >
> > juhl@dragon:~/kernel/linux-2.6$ scripts/ver_linux
> > If some fields are empty or look unusual you may have an old version.
> > Compare to the current minimal requirements in Documentation/Changes.
> >
> > Linux dragon 2.6.22-rc7-g4e99325b #1 SMP PREEMPT Sun Jul 8 21:24:48 CEST 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD GNU/Linux
> >
> > Gnu C                  4.1.2
> > Gnu make               3.81
> > binutils               Binutils
> > util-linux             2.12r
> > mount                  2.12r
> > module-init-tools      3.2.2
> > e2fsprogs              1.39
> > jfsutils               1.1.11
> > reiserfsprogs          3.6.19
> > xfsprogs               2.8.16
> > pcmciautils            014
> > quota-tools            3.13.
> > PPP                    2.4.4
> > Linux C Library        > libc.2.5
> > Dynamic linker (ldd)   2.5
> > Linux C++ Library      6.0.8
> > Procps                 3.2.7
> > Net-tools              1.60
> > Kbd                    1.12
> > oprofile               0.9.2
> > Sh-utils               6.9
> > udev                   111
> > Modules Loaded         dm_mod snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss agpgart lp snd_emu10k1 snd_rawmidi firmware_class snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem via_rhine snd_hwdep ehci_hcd sg evdev k8temp
> >
> 
> except for the slightly newer kernel, the above userspace info is still valid.
> 
> >
> > and here's /proc/scsi/scsi :
> >
> > juhl@dragon:~/kernel/linux-2.6$ cat /proc/scsi/scsi
> > Attached devices:
> > Host: scsi0 Channel: 00 Id: 04 Lun: 00
> >   Vendor: PIONEER  Model: DVD-ROM DVD-305  Rev: 1.03
> >   Type:   CD-ROM                           ANSI  SCSI revision: 02
> > Host: scsi0 Channel: 00 Id: 05 Lun: 00
> >   Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
> >   Type:   CD-ROM                           ANSI  SCSI revision: 02
> > Host: scsi0 Channel: 00 Id: 06 Lun: 00
> >   Vendor: IBM      Model: DDYS-T36950N     Rev: S96H
> >   Type:   Direct-Access                    ANSI  SCSI revision: 03
> >
> 
> This scsi info is still valid.
> 
> >
> > uname -a is :
> >
> > juhl@dragon:~/kernel/linux-2.6$ uname -a
> > Linux dragon 2.6.22-rc7-g4e99325b #1 SMP PREEMPT Sun Jul 8 21:24:48 CEST 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD GNU/Linux
> >
> 
> This is now :
> 
> Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST
> 2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD
> GNU/Linux
> 
> >
> > I have a feeling this may be related to my old problem with machine hangs when
> > building kernels in a loop that I reported back in 2.6.17-2.6.19 times :
> > http://www.webservertalk.com/archive242-2006-11-1692290.html
> >
> > The problem mentioned in the thread above I can still reliably reproduce. All
> > I need to do is use my script to build kernels in a loop and I'll usually get a
> > hang within 10 kernels (with recent versions) or 100 kernels (with pre-2.6.20
> > kernels).
> > One difference between the hangs I've seen previously and this one is that
> > previously I've always use "nice make -j 3" when building the kernels, but
> > this time I edited my script to use just "nice make", thus only using a single
> > core. I suspect this is why my box stayed resonably alive this time - enough
> > for me to be able to capture some dmesg output - instead of just hanging
> > completely like it usually does.
> >
> > If any further information is required, just let me know and I'll be happy to
> > provide it.
> > Any patches you want me to test, just send them my way :-)
> >
> > Getting this finally resolved would be *very* nice :-)
> >
> >
> > (please note that I'm not subscribed to linux-scsi, so please keep me on Cc)
> >
> 
> It seems that since 2.6.22-rc<mid/late-ish> this is getting more
> frequent, but that's just a subjective feeling, quite vague...
> 

Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>



