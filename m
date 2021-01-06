Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4A7C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5537822EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbhAGEy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:54:28 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:52126 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbhAGEy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:54:26 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id F389D82D0D;
        Wed,  6 Jan 2021 20:53:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com F389D82D0D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609995203;
        bh=FxTtnlGadZn3It6ChcRUQ0tpCBNu7uDAvp7csH4bByk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLtR4cILeN8hIDgGaXPBbcM+VZs5X0CCGZji2t0SfNJsXJRRKX36a3bDnoyD+0du5
         IzDBRm3Z5IVyEdXBjfpjUvidqVquRILwBVv2KPQsHnOEJmZVwuDQ1W2tGQsQcHwY9O
         AuXHvpPdLYDRCciyzlK/Wr0tmoUCwB8fx06lqCAU=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v7 06/16] lpfc: vmid: Forward declarations for APIs
Date:   Thu,  7 Jan 2021 03:30:20 +0530
Message-Id: <1609970430-19084-7-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch contains the forward declarations of commonly used APIs which
are used outside the scope of the file.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v7:
No change

v6:
No change

v5:
No change

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_crtn.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f78e52a18b0b..7eb0200ecaa8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -606,3 +606,14 @@ extern unsigned long lpfc_no_hba_reset[];
 extern union lpfc_wqe128 lpfc_iread_cmd_template;
 extern union lpfc_wqe128 lpfc_iwrite_cmd_template;
 extern union lpfc_wqe128 lpfc_icmnd_cmd_template;
+
+/* vmid interface */
+int lpfc_vmid_uvem(struct lpfc_vport *vport, struct lpfc_vmid *vmid, bool ins);
+uint32_t lpfc_vmid_get_cs_ctl(struct lpfc_vport *vport);
+int lpfc_vmid_cmd(struct lpfc_vport *vport,
+		  int cmdcode, struct lpfc_vmid *vmid);
+int lpfc_vmid_hash_fn(char *vmid, int len);
+struct lpfc_vmid *lpfc_get_vmid_from_hastable(struct lpfc_vport *vport,
+					      uint32_t hash, uint8_t *buf);
+void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
+int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
-- 
2.26.2

