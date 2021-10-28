Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642BAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 10:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 431A060232
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 10:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhJ1KVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 06:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1KVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 06:21:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8801AC061570;
        Thu, 28 Oct 2021 03:18:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so4292172pjb.4;
        Thu, 28 Oct 2021 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtRMwbZy5HFLEPgyWN1+wEtHlSPg79vWQXM45h0t10c=;
        b=oxgzxeTrN+TYAcnoVkWvO74cRWoGFvMFKYQDZ8W6fMJQeyG7t4p+JZkYdbKNn43Fs8
         ezL2e29zimjGZ9gGRseCM3rLlNAM4ozEZKEzpxVJ6K6TF/s6DcrJ2COcVz0QsAgqHGxb
         pNk2hj7W3wdZkMtQJj3zxNBtmSO2sWz02V4br3wRzpjtmV/5cQzOTQrFOXPmM4r0ys46
         rrTtLNzJAXNr+ixnmyitix+R/PbtCBGsSBm2YBsq6Z4QaQ+lhdTNzTNl7jDzUtQfub01
         aIT6YZJsDLaPmR5JITYPAcgfwbkXHvHWkgIlWY0jtOG7GjuX0j/ARb2i3WNUD9y64elM
         3YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AtRMwbZy5HFLEPgyWN1+wEtHlSPg79vWQXM45h0t10c=;
        b=EGWmaTRAfrdHcb39D/TkPGw0Tl26zlbmUxU+fQjpqyMYJxaLqhMa8WSCqIyC7Wex6f
         wcbNBpasPF/k6llh2yyiFwE7SAoGXdKbul5D11AfwjysH9HDvqvKAkN2nB8PuDoqeWO2
         I1aROVXRw4IcYz5yoQajLqjo4Z42ewNTyUkAHfkJuraWv32+gtqk3TKl2VsC9twQey41
         XnBdeGHt1adTmZQal0Ky+QUYHXF23BplAsB7K+kYogo87qHilfW+WVPXXF4CCE5OgqMf
         c5fmQ+3FKLOQqZLbkcrjtdkq36g6FxR1dL9XMeFWUgIywvvgTQztA/Zxl9taroIjQciZ
         xzdw==
X-Gm-Message-State: AOAM530B4Z4UTc9uPXcRZ9OXfjgO8A63mV5/31gcWNbF8aNz2kpxdHCJ
        tCwyHlZopxAxdabyJLmSrc0=
X-Google-Smtp-Source: ABdhPJz7xIwmNa3Y3CFRxLmGY5vvdUVSMta4nlpfTYIzMnKDtZuK8/U1rVWjSsZ+c9d0o4i9zUx6WQ==
X-Received: by 2002:a17:90a:7a81:: with SMTP id q1mr33172pjf.1.1635416321121;
        Thu, 28 Oct 2021 03:18:41 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g13sm3167115pfv.20.2021.10.28.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 03:18:40 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     tyreld@linux.ibm.com
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] drivers: scsi: replace snprintf in show functions with sysfs_emit
Date:   Thu, 28 Oct 2021 10:18:22 +0000
Message-Id: <20211028101822.14278-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index d0eab5700dc5..9f20fefc2c02 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3403,7 +3403,7 @@ static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, PAGE_SIZE, "%s\n",
 			vhost->login_buf->resp.partition_name);
 }
 
@@ -3413,7 +3413,7 @@ static ssize_t ibmvfc_show_host_device_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, PAGE_SIZE, "%s\n",
 			vhost->login_buf->resp.device_name);
 }
 
@@ -3423,7 +3423,7 @@ static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, PAGE_SIZE, "%s\n",
 			vhost->login_buf->resp.port_loc_code);
 }
 
@@ -3433,7 +3433,7 @@ static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",
+	return sysfs_emit(buf, PAGE_SIZE, "%s\n",
 			vhost->login_buf->resp.drc_name);
 }
 
@@ -3442,7 +3442,7 @@ static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
+	return sysfs_emit(buf, PAGE_SIZE, "%d\n", be32_to_cpu(vhost->login_buf->resp.version));
 }
 
 static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
@@ -3450,7 +3450,7 @@ static ssize_t ibmvfc_show_host_capabilities(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
-	return snprintf(buf, PAGE_SIZE, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
+	return sysfs_emit(buf, PAGE_SIZE, "%llx\n", be64_to_cpu(vhost->login_buf->resp.capabilities));
 }
 
 /**
-- 
2.25.1

