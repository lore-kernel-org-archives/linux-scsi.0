Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1320C43141
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 23:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAF8420857
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 23:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfKQX0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 18:26:53 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49276 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfKQX0x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 18:26:53 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 675E62A771;
        Sun, 17 Nov 2019 18:26:48 -0500 (EST)
Date:   Mon, 18 Nov 2019 10:26:47 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO
 transfers
In-Reply-To: <alpine.LNX.2.21.1.1911180947020.8@nippy.intranet>
Message-ID: <alpine.LNX.2.21.1.1911181019110.75@nippy.intranet>
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au> <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com> <alpine.LNX.2.21.1.1911180947020.8@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Nov 2019, Finn Thain wrote:

> On Sun, 17 Nov 2019, Kars de Jong wrote:
> 
> > The only [time when] the driver reads these registers is after a data 
> > transfer. These are done using DMA on all Zorro boards, so I don't 
> > think there's a risk of stale values from a PIO transfer there.
> > 
> 
> I'm not entirely sure that the chip is unaffected by stale counter 
> values.
> 
> (Stale transfer counter values are distinct from stale transfer count 
> register values. Both are addressed by the patch.)
> 

Sorry -- I should have said, "both were _intended_ to be addressed by the 
patch". But, as Michael pointed out, the DMA NOP command was missing from 
the v1 patch. Please see revised patch below.


diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bb88995a12c7..82d49f0f09df 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2835,6 +2835,10 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 	cmd &= ~ESP_CMD_DMA;
 	esp->send_cmd_error = 0;
 
+	esp_write8(0, ESP_TCLOW);
+	esp_write8(0, ESP_TCMED);
+	scsi_esp_cmd(esp, ESP_CMD_NULL | ESP_CMD_DMA);
+
 	if (write) {
 		u8 *dst = (u8 *)addr;
 		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 1c78bc10c790..797579247e47 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -361,8 +361,6 @@ static int esp_mac_probe(struct platform_device *dev)
 	esp->flags = ESP_FLAG_NO_DMA_MAP;
 	if (mep->pdma_io == NULL) {
 		printk(KERN_INFO PFX "using PIO for controller %d\n", dev->id);
-		esp_write8(0, ESP_TCLOW);
-		esp_write8(0, ESP_TCMED);
 		esp->flags |= ESP_FLAG_DISABLE_SYNC;
 		mac_esp_ops.send_dma_cmd = esp_send_pio_cmd;
 	} else {
