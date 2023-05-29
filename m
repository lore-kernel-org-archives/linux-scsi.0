Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E90C77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjE2U07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjE2U06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:26:58 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B9AC9
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:53 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-25676b4fb78so976459a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392013; x=1687984013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+LEYF/kzJB86d8rdLeGpy+yEdXC6a953lW7SwYMpO0=;
        b=FKQMQoY5bbHojkhpUqw2H23FgynNKqRRlA4Pam98zHU8zSyLRMfO6jtoDOQVZb/aI4
         UIc83kiGaxAbzLxmbFHMamE3Qjwtx3zHr5ip4dWRi4fzBh31MaveWRsCUpem53zjKh32
         x0D452F0F8TGM5tXEAsQB80SjHzMeTnFMoRN2BlzjzA4IMTMgwjLIBV1DLtTCG93xD32
         Yq6wHpeIGYSSc25LnXmyCZGywyvhBaHoOYZPZDoHVrs2R0To9UlSeq4H9TRytUEACLTo
         nBKArhQIHIxQe15CGlehF4uhW9tJV8ax4UwUUTl6xtwsx4wyiL/htKMV0wPZ61mq2HAl
         RJQA==
X-Gm-Message-State: AC+VfDyOW6LvDG+BryFGwJBpjZ/HeMZmM8TdC3Sm7+NOEHIoc58I8ohB
        r/5w1b1EJgMCHN2P9dqaQBR9U1LgaTM=
X-Google-Smtp-Source: ACHHUZ7xEHU5GuEq76XsGy7iR8xki2T8IWNjgiQCzUbgE9Gb/kfhtvFTVndK7YZ6fZAm8rg0HHZuDA==
X-Received: by 2002:a17:903:644:b0:1af:babd:7b6d with SMTP id kh4-20020a170903064400b001afbabd7b6dmr170143plb.52.1685392013359;
        Mon, 29 May 2023 13:26:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b001b027221393sm4957237pls.43.2023.05.29.13.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:26:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 4/5] scsi: ufs: Declare ufshcd_{hold,release}() once
Date:   Mon, 29 May 2023 13:26:39 -0700
Message-Id: <20230529202640.11883-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
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
