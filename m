Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1B8C43215
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87F62230C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKRXEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 18:04:21 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39664 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfKRXEV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 18:04:21 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 331C5283B8;
        Mon, 18 Nov 2019 18:04:17 -0500 (EST)
Date:   Tue, 19 Nov 2019 10:04:17 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO
 transfers
In-Reply-To: <CACz-3rhr_R+_mJpg+Rvgoj=1GC5AO3YKxYxS_0ShAfQ-NiFDtg@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.1.1911190923120.8@nippy.intranet>
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au> <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com> <alpine.LNX.2.21.1.1911180947020.8@nippy.intranet>
 <CACz-3rhr_R+_mJpg+Rvgoj=1GC5AO3YKxYxS_0ShAfQ-NiFDtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Nov 2019, Kars de Jong wrote:

> Op ma 18 nov. 2019 om 00:13 schreef Finn Thain <fthain@telegraphics.com.au>:
> >
> > On Sun, 17 Nov 2019, Kars de Jong wrote:
> > > Are you sure this is really needed?
> > >
> >
> > No. I think it improves robustness and correctness.
> >
> > I would be interested to know whether there is any measurable performance
> > impact on zorro_esp.
> >
> > > The only [time when] the driver reads these registers is after a data
> > > transfer. These are done using DMA on all Zorro boards, so I don't think
> > > there's a risk of stale values from a PIO transfer there.
> > >
> >
> > I'm not entirely sure that the chip is unaffected by stale counter values.
> >
> > (Stale transfer counter values are distinct from stale transfer count
> > register values. Both are addressed by the patch.)
> 
> I still don't see the need to address that in the PIO transfer code.

Well, send_dma_cmd() always initializes those registers. That's fine in 
the DMA case and seems to be the least surprising and cleanest thing to do 
for the PIO case, I think.

> The ESP (when in initiator mode) doesn't use the transfer counter 
> (registers) in PIO mode.
> 
> > If there are DMA controllers out there that can't do very short 
> > transfers then this objection would seem to be invalid, because the 
> > "DMA length is zero!" issue could be tackled using PIO.
> 
> That's the issue you fixed by limiting the transfer size to 65535 bytes, 
> correct?

I was alluding to an unpatched theoretical failure.

The issue would arise when a board driver indicated to the core driver 
that the requested transfer was too small. I'm assuming that it would do 
this by returning zero from esp->ops->dma_length_limit(), which puts us in 
the "DMA length is zero" code path.

The actual failure (that you patched) shows that your board isn't able to 
do short DMA transfers and would require PIO for that.

But this is a theoretical problem so far. You may need to use sg_utils to 
generate a SCSI command like that.

(For a DMA controller subject to, say, 24-bit boundaries, there are 
additional ways to end up with short transfers.)

