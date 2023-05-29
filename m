Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B03C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjE2UWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjE2UWR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:17 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E732DB7;
        Mon, 29 May 2023 13:22:16 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5346d150972so3272126a12.3;
        Mon, 29 May 2023 13:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391736; x=1687983736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+LEYF/kzJB86d8rdLeGpy+yEdXC6a953lW7SwYMpO0=;
        b=eWEskU5gZ0EmrShjiZnRoJOfBP11Lotei16g0n7sXK8p6c45WUI3d5fEt4nNrz85kl
         hoEHfmBVM/Pxfo8ULtZkJxqMLROl1G3mcP4IwDifxkLH/Gq8FvpjNcIkcA6q/LBrrGNi
         Mte62Y+jLxmo+jic+g+HfCsX8AkrEosRsMu4dyd0qPvel0gZdr6f230sOpkZZJl207hd
         6uv0sSh3h4ldA55eX0UijMLsFM02YXaL2cnwC8rOeCeHV1hRcldfCbGVWdqe4YYp+H2k
         zXeh1QMOFF64K1oj8td4fyFkxwQ04pKoK6STQP29gCnE0Fzo8zTt5+H5Wdj7SZa0UTMC
         4+sQ==
X-Gm-Message-State: AC+VfDyTtLUM3hqaJcaextQyjO4jKGWKnvhJitYHV8/l+SlAOnlo74vG
        yK6eTNqm9fTHhL2JIZFqrMcmPw/sdTc=
X-Google-Smtp-Source: ACHHUZ6YonyyHP6I/1NArMCWS2XJ3iWzZbmZzKSJKJMnb4P56/zeiZQL75+4Jve8NpeHP54+wzim8Q==
X-Received: by 2002:a05:6a20:ae10:b0:110:2e00:3d59 with SMTP id dp16-20020a056a20ae1000b001102e003d59mr95128pzb.23.1685391736255;
        Mon, 29 May 2023 13:22:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 4/5] scsi: ufs: Declare ufshcd_{hold,release}() once
Date:   Mon, 29 May 2023 13:21:56 -0700
Message-Id: <20230529202157.11361-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
References: <20230529202157.11361-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_hold() and ufshcd_release are declared twice: once in
drivers/ufs/core/ufshcd-priv.h and a second time in include/ufs/ufshcd.h.
Remove the declarations from ufshcd-priv.h.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd-priv.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d53b93c21a0c..8f58c2169398 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,9 +84,6 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-int ufshcd_hold(struct ufs_hba *hba, bool async);
-void ufshcd_release(struct ufs_hba *hba);
-
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
