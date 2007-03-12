From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/6] qla2xxx: Add cond_resched() calls during HBA flash manipulation.
Date: Mon, 12 Mar 2007 10:41:28 -0700
Message-ID: <11737212911259-git-send-email-andrew.vasquez@qlogic.com>
References: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25532 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXCLRle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:41:34 -0400
In-Reply-To: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

We're observing soft lockups during HBA FLASH retrieval and
update.  Add cond_resched() each time around the tight-loops
during flash read()s/write()s.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ff1dd41..362d041 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -466,6 +466,7 @@ qla24xx_read_flash_dword(scsi_qla_host_t *ha, uint32_t addr)
 			udelay(10);
 		else
 			rval = QLA_FUNCTION_TIMEOUT;
+		cond_resched();
 	}
 
 	/* TODO: What happens if we time out? */
@@ -508,6 +509,7 @@ qla24xx_write_flash_dword(scsi_qla_host_t *ha, uint32_t addr, uint32_t data)
 			udelay(10);
 		else
 			rval = QLA_FUNCTION_TIMEOUT;
+		cond_resched();
 	}
 	return rval;
 }
@@ -1255,6 +1257,7 @@ qla2x00_poll_flash(scsi_qla_host_t *ha, uint32_t addr, uint8_t poll_data,
 		}
 		udelay(10);
 		barrier();
+		cond_resched();
 	}
 	return status;
 }
@@ -1403,6 +1406,7 @@ qla2x00_read_flash_data(scsi_qla_host_t *ha, uint8_t *tmp_buf, uint32_t saddr,
 		if (saddr % 100)
 			udelay(10);
 		*tmp_buf = data;
+		cond_resched();
 	}
 }
 
@@ -1689,6 +1693,7 @@ update_flash:
 				rval = QLA_FUNCTION_FAILED;
 				break;
 			}
+			cond_resched();
 		}
 	} while (0);
 	qla2x00_flash_disable(ha);
-- 
1.5.0.3.382.g34572

