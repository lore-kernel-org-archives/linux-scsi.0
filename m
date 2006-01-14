From: andrew.vasquez@qlogic.com
Subject: [PATCH 06/15] qla2xxx: Re-enable flash-part write protection on ISP24xx boards.
Date: Fri, 13 Jan 2006 17:05:15 -0800
Message-ID: <11372007102289-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:3876 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945931AbWANBFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:16 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Driver would not correctly re-enable the write-protection
bits of the flash part after updates.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_sup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

8b1f204feb44e6ee426c4d1b068ac6234fc1c0a6
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index d54d2a9..f4d755a 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -573,6 +573,9 @@ qla24xx_write_flash_data(scsi_qla_host_t
 		}
 	} while (0);
 
+	/* Enable flash write-protection. */
+	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0x9c);
+
 	/* Disable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    RD_REG_DWORD(&reg->ctrl_status) & ~CSRX_FLASH_ENABLE);
-- 
1.1.1-g4c34


