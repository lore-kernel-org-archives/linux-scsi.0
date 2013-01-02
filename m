From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Fix several unlock issues in ipr driver
Date: Wed, 02 Jan 2013 16:26:38 -0600
Message-ID: <20130102222700.693011987@linux.vnet.ibm.com>
References: <20130102222637.134060560@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:48302 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752707Ab3ABW3T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2013 17:29:19 -0500
Content-Disposition: inline; filename=lock_bugs
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch fixes several unlock issues in ipr driver.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-01-02 15:10:03.000000000 -0600
+++ b/drivers/scsi/ipr.c	2013-01-02 15:13:49.572476277 -0600
@@ -4985,8 +4985,8 @@ static int __ipr_eh_dev_reset(struct scs
 					ipr_cmd->qc->flags |= ATA_QCFLAG_FAILED;
 				}
 			}
-		spin_unlock(&hrrq->_lock);
 		}
+		spin_unlock(&hrrq->_lock);
 	}
 	res->resetting_device = 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
@@ -5006,8 +5006,8 @@ static int __ipr_eh_dev_reset(struct scs
 					rc = -EIO;
 					break;
 				}
-			spin_unlock(&hrrq->_lock);
 			}
+			spin_unlock(&hrrq->_lock);
 		}
 	} else
 		rc = ipr_device_reset(ioa_cfg, res);
@@ -6663,6 +6663,7 @@ static unsigned int ipr_qc_issue(struct 
 
 	default:
 		WARN_ON(1);
+		spin_unlock(&ipr_cmd->hrrq->_lock);
 		return AC_ERR_INVALID;
 	}
 

-- 
