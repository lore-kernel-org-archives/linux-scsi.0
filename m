Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18B7CA5534
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 10:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbjIMKZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbjIMKZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 06:25:44 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F16F19B3
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 03:25:39 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:f674:9611:cd05:f25a])
        by andre.telenet-ops.be with bizsmtp
        id lNRa2A00A3fvA4V01NRaKl; Wed, 13 Sep 2023 12:25:36 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1qgN3u-003b80-3x;
        Wed, 13 Sep 2023 12:25:34 +0200
Date:   Wed, 13 Sep 2023 12:25:34 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Damien Le Moal <dlemoal@kernel.org>
cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 03/21] ata: libata-scsi: link ata port and scsi
 device
In-Reply-To: <20230912005655.368075-4-dlemoal@kernel.org>
Message-ID: <1e25e64-a6bc-49e8-62c8-101f3f6de113@linux-m68k.org>
References: <20230912005655.368075-1-dlemoal@kernel.org> <20230912005655.368075-4-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 	Hi Damien,

On Tue, 12 Sep 2023, Damien Le Moal wrote:
> There is no direct device ancestry defined between an ata_device and
> its scsi device which prevents the power management code from correctly
> ordering suspend and resume operations. Create such ancestry with the
> ata device as the parent to ensure that the scsi device (child) is
> suspended before the ata device and that resume handles the ata device
> before the scsi device.
>
> The parent-child (supplier-consumer) relationship is established between
> the ata_port (parent) and the scsi device (child) with the function
> device_add_link(). The parent used is not the ata_device as the PM
> operations are defined per port and the status of all devices connected
> through that port is controlled from the port operations.
>
> The device link is established with the new function
> ata_scsi_dev_alloc(). This function is used to define the ->slave_alloc
> callback of the scsi host template of most drivers.
>
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks for your patch, which is now commit 99626085d036ec32 ("ata:
libata-scsi: link ata port and scsi device") in libata/for-next.

This patch causes /dev/sda to disappear on Renesas Salvator-XS with
R-Car H3 ES2.0.  Changes to dmesg before/after:

      sata_rcar ee300000.sata: ignoring dependency for device, assuming no driver
      scsi host0: sata_rcar
     -ata1: SATA max UDMA/133 irq 184 lpm-pol 0
     +ata1: SATA max UDMA/133 irq 179 lpm-pol 0
      ata1: link resume succeeded after 1 retries
      ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
      ata1.00: ATA-7: Maxtor 6L160M0, BANC1G10, max UDMA/133
      ata1.00: 320173056 sectors, multi 0: LBA48 NCQ (not used)
      ata1.00: configured for UDMA/133
      scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L160M0   1G10 PQ: 0 ANSI: 5
     -sd 0:0:0:0: [sda] 320173056 512-byte logical blocks: (164 GB/153 GiB)
     -sd 0:0:0:0: [sda] Write Protect is off
     -sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
     -sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     -sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
     - sda: sda1
     -sd 0:0:0:0: [sda] Attached SCSI disk

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
