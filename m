Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDAEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71A920784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADSEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbhADSEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:11 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B17C061798
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b5so58428pjk.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O7LymfHZoxVbM06ju8zfjeBBPjcIyw3gwBJgr1ToUwo=;
        b=degkkc8JrrnQ9mI9jMqlDhokTfbW7yD2WZfxX1XNeq5Vj4Rr6rxjFgWtsBXRIC6VtE
         WD2UtUtnhvJg8hEWbDkh4bpBehbwhasCLMP51XkIsQlba7xgoS8ggoCnSnJjb09tLvcJ
         znYT8x3Pzwcrl2achICrmN7JA3yZOvpHnsMjjZKANS8bcAzxTqWE2mbOGZtNfwR5z+wq
         Uyo4d0eqd+UDEr6Kz2wmDORpRCT5TVNiYkoZgmS7Q9My8xHA2un82vTAy8azXmVRCDGe
         IzsRN9Vt5ELD9rU1eYbb1Qk/5SvJM36fGqE+JNeQvKhsFWBaFG0tIP3OgT/Kts/Hg1p4
         OHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7LymfHZoxVbM06ju8zfjeBBPjcIyw3gwBJgr1ToUwo=;
        b=YFazpG98kX9wkJMw7DtnJ8OthxGQHYPenbeS+zz1Nk0UC9Tb/35OTtkQbNdT+QDJAP
         I+tTSjKA9iapg5/8vkMXX7+tzJ09C3gJ3ZTfSXMkbxtgJ6iE0sP/oZ9SavULpTsQTQyR
         vdN2usR93wGNj3QCF8fLf3X/rshL+plQKjaXcOkbQ+gUNQObcdQ5O6J+x8ii1+pdFyou
         yLwARS9i/vxoTGA9BBgtM1F/IWlKXo7kjU/20GUdgY0qvNlehTSlNXrjp/u/hqAMsoL2
         Wwzr2mw7NyPx5UohTR5Zlw+9KtzDbC6XGS7xOuy1qIyaCINAiOUPKmW038zF5nYPq4Vs
         /Jyw==
X-Gm-Message-State: AOAM533uka5X0MLv56RvIMtvTo/nSd5deDFKYGwTwwMhgjJMVjdZ9YJV
        y0jg2nZucfK3js3FNMkNQPKVUSa/OWs=
X-Google-Smtp-Source: ABdhPJxktcWC4PZxXaiRZ3Ylw205BtaFs2JwRx3UbogfOMXDqCUrjYezcHUZVPxeHVKM/0s1FaRGVQ==
X-Received: by 2002:a17:902:c392:b029:dc:3e1d:2316 with SMTP id g18-20020a170902c392b02900dc3e1d2316mr62285338plg.50.1609783383392;
        Mon, 04 Jan 2021 10:03:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 05/15] lpfc: Use the nvme-fc transport supplied timeout for LS requests
Date:   Mon,  4 Jan 2021 10:02:30 -0800
Message-Id: <20210104180240.46824-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When lpfc generates a GEN_REQUEST wqe for the nvme LS (such as Create
Association), the timeout is set to R_A_TOV  without regard to the
timeout value supplied by the nvme-fc transport. The driver should be
setting the timeout to the value passed into the routine. Additionally
the caller should be setting the timeout value to the value in the ls
request set by the nvme transport. Instead, it unconditionally is
setting it to a driver defined value.  So the driver actually overrode
the value twice.

Fix by using the timeout provided to the routine, and for the caller,
set the timeout to the ls request timeout value.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 1cb82fa6a60e..fd4a1cf0e4a6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -458,7 +458,7 @@ lpfc_nvme_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	bf_set(wqe_xri_tag, &wqe->gen_req.wqe_com, genwqe->sli4_xritag);
 
 	/* Word 7 */
-	bf_set(wqe_tmo, &wqe->gen_req.wqe_com, (vport->phba->fc_ratov-1));
+	bf_set(wqe_tmo, &wqe->gen_req.wqe_com, tmo);
 	bf_set(wqe_class, &wqe->gen_req.wqe_com, CLASS3);
 	bf_set(wqe_cmnd, &wqe->gen_req.wqe_com, CMD_GEN_REQUEST64_WQE);
 	bf_set(wqe_ct, &wqe->gen_req.wqe_com, SLI4_CT_RPI);
@@ -615,7 +615,7 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	ret = lpfc_nvme_gen_req(vport, bmp, pnvme_lsreq->rqstaddr,
 				pnvme_lsreq, gen_req_cmp, ndlp, 2,
-				LPFC_NVME_LS_TIMEOUT, 0);
+				pnvme_lsreq->timeout, 0);
 	if (ret != WQE_SUCCESS) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6052 NVMEx REQ: EXIT. issue ls wqe failed "
-- 
2.26.2

