Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E09EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 04:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245048AbhKZEVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 23:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358031AbhKZETb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 23:19:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19AC061370
        for <linux-scsi@vger.kernel.org>; Thu, 25 Nov 2021 19:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eLmsdT2fv2xBOXVTJ+H6kgBUH4ZjtVoVSb2lWcfQmLg=; b=JB5gbg6k9NAdFrDTyK+wBDfWBg
        54GVOwsMd90+x7XOiB0pCx8FADT3LpiB4gfQX55DEsZ80oKFQ75QYdX2AOMXg4fNXGiS+nOAsNbOf
        wTfASIXf3+/EAduR+QW3WjGFE77NknXLHP5HSVpIBMx0JH6zOonEoBAJvffPP+6gy0PT7qftUcjkw
        Uttq3eIAHo+c6lfCm2bArPiDGhDOavynuuY2fsFlkvtIGvQRdmrUpA+/635804JeTJ9GqxvY/fPBU
        LkxFSIdhKiMXeQ8HiA8BpLEilLVdV0dp1s0YCUrX1M8byiiWeIyQn+m/I5TJhB7LHdmgPQXr+ytZk
        mwikZGzg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqRo7-00975F-QH; Fri, 26 Nov 2021 03:21:52 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-scsi@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: esp_scsi: limit build to builtin only
Date:   Thu, 25 Nov 2021 19:21:51 -0800
Message-Id: <20211126032151.15040-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When CONFIG_SCSI=m and CONFIG_JAZZ_ESP=y, esp_scsi.c cannot reference
the modular SCSI subsytem symbols (this is a partial list):

   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_setsync':
   esp_scsi.c:(.text+0xc04): undefined reference to `spi_display_xfer_agreement'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `scsi_esp_register':
   (.text+0xdec): undefined reference to `scsi_add_host_with_dma'
   mips64-linux-ld: (.text+0xe0c): undefined reference to `scsi_scan_host'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `scsi_esp_unregister':
   (.text+0xf70): undefined reference to `scsi_remove_host'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_set_offset':
   esp_scsi.c:(.text+0xfa8): undefined reference to `scsi_is_host_device'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_slave_configure':
   esp_scsi.c:(.text+0x10bc): undefined reference to `scsi_change_queue_depth'
   mips64-linux-ld: esp_scsi.c:(.text+0x10e8): undefined reference to `spi_dv_device'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_data_bytes_sent':
   esp_scsi.c:(.text+0x15b4): undefined reference to `scsi_kmap_atomic_sg'
   mips64-linux-ld: esp_scsi.c:(.text+0x15cc): undefined reference to `scsi_kunmap_atomic_sg'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_reset_cleanup':
   esp_scsi.c:(.text+0x192c): undefined reference to `scsi_done'
   mips64-linux-ld: esp_scsi.c:(.text+0x1ac0): undefined reference to `scsi_dma_unmap'
   mips64-linux-ld: esp_scsi.c:(.text+0x1b2c): undefined reference to `__starget_for_each_device'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_maybe_execute_command.part.0':
   esp_scsi.c:(.text+0x2108): undefined reference to `spi_populate_tag_msg'
   mips64-linux-ld: esp_scsi.c:(.text+0x2350): undefined reference to `scsi_dma_map'
   mips64-linux-ld: esp_scsi.c:(.text+0x2488): undefined reference to `spi_populate_sync_msg'
   mips64-linux-ld: esp_scsi.c:(.text+0x2798): undefined reference to `spi_populate_width_msg'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_reconnect':
   esp_scsi.c:(.text+0x3010): undefined reference to `__scsi_device_lookup_by_target'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_process_event':
   esp_scsi.c:(.text+0x3f08): undefined reference to `scsi_track_queue_full'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_exit':
   esp_scsi.c:(.exit.text+0x4): undefined reference to `spi_release_transport'
   mips64-linux-ld: drivers/scsi/esp_scsi.o: in function `esp_init':
   esp_scsi.c:(.init.text+0xc): undefined reference to `spi_attach_transport'
   mips64-linux-ld: drivers/scsi/jazz_esp.o: in function `esp_jazz_remove':
   jazz_esp.c:(.text+0x98): undefined reference to `scsi_host_put'
   mips64-linux-ld: drivers/scsi/jazz_esp.o: in function `esp_jazz_probe':
   jazz_esp.c:(.text+0x1e4): undefined reference to `scsi_host_alloc'

Since JAZZ_ESP is a bool Kconfig symbol, make the driver only available
to be built when CONFIG_SCSI=y to eliminate the build errors.

Fixes: f8ab27d96494 ("scsi: esp_scsi: Call scsi_done() directly")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
---
 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211125.orig/drivers/scsi/Kconfig
+++ linux-next-20211125/drivers/scsi/Kconfig
@@ -1296,7 +1296,7 @@ source "drivers/scsi/arm/Kconfig"
 
 config JAZZ_ESP
 	bool "MIPS JAZZ FAS216 SCSI support"
-	depends on MACH_JAZZ && SCSI
+	depends on MACH_JAZZ && SCSI=y
 	select SCSI_SPI_ATTRS
 	help
 	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
