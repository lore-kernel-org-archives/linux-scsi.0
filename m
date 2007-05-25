From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 11:08:08 +0200
Message-ID: <4656A778.2000403@suse.de>
References: <20070525082238.GA30876@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:48708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXEYJIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2007 05:08:13 -0400
In-Reply-To: <20070525082238.GA30876@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Olaf Hering wrote:
> Current Linus tree does not compile on s390 because esp_scsi referenc=
es
> unavailable functions.
>=20
> /dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c: In function `esp_map=
_dma':
> /dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c:338: error: implicit =
declaration of function `sg_dma_len'
> /dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c: In function `esp_cur=
_dma_addr':
> /dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c:357: error: implicit =
declaration of function `sg_dma_address'
>=20
Hmm. Try this:

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d28c14e..4909863 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1755,7 +1755,7 @@ config SUN3X_ESP

 config SCSI_ESP_CORE
        tristate "ESP Scsi Driver Core"
-       depends on SCSI
+       depends on SCSI && !S390
        select SCSI_SPI_ATTRS
        help
          This is a core driver for NCR53c9x based scsi chipsets,

James, please apply. ESP cards simply don't fit in a mainframe :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
