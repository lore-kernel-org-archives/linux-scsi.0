Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6743CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 18:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344089AbjJQSUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 14:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbjJQSUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 14:20:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB0E8
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 11:20:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a839b31a0dso61105747b3.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 11:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697566833; x=1698171633; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cogZn6SR2Hrm3xwpZC/9u1+k1saONFiJF3pmAllmSYA=;
        b=OJ7VhqFYvc7y9VXkTowPxf9eo2598iYFLcoo6Wz3YzrRqXIjEiaGUk3rX8F6VXXm+V
         slVA/qE3GARelgEnRMRGwQk/sHypIplRyoP7iFFWNixvhwU2A0LtXmM4kZluRzO1Pn1e
         ZeuYaUL9s/am4uV6BFk8/+Mpn3FjbCReaQLhVc7M0oUmEkta0414h/A4m61x/K0e6Yq4
         OkXgx4YWU1Eux6/Su/4Qk2LCm9Ut5nZquLasFipiIyXSGdR+qGfu+QVUwI5FSBpfLILm
         xp9iYXjB/RM4CSLcdmCyD2PLiC8xN85JwJliq7VAHUAerhg9Wi0nCVbAoeoy4aRAfgkv
         09mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697566833; x=1698171633;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cogZn6SR2Hrm3xwpZC/9u1+k1saONFiJF3pmAllmSYA=;
        b=Lg5/LOCyMuP0asl2w1aQ5TOrX4//UhBbm6eSye8/B73jIfkNwjMGWV7oj/dlBs/ZI1
         A61ELbye1d7FQpNpLfAUNYKbfmPOaWbjPcPm+Lzd3igbAIzyGPP87J5l90fWacFTqJ6C
         QDxNmEDZ1lNer5vygQgyWoaPkTVbbF4tTuXZhmqSv7ixCUd7qhGCiyWPE2Ey/UUhiSbB
         vw93SD0E+I6kn2sSt84AWOaQzSDwUCRHW2HSZonWkc7xq19YkLo/31Yn/xcz0U4l04DM
         +eGh5/BBIUID2xcPRcNtG5HSXnmIaSrhEwJLPnxqzAb3fCD4YKajmP57OvGN+ma840Y8
         zq6Q==
X-Gm-Message-State: AOJu0YxcciI/b2Z+pEWORTs1WtEVLEmnR1TBCamcq6J3zQIZI2JEmOfm
        bnwJHujpjqoN36XAw8f23kxw26uIr9s47HS9fiRs3osz9w7a/KIUoXQJWzmHfPxAWQym3ft7ZqN
        s7yBUwi9Q8/bR16+34dHQnTL+nIUPXg9oowOvMRzXT2bwYz9+cP0OVuBzA36KRfNB/0R2dMZtgX
        dAgKsy
X-Google-Smtp-Source: AGHT+IEpgKHFswJWt16YETcyCpL2RTWhu2Rca3LfIdPF0vh7gFgWhUwDiXg6AYDmdBtS+FxsRbSWaLdeSBlJ4FshJw==
X-Received: from danielmentz2.mtv.corp.google.com ([2620:15c:72:205:c52:2f36:304a:2c97])
 (user=danielmentz job=sendgmr) by 2002:a25:6984:0:b0:d8b:737f:8240 with SMTP
 id e126-20020a256984000000b00d8b737f8240mr61351ybc.0.1697566833277; Tue, 17
 Oct 2023 11:20:33 -0700 (PDT)
Date:   Tue, 17 Oct 2023 11:20:26 -0700
Message-Id: <20231017182026.2141163-1-danielmentz@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Subject: [PATCH] scsi: ufs: Leave space for '\0' in utf8 desc string
From:   Daniel Mentz <danielmentz@google.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daniel Mentz <danielmentz@google.com>,
        Mars Cheng <marscheng@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Yen-lin Lai <yenlinlai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

utf16s_to_utf8s does not NULL terminate the output string. For us to be
able to add a NULL character when utf16s_to_utf8s returns, we need to
make sure that there is space for such NULL character at the end of the
output buffer. We can achieve this by passing an output buffer size to
utf16s_to_utf8s that is one character less than what we allocated.

Other call sites of utf16s_to_utf8s appear to be using the same
technique where they artificially reduce the buffer size by one to leave
space for a NULL character or line feed character.

Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
Reviewed-by: Mars Cheng <marscheng@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Yen-lin Lai <yenlinlai@google.com>
Signed-off-by: Daniel Mentz <danielmentz@google.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8382e8cfa414..5767642982c1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3632,7 +3632,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
 				      uc_str->len - QUERY_DESC_HDR_SIZE,
-				      UTF16_BIG_ENDIAN, str, ascii_len);
+				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
 		for (i = 0; i < ret; i++)
-- 
2.42.0.655.g421f12c284-goog

