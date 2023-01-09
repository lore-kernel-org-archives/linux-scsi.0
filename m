Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2500CC54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbjAIXXG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbjAIXW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:56 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F65591
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:54 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d15so11295293pls.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENG+xXxIpzNakvIl6g76frXEgokYLHb09WosjLbHNdk=;
        b=Nf7qUMXloYgvjvOcW4tEoV+CLDF1/7lFQl4OoP9OQF7xU9+1Op/43fIRmofAlqr+xh
         HlYo+WMuXwHh6CuJVn6v6q5JXyfvQ6l8ekFrMUg/To8CIcjumFavngjQmPjHI6wN9Tww
         cKp3folvaYN9si0TKL7j1k5+yn/jeDT7SVyQW04vPlZJRwJUVjCphmnKc6BitmIr30vB
         OWDLsHZHe/vASBaEOr8VjuF2IRp//vLrXgT0Cvf023lGPDZBvsWobyHcjyZzxJmcA9aw
         xTBcX+tXRMRsu2Ht9SNasJBg3kH6YfHSS9czIQlF2OK+9xshVqumktQVUa3f3DuxFKJi
         eDSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENG+xXxIpzNakvIl6g76frXEgokYLHb09WosjLbHNdk=;
        b=s60oJYTLF9/9INdCqxH6DRtn2iX30I9MXDs1yrMHVA0v68goXvtNqM6LkTNt6QXVU9
         sPgnmRJzjfCdCgiXx94xvoaKDNIUXVvr9SA+2fyhkRyBTFGHJbDyolfvmMoS7K8JCI1Q
         x7O4U8xTyKdkNJK+ZGnkb24p3x23J2BNhTLpJQNDuqtwJJ3Jwc6gmuG8upwSX5xcS5fW
         Rxkjz549Ir0sG7j/1wmMWWZANzVUvyBTirleJ8i1xWGX+VG1yL+LTW94NpjiM+FM58Ba
         7jS0gk5uXtFONKUnigsC3QS4dLnHamaP7t4h911QZyL5g28D4/8A1GlRuUoz+HUsrAo4
         LKZw==
X-Gm-Message-State: AFqh2krlA4ZkWZk7bMdCLS92DOuOcPP4/bo3b4PSuCOSpc4Ov72wsdN8
        chGmSPOTX62wbqL1EWdPaUKPgFs8c0A=
X-Google-Smtp-Source: AMrXdXshcsfb6HWWeVCeWTSBSzC4VwGUZvYoZLG+x/fFk1jX31Kbviqcn+jqXcmpHPXGgMH1kBb2ww==
X-Received: by 2002:a17:902:ce85:b0:18f:a0de:6ad0 with SMTP id f5-20020a170902ce8500b0018fa0de6ad0mr88325421plg.55.1673306573841;
        Mon, 09 Jan 2023 15:22:53 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:53 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/12] lpfc: Reinitialize internal VMID data structures after FLOGI completion
Date:   Mon,  9 Jan 2023 15:33:14 -0800
Message-Id: <20230109233317.54737-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After enabling VMID, an issue lip test was erasing fabric switch VMID
information.

Introduce a lpfc_reinit_vmid routine, which reinitializes all VMID data
structures upon FLOGI completion in fabric topology.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_els.c  |  3 +++
 drivers/scsi/lpfc/lpfc_vmid.c | 39 +++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 6f63e0acf9dd..e72a2504163a 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -683,6 +683,7 @@ int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
 			union lpfc_vmid_io_tag *tag);
 void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
 int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
+void lpfc_reinit_vmid(struct lpfc_vport *vport);
 
 void lpfc_sli_rpi_release(struct lpfc_vport *vport,
 			  struct lpfc_nodelist *ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4d3b8f2036d2..264a3db6cd69 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1123,6 +1123,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (sp->cmn.priority_tagging)
 		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
 						  LPFC_VMID_TYPE_PRIO);
+	/* reinitialize the VMID datastructure before returning */
+	if (lpfc_is_vmid_enabled(phba))
+		lpfc_reinit_vmid(vport);
 
 	/*
 	 * Address a timing race with dev_loss.  If dev_loss is active on
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index ed1d7f7b88a3..9175982066f8 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -284,3 +284,42 @@ int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
 	}
 	return rc;
 }
+
+/*
+ * lpfc_reinit_vmid - reinitializes the vmid data structure
+ * @vport: pointer to vport data structure
+ *
+ * This routine reinitializes the vmid post flogi completion
+ *
+ * Return codes
+ *	None
+ */
+void
+lpfc_reinit_vmid(struct lpfc_vport *vport)
+{
+	u32 bucket, i, cpu;
+	struct lpfc_vmid *cur;
+	struct lpfc_vmid *vmp = NULL;
+	struct hlist_node *tmp;
+
+	write_lock(&vport->vmid_lock);
+	vport->cur_vmid_cnt = 0;
+
+	for (i = 0; i < vport->max_vmid; i++) {
+		vmp = &vport->vmid[i];
+		vmp->flag = LPFC_VMID_SLOT_FREE;
+		memset(vmp->host_vmid, 0, sizeof(vmp->host_vmid));
+		vmp->io_rd_cnt = 0;
+		vmp->io_wr_cnt = 0;
+
+		if (vmp->last_io_time)
+			for_each_possible_cpu(cpu)
+				*per_cpu_ptr(vmp->last_io_time, cpu) = 0;
+	}
+
+	/* for all elements in the hash table */
+	if (!hash_empty(vport->hash_table))
+		hash_for_each_safe(vport->hash_table, bucket, tmp, cur, hnode)
+			hash_del(&cur->hnode);
+	write_unlock(&vport->vmid_lock);
+}
-- 
2.38.0

