Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B19DC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1392121744
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgGaVzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:55:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39693 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgGaVz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:55:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id z4so3453016ljj.6;
        Fri, 31 Jul 2020 14:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IREyWOnRtPYurDQBokCGrZOkPJGajEmSGqa5viO2V+Q=;
        b=X/T0rGF3sWdQAuytOSgGqy93OWTVQlN7tAh7aCmxFFwmr7QIRfjqtqQOucvRXg7aNu
         iL3W6e4I9M4KORk4GK7CEhORLFj1O+R6ZAkMjygoqKBSU6SlbA/6EGJZGPJztD6jhGdQ
         +sEM2R6rWgA2bj8DJIyiTNbFzolePR+qRCG6fcrmFqHPlVV0jLXxS6a/iwyxME3+pgEP
         VFlTOBAU+w/joUS60hhrcMdaI9iaOj/Tr//HgzPujENVss5u0i9KyNqjucV1zaTqEn68
         KK8Y6ApE1Q3hSHjzq54plKbVGUaABqeWyF70EhiVDmHQ+7PepKHdX3gkt4ESQRz+Qeeu
         vbvA==
X-Gm-Message-State: AOAM531Vhu0cO9C41nv7fXazd2WPEyynDBxtNW/yeC47I6wShBpgcSbE
        mkFZ1TkrfxV7gxyR3pzUYJk=
X-Google-Smtp-Source: ABdhPJzTQM3MSx3+FAXQJIknEu77JCBKZyDpD/fX9ynCFXtcqMitXWOvxeHoHBMV8cpRUAoOaQQLKw==
X-Received: by 2002:a2e:908a:: with SMTP id l10mr2537005ljg.409.1596232527161;
        Fri, 31 Jul 2020 14:55:27 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id j144sm2674832lfj.54.2020.07.31.14.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:55:26 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libcxgbi: use kvzalloc instead of opencoded kzalloc/vzalloc
Date:   Sat,  1 Aug 2020 00:55:24 +0300
Message-Id: <20200731215524.14295-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
and use kvzalloc/kvfree instead.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  8 ++++----
 drivers/scsi/cxgbi/libcxgbi.h | 16 ----------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4bc794d2f51c..a98b870eb1f3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -77,9 +77,9 @@ int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
 {
 	struct cxgbi_ports_map *pmap = &cdev->pmap;
 
-	pmap->port_csk = cxgbi_alloc_big_mem(max_conn *
-					     sizeof(struct cxgbi_sock *),
-					     GFP_KERNEL);
+	pmap->port_csk = kvzalloc(array_size(max_conn,
+					     sizeof(struct cxgbi_sock *)),
+				  GFP_KERNEL);
 	if (!pmap->port_csk) {
 		pr_warn("cdev 0x%p, portmap OOM %u.\n", cdev, max_conn);
 		return -ENOMEM;
@@ -124,7 +124,7 @@ static inline void cxgbi_device_destroy(struct cxgbi_device *cdev)
 	if (cdev->cdev2ppm)
 		cxgbi_ppm_release(cdev->cdev2ppm(cdev));
 	if (cdev->pmap.max_connect)
-		cxgbi_free_big_mem(cdev->pmap.port_csk);
+		kvfree(cdev->pmap.port_csk);
 	kfree(cdev);
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 84b96af52655..321426242be4 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -537,22 +537,6 @@ struct cxgbi_task_data {
 #define iscsi_task_cxgbi_data(task) \
 	((task)->dd_data + sizeof(struct iscsi_tcp_task))
 
-static inline void *cxgbi_alloc_big_mem(unsigned int size,
-					gfp_t gfp)
-{
-	void *p = kzalloc(size, gfp | __GFP_NOWARN);
-
-	if (!p)
-		p = vzalloc(size);
-
-	return p;
-}
-
-static inline void cxgbi_free_big_mem(void *addr)
-{
-	kvfree(addr);
-}
-
 static inline void cxgbi_set_iscsi_ipv4(struct cxgbi_hba *chba, __be32 ipaddr)
 {
 	if (chba->cdev->flags & CXGBI_FLAG_IPV4_SET)
-- 
2.26.2

