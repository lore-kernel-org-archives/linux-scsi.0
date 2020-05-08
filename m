Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68E6C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8DA4208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HymF7E+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEHIjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHIjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:39:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFC1C05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:39:06 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so870636wra.7
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VHaRXmUthYzSArh/32QvwMeC/h2ZmXYfHepv5d7Xy+k=;
        b=HymF7E+hcAE3oDDv9hGCJbm3SgXDOzFUF6+m0K5mGnfr2z86ZFss92Imoq7oznjm3x
         //Aw+loJRlWQFIqeqW3ow02GWu8WO9fGyl0LLbHx2QBP0uxqizy9SjmQQVYmPVyoVP+k
         5lF6kkLOGic2mK5y9Kxv96GbdR6O4lc/qYosM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VHaRXmUthYzSArh/32QvwMeC/h2ZmXYfHepv5d7Xy+k=;
        b=mAxi1ntcvtmVWle1lQrOQLYUXXm3w6vORb1N/Pvu4ffyvrJnvTwSUt92CepGezKcK0
         iRSG7sgg5VTA6zd6YOO5BX6BZy3H2S6R6Uh1BmlEOdSLM5rOTJK/qh5Da9xc1kTqBKJp
         Gs9XQBScHqaIHkLn6eU2n6+gkEY+7JJOBut/SmBwof0uPDs+QZZG1pr08UOt0ilu8DlE
         nCP6Z+uEV2ajnOmOado9bWlUV0avpUZkU1pHRA9Yf2eA/OM7T4Ksee12DcSVlu/VTdwY
         amSltvA6XSbZ8UjaUsJaek6OBcZTeLdKAVbiSEyiDVble4+a1UmKnmOSApu/OuFcqNEb
         fh4g==
X-Gm-Message-State: AGi0PuZWR41fTe4BblC4NvPooKjk6uB3xJkdnRxTo2eMqMRvQ0gW89qO
        +gJz218XjuTKa20l1lJ788ZFRDc/mKVylq9Yic9qOYd/8OS2tLUJ1SRpLgtQsKBnlJcKIHYQj5N
        aC235mg550kzKi9XyqXUkgc9qa2XFGBL2VbzErdV4IlHV6LRJEFvz8aQPskvuYfj0NrPv5leuFL
        oAJbq6c1fd+buu
X-Google-Smtp-Source: APiQypIIztdXMxpbVjP+9p3bPRJArlxSkdv7ok2B5NHXXwnBC7qziFO2Tb0flqgBZun7LMxXQ9XUtw==
X-Received: by 2002:adf:ffc2:: with SMTP id x2mr1582369wrs.273.1588927145121;
        Fri, 08 May 2020 01:39:05 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a8sm1810240wrg.85.2020.05.08.01.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:39:04 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/5] megaraid_sas: Limit device qd to controller qd when device qd is greater than controller qd
Date:   Fri,  8 May 2020 14:08:34 +0530
Message-Id: <20200508083838.22778-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
References: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, driver assigns pre-defined qd when firmware provided
device qd is greater than the controller queue depth.
This change assigns controller queue depth instead of pre-defined
qd when firmware provided qd is greater than controller queue depth.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index fb9c3ce..aeb5952 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1982,9 +1982,8 @@ static void megasas_set_fw_assisted_qd(struct scsi_device *sdev,
 
 	if (is_target_prop) {
 		tgt_device_qd = le32_to_cpu(instance->tgt_prop->device_qdepth);
-		if (tgt_device_qd &&
-		    (tgt_device_qd <= instance->host->can_queue))
-			device_qd = tgt_device_qd;
+		if (tgt_device_qd)
+			device_qd = min(instance->host->can_queue, (int)tgt_device_qd);
 	}
 
 	if (instance->enable_sdev_max_qd && interface_type != UNKNOWN_DRIVE)
-- 
2.9.5

