From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] be2iscsi: fix handling return value of mgmt_open_connection
Date: Mon, 14 Dec 2015 11:06:04 +0100
Message-ID: <1450087564-28441-7-git-send-email-a.hajda@samsung.com>
References: <1450087564-28441-1-git-send-email-a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1450087564-28441-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The function can return negative values, so its result should
be assigned to signed variable.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2046107

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b7087ba..ce9f192 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1106,8 +1106,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
 	struct tcp_connect_and_offload_out *ptcpcnct_out;
 	struct be_dma_mem nonemb_cmd;
-	unsigned int tag, req_memsize;
-	int ret = -ENOMEM;
+	unsigned int req_memsize;
+	int tag, ret = -ENOMEM;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BS_%d : In beiscsi_open_conn\n");
-- 
1.9.1
