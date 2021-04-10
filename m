Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25749C43461
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F066115A
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhDJGsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16887 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhDJGsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ4dlRzkhqZ;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:44 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 4/8] scsi: megaraid: clean up for open/close brace
Date:   Sat, 10 Apr 2021 14:48:03 +0800
Message-ID: <1618037287-460-5-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
References: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are few kinds of error about open/close brace is reported by
checkpatch.pl:

ERROR: open brace '{' following function definitions go on the next line
int
megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {

ERROR: else should follow close brace '}'
+       }
+       else

So fix them all.

Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c       | 57 ++++++++++-------------------
 drivers/scsi/megaraid/megaraid_mm.c         | 10 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  7 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 11 +++---
 4 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 6d76b15..d3fcaca 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -537,8 +537,7 @@ megaraid_detach_one(struct pci_dev *pdev)
 			pdev->subsystem_device));
 
 		return;
-	}
-	else {
+	} else {
 		con_log(CL_ANN, (KERN_NOTICE
 		"megaraid: detaching device %#4.04x:%#4.04x:%#4.04x:%#4.04x\n",
 			pdev->vendor, pdev->device, pdev->subsystem_vendor,
@@ -1545,8 +1544,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 				vaddr = (caddr_t) sg_virt(&sgl[0]);
 
 				memset(vaddr, 0, scp->cmnd[4]);
-			}
-			else {
+			} else {
 				con_log(CL_ANN, (KERN_WARNING
 						 "megaraid mailbox: invalid sg:%d\n",
 						 __LINE__));
@@ -1705,8 +1703,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 					((uint32_t)scp->cmnd[7] << 16) |
 					((uint32_t)scp->cmnd[8] << 8) |
 					(uint32_t)scp->cmnd[9];
-			}
-			else {
+			} else {
 				con_log(CL_ANN, (KERN_WARNING
 					"megaraid: unsupported CDB length\n"));
 
@@ -1762,8 +1759,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			scp->result = (DID_BAD_TARGET << 16);
 			return NULL;
 		}
-	}
-	else { // Passthru device commands
+	} else { // Passthru device commands
 
 		// Do not allow access to target id > 15 or LUN > 7
 		if (target > 15 || SCP2LUN(scp) > 7) {
@@ -1830,8 +1826,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			mbox64->xferaddr_lo	= (uint32_t)ccb->epthru_dma_h;
 			mbox64->xferaddr_hi	= 0;
 			mbox->xferaddr		= 0xFFFFFFFF;
-		}
-		else {
+		} else {
 			mbox->cmd = MBOXCMD_PASSTHRU64;
 
 			megaraid_mbox_prepare_pthru(adapter, scb, scp);
@@ -1961,8 +1956,7 @@ megaraid_mbox_prepare_pthru(adapter_t *adapter, scb_t *scb,
 		pthru->dataxferlen	= scsi_bufflen(scp);
 		pthru->dataxferaddr	= ccb->sgl_dma_h;
 		pthru->numsge		= megaraid_mbox_mksgl(adapter, scb);
-	}
-	else {
+	} else {
 		pthru->dataxferaddr	= 0;
 		pthru->dataxferlen	= 0;
 		pthru->numsge		= 0;
@@ -2010,8 +2004,7 @@ megaraid_mbox_prepare_epthru(adapter_t *adapter, scb_t *scb,
 		epthru->dataxferlen	= scsi_bufflen(scp);
 		epthru->dataxferaddr	= ccb->sgl_dma_h;
 		epthru->numsge		= megaraid_mbox_mksgl(adapter, scb);
-	}
-	else {
+	} else {
 		epthru->dataxferaddr	= 0;
 		epthru->dataxferlen	= 0;
 		epthru->numsge		= 0;
@@ -2100,8 +2093,7 @@ megaraid_ack_sequence(adapter_t *adapter)
 				// a cmm command
 				scb = adapter->uscb_list + (completed[i] -
 						MBOX_MAX_SCSI_CMDS);
-			}
-			else {
+			} else {
 				// an os command
 				scb = adapter->kscb_list + completed[i];
 			}
@@ -2303,8 +2295,7 @@ megaraid_mbox_dpc(unsigned long devp)
 
 				scp->result = DRIVER_SENSE << 24 |
 					DID_OK << 16 | CHECK_CONDITION << 1;
-			}
-			else {
+			} else {
 				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
 
 					memcpy(scp->sense_buffer,
@@ -2335,8 +2326,7 @@ megaraid_mbox_dpc(unsigned long devp)
 			if (scp->cmnd[0] == TEST_UNIT_READY) {
 				scp->result = DID_ERROR << 16 |
 					RESERVATION_CONFLICT << 1;
-			}
-			else
+			} else
 			/*
 			 * Error code returned is 1 if Reserve or Release
 			 * failed or the input parameter is invalid
@@ -2346,8 +2336,7 @@ megaraid_mbox_dpc(unsigned long devp)
 
 				scp->result = DID_ERROR << 16 |
 					RESERVATION_CONFLICT << 1;
-			}
-			else {
+			} else {
 				scp->result = DID_BAD_TARGET << 16 | status;
 			}
 		}
@@ -2485,8 +2474,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
 				"megaraid abort: %d[%d:%d], invalid state\n",
 				scb->sno, scb->dev_channel, scb->dev_target));
 				BUG();
-			}
-			else {
+			} else {
 				con_log(CL_ANN, (KERN_WARNING
 				"megaraid abort: %d[%d:%d], fw owner\n",
 				scb->sno, scb->dev_channel, scb->dev_target));
@@ -2621,8 +2609,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 
 		rval = FAILED;
 		goto out;
-	}
-	else {
+	} else {
 		con_log(CL_ANN, (KERN_NOTICE
 		"megaraid mbox: reset sequence completed successfully\n"));
 	}
@@ -2642,8 +2629,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	if (mbox_post_sync_cmd_fast(adapter, raw_mbox) == 0) {
 		con_log(CL_ANN,
 			(KERN_INFO "megaraid: reservation reset\n"));
-	}
-	else {
+	} else {
 		rval = FAILED;
 		con_log(CL_ANN, (KERN_WARNING
 				"megaraid: reservation reset failed\n"));
@@ -3147,8 +3133,7 @@ megaraid_mbox_get_max_sg(adapter_t *adapter)
 	// Issue the command
 	if (mbox_post_sync_cmd(adapter, raw_mbox) == 0) {
 		nsg =  *(uint8_t *)adapter->ibuf;
-	}
-	else {
+	} else {
 		nsg =  MBOX_DEFAULT_SG_SIZE;
 	}
 
@@ -3940,21 +3925,18 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 				"megaraid: sysfs get ld map timed out\n"));
 
 			rval = -ETIME;
-		}
-		else {
+		} else {
 			rval = mbox->status;
 		}
 
 		if (rval == 0) {
 			memcpy(raid_dev->curr_ldmap, ldmap,
 				sizeof(raid_dev->curr_ldmap));
-		}
-		else {
+		} else {
 			con_log(CL_ANN, (KERN_NOTICE
 				"megaraid: get ld map failed with %x\n", rval));
 		}
-	}
-	else {
+	} else {
 		con_log(CL_ANN, (KERN_NOTICE
 			"megaraid: could not issue ldmap command:%x\n", rval));
 	}
@@ -4050,8 +4032,7 @@ megaraid_sysfs_show_ldnum(struct device *dev, struct device_attribute *attr, cha
 					break;
 				}
 			}
-		}
-		else {
+		} else {
 			con_log(CL_ANN, (KERN_NOTICE
 				"megaraid: sysfs get ld map failed: %x\n",
 				rval));
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 2939f0e..864cbb6 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -390,8 +390,7 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 
 			if (mraid_mm_attach_buf(adp, kioc, kioc->xferlen))
 				return (-ENOMEM);
-		}
-		else {
+		} else {
 			con_log(CL_ANN, (KERN_WARNING
 					"megaraid cmm: Invalid subop\n"));
 			return (-EINVAL);
@@ -539,8 +538,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 
 			spin_unlock_irqrestore(&pool->lock, flags);
 			return 0;
-		}
-		else {
+		} else {
 			spin_unlock_irqrestore(&pool->lock, flags);
 			continue;
 		}
@@ -760,10 +758,8 @@ ioctl_done(uioc_t *kioc)
 		if (adapter) {
 			mraid_mm_dealloc_kioc(adapter, kioc);
 		}
-	}
-	else {
+	} else
 		wake_up(&wait_q);
-	}
 }
 
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7ff5820..40c77bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3199,8 +3199,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		spin_unlock_irqrestore(&poll_aen_lock, flags);
 		wake_up(&megasas_poll_wait);
 		kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
-	}
-	else
+	} else
 		cmd->abort_aen = 0;
 
 	instance->aen_cmd = NULL;
@@ -5686,8 +5685,8 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
  * return:				void
  */
 static void
-megasas_destroy_irqs(struct megasas_instance *instance) {
-
+megasas_destroy_irqs(struct megasas_instance *instance)
+{
 	int i;
 	int count;
 	struct megasas_irq_context *irq_ctx;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7d10448..4591262 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -908,8 +908,8 @@ megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 }
 
 static void
-megasas_free_rdpq_fusion(struct megasas_instance *instance) {
-
+megasas_free_rdpq_fusion(struct megasas_instance *instance)
+{
 	int i;
 	struct fusion_context *fusion;
 
@@ -932,8 +932,8 @@ megasas_free_rdpq_fusion(struct megasas_instance *instance) {
 }
 
 static void
-megasas_free_reply_fusion(struct megasas_instance *instance) {
-
+megasas_free_reply_fusion(struct megasas_instance *instance)
+{
 	struct fusion_context *fusion;
 
 	fusion = instance->ctrl_context;
@@ -1296,7 +1296,8 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
  * issue and receive command.
  */
 int
-megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
+megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend)
+{
 	int ret = 0;
 	size_t pd_seq_map_sz;
 	struct megasas_cmd *cmd;
-- 
2.7.4

