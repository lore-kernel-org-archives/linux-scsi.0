Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C94C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B97216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405051AbfHIDCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42092 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405037AbfHIDCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so45206028pff.9
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9WAAX9Y0zP1Jn7Vve06z7WASC8kB7DiabVDFYSgmhhg=;
        b=tWUb5iTSduj24vQbtPa7JjHHyVL5CR1Rkr1IUFCXyVVaH8fYQQ6HjHMUskw7zpN9GX
         h4v6uS5gPR1t2N5De27Xf7kodONqM42vkscV2jR3c+gTzph+A1aI0FW+uJ8ygoCGh1DB
         eTZlLZSnGkHCteEvQLR01tBpFIqZb/ObpIXxDWMuATGwFPEhVqX0DaioqROzrJZsz48X
         quIdWi5Z9L3aIMe7/WrCmPQJ9ksnYbOJm6/ahWvP/tpMj9wm5IbHM4tWGtxpQ9pIAQ8x
         kML09A8dmF6KLHE9FbOLVXLikTyX9fkHYQBv3NtH5qVuWZxy/AgjUd60Cx0aXDuBPSh+
         wJlg==
X-Gm-Message-State: APjAAAV0tC+BO9sn9qNZllDLJkCjgGngIT+aqlPp+AdBEhGZTyS/7URY
        kNB/An0MaSOXyT9ry5i/P/4=
X-Google-Smtp-Source: APXvYqzsrK0FBU82d3IGtKTKWdgc/6c1SX0ZaaTnkEqdE7Cat8cbh63rbGnTbhpSPsXbKLcDAIsWXQ==
X-Received: by 2002:aa7:8392:: with SMTP id u18mr19130202pfm.72.1565319773612;
        Thu, 08 Aug 2019 20:02:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 13/58] qla2xxx: Verify locking assumptions at runtime
Date:   Thu,  8 Aug 2019 20:01:34 -0700
Message-Id: <20190809030219.11296-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that locking assumptions are verified at runtime if kernel
debugging is enabled.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b8241d7b1f8a..ded5f13372af 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -789,6 +789,8 @@ qlt_plogi_ack_find_add(struct scsi_qla_host *vha, port_id_t *id,
 {
 	struct qlt_plogi_ack_t *pla;
 
+	lockdep_assert_held(&vha->hw->hardware_lock);
+
 	list_for_each_entry(pla, &vha->plogi_ack_list, list) {
 		if (pla->id.b24 == id->b24) {
 			ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x210d,
@@ -4713,6 +4715,8 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 	struct qlt_plogi_ack_t *pla;
 	unsigned long flags;
 
+	lockdep_assert_held(&vha->hw->hardware_lock);
+
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
 
 	port_id.b.domain = iocb->u.isp24.port_id[2];
@@ -4886,6 +4890,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	int res = 0;
 	unsigned long flags;
 
+	lockdep_assert_held(&ha->hardware_lock);
+
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
 
 	port_id.b.domain = iocb->u.isp24.port_id[2];
@@ -5162,6 +5168,8 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 	int send_notify_ack = 1;
 	uint16_t status;
 
+	lockdep_assert_held(&ha->hardware_lock);
+
 	status = le16_to_cpu(iocb->u.isp2x.status);
 	switch (status) {
 	case IMM_NTFY_LIP_RESET:
-- 
2.22.0

