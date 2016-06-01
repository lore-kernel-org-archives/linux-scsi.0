From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 14/14] target: Make sbc_ops accessable via target_backend_ops
Date: Wed,  1 Jun 2016 21:48:47 +0000
Message-ID: <1464817727-9125-15-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch allows backend driver sbc_ops function pointers
to be accessed externally, so external target consumers
can perform target_iostate + target_iomem I/O submission
outside of /sys/kernel/config/target/$FABRIC/ users.

Specifically, IBLOCK, FILEIO, and RAMDISK have been
enabled, while PSCSI and TCMU have left sbc_ops NULL
as they perform SCSI CDB pass-through.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    | 1 +
 drivers/target/target_core_iblock.c  | 1 +
 drivers/target/target_core_pscsi.c   | 1 +
 drivers/target/target_core_rd.c      | 1 +
 drivers/target/target_core_user.c    | 1 +
 include/target/target_core_backend.h | 4 ++++
 6 files changed, 9 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b4956a5e..6f0064e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -815,6 +815,7 @@ static const struct target_backend_ops fileio_ops = {
 	.inquiry_prod		= "FILEIO",
 	.inquiry_rev		= FD_VERSION,
 	.owner			= THIS_MODULE,
+	.sbc_ops		= &fd_sbc_ops,
 	.attach_hba		= fd_attach_hba,
 	.detach_hba		= fd_detach_hba,
 	.alloc_device		= fd_alloc_device,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 00781c8..29d3167 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -833,6 +833,7 @@ static const struct target_backend_ops iblock_ops = {
 	.inquiry_prod		= "IBLOCK",
 	.inquiry_rev		= IBLOCK_VERSION,
 	.owner			= THIS_MODULE,
+	.sbc_ops		= &iblock_sbc_ops,
 	.attach_hba		= iblock_attach_hba,
 	.detach_hba		= iblock_detach_hba,
 	.alloc_device		= iblock_alloc_device,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c52f943..4284dbf 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1127,6 +1127,7 @@ static void pscsi_req_done(struct request *req, int uptodate)
 static const struct target_backend_ops pscsi_ops = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
+	.sbc_ops		= NULL,
 	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index a38a37f..e9df036 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -662,6 +662,7 @@ static const struct target_backend_ops rd_mcp_ops = {
 	.name			= "rd_mcp",
 	.inquiry_prod		= "RAMDISK-MCP",
 	.inquiry_rev		= RD_MCP_VERSION,
+	.sbc_ops		= &rd_sbc_ops,
 	.attach_hba		= rd_attach_hba,
 	.detach_hba		= rd_detach_hba,
 	.alloc_device		= rd_alloc_device,
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3467560..ec6142b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1151,6 +1151,7 @@ static const struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
 	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH,
+	.sbc_ops		= NULL,
 	.attach_hba		= tcmu_attach_hba,
 	.detach_hba		= tcmu_detach_hba,
 	.alloc_device		= tcmu_alloc_device,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 9efe718..15f731f 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -8,6 +8,10 @@ struct target_backend_ops {
 	char inquiry_prod[16];
 	char inquiry_rev[4];
 	struct module *owner;
+	/*
+	 * Used by NVMe-target for se_cmd dispatch without SCSI CDB parsing
+	 */
+	struct sbc_ops *sbc_ops;
 
 	u8 transport_flags;
 
-- 
1.9.1