> The SYM53CF92-X in my Blizzard didn't show this error for the 1 byte
> transfers.
> It just hung up:
> 
>  sdb: RDSK (512) sdb1 (DOS^C)(res 2 spb 1) sdb2 (SWP^@)(res 0 spb 8)
> sdb3 (LNX^@)(res 2 spb 1) sdb4 (LNX^@)(res 2 spb 1)
> sd 1:0:0:0: [sdb] Attached SCSI disk
> EXT4-fs (sdb3): mounting ext3 file system using the ext4 subsystem
> scsi host1: Aborting command [(ptrval):28]
> scsi host1: Current command [(ptrval):28]
> scsi host1:  Active command [(ptrval):28]
> scsi host1: Dumping command log
> scsi host1: ent[6] CMD val[12] sreg[97] seqreg[9c] sreg2[00] ireg[08] ss[00] event[0c]
> scsi host1: ent[7] EVENT val[0d] sreg[91] seqreg[9c] sreg2[00] ireg[08] ss[00] event[0c]
> scsi host1: ent[8] EVENT val[03] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[0d]
> scsi host1: ent[9] CMD val[80] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> scsi host1: ent[10] CMD val[90] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> scsi host1: ent[11] EVENT val[05] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> scsi host1: ent[12] EVENT val[0d] sreg[93] seqreg[cc] sreg2[00] ireg[10] ss[00] event[05]
> scsi host1: ent[13] CMD val[01] sreg[93] seqreg[cc] sreg2[00] ireg[10] ss[00] event[0d]
> scsi host1: ent[14] CMD val[11] sreg[93] seqreg[cc] sreg2[00] ireg[10] ss[00] event[0d]
> scsi host1: ent[15] EVENT val[0b] sreg[93] seqreg[cc] sreg2[00] ireg[10] ss[00] event[0d]
> scsi host1: ent[16] CMD val[12] sreg[97] seqreg[cc] sreg2[00] ireg[08] ss[00] event[0b]
> scsi host1: ent[17] EVENT val[0c] sreg[97] seqreg[cc] sreg2[00] ireg[08] ss[00] event[0b]
> scsi host1: ent[18] CMD val[44] sreg[90] seqreg[cc] sreg2[00] ireg[20] ss[00] event[0c]
> scsi host1: ent[19] CMD val[01] sreg[90] seqreg[cc] sreg2[00] ireg[20] ss[01] event[0c]
> scsi host1: ent[20] CMD val[46] sreg[90] seqreg[cc] sreg2[00] ireg[20] ss[01] event[0c]
> scsi host1: ent[21] EVENT val[0d] sreg[97] seqreg[04] sreg2[00] ireg[18] ss[00] event[0c]
> scsi host1: ent[22] EVENT val[06] sreg[97] seqreg[04] sreg2[00] ireg[18] ss[00] event[0d]
> scsi host1: ent[23] CMD val[01] sreg[97] seqreg[04] sreg2[00] ireg[18] ss[00] event[06]
> scsi host1: ent[24] CMD val[10] sreg[97] seqreg[04] sreg2[00] ireg[18] ss[00] event[06]
> scsi host1: ent[25] EVENT val[0c] sreg[97] seqreg[8c] sreg2[00] ireg[08] ss[00] event[06]
> scsi host1: ent[26] CMD val[12] sreg[97] seqreg[8c] sreg2[00] ireg[08] ss[00] event[0c]
> scsi host1: ent[27] CMD val[44] sreg[90] seqreg[cc] sreg2[00] ireg[20] ss[00] event[0c]
> scsi host1: ent[28] CMD val[01] sreg[97] seqreg[9c] sreg2[00] ireg[0c] ss[00] event[0c]
> scsi host1: ent[29] CMD val[00] sreg[97] seqreg[9c] sreg2[00] ireg[0c] ss[00] event[0c]
> scsi host1: ent[30] CMD val[12] sreg[97] seqreg[9c] sreg2[00] ireg[0c] ss[00] event[0c]
> scsi host1: ent[31] CMD val[10] sreg[97] seqreg[9c] sreg2[00] ireg[10] ss[00] event[0c]
> scsi host1: ent[0] CMD val[12] sreg[97] seqreg[9c] sreg2[00] ireg[08] ss[00] event[0c]
> scsi host1: ent[1] EVENT val[0d] sreg[91] seqreg[9c] sreg2[00] ireg[08] ss[00] event[0c]
> scsi host1: ent[2] EVENT val[03] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[0d]
> scsi host1: ent[3] CMD val[80] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> scsi host1: ent[4] CMD val[90] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> scsi host1: ent[5] EVENT val[05] sreg[91] seqreg[c4] sreg2[00] ireg[10] ss[00] event[03]
> 
> > > The only place the controller reads these registers is when a DMA
> > > command is issued. The only place where that is done is in the zorro_esp
> > > send_dma_command() functions.
> >
> > Aren't you overlooking all of the ESP_CMD_DMA flags in the core driver?
> 
> No, all those occurences are only used when calling
> send_dma_command(), except the NULL/NOP DMA commands
> directly after a chip reset.
> 

Fair enough. That means a stale count could be used after a PIO transfer 
in DATA IN and DATA OUT phase that happened to follow a DMA transfer (in 
any phase).

I still think there is a opportunity to improve robustness and correctness 
(presuming that performance isn't impacted).

-- 

> Kind regards,
> 
> Kars.
> 
