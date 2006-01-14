From: andrew.vasquez@qlogic.com
Subject: [PATCH 04/15] qla2xxx: Use msleep() as delay during ISP polling.
Date: Fri, 13 Jan 2006 17:05:05 -0800
Message-ID: <11372007004181-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:37411 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945922AbWANBFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:05 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Mailbox commands are polled for completion during ISP
initialization.  During potentially 'long' mailbox commands
(i.e. fabric login), we really don't want a busy-wait delay
to potentially trigger a (benign) soft-lockup BUG().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

33308585d10c6105a34a23246190d64477a0a372
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9746cd1..f90e68d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -196,7 +196,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha);
 
-			udelay(10); /* v4.27 */
+			msleep(10);
 		} /* while */
 	}
 
-- 
1.1.1-g4c34


