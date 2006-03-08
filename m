From: ravi.anand@qlogic.com
Subject: [PATCH 05/11] Correct allocations of ddb_entry.
Date: Tue, 7 Mar 2006 16:35:37 -0800
Message-ID: <1141778132112-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:57072 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964854AbWCHAfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:41 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

As qla4xxx_alloc_ddb() is called from process-context.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

1a707252f20e748a8a4fc151405c71c0259794c0
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6d10809..004782c 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -527,7 +527,7 @@ qla4xxx_alloc_ddb(scsi_qla_host_t * ha, 
 	DEBUG2(printk("scsi%ld: %s: fw_ddb_index [%d]\n", ha->host_no,
 	    __func__, fw_ddb_index));
 
-	ddb_entry = (struct ddb_entry *)kmalloc(sizeof(*ddb_entry), GFP_ATOMIC);
+	ddb_entry = (struct ddb_entry *)kmalloc(sizeof(*ddb_entry), GFP_KERNEL);
 	if (ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
 		    "to add fw_ddb_index [%d]\n", ha->host_no, __func__,
-- 
1.2.4.g9201-dirty


