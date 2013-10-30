From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/22] qla2xxx: Clear RISC INT reg only for an event and not always while polling.
Date: Wed, 30 Oct 2013 03:38:20 -0400
Message-ID: <1383118709-5569-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.156.153] ([67.231.156.153]:19601 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753033Ab3J3IL1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:27 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 3da2372..1468c59 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2237,8 +2237,8 @@ qla82xx_poll(int irq, void *dev_id)
 			    stat * 0xff);
 			break;
 		}
+		WRT_REG_DWORD(&reg->host_int, 0);
 	}
-	WRT_REG_DWORD(&reg->host_int, 0);
 out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
-- 
1.7.7

