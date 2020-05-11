Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660DAC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3787A20736
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgEKUKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32940 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUJ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:09:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id x77so5244809pfc.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mE/MFxulCM2hmbAMZzvO8l4fJuJyw+Xw1Py8yc/jIqA=;
        b=KXJ0HD7CrL5Vf0MMjZiBRIRbVO1oL80HiKXsLc9dJcbUT9yDcDHs+P8QqjM8Dckx0r
         xv4QnniCjSaD8+A9+mkYbW+SkfJc76AuHrigFIeasKOwBWLvIng08wn4S/ExQL1z0w63
         Qmn9Ho1dq0lrgZrB3cWSl1Jd5U/djZSr2O1pSzL0xNQyLwow/rHCLtyveQs/HD11koPT
         RXbV1uxkNPphCAGDO2FYyQ27aiGENse128zI7Ag9iFzlnLLdynjbLGCVTZ/l1j+lKk5g
         hzwGLh9nwglstLs6b6r9Ho/6m/gkif9nPNBjK4fyWR8R5wJwLCa+JWfskI/XwCugHq+y
         eGeQ==
X-Gm-Message-State: AGi0PuZPkTObAiZ2WIIpUQqH3JXSbW0sRIrWdXrKkvWwzKGZEUY49vl8
        tcZyyeEia/5o5tTjIXbCIJI=
X-Google-Smtp-Source: APiQypIsaZVDhdBCZ2pVIOwYjCSo8x7j189kbl/oCgg+7Ukw4tF4KksXkdS0wK2RGjxiWOaAkBrcBA==
X-Received: by 2002:aa7:9f8e:: with SMTP id z14mr18503594pfr.189.1589227797699;
        Mon, 11 May 2020 13:09:57 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:09:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 03/15] qla2xxx: Simplify the functions for dumping firmware
Date:   Mon, 11 May 2020 13:09:34 -0700
Message-Id: <20200511200946.7675-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing an argument to the firmware dumping functions that
tells these functions whether or not to obtain the hardware lock, obtain
that lock before calling these functions. This patch fixes the following
recently introduced C=2 build error:

  CHECK   drivers/scsi/qla2xxx/qla_tmpl.c
drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: Expected ; at end of statement
drivers/scsi/qla2xxx/qla_tmpl.c:1133:1: error: got }
drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: Expected } at end of function
drivers/scsi/qla2xxx/qla_tmpl.h:247:0: error: got end-of-input

Cc: Arun Easi <aeasi@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Fixes: cbb01c2f2f63 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.c    | 153 ++++++++----------------------
 drivers/scsi/qla2xxx/qla_def.h    |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  21 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |  12 +--
 drivers/scsi/qla2xxx/qla_mbx.c    |   6 +-
 drivers/scsi/qla2xxx/qla_nx.c     |   2 +-
 drivers/scsi/qla2xxx/qla_nx2.c    |   2 +-
 drivers/scsi/qla2xxx/qla_os.c     |   2 +-
 drivers/scsi/qla2xxx/qla_target.c |   4 +-
 drivers/scsi/qla2xxx/qla_tmpl.c   |  19 +---
 11 files changed, 71 insertions(+), 156 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 97b51c477972..3af7ca68ec44 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -691,7 +691,7 @@ qla81xx_set_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
 		 * dump and reset the chip.
 		 */
 		if (ret) {
-			ha->isp_ops->fw_dump(vha, 0);
+			qla2xxx_dump_fw(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		}
 		rval = -EINVAL;
@@ -896,7 +896,7 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 					 * doesn't work take FCoE dump and then
 					 * reset the chip.
 					 */
-					ha->isp_ops->fw_dump(vha, 0);
+					qla2xxx_dump_fw(vha);
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 				}
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1206f7c1ce6a..07a8c674b741 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -716,35 +716,37 @@ qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
 	}
 }
 
+void qla2xxx_dump_fw(scsi_qla_host_t *vha)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	vha->hw->isp_ops->fw_dump(vha);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @vha: HA context
- * @hardware_locked: Called with the hardware_lock
  */
 void
-qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla2300_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
-	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
 	void		*nxt;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	flags = 0;
-
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
+	lockdep_assert_held(&ha->hardware_lock);
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd002,
 		    "No buffer available for dump.\n");
