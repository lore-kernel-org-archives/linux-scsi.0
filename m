Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B3FC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 306486526E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbhCAR1p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237897AbhCARV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:28 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0490C061223
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so847621ply.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HojwSP4OY4K/DWvWvgLZZT3DYlNWcPTcaG9iktTxOp8=;
        b=JO7I4j8FiQdRIjFB82ZpbZr4QxtHHQnorcZDzuqcdyrszI6W+XTIyudL7QfJnerglZ
         X9HFN5Gc8rU7WCSBaeN78yqbgAhH2mI8bHvhDncbS4C2WfJAcSrG7AdbXnbTP8kH2ccG
         gSXfXIdKr9wrk/KG7sva54VG8/Lhp9hPQ0sVBrQYStxJCgaCMbqclh3DeAcV0d9HNi4N
         y+NqXgIoLzHkZRI2Rx6gKa+GvjcuvHpYdjb1hF6BgF8OxWVVww7wK9BYLEMvMoFI/OyO
         fIK9wCYsxdbfByMrsJIwVxdl3g5iz/KAB/UP4v7vEKh2AJDFoN494S7WjCEFSLBpa8eY
         RlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HojwSP4OY4K/DWvWvgLZZT3DYlNWcPTcaG9iktTxOp8=;
        b=svEJ9U+IuJHR2uD3B15JN/8mS+cyfa0p4LfL/waKI4wAZp8aZ35aRn9kzhiAX3D9bR
         e0+cPwVqETiD/VRej0OXUFDXiYyFbTisur5bsEUWIg3x6EJcwHgfyISsK8WdUPDlK6dK
         DYRbfhjbIrsYwdOr9zkAsSuiFap4r7K4qnnvk62GCHXpoSCdDNfUo7Je7h1NDfb6vLwI
         irlF/kgGCb2KzOJPX3iSNp573sde0ca63A6P0eclaM4/JsXSXB9bxuvpv/HU9FaZlkaV
         88ZnXomFc2B0vA0i/ozbrzRZ6TJsPONyZGEB1DvWvcHuCSr0iASb6qlMs9Acl4WDAyPJ
         K7Ig==
X-Gm-Message-State: AOAM533CgqOZgtI+c7lAzbOer7ShNgmBY7awr/V9JuPsjxwJtf7G3zAu
        p/X6gu8ymXDcobNHVnJY4QnTnjyZnsA=
X-Google-Smtp-Source: ABdhPJzKWmFs3uVFkMDQkNKXjPH+JnBz/Fs67cpFu3t/vr8avfhWgHE6Xg9QRGo+MGY8njI5QGrbRg==
X-Received: by 2002:a17:902:7407:b029:e4:9b2c:528b with SMTP id g7-20020a1709027407b02900e49b2c528bmr9057527pll.6.1614619117378;
        Mon, 01 Mar 2021 09:18:37 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:37 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 15/22] lpfc: Fix nodeinfo debugfs output
Date:   Mon,  1 Mar 2021 09:18:14 -0800
Message-Id: <20210301171821.3427-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The debugfs nodeinfo output gets jumbled when  no rpri or a defer entry
is displayed. The misalignment makes it difficult to read.

Change the format to consistently print out a 4 character rpi, and turn
defer into a suffix.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index bc79a017e1a2..689c183485f7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -869,7 +869,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 				"WWNN x%llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len += scnprintf(buf+len, size-len, "RPI:%03d ",
+			len += scnprintf(buf+len, size-len, "RPI:%04d ",
 					ndlp->nlp_rpi);
 		else
 			len += scnprintf(buf+len, size-len, "RPI:none ");
@@ -895,7 +895,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
 			len += scnprintf(buf + len,
 					size - len, "NVME_INITIATOR ");
-		len += scnprintf(buf+len, size-len, "refcnt:%x",
+		len += scnprintf(buf+len, size-len, "refcnt:%d",
 			kref_read(&ndlp->kref));
 		if (iocnt) {
 			i = atomic_read(&ndlp->cmd_pending);
@@ -904,8 +904,11 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 					i, ndlp->cmd_qdepth);
 			outio += i;
 		}
-		len += scnprintf(buf + len, size - len, "defer:%x ",
-			ndlp->nlp_defer_did);
+		len += scnprintf(buf+len, size-len, " xpt:x%x",
+				 ndlp->fc4_xpt_flags);
+		if (ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING)
+			len += scnprintf(buf+len, size-len, " defer:%x",
+					 ndlp->nlp_defer_did);
 		len +=  scnprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
-- 
2.26.2

