From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/11] qla2xxx: Clear EFT buffer before firmware reinitialization.
Date: Thu, 31 Jan 2008 12:33:47 -0800
Message-ID: <1201811634-19865-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8353 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760490AbYAaUeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:07 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

To insure that there is no stale data present during EFT
re-registration.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2e51fa8..97063cb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3259,6 +3259,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 
 			if (ha->eft) {
+				memset(ha->eft, 0, EFT_SIZE);
 				rval = qla2x00_enable_eft_trace(ha,
 				    ha->eft_dma, EFT_NUM_BUFFERS);
 				if (rval) {
-- 
1.5.4.rc5.5.gab98

