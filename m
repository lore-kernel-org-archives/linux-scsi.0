Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CF3C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiDLXfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D141C55B1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id cw11so304842pfb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HQ8DnYInUPmNdfocvWClka5SUfhGXiHRgCQGuq108Pw=;
        b=YZkoWsFUOtCdB9o/X4OSP/FtMEVc+YTAxlYWnYn0JqrmCGXyjca+0OwzIB1Bf7tTmJ
         WS5iLEE52ap1XH8e5rilVu+dEFwDTxZNF8eaORGaMfDjNahGQblBLbLSncDhOGN0z2/N
         ryEUSaRLuG3gQu5Rg8cw+LvhbL9SZNQ3xpJcBmMeg094fIy2sp/53le5qRbKkFfeeUCc
         lQdwxggb7dwJwlVjfcWrHstLbKF1YlCks8ziNfxILW/MsKZHUWpTjlHnb29xfQbL5uin
         wGpW/NjAF8eHEH2G/ULd22cRQK7h5LWdOEUrbh4Kcpzbya/+bltotc8hlhSrZwWfZbn1
         2PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQ8DnYInUPmNdfocvWClka5SUfhGXiHRgCQGuq108Pw=;
        b=MmTIp3cxThnHW9GV6oh/3J/U9iEfBDSzW6iTpf0tbSQTilK3n3RdiijCACm8Wkqike
         Dh09/lTFrK7llUMNFx5BkLxUWC/jnpnPbicjB+OewecA//6FKX/E3zqa7DSPaaFuroED
         IMiHHn4FyFcyV6hBMQSDf55L9LYwzNHM8aTmoU6hQxXX/MEP9SAyR883XWP7DYJoytcV
         14JOImgaxmKmyoYgdl/mle+LwTQRi6TtGDidVHp3JvZhIyx9kFrIufLMdLLjzLv7+2rr
         7FCVxLhdaljhMqEsfJyrC2uxgZTEjWsU0Cu6voAZx3MJoKuuniHJhLIUnMah8rbHWxSL
         7rFg==
X-Gm-Message-State: AOAM530s8mdIeIE1fCUSOJN1gPlfYFXN4qjFaUXXDTst/KeJlTI6heIu
        rzLvDg1SRISFGHbRrkfG3JoHEvRzvc0=
X-Google-Smtp-Source: ABdhPJx9qNUnm/dk8Zq2j3T0aO0ELEXJ0mqxcwAx2n3xy+tQkx5/sfTvt9fCvwrdGTIh5sNMmeL2Rg==
X-Received: by 2002:a05:6a00:1145:b0:4f6:3ebc:a79b with SMTP id b5-20020a056a00114500b004f63ebca79bmr39776152pfm.41.1649802025851;
        Tue, 12 Apr 2022 15:20:25 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 14/26] lpfc: Correct CRC32 calculation for congestion stats
Date:   Tue, 12 Apr 2022 15:19:56 -0700
Message-Id: <20220412222008.126521-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_cgn_calc_crc32 is returning 32 bits, and lpfc_cgn_update_stat was
using u16 to store the crc32 value.  Correct by redeclaring the local
variable to u32.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ec6da7e27e4b..578e9947125b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5539,7 +5539,7 @@ lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
 	struct tm broken;
 	struct timespec64 cur_time;
 	u32 cnt;
-	u16 value;
+	u32 value;
 
 	/* Make sure we have a congestion info buffer */
 	if (!phba->cgn_i)
-- 
2.26.2

