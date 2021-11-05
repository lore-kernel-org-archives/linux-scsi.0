Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D58FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 09:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7720961268
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 09:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhKEJGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 05:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhKEJGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 05:06:08 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB009C061714;
        Fri,  5 Nov 2021 02:03:28 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id bk22so8150879qkb.6;
        Fri, 05 Nov 2021 02:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RvXU3TzZJE0WgQ5a4zt4EIB12q4I8O54Traj0ZCO/MI=;
        b=R1BMxzb926eBIPilf9yOuD/rXezyX0n0aIZytSurOkhRpASg9QjPKbdWw2R58HyYld
         7dnT/SRXsWi8KuADQaaNjfGqNliSbH/4NANON7aAjGcTdDVX3A9TOjia9d7mkAs4SvWn
         kVCZck9q5wKf/OsHCWhk1/PPLUd2OTzaXcKAaAjlIxcY0v0Yolgm/2MA/1KVJuPV/VJM
         WzCV+hlDbdIvwkSAbGI1ewyu3XMUYj3RP+FO2VYxB6JBIsPDtZZHXJY1UNS/9vl/0bGL
         Sr2UKGXwZ0+fpxBIOgXpQmYph0ZAzQxOKGOemQ8Cm4Os4NjtT6vqV98oetfWuh9ZF3bc
         Y0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RvXU3TzZJE0WgQ5a4zt4EIB12q4I8O54Traj0ZCO/MI=;
        b=BZe7glc751pU9nlU8h2SA+Fz5kdnIlGuWU3Cus+apFALfI3H19BPtVnCHISmgh+iB6
         676tdBo1jlZPK0iqpwlXDEwsx58aGjKFyZ/h8kyr3vKU7pL/dMSbWgbNMl35u6C8DaMK
         WNG5YnCS+hs5Srtr70bRANqjqXAQcx8W9QiYUWYyMLBnzXsAMhiDEd0atbgQoKt/f5sz
         FGvDDbqpdYZW97SuP5XLfP5mtH7118nmNyyY7EgIAsHW2Wq7dx2Ln16eR1Wn0Ggb23wN
         9/XuzGDurC9kpimYpRXsI11aBlMpFH74FPiMKjRaegnASLViG6rJH1H5W2MiMm7oqBTv
         /FZQ==
X-Gm-Message-State: AOAM532NI3FclY6hAX67pZdgSdX2CC/eM21A5Wnssl8PceT6Dqs+RwNs
        Qu9kQgWdqH/KkggvGP2/M3gnTMFAFfw=
X-Google-Smtp-Source: ABdhPJwZAYytbOt7HFTK4TeCTGyu6xSt282z/ZEIPJCJb9J9kQPBw92RNACSnSeKbI+RTDyegS5HMA==
X-Received: by 2002:a05:620a:28ce:: with SMTP id l14mr29881294qkp.456.1636103007991;
        Fri, 05 Nov 2021 02:03:27 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j192sm1829817qke.13.2021.11.05.02.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 02:03:27 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        jiapeng.chong@linux.alibaba.com, yao.jing2@zte.com.cn,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: csiostor: Replace snprintf in show functions with  sysfs_emit
Date:   Fri,  5 Nov 2021 09:03:21 +0000
Message-Id: <20211105090321.77350-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/scsi/csiostor/csio_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 55db02521221..f9b87ae2aa25 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 
 	if (csio_is_hw_ready(hw))
-		return snprintf(buf, PAGE_SIZE, "ready\n");
+		return sysfs_emit(buf, "ready\n");
 	else
-		return snprintf(buf, PAGE_SIZE, "not ready\n");
+		return sysfs_emit(buf, "not ready\n");
 }
 
 /* Device reset */
@@ -1430,7 +1430,7 @@ csio_show_dbg_level(struct device *dev,
 {
 	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%x\n", ln->params.log_level);
+	return sysfs_emit(buf, "%x\n", ln->params.log_level);
 }
 
 /* Store debug level */
@@ -1476,7 +1476,7 @@ csio_show_num_reg_rnodes(struct device *dev,
 {
 	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ln->num_reg_rnodes);
+	return sysfs_emit(buf, "%d\n", ln->num_reg_rnodes);
 }
 
 static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);
-- 
2.25.1

