Return-Path: <SRS0=6ycn=BL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F58EC433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Aug 2020 13:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29EEC2083E
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Aug 2020 13:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgHANbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Aug 2020 09:31:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41907 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgHANbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2020 09:31:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id s16so19919695ljc.8;
        Sat, 01 Aug 2020 06:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pzBNlNP+HjEb61+l8s6iD5NGvZcBwVXRY/7DujsTy2A=;
        b=YLeKLhtK4nvRhu8pNjGMcWYERRRJ9kA+WK9Ed5vNEuIOZ+lNAeHez5dqOZOFn1w8qY
         tDneV9m7yqM0M1orPmLfRjzUA1j5e+K/GJrNrv4aUxQ92zilQ1CSWZm7UXvCYpEQw8nw
         nZ4k6pVHEGU8wUhxwITER1ROyLww3G8wO9S1kcKXynO7901XDBMEcgSgQDfDnmNDl/K8
         w7Evz3IjCGLt5ZW58fyOGLNcQqnRkZL0da19Cn+O+i8oJP78VWwS4cYOAtyQcdSNwn5K
         Md77N5hm8ePTmeP5N0Aj3ONVN3/R2SSamvmAl9hvtlsnWbSeBb5l0olQAjUBBBX9kaVx
         4dAA==
X-Gm-Message-State: AOAM5306zFV1yyVLSQFIAWhHnY+xc4ckstSkW2wyThSvC4QIO0lXpSTo
        j2D2I7i8GIDvR3bc/KIbdkX2IU8s2bU=
X-Google-Smtp-Source: ABdhPJw9gcZ/VDXmrjhd44WKk9tXDwe1h2NRww6LZWdyx9zqJhqOShjbSG4PGGD24Mxab24bhCbHug==
X-Received: by 2002:a05:651c:201b:: with SMTP id s27mr4058351ljo.468.1596288712717;
        Sat, 01 Aug 2020 06:31:52 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id n82sm2704136lfa.40.2020.08.01.06.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 06:31:52 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: [PATCH v2] scsi: libcxgbi: use kvzalloc instead of opencoded kzalloc/vzalloc
Date:   Sat,  1 Aug 2020 16:31:23 +0300
Message-Id: <20200801133123.61834-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731215524.14295-1-efremov@linux.com>
References: <20200731215524.14295-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
and use kvzalloc/kvfree instead. __GFP_NOWARN added to kvzalloc()
call because we already print a warning in case of allocation fail.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  8 ++++----
 drivers/scsi/cxgbi/libcxgbi.h | 16 ----------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4bc794d2f51c..51f4d34da73f 100644
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
+				  GFP_KERNEL | __GFP_NOWARN);
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

