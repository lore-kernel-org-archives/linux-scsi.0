Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF5CC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8839D6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhDTAJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:32 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:40872 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhDTAJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:29 -0400
Received: by mail-pl1-f171.google.com with SMTP id 20so14722925pll.7
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q9iK91yNau6O94ZCbM5uG/Ghx1tOYDNnoEZlBq1nB6c=;
        b=b8MGXfAegW0PHXindIjE1LeiknPv6mTg5r4pDENxVwSGDF3wDym8tNnMfiunFAbBSU
         SXyzuJPXVUKn852puyTEHXCUSI8HriapCTqdcaJCCg1D2PZZEQuy0bjSsKCsv+rx/iHy
         lgDxX0oifgjoUwB3QaXLqcL9WGVjO1idiVP0BnUtogZFtjuqylOCArfGb0UM5czmv6PI
         YPkasYDCvbzOm7Vi2qJkpXTfY883rAzRi4T2LrWUfDttUwTuu/Ey2faZMTCQrFAq1QoC
         JkTmh+BeSPiDzccgPanAKGwnQ6zBIgWGTsyFBQdF+K8NTYHhbbs743Hpi7PWfWNYVuiy
         CLsA==
X-Gm-Message-State: AOAM5332Ol6Hi2cRcwpm4ro7nZruVFG5iBp/7bnxsTnKTmB4q4B6oomG
        KodIHvi/Wb6iNgMF97IXgTA=
X-Google-Smtp-Source: ABdhPJzfy9+tbq3blpUfrQjkW9/ZZprwiAAjqytH/Zlw0Bje0ASGq17Mu3BGSSBIi/rbuWf3RzAKjw==
X-Received: by 2002:a17:902:f2d1:b029:eb:2e32:8804 with SMTP id h17-20020a170902f2d1b02900eb2e328804mr26027319plc.40.1618877338688;
        Mon, 19 Apr 2021 17:08:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:08:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 006/117] target: Use enum sam_status instead of u8
Date:   Mon, 19 Apr 2021 17:06:54 -0700
Message-Id: <20210420000845.25873-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify whether a SAM status code has been specified
where such a code is expected. This patch does not change any functionality
since SAM_STAT_GOOD and GOOD are both symbolic names for the numerical value
0.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/loopback/tcm_loop.c     |  2 +-
 drivers/target/target_core_alua.c      |  6 +++---
 drivers/target/target_core_iblock.c    |  2 +-
 drivers/target/target_core_pr.c        |  8 ++++----
 drivers/target/target_core_pscsi.c     |  4 ++--
 drivers/target/target_core_sbc.c       | 10 +++++-----
 drivers/target/target_core_spc.c       | 14 +++++++-------
 drivers/target/target_core_transport.c |  5 +++--
 drivers/target/target_core_xcopy.c     |  2 +-
 include/target/target_core_backend.h   |  4 ++--
 include/target/target_core_base.h      |  3 ++-
 11 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 2687fd7d45db..66ea91c52175 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -550,7 +550,7 @@ static int tcm_loop_write_pending(struct se_cmd *se_cmd)
 }
 
 static int tcm_loop_queue_data_or_status(const char *func,
-		struct se_cmd *se_cmd, u8 scsi_status)
+		struct se_cmd *se_cmd, enum sam_status scsi_status)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 5517c7dd5144..3bb921345bce 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -123,7 +123,7 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -255,7 +255,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	}
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd_with_length(cmd, GOOD, rd_len + 4);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, rd_len + 4);
 	return 0;
 }
 
@@ -424,7 +424,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 out:
 	transport_kunmap_data_sg(cmd);
 	if (!rc)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return rc;
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d6fdd1c61f90..deb2b8b64d20 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -474,7 +474,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 6fd5fec95539..4b94b085625b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -234,7 +234,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
 out:
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -297,7 +297,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_unlock(&dev->dev_reservation_lock);
 out:
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -3676,7 +3676,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -4073,7 +4073,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 	}
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index dac44caf77a3..fd617bc4113e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -588,7 +588,7 @@ static void pscsi_destroy_device(struct se_device *dev)
 	}
 }
 
