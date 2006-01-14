From: andrew.vasquez@qlogic.com
Subject: [PATCH 05/15] qla2xxx: Correct excessive delay during LOAD-RISC-RAM mailbox command.
Date: Fri, 13 Jan 2006 17:05:10 -0800
Message-ID: <11372007051359-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56355 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945925AbWANBFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:10 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Problem report (against 2.4.x driver) from Jeff Layton
<jlayton@redhat.com>:

An OEM noticed that the U6 qla2200 driver would hang for
around 2 minutes at boot time and then proceed normally. I
found that the delay was occurring when loading the new
firmware into the card, and was due to a
schedule_timeout(10) added to the bottom of the polling
loop.

Some testing showed that the load ram operation on the card
was very quick (on the order of a couple of jiffies), but
the sleep in the polling loop was making each operation take
around 25-30.

The attached patch corrects this by making it skip sleeping
during the load ram operation, since I believe we only do
that when the module is plugged in. It also skips sleeping
if the mbox_int flag got set during the current loop.

This corrected the hang on my test setup, and OEM also
confirmed that it corrected the problem for them.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_mbx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

d2997d0c232a39d077c4744a97a274cc31884d15
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f90e68d..3de8fee 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -196,7 +196,9 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha);
 
-			msleep(10);
+			if (command != MBC_LOAD_RISC_RAM_EXTENDED &&
+			    !ha->flags.mbox_int)
+				msleep(10);
 		} /* while */
 	}
 
-- 
1.1.1-g4c34