-		goto qla2300_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
@@ -752,7 +754,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    "Firmware has been previously dumped (%p) "
 		    "-- ignoring request.\n",
 		    ha->fw_dump);
-		goto qla2300_fw_dump_failed;
+		return;
 	}
 	fw = &ha->fw_dump->isp.isp23;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
@@ -876,48 +878,31 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		qla2xxx_copy_queues(ha, nxt);
 
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla2300_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 /**
  * qla2100_fw_dump() - Dumps binary data from the 2100/2200 firmware.
  * @vha: HA context
- * @hardware_locked: Called with the hardware_lock
  */
 void
-qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla2100_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt, timer;
-	uint16_t	risc_address;
-	uint16_t	mb0, mb2;
+	uint16_t	risc_address = 0;
+	uint16_t	mb0 = 0, mb2 = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
-	unsigned long	flags;
 	struct qla2100_fw_dump	*fw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	risc_address = 0;
-	mb0 = mb2 = 0;
-	flags = 0;
-
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
+	lockdep_assert_held(&ha->hardware_lock);
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd004,
 		    "No buffer available for dump.\n");
-		goto qla2100_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
@@ -925,7 +910,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    "Firmware has been previously dumped (%p) "
 		    "-- ignoring request.\n",
 		    ha->fw_dump);
-		goto qla2100_fw_dump_failed;
+		return;
 	}
 	fw = &ha->fw_dump->isp.isp21;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
@@ -1080,18 +1065,10 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
 
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla2100_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 void
-qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla24xx_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt;
@@ -1100,28 +1077,23 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
-	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
 	void		*nxt;
 	void		*nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
+	lockdep_assert_held(&ha->hardware_lock);
+
 	if (IS_P3P_TYPE(ha))
 		return;
 
-	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
-
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd006,
 		    "No buffer available for dump.\n");
-		goto qla24xx_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
@@ -1129,7 +1101,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    "Firmware has been previously dumped (%p) "
 		    "-- ignoring request.\n",
 		    ha->fw_dump);
-		goto qla24xx_fw_dump_failed;
+		return;
 	}
 	QLA_FW_STOPPED(ha);
 	fw = &ha->fw_dump->isp.isp24;
@@ -1339,18 +1311,10 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 qla24xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla24xx_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 void
-qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla25xx_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt;
@@ -1359,24 +1323,19 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
-	unsigned long	flags;
 	struct qla25xx_fw_dump *fw;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	flags = 0;
-	ha->fw_dump_cap_flags = 0;
+	lockdep_assert_held(&ha->hardware_lock);
 
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
+	ha->fw_dump_cap_flags = 0;
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd008,
 		    "No buffer available for dump.\n");
-		goto qla25xx_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
@@ -1384,7 +1343,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    "Firmware has been previously dumped (%p) "
 		    "-- ignoring request.\n",
 		    ha->fw_dump);
-		goto qla25xx_fw_dump_failed;
+		return;
 	}
 	QLA_FW_STOPPED(ha);
 	fw = &ha->fw_dump->isp.isp25;
@@ -1665,18 +1624,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 qla25xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla25xx_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 void
-qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla81xx_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt;
@@ -1685,24 +1636,19 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
-	unsigned long	flags;
 	struct qla81xx_fw_dump *fw;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	flags = 0;
-	ha->fw_dump_cap_flags = 0;
+	lockdep_assert_held(&ha->hardware_lock);
 
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
+	ha->fw_dump_cap_flags = 0;
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd00a,
 		    "No buffer available for dump.\n");
-		goto qla81xx_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
@@ -1710,7 +1656,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		    "Firmware has been previously dumped (%p) "
 		    "-- ignoring request.\n",
 		    ha->fw_dump);
-		goto qla81xx_fw_dump_failed;
+		return;
 	}
 	fw = &ha->fw_dump->isp.isp81;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
@@ -1993,18 +1939,10 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 qla81xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla81xx_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 void
-qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla83xx_fw_dump(scsi_qla_host_t *vha)
 {
 	int		rval;
 	uint32_t	cnt;
@@ -2013,31 +1951,26 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
 	uint16_t __iomem *mbx_reg;
-	unsigned long	flags;
 	struct qla83xx_fw_dump *fw;
 	void		*nxt, *nxt_chain;
 	uint32_t	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	flags = 0;
-	ha->fw_dump_cap_flags = 0;
+	lockdep_assert_held(&ha->hardware_lock);
 
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-#endif
+	ha->fw_dump_cap_flags = 0;
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd00c,
 		    "No buffer available for dump!!!\n");