-static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
+static void pscsi_complete_cmd(struct se_cmd *cmd, enum sam_status scsi_status,
 			       unsigned char *req_sense)
 {
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
@@ -1044,7 +1044,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	struct se_cmd *cmd = req->end_io_data;
 	struct pscsi_plugin_task *pt = cmd->priv;
 	int result = scsi_req(req)->result;
-	u8 scsi_status = status_byte(result) << 1;
+	enum sam_status scsi_status = status_byte(result) << 1;
 
 	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 7b07e557dc8d..b32f4ee88e79 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -67,7 +67,7 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 8);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 8);
 	return 0;
 }
 
@@ -130,7 +130,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 32);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 32);
 	return 0;
 }
 
@@ -202,14 +202,14 @@ sbc_execute_write_same_unmap(struct se_cmd *cmd)
 			return ret;
 	}
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
 static sense_reason_t
 sbc_emulate_noop(struct se_cmd *cmd)
 {
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -1245,7 +1245,7 @@ sbc_execute_unmap(struct se_cmd *cmd)
 err:
 	transport_kunmap_data_sg(cmd);
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 70a661801cb9..0756a690ea84 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -750,7 +750,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	kfree(buf);
 
 	if (!ret)
-		target_complete_cmd_with_length(cmd, GOOD, len);
+		target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, len);
 	return ret;
 }
 
@@ -1104,7 +1104,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, length);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, length);
 	return 0;
 }
 
@@ -1122,7 +1122,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	int i;
 
 	if (!cmd->data_length) {
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 		return 0;
 	}
 
@@ -1165,7 +1165,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	transport_kunmap_data_sg(cmd);
 
 	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
 }
 
@@ -1198,7 +1198,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
@@ -1265,7 +1265,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		transport_kunmap_data_sg(cmd);
 	}
 
-	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
+	target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, 8 + lun_count * 8);
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_report_luns);
@@ -1273,7 +1273,7 @@ EXPORT_SYMBOL(spc_emulate_report_luns);
 static sense_reason_t
 spc_emulate_testunitready(struct se_cmd *cmd)
 {
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8fbfe75c5744..b55db3a1f94b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -855,7 +855,7 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 }
 
 /* May be called from interrupt context so must not sleep. */
-void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+void target_complete_cmd(struct se_cmd *cmd, enum sam_status scsi_status)
 {
 	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
 	int success, cpu;
@@ -910,7 +910,8 @@ void target_set_cmd_data_length(struct se_cmd *cmd, int length)
 }
 EXPORT_SYMBOL(target_set_cmd_data_length);
 
-void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+void target_complete_cmd_with_length(struct se_cmd *cmd,
+				     enum sam_status scsi_status, int length)
 {
 	if (scsi_status == SAM_STAT_GOOD ||
 	    cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) {
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d31ed071cb08..44d76c304701 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -1011,7 +1011,7 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 	put_unaligned_be32(42, &p[0]);
 
 	transport_kunmap_data_sg(se_cmd);
-	target_complete_cmd(se_cmd, GOOD);
+	target_complete_cmd(se_cmd, SAM_STAT_GOOD);
 
 	return TCM_NO_SENSE;
 }
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1f78b09bba55..15e1db779bce 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -73,9 +73,9 @@ struct sbc_ops {
 int	transport_backend_register(const struct target_backend_ops *);
 void	target_backend_unregister(const struct target_backend_ops *);
 
-void	target_complete_cmd(struct se_cmd *, u8);
+void	target_complete_cmd(struct se_cmd *, enum sam_status);
 void	target_set_cmd_data_length(struct se_cmd *, int);
-void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
+void	target_complete_cmd_with_length(struct se_cmd *, enum sam_status, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d1f7d2a45354..68accab36b3e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,6 +8,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
+#include <scsi/scsi_proto.h>
 
 #define TARGET_CORE_VERSION		"v5.0"
 
@@ -453,7 +454,7 @@ enum target_core_dif_check {
 
 struct se_cmd {
 	/* SAM response code being sent to initiator */
-	u8			scsi_status;
+	enum sam_status		scsi_status;
 	u8			scsi_asc;
 	u8			scsi_ascq;
 	u16			scsi_sense_length;
