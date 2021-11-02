Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB086C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 10:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42E460EE9
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 10:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKBKnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 06:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhKBKne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 06:43:34 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C8FC061767
        for <linux-scsi@vger.kernel.org>; Tue,  2 Nov 2021 03:40:59 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:5050:fce2:2424:248f])
        by andre.telenet-ops.be with bizsmtp
        id DNgw2600M0xGf5L01Ngwqg; Tue, 02 Nov 2021 11:40:57 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mhrDs-009hYL-6S; Tue, 02 Nov 2021 11:40:56 +0100
Date:   Tue, 2 Nov 2021 11:40:56 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Damien Le Moal <damien.lemoal@wdc.com>
cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-renesas@vger.kernel.org
Subject: Re: [PATCH v9 3/5] libata: support concurrent positioning ranges
 log
In-Reply-To: <20211027022223.183838-4-damien.lemoal@wdc.com>
Message-ID: <alpine.DEB.2.22.394.2111021130020.2311589@ramsan.of.borg>
References: <20211027022223.183838-1-damien.lemoal@wdc.com> <20211027022223.183838-4-damien.lemoal@wdc.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 	Hi Damien,

On Wed, 27 Oct 2021, Damien Le Moal wrote:
> Add support to discover if an ATA device supports the Concurrent
> Positioning Ranges data log (address 0x47), indicating that the device
> is capable of seeking to multiple different locations in parallel using
> multiple actuators serving different LBA ranges.
>
> Also add support to translate the concurrent positioning ranges log
> into its equivalent Concurrent Positioning Ranges VPD page B9h in
> libata-scsi.c.
>
> The format of the Concurrent Positioning Ranges Log is defined in ACS-5
> r9.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Thanks for your patch, which is now commit fe22e1c2f705676a ("libata:
support concurrent positioning ranges log") upstream.

During resume from s2ram on Renesas Salvator-XS, I now see more scary
messages than before:

      ata1: link resume succeeded after 1 retries
      ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
     +ata1.00: qc timeout (cmd 0x2f)
     +ata1.00: Read log page 0x00 failed, Emask 0x4
     +ata1.00: ATA Identify Device Log not supported
     +ata1.00: failed to set xfermode (err_mask=0x40)
      ata1: link resume succeeded after 1 retries
      ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
     +ata1.00: ATA Identify Device Log not supported
     +ata1.00: ATA Identify Device Log not supported
      ata1.00: configured for UDMA/133

I guess this is expected?

The hard drive (old Maxtor 6L160M0 that received a third life as a test
bed for Renesas SATA regression testing) seems to still work fine.

Thanks!

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
