From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 2/3] Re: sil3114 data corruption
Date: Thu, 11 Oct 2007 14:20:34 +0200
Message-ID: <200710111420.35166.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <200710111409.56210.bs@q-leap.de> <200710111415.35203.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200710111415.35203.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This will add the sil3114 back to the controllers with the mod15 bug. Without 
this patch no workaround for this controller is done and people might/will 
suffer from data corruption.

Also rather trivial, though with a huge effect, the speed for the effected 
disks will go down from about 45-50MB/s to 20-25MB/s. But better safe than 
lost data or damaged filesystem.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

Index: linux-2.6.23-rc9/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.23-rc9.orig/drivers/ata/sata_sil.c	2007-10-11 10:45:02.000000000 
+0200
+++ linux-2.6.23-rc9/drivers/ata/sata_sil.c	2007-10-11 10:45:08.000000000 
+0200
@@ -241,7 +241,8 @@ static const struct ata_port_info sil_po
 	},
 	/* sil_3114 */
 	{
-		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT,
+		.flags		= SIL_DFL_PORT_FLAGS | SIL_FLAG_RERR_ON_DMA_ACT
+				| SIL_FLAG_MOD15WRITE,
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,



-- 
Bernd Schubert
Q-Leap Networks GmbH
