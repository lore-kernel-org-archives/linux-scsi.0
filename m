Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909B7C6FD1F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 20:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCNU6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCNU6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 16:58:49 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373A127483
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2023 13:58:48 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so8175653pjt.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2023 13:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678827527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wvsm3BywS+tiB2/dVD73rcmCmFQNfENoj0TNdJqUu1o=;
        b=pz+fcNqa2GuD0NOF0P1gXaXpV9XrmtjR+/UHxVRLFlluRmc58SUw/1G4SInvnJLe5X
         IdheUGUrEaNa0ov9cg9zpsgH+sI536TN5FFilv+IWQs1iEYXMRM8wvdNE874kv6Vhb6b
         rtEt8b55it/IfKH7cfo2814CoVLWkrlMg+KWG2EjOnAMGJxHFSCU6yZiPAM8tu1p0duC
         AfJPYdFuwukVsnamN3Z7TuBQKUjyU03TKmmfiA+/wrV9/nItAqzknQbfe6LJ4gRpYeME
         5r2Kc7C3dRl3P9Lw299AlIEkNwVbnUUQvOpxcy7AQrzOTOIslqf8uXWeg1ArbrEWlNp5
         r/RA==
X-Gm-Message-State: AO0yUKWny7CtyRK3wGAtEOyC7Sr2SQqhMtfa/vYbGFYlIMkaWQk+SqjX
        GhdMx/ydqN3Nug3/RBkaW3c=
X-Google-Smtp-Source: AK7set+M7PtHSMJU9XB3X/6YHmaw18+nnktbYELODxQGm5gs2OtcjStNEMILGpujgm4VDDEW2659aw==
X-Received: by 2002:a17:90a:aa91:b0:23d:1143:1e15 with SMTP id l17-20020a17090aaa9100b0023d11431e15mr6402761pjq.19.1678827527530;
        Tue, 14 Mar 2023 13:58:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:558a:e74:a7b9:2212])
        by smtp.gmail.com with ESMTPSA id m5-20020a17090a858500b00233b18e6fb3sm2146536pjn.1.2023.03.14.13.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:58:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
Date:   Tue, 14 Mar 2023 13:58:35 -0700
Message-Id: <20230314205844.313519-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is important for the SCSI core to know the residual byte count.
Hence, extract the residual byte count from the UFS response and pass it to
the SCSI core. A few examples of the output of a debugging patch that has
been applied on top of this patch:

[    1.937750] cmd 0x12: len = 255; resid = 241
[ ... ]
[    1.993400] cmd 0xa0: len = 4096; resid = 4048
[ ... ]

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce7b765aa2af..7bbbae9c7c61 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5238,6 +5238,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	int scsi_status;
 	enum utp_ocs ocs;
 
+	scsi_set_resid(lrbp->cmd,
+		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
+
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
 
