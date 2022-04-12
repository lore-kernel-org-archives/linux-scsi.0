Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB34C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiDLXgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiDLXcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02917C4E3F
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 125so18468091pgc.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XYNXZiaSRih3MkZK58qB9oAvWwBnBs1tqFcjf6GOCFc=;
        b=eWLd4mn8HV9BSNigsRI+bYBaLCuzgrN+6e6au5u/zd9PAex1E/Jj0MP1giJKAlwKr9
         M97XgAmAGncr8jBVLhGIAH0ujAzQgVpoe9FSzEE2GvuXEMsFe8s5gxCLXpUkbg8aBS5r
         5rZWbO059bvfHhPk5IF6RvQqWYUAATWwSXtbf9wWvkEdusR9PCkcENuLz5/G4Hi7i4jD
         zYj91qmlc7lY/m7V45nN0Pv0Db0BmorbKxpPg2GZXogVWZENW1VrIGdyVS2iJnj5xm4H
         yZLtHMo+zt0QIYpKwFTF2PTV+VlobsZx13ZTwNA/5N/YBRKdDEVQTF3TmxBCtA/fqvYg
         4Zng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XYNXZiaSRih3MkZK58qB9oAvWwBnBs1tqFcjf6GOCFc=;
        b=UnjY6KCogt4uKjiSpVljsfYFfccVp5blavxL+u3gA8uOUGL5WCQZYonvgaTUQrjtxA
         mJ51ZpeD1AJ9lFmtyTDuZJUftPvvtiqzkulh6PqJoAQzzydozZz7zGQzLSmKSV6r+/bp
         rFX8qrQTGuMk5PXKKolBRvYXfmKowebLO8qDvHALGlOjBNsCrx9JfjIPUhC4aBHH7WCB
         24VedrxW5J5DfRmf5lB5RKe81xTySPGiBOyZaMZNFC7vKuZihOhp2KvCCkmgA4pg4lCM
         OcVTkwsP/vayQHkJE6t6+in4cEngsk1KQAEnA0gwLwWxfOks0nBCFZZxCbeFsQqlto82
         9Mcw==
X-Gm-Message-State: AOAM5333T+igdDMfyrWnXbHR8/W1Iik5FwtdUFOULk8gQ6D+/Bfih+VC
        ININLewJMY9JUgZt9cywiinyI/+kA5Q=
X-Google-Smtp-Source: ABdhPJwgmB+tonR3M6gTTn24ajfWZjZxLfoxmL2ezPYl1kkeWN60e1kR65mrUnvv7RoIYnkBtwAtHQ==
X-Received: by 2002:a63:ff1c:0:b0:39c:c83a:7da with SMTP id k28-20020a63ff1c000000b0039cc83a07damr23891804pgi.479.1649802018470;
        Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/26] lpfc: Zero SLI4 fcp_cmnd buffer's fcpCntl0 field
Date:   Tue, 12 Apr 2022 15:19:46 -0700
Message-Id: <20220412222008.126521-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's possible that the fcpCntl0 reserved field is allocated non-zero.

For certain target storage arrays this could cause problems expecting
reserved fields to be all zero.

SLI3 path already allocates fcp_cmnd buffer with dma_pool_zalloc in
lpfc_new_scsi_buf_s3.  The fcpCntl0 field itself is never proactively set
throughout the SCSI I/O path.  Thus, we only change the SLI4 fcp_cmnd
buffer allocation to dma_pool_zalloc.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7c86271f05fd..28d8ded9e7e1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22117,7 +22117,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpfc_hba *phba,
 			return NULL;
 		}
 
-		tmp->fcp_cmnd = dma_pool_alloc(phba->lpfc_cmd_rsp_buf_pool,
+		tmp->fcp_cmnd = dma_pool_zalloc(phba->lpfc_cmd_rsp_buf_pool,
 						GFP_ATOMIC,
 						&tmp->fcp_cmd_rsp_dma_handle);
 
-- 
2.26.2