-		goto qla83xx_fw_dump_failed;
+		return;
 	}
 
 	if (ha->fw_dumped) {
 		ql_log(ql_log_warn, vha, 0xd00d,
 		    "Firmware has been previously dumped (%p) -- ignoring "
 		    "request...\n", ha->fw_dump);
-		goto qla83xx_fw_dump_failed;
+		return;
 	}
 	QLA_FW_STOPPED(ha);
 	fw = &ha->fw_dump->isp.isp83;
@@ -2507,14 +2440,6 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 qla83xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
-
-qla83xx_fw_dump_failed:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-#else
-	;
-#endif
 }
 
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 172ea4e5887d..5ca46b15ca3c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3222,7 +3222,7 @@ struct isp_operations {
 	int (*write_nvram)(struct scsi_qla_host *, void *, uint32_t,
 		uint32_t);
 
-	void (*fw_dump) (struct scsi_qla_host *, int);
+	void (*fw_dump)(struct scsi_qla_host *vha);
 	void (*mpi_fw_dump)(struct scsi_qla_host *, int);
 
 	int (*beacon_on) (struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f62b71e47581..061f91b521b3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -637,15 +637,16 @@ extern int qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
-extern void qla2100_fw_dump(scsi_qla_host_t *, int);
-extern void qla2300_fw_dump(scsi_qla_host_t *, int);
-extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
-extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
-extern void qla81xx_fw_dump(scsi_qla_host_t *, int);
-extern void qla82xx_fw_dump(scsi_qla_host_t *, int);
-extern void qla8044_fw_dump(scsi_qla_host_t *, int);
-
-extern void qla27xx_fwdump(scsi_qla_host_t *, int);
+void qla2xxx_dump_fw(scsi_qla_host_t *vha);
+void qla2100_fw_dump(scsi_qla_host_t *vha);
+void qla2300_fw_dump(scsi_qla_host_t *vha);
+void qla24xx_fw_dump(scsi_qla_host_t *vha);
+void qla25xx_fw_dump(scsi_qla_host_t *vha);
+void qla81xx_fw_dump(scsi_qla_host_t *vha);
+void qla82xx_fw_dump(scsi_qla_host_t *vha);
+void qla8044_fw_dump(scsi_qla_host_t *vha);
+
+void qla27xx_fwdump(scsi_qla_host_t *vha);
 extern void qla27xx_mpi_fwdump(scsi_qla_host_t *, int);
 extern ulong qla27xx_fwdt_calculate_dump_size(struct scsi_qla_host *, void *);
 extern int qla27xx_fwdt_template_valid(void *);
@@ -873,7 +874,7 @@ extern int qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t,
 	uint16_t *, uint16_t *);
 
 /* 83xx related functions */
-extern void qla83xx_fw_dump(scsi_qla_host_t *, int);
+void qla83xx_fw_dump(scsi_qla_host_t *vha);
 
 /* Minidump related functions */
 extern int qla82xx_md_get_template_size(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a9e8513e1cf1..54e1ecdc0cdb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -220,7 +220,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
 
-			ha->isp_ops->fw_dump(vha, 1);
+			ha->isp_ops->fw_dump(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((RD_REG_WORD(&reg->istatus) & ISR_RISC_INT) == 0)
@@ -351,7 +351,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 			WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
 			RD_REG_WORD(&reg->hccr);
 
-			ha->isp_ops->fw_dump(vha, 1);
+			ha->isp_ops->fw_dump(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSR_RISC_INT) == 0)
@@ -777,7 +777,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	       "MPI Heartbeat stop. FW dump needed\n");
 
 	if (ql2xfulldump_on_mpifail) {
-		ha->isp_ops->fw_dump(vha, 1);
+		ha->isp_ops->fw_dump(vha);
 		reset_isp_needed = 1;
 	}
 
@@ -908,7 +908,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		if ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
 		    RD_REG_WORD(&reg24->mailbox7) & BIT_8)
 			ha->isp_ops->mpi_fw_dump(vha, 1);
-		ha->isp_ops->fw_dump(vha, 1);
+		ha->isp_ops->fw_dump(vha);
 		ha->flags.fw_init_done = 0;
 		QLA_FW_STOPPED(ha);
 
