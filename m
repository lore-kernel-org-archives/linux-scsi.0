From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 11/15] target: WRITE_SAME_16 and WRITE_SAME_32 should be DATA_SG_IO cdbs
Date: Tue, 28 Jun 2011 12:29:33 -0700
Message-ID: <1309289377-8029-12-git-send-email-agrover@redhat.com>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab1F1T3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 15:29:53 -0400
In-Reply-To: <1309289377-8029-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

The definition of what's a data and what's a control CDB is not
totally clear, but both of these set t_task_lba, so I'm inclined
to call them data CDBs.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3dec696..fff099a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3078,7 +3078,7 @@ static int transport_generic_cmd_sequencer(
 				size = dev->se_sub_dev->se_dev_attrib.block_size;
 
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
-			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
+			cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 
 			/*
 			 * Skip the remaining assignments for TCM/PSCSI passthrough
@@ -3381,7 +3381,7 @@ static int transport_generic_cmd_sequencer(
 				goto out_invalid_cdb_field;
 			}
 		}
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case GPCMD_CLOSE_TRACK:
-- 
1.7.1

