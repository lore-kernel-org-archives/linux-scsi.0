Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CB7C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCIT0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCIT0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:26:24 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6CE841C
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:26:23 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id 16so1692492pge.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:26:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678389983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTPeS6tBEMRDFCUaBbBw56D6tDM3vZchiMLIhTZmKIw=;
        b=vYwjPnGA68L4wW+U6lohD78xtsW4UwDxUEO0V69wi840UDVgZosmKjh52B+wt8qd2x
         IkN0yp/1VH9oQjrbRderSuNU2/4xYD7Tff41gXKtDjhtihz8AvaELbGaC16JKLmJbT+9
         2FjQxYfTDtK7qKjMs0NolUV7OWgNTG53WH3fWJGKwedx6loLNoCYEhAUIKYJac22/f4n
         8lvrNJRpFYbmM3hK0lfFvzArNfjhIy47rQKxFeX9/lG2REr7b5U01+28wx12uytMVF9l
         hvQ6uSXtlB2m1PcXNeR40q9M9aLUq5cuCpVHfo8RVn0jtmXxf08hwlm7SxcUSKFkfv+u
         TIvA==
X-Gm-Message-State: AO0yUKW2DMIzDCgLF0/LNDSkgA65UfiuJf1E4cCuFh+Vdra1OfFPx1tw
        v8ndaKW2sKIeHBY0uHF39Fc=
X-Google-Smtp-Source: AK7set90oEJRldaMAaC3iysy0h5ux6FJyOz4L543boa0qaHqEPd41gTERTHab0o3LIWmY6AGr4b6eg==
X-Received: by 2002:a62:1a46:0:b0:598:b178:a3a9 with SMTP id a67-20020a621a46000000b00598b178a3a9mr18843988pfa.6.1678389982930;
        Thu, 09 Mar 2023 11:26:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:26:22 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 01/82] scsi: qla2xxx: Refer directly to the qla2xxx_driver_template
Date:   Thu,  9 Mar 2023 11:24:53 -0800
Message-Id: <20230309192614.2240602-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Access the qla2xxx_driver_template data structure directly instead of via
the host pointer. This patch prepares for declaring the 'hostt' pointer
const.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index aa0cf5ca6c1c..5258b07687a9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6395,8 +6395,7 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		return -ENOMEM;
 	}
 
-	if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
-		base_vha->host->hostt->supported_mode |= MODE_TARGET;
+	qla2xxx_driver_template.supported_mode |= MODE_TARGET;
 
 	rc = btree_init64(&tgt->lun_qpair_map);
 	if (rc) {
