From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI_QLOGIC_1280_1040 dependencies
Date: Sat, 30 Oct 2004 00:01:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041029220153.GZ6677@stusta.de>
References: <4179BA08.3080902@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:19211 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S263610AbUJ2WC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 18:02:26 -0400
Content-Disposition: inline
In-Reply-To: <4179BA08.3080902@eyal.emu.id.au>
List-Id: linux-scsi@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Jes Sorensen <jes@wildopensource.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel list <linux-kernel@vger.kernel.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sat, Oct 23, 2004 at 11:55:20AM +1000, Eyal Lebedinsky wrote:

> Should the second line be indented?
> 
> Qlogic QLA 1240/1x80/1x160 SCSI support (SCSI_QLOGIC_1280) [M/n/?] m
> Qlogic QLA 1020/1040 SCSI support (SCSI_QLOGIC_1280_1040) [N/y/?] (NEW) y

Correct, SCSI_QLOGIC_1280_1040 should depend on SCSI_QLOGIC_1280.

The patch below does this.

Additionally, it prevents the case that both drivers are built 
statically and both support the 1020/1040.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm2-full/drivers/scsi/Kconfig.old	2004-10-29 23:51:39.000000000 +0200
+++ linux-2.6.10-rc1-mm2-full/drivers/scsi/Kconfig	2004-10-29 23:56:42.000000000 +0200
@@ -1288,6 +1288,7 @@
 
 config SCSI_QLOGIC_1280_1040
 	bool "Qlogic QLA 1020/1040 SCSI support"
+	depends on SCSI_QLOGIC_1280 && SCSI_QLOGIC_ISP!=y
 	help
 	  Say Y here if you have a QLogic ISP1020/1040 SCSI host adapter and
 	  do not want to use the old driver.  This option enables support in

