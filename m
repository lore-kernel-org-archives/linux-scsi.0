From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Sat, 01 Jan 2011 17:45:11 +0100
Message-ID: <4D1F5A17.4010807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nick.cheng@areca.com.tw, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The WRITE_{6,10,12} are defined numbers, so the branch was always taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

See include/scsi/scsi.h:58-123 for
#define WRITE_6               0x0a
#define WRITE_10              0x2a
#define WRITE_12              0xaa

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 17e3df4..a6e5222 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1171,7 +1171,8 @@ static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 || pcmd->cmnd[0]|WRITE_12 ){
+	if (pcmd->cmnd[0] & WRITE_6 || pcmd->cmnd[0] & WRITE_10 ||
+			pcmd->cmnd[0] & WRITE_12 ){
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	}
 	ccb->arc_cdb_size = arccdbsize;