@@ -3473,7 +3473,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 			qla2xxx_check_risc_status(vha);
 
-			ha->isp_ops->fw_dump(vha, 1);
+			ha->isp_ops->fw_dump(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
@@ -3602,7 +3602,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 			qla2xxx_check_risc_status(vha);
 
-			ha->isp_ops->fw_dump(vha, 1);
+			ha->isp_ops->fw_dump(vha);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			break;
 		} else if ((stat & HSRX_RISC_INT) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9fd83d1bffe0..fb3e481bfa0c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -462,7 +462,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			 * a dump
 			 */
 			if (mcp->mb[0] != MBC_GEN_SYSTEM_ERROR)
-				ha->isp_ops->fw_dump(vha, 0);
+				qla2xxx_dump_fw(vha);
 			rval = QLA_FUNCTION_TIMEOUT;
 		 }
 	}
@@ -6213,7 +6213,7 @@ qla83xx_restart_nic_firmware(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1144,
 		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
 		    rval, mcp->mb[0], mcp->mb[1]);
-		ha->isp_ops->fw_dump(vha, 0);
+		qla2xxx_dump_fw(vha);
 	} else {
 		ql_dbg(ql_dbg_mbx, vha, 0x1145, "Done %s.\n", __func__);
 	}
@@ -6258,7 +6258,7 @@ qla83xx_access_control(scsi_qla_host_t *vha, uint16_t options,
 		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[3]=%x mb[4]=%x.\n",
 		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3],
 		    mcp->mb[4]);
-		ha->isp_ops->fw_dump(vha, 0);
+		qla2xxx_dump_fw(vha);
 	} else {
 		if (subcode & BIT_5)
 			*sector_size = mcp->mb[1];
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d2037253e2d7..ec4d6675c62f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -4514,7 +4514,7 @@ qla82xx_beacon_off(struct scsi_qla_host *vha)
 }
 
 void
-qla82xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla82xx_fw_dump(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index b5c3e56edaba..df9429428316 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -4070,7 +4070,7 @@ qla8044_abort_isp(scsi_qla_host_t *vha)
 }
 
 void
-qla8044_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+qla8044_fw_dump(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 382e1f977d01..8f96d37a866c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7575,7 +7575,7 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	if (risc_paused) {
 		ql_log(ql_log_info, base_vha, 0x9003,
 		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
-		ha->isp_ops->fw_dump(base_vha, 0);
+		qla2xxx_dump_fw(base_vha);
 
 		return PCI_ERS_RESULT_NEED_RESET;
 	} else
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f3255aa70dcc..3af8a8a7f997 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5670,9 +5670,9 @@ static int qlt_chk_unresolv_exchg(struct scsi_qla_host *vha,
 			    vha, 0xffff, (uint8_t *)entry, sizeof(*entry));
 
 			if (qpair == ha->base_qpair)
-				ha->isp_ops->fw_dump(vha, 1);
+				ha->isp_ops->fw_dump(vha);
 			else
-				ha->isp_ops->fw_dump(vha, 0);
+				qla2xxx_dump_fw(vha);
 
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 281973b317a8..4a4d92046cbf 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1081,14 +1081,9 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 }
 
 void
-qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
+qla27xx_fwdump(scsi_qla_host_t *vha)
 {
-	ulong flags = 0;
-
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
-#endif
+	lockdep_assert_held(&vha->hw->hardware_lock);
 
 	if (!vha->hw->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd01e, "-> fwdump no buffer\n");
@@ -1105,11 +1100,11 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		if (!fwdt->template) {
 			ql_log(ql_log_warn, vha, 0xd012,
 			       "-> fwdt0 no template\n");
-			goto bailout;
+			return;
 		}
 		len = qla27xx_execute_fwdt_template(vha, fwdt->template, buf);
 		if (len == 0) {
-			goto bailout;
+			return;
 		} else if (len != fwdt->dump_size) {
 			ql_log(ql_log_warn, vha, 0xd013,
 			       "-> fwdt0 fwdump residual=%+ld\n",
@@ -1124,10 +1119,4 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		    vha->host_no, vha->hw->fw_dump, vha->hw->fw_dump_cap_flags);
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
-
-bailout:
-#ifndef __CHECKER__
-	if (!hardware_locked)
-		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
-#endif
 }
