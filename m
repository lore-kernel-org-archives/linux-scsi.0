Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FBAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 05:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76AD662F90
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 05:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhKOGAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 01:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhKOGAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 01:00:30 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EFBC061746;
        Sun, 14 Nov 2021 21:57:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so12111455pjb.5;
        Sun, 14 Nov 2021 21:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogwLJYhRl6mAF5zsE0HWAzRXmuhZqIu9WWvR7F7G9Uw=;
        b=jiiJ+FypMEHEq0AY7xqmOhTt699d0jkMZE2VzfuZGtmxKj8/xUm5WSG+aTKJvEpDoQ
         3Sjdyiu0G0Qg/NmsTaT5j9rRR/5Tp5ul28D0wDyT8tfleaFaKISCj7Ktz7pgIU19KeU5
         hrFnW+1BsLKng43XkZ0JROWjIRaW23J6VdHTC+Gtvjoj10yXSREUESRW4TOfcclCnjhz
         ARDaB699gRj63j6i71k5/XzH1lUGuG583qilyPiTLFeBtsqjcUE8CzvlY5M25WIAfGhU
         ZtJZb4/Ps52aeHTckyprnD3BHelRu8/hbHPkn+i5R0u0A5ZCkaBSaJE6vSaHaM7d66tE
         407g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogwLJYhRl6mAF5zsE0HWAzRXmuhZqIu9WWvR7F7G9Uw=;
        b=DbwtgXlDCM/SN4i0VTws56aPHPEwmC6WO/0OWlIc8e1/e67YqUjeDaDIlRlgrXLoDs
         0ulYXsoHT4LNNR22q+Nk8o6cecsj54E52RFci8/Ba4+tOg1H1NjsARap/qZg/ZVlzwZq
         UGe9eHAIT8LjRjmJTxv/XCMqBGE5jVJ1V0/oWO+dCq342DTocp6skBg0uwLa3HjXubjB
         /yIMeJ9MsS1Iindy4Ds7wt+0OfbFWrmeAk1o1Bhn3VmN06qI56U8HeZNzZ6A41etC/wA
         H54afxCPxbSzR/K4puCmvBvzABu7hTsSVDyW5eY7EY/Tq4Xu9YDhV116on6QlZZvQfGv
         ENbg==
X-Gm-Message-State: AOAM531s0gbR4uUgm/uNjQI+gPalIjwd0sZgfE4TNuwtbxGCkkCiELb7
        YEXtUe27DzbYgWjLaBmcHTw=
X-Google-Smtp-Source: ABdhPJxOSQpy8Zq0oETPPCXNmdMH4+p+Ien8tZmgYjFwiNnc0We3kHRb7XsrldnWMV8MwoSSiO2Wxg==
X-Received: by 2002:a17:903:11d0:b0:13f:ecf6:26ce with SMTP id q16-20020a17090311d000b0013fecf626cemr32703258plh.2.1636955853938;
        Sun, 14 Nov 2021 21:57:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y184sm14070281pfg.175.2021.11.14.21.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 21:57:33 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     james.smart@broadcom.com
Cc:     ram.vegesna@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dwagner@suse.de, hare@suse.de,
        christophe.jaillet@wanadoo.fr, chi.minghao@zte.com.cn,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] scsi:elx: fix cond_no_effect.cocci warnings
Date:   Mon, 15 Nov 2021 05:57:25 +0000
Message-Id: <20211115055725.85631-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>

Fix the following coccicheck WARNING:
./drivers/scsi/elx/libefc_sli/sli4.c, 2320, 2-4, WARNING
possible condition with no effect (if == else)

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 907d67aeac23..b74065a4e5c1 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -2317,12 +2317,8 @@ sli_xmit_bls_rsp64_wqe(struct sli4 *sli, void *buf,
 		SLI4_GENERIC_CONTEXT_VPI << SLI4_BLS_RSP_WQE_CT_SHFT;
 		bls->context_tag = cpu_to_le16(params->vpi);
 
-		if (params->s_id != U32_MAX)
-			bls->local_n_port_id_dword |=
-				cpu_to_le32(params->s_id & 0x00ffffff);
-		else
-			bls->local_n_port_id_dword |=
-				cpu_to_le32(params->s_id & 0x00ffffff);
+		bls->local_n_port_id_dword |=
+			cpu_to_le32(params->s_id & 0x00ffffff);
 
 		dw_ridflags = (dw_ridflags & ~SLI4_BLS_RSP_RID) |
 			       (params->d_id & SLI4_BLS_RSP_RID);
-- 
2.25.1

