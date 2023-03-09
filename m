Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F09C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCIT21 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCIT2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:09 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9333028E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:08 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so7273335pjg.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtvaziFz+alOfUQZbNe+VAlPBd5fDCw1fGTb/wB6Zxw=;
        b=7OKEWkrF+l47Q6ep7TnE5c+KLQUb814UcZ3PTzTHI9Fx0mclVh+wcht0qqWAkpNmwD
         NBpQq2Ykp701Dv0u+IEPd+Zwrvh2F9zxuUxBhf90f0rHG4KuXeusxiwQPNS4T0BLBFPm
         UvuPPyOlvlq1gw4tKIUU8Dn5e8MHjZnHWmjaKCSim8rf2WCTdwcDiRA8i8VJIfXtWTVw
         VC4RN3OLxcST9xLfMiR8t5MvjYAcsCv1OzteMtpjbHyzEVk9ptRY9D97KSPSFsJdgK1S
         cO7B+TafuqBvTyhBJ3haX0kBtB0u9ek2G16JTM+jKmaHK86q8x/XFnlWOW7bXXl8clpC
         c82Q==
X-Gm-Message-State: AO0yUKWix1DlyCDzcUNn4sKD6rPVIqKsl7uBq9gmPVnrFVO07OkQcui+
        fgwia1RHc9qpYSrN7AZJW/c=
X-Google-Smtp-Source: AK7set/OdGrUFLt43qReraA47Q/nKSwR7YXGQmCrzfvtCJQzCRcEhpDC/pzg1cAMbMcKVH0448xBUQ==
X-Received: by 2002:a05:6a20:3caa:b0:af:7233:5bfc with SMTP id b42-20020a056a203caa00b000af72335bfcmr23899742pzj.8.1678390087552;
        Thu, 09 Mar 2023 11:28:07 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 28/82] scsi: powertec: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:20 -0800
Message-Id: <20230309192614.2240602-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/powertec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 7586d2a03812..3b5991427886 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -279,7 +279,7 @@ powertecscsi_store_term(struct device *dev, struct device_attribute *attr, const
 static DEVICE_ATTR(bus_term, S_IRUGO | S_IWUSR,
 		   powertecscsi_show_term, powertecscsi_store_term);
 
-static struct scsi_host_template powertecscsi_template = {
+static const struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
 	.show_info			= powertecscsi_show_info,
 	.write_info			= powertecscsi_set_proc_info,
