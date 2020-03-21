Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A72C4332B
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F7E2070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7+jsNFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgCUAmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35753 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgCUAmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so9633402wru.2;
        Fri, 20 Mar 2020 17:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3z4MVElDmiI2dm0EzeC2YxIS/QbuYtQadcdcivLvoZQ=;
        b=A7+jsNFsTfNemQuj2xd8LVu8NvQpWJkK35a5gxMBs/XsSIhku0jZgKxmfgX2q3FxY4
         xnhGnxcQoSxPXJKsOsrdQyxoDvdw8zHMd0h5GK6Osp3eXOrrnUHmNHNgbK+PqPCnPN0h
         v23C5lxoPrwv+A8iAE2Al0QoAMxIwmyHVsIDA6SY2tu/bQezbz3KbbME3EPtgJl2IfVv
         UDHWUX5KGTYRHHOPMZVxbcT+GGMNo+GlQii/7pUJAsOg2gv04yVfhCKKkAEinRCh7Ex7
         KnHp3P9H5xIAWupXjP4Sk/4a4u0x/gDP31pmsrE4TXeL4QRgaWdh+a0QO/GxMzZS0uzg
         i3Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3z4MVElDmiI2dm0EzeC2YxIS/QbuYtQadcdcivLvoZQ=;
        b=Tky7Ra/z5JjcjsL5XqqXqZKLQ7PxzqH+s+vCm2c5Xd5PlQ6RddoiaTg9WIRMNyvRPy
         Ly2E8R/gxl0VvLfwX1W4YNzjpq4oafUSmAoX3WRquMRdB+ADyi512A+jc5E5W1QQGjta
         jTb6FsPKOeTTiIrN6U/IfEZYlMxsQwj5OIFHgC6P3FgwNODqces5pvzwqiysgsqhkuit
         RI57dyd5xOIL2bLCuYLuoA1d9+yfnMjjjePfrt7KVHMaWSe4FRIPUrSgT2ROvrNulPus
         s0TAt4PkXcbnJfndM3BYbJlSbURjQDj+7G0hxW1A8sHKA6Ocp/XhIur0WoRAYAQZrk2G
         ym4w==
X-Gm-Message-State: ANhLgQ1fwe3bJGiJtM9zuUXmzIMMdS2pZ4ZavfYNO97aNyJ0nZO9nuGq
        IE/ELAV6nhH7XWeN/02Tqqc=
X-Google-Smtp-Source: ADFU+vtbb6CqDYWH1O+xiQCW2MPu6yGgut1UCnE/FSy7D9Bft05TCK6evHkYEYqk8aAuKg8YVzTnBA==
X-Received: by 2002:a5d:4cc2:: with SMTP id c2mr14558135wrt.398.1584751329809;
        Fri, 20 Mar 2020 17:42:09 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:09 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 2/5] scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
Date:   Sat, 21 Mar 2020 01:41:53 +0100
Message-Id: <20200321004156.23364-3-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200321004156.23364-1-beanhuo@micron.com>
References: <20200321004156.23364-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

HPB driver needs to read unit descriptors through ufshcd_read_unit_desc_param(),
make it an extern Function.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++-----
 drivers/scsi/ufs/ufshcd.h | 5 ++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 492e4685e587..a40023ad1336 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3276,11 +3276,9 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
-					      int lun,
-					      enum unit_desc_param param_offset,
-					      u8 *param_read_buf,
-					      u32 param_size)
+int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				enum unit_desc_param param_offset,
+				u8 *param_read_buf, u32 param_size)
 {
 	/*
 	 * Unit descriptors are only available for general purpose LUs (LUN id
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d45a04444191..2fa9b880e228 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -838,7 +838,10 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode);
+extern int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				       enum unit_desc_param param_offset,
+				       u8 *param_read_buf, u32 param_size);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
2.17.1

