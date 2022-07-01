Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFB4CCA47F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiGAVPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiGAVPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:03 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3434E4093A
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:02 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b125so2697574qkg.11
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aUjwU9cYCEW/eO1AO2w9M39elnV97I3v84MWbdlvAG8=;
        b=HX3Ih/OamRfL9i6kRJC8SZUVQmCGAAQNWQW0W/Jhem4UbzpshJBLfF2j1RWd5267LN
         wgTrh/KrWlP5iQfN7ssYeTJN/mPCgBy294ignigLIe1YE3faWFPEk4LidArfRw3J1Fav
         cEWj6c6WfdZYpIbN6zEg1YGhPblcGSNa2Q3l3BfWGooXPnegZQM2wDl0EKczi8fboF5+
         IVerPWsg4nB2UXnCn6Br58aUTriIhGLM1+LumWdZjA/kPqUMAYtpxnJmTTLNGTc8Xpk4
         x4K9G97pOGNFI/pEApru3sS4hdRnS0ksy+KdConO/H13rukjG6tYaWZkwTZExJfvbzRi
         66NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aUjwU9cYCEW/eO1AO2w9M39elnV97I3v84MWbdlvAG8=;
        b=URMsBW7NhEDFL4J5tXjUTu6fsfW367nQyawqxud6k0WNWtcKLfNHyZppV3dwCrUcN6
         Ouhh5tjIyFg6O74Sn3YJ9v7kEXSk31+h6d0hKG4M7LLcCzC2WSiGVO00ie0Z894pzafL
         Fa0JAyArVQCeR0R4mISr8IRPFrFaUeGij+EYjUZa9iAGIoMDYqsyhioOTdPfNY7ZPEvs
         FmZn+/qryjSrXMhevjuVG1IIWafZG8XyNV3TZNWLJujTMg414y93jGwYPqDtI4lfcNMU
         o/EOxaer4T4DxISfHWNE9uTPnfFIpnCjJlFGWsew1dk1sLpkeyiQeJFMla6Em5N5S66W
         am9w==
X-Gm-Message-State: AJIora8GyNUXgHutWcAA6As/mqnL8iluJa6Qi56MM3bXokKpKOeVekld
        NaMEsYT5vRc3pAede3ZBra/KdT8yih4=
X-Google-Smtp-Source: AGRyM1vZgdnABK1Iam9pmXPx7Gg8+ucLDjlnLl55hRdU5iWyJPr8ruKHpOXCQHpddJBg6VsihAb0gg==
X-Received: by 2002:a05:620a:29d6:b0:6af:10ba:834 with SMTP id s22-20020a05620a29d600b006af10ba0834mr12280913qkp.466.1656710101131;
        Fri, 01 Jul 2022 14:15:01 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:00 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/12] lpfc: Set PU field when providing D_ID in XMIT_ELS_RSP64_CX iocb
Date:   Fri,  1 Jul 2022 14:14:16 -0700
Message-Id: <20220701211425.2708-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When providing a D_ID in XMIT_ELS_RSP64_CX iocb the PU field should
be set to 3 to describe the parameter being passed to firmware.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 80ac3a051c19..98fef6353b60 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10549,6 +10549,7 @@ __lpfc_sli_prep_els_req_rsp_s3(struct lpfc_iocbq *cmdiocbq,
 		cmd->un.elsreq64.bdl.bdeSize = sizeof(struct ulp_bde64);
 		cmd->un.genreq64.xmit_els_remoteID = did; /* DID */
 		cmd->ulpCommand = CMD_XMIT_ELS_RSP64_CX;
+		cmd->ulpPU = PARM_NPIV_DID;
 	}
 	cmd->ulpBdeCount = 1;
 	cmd->ulpLe = 1;
-- 
2.26.2

