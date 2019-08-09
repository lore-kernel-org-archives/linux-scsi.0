Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019D2C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D10E4216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405103AbfHIDDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46331 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so22084901pfa.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OihDqAFcZAAQI9tyU/1cYrK6T4AXY8Qv0TkWBV72KK0=;
        b=OeyUeyDJvgCNGC1FobnhTCFxD6/HZUxanTKZNwZyg2zOpVcFN7YZOXgzr4JF7ki0B5
         Ljn7OebbMSMmJiXm7u7lZpUCkNHJQBEu7m1BwnPhD56NqW2VO/OIeEt5tKQx9MFHHkMi
         U+7dxq1dugZMWjvVXl1am4qYDDZVAJoYl+Zd7GAJrsSK0mIifaqA0o+XmDaDBtHYVNlq
         maD2+Yp3AogKX0KWs3Jxkpwo1na66qExH7wWWsjot+RgV5waS40vdNL3hh3XiFRNT6M3
         VGtjfXwfc4OcqZ74kG25keC2i3I5wr1s/VoaXX3iQrBRRBeh2898sT18bLKxmRYDpJLV
         TmIg==
X-Gm-Message-State: APjAAAVXgO8NmZQfFTaP7L2fuABqyjhRx3RUudsEfvHuEDs7j1Ojt1ev
        YGkbcNcWqYpHLOnXm9w/1D4=
X-Google-Smtp-Source: APXvYqxrKiA/dkMwPPHcrJVcuDim7PerC9JI0mBkkmyJdes/dgQ6Z4M0iRp2i9dC/IfJ+G2hVsSiCg==
X-Received: by 2002:a17:90b:95:: with SMTP id bb21mr7335388pjb.8.1565319785643;
        Thu, 08 Aug 2019 20:03:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 22/58] qla2xxx: Use strlcpy() instead of strncpy()
Date:   Thu,  8 Aug 2019 20:01:43 -0700
Message-Id: <20190809030219.11296-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes several gcc complaints about string truncation.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index cd892edec4dc..b6be7e7f2a43 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1880,22 +1880,22 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			phost_info = &preg_hsi->hsi;
 			memset(preg_hsi, 0, sizeof(struct register_host_info));
 			phost_info->os_type = OS_TYPE_LINUX;
-			strncpy(phost_info->sysname,
-			    p_sysid->sysname, SYSNAME_LENGTH);
-			strncpy(phost_info->nodename,
-			    p_sysid->nodename, NODENAME_LENGTH);
+			strlcpy(phost_info->sysname, p_sysid->sysname,
+				sizeof(phost_info->sysname));
+			strlcpy(phost_info->nodename, p_sysid->nodename,
+				sizeof(phost_info->nodename));
 			if (!strcmp(phost_info->nodename, "(none)"))
 				ha->mr.host_info_resend = true;
-			strncpy(phost_info->release,
-			    p_sysid->release, RELEASE_LENGTH);
-			strncpy(phost_info->version,
-			    p_sysid->version, VERSION_LENGTH);
-			strncpy(phost_info->machine,
-			    p_sysid->machine, MACHINE_LENGTH);
-			strncpy(phost_info->domainname,
-			    p_sysid->domainname, DOMNAME_LENGTH);
-			strncpy(phost_info->hostdriver,
-			    QLA2XXX_VERSION, VERSION_LENGTH);
+			strlcpy(phost_info->release, p_sysid->release,
+				sizeof(phost_info->release));
+			strlcpy(phost_info->version, p_sysid->version,
+				sizeof(phost_info->version));
+			strlcpy(phost_info->machine, p_sysid->machine,
+				sizeof(phost_info->machine));
+			strlcpy(phost_info->domainname, p_sysid->domainname,
+				sizeof(phost_info->domainname));
+			strlcpy(phost_info->hostdriver, QLA2XXX_VERSION,
+				sizeof(phost_info->hostdriver));
 			preg_hsi->utc = (uint64_t)ktime_get_real_seconds();
 			ql_dbg(ql_dbg_init, vha, 0x0149,
 			    "ISP%04X: Host registration with firmware\n",
-- 
2.22.0

