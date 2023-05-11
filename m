Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D09FC7EE24
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 22:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbjEKWKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 18:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbjEKWKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 18:10:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57841869A
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 15:10:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64395e741fcso9490742b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 15:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683843003; x=1686435003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ooac5tL+mseyTN9L+x1m+1D+z3zZPNRSrEyDHL8CuWc=;
        b=JXR/xm0E+UUFmWf1wRMZgI6VaUWPK5W5tDN0vIDM2B0+aOQUWkZiPgoMyBO8V6cyke
         HPakTwy7CgGnYSqHxcjTXah9Qt1GrRy+PSwbmabFLI+1TM111+Slg9bRn3Yhxy1XMF2z
         G0R4D24TLDlxpvCnb1z6VM2qFUEpZO95MCunk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683843003; x=1686435003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ooac5tL+mseyTN9L+x1m+1D+z3zZPNRSrEyDHL8CuWc=;
        b=dqNtKiRATtvLg4YTszpnBu+fT2WyRIWrhSXSmZk5NM/NncXAn7ArUZgBJHYedqQnL0
         16RKODDLqtFTzcpC59pn4Jr1UA+Pk232MSqdl6dUPbbs6gcmABfh2K1kcLJnkjvGprjo
         XT558I2lJNVBfEFW70we1rHYGVrxjr8FhjW2xTDeVV2de92jZ9oAQV0e8//COtAe3ofA
         KJzGVy+4Tleop03+p4fmKsV8OoQCk1zkV9M/dBIPbfv2G6GMfUBoep0S/3eh2+3AJaIr
         igAlViAnfLc3sK1QMuwiFKhaYoYw/X8eE1zJ15osBuPtdgPv3ykInNZrQGsLvDbuDQt5
         Q9lg==
X-Gm-Message-State: AC+VfDz0kxLVaf6RNbT7FjnE5Zdx9wdHF39/9jZqXEqkUiH8kWdV4h+x
        Y76zmLfCMI0TbMJlNoP8W/ywGg==
X-Google-Smtp-Source: ACHHUZ4aUI8ISpA8NkZd6SJuB882GbxNnfGq9BATmlyfEHldSuNSzQ43VWj3WFDwdyJ0waq/rtxjPg==
X-Received: by 2002:a05:6a00:8c5:b0:647:4dee:62a4 with SMTP id s5-20020a056a0008c500b006474dee62a4mr14029138pfu.34.1683843002834;
        Thu, 11 May 2023 15:10:02 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x20-20020aa793b4000000b0063d2bb0d107sm5803828pff.64.2023.05.11.15.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:10:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: Convert union megasas_sgl to flex-arrays
Date:   Thu, 11 May 2023 15:10:00 -0700
Message-Id: <20230511220957.never.919-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1525; h=from:subject:message-id; bh=LtOldvtOS7BP2znGslCZolBglC52ivG2kUh4xsBr7gw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBkXWe4srTr9P0R2BfZ0l3zZwW7FDKgoLhejYjQrjIf E1DhPjSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZF1nuAAKCRCJcvTf3G3AJq5ID/ 0Y3B0fKlu1yboIdHGvoWREvQu7tbf7nV5Z41kc6P+Ojp9TNpFBIlG96li90StqxGhYgOIEkFSYH3l4 Wi2Yp/ZCkyNU+sYXJzElh/YaIzN1A6Lr4VmwQiuQaNPZImUSXDAK50ZtSe/bQOQA8dOhIlYn5UmsRX LT/qVO8M6go9nbw95DXaRuzKNy5quQ01yWS0WCZX6lfWOA3njEY4GdoIZctuxniV+tIbHQv4IXVwIp +fq1rperKy9ZE+7FnEBZ1MmQBk3XLJsk4eaO+QPEUr2g4z5U6VojjqnHwEqqcvixz0YGxl/iBe8Xap eIFLGGwEXeTl947aab86Qm1AnzMqCVKj1Wtln0muf7DGwuNOJkw6WFOLtIUFdur7GnWp7gyLDC939M fXuAQhCxIuWbzYU1hV3IjUs/PA4UufdBvofOg2+r9bje5PCZrSUXOT4XQkHwZC2OSrWva/mIQ5axn0 PDQA2r5xZuXYuDrgLookOhX0CfYleymhaYpFKZovIrPbBOb4S1WcHe/12vLSzMwfA4673xs9l8yATc e9gydMjqmpJ5+JfaKDyr8bUWxtR6omvsi0Z+YxP0HJSwm5MkHvpRXwi9h/Jg8M4LI3CJD0t5JonWy/ jLrcHchurIWO129uc/Vz5ExJ0UILUdacwQRf9o89nhNKx5C8TvKolC8Ep7Jg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the ongoing effort to replace all fake flexible arrays with true
flexible arrays, replace the sge32, sge64, and sge_skinny members of
union megasas_sgl with true flexible arrays. No binary differences are
seen after this change; sizes were already being manually calculated
using the member struct sizes directly.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/megaraid/megaraid_sas.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 63bac3684c19..3554f6b07727 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1722,11 +1722,9 @@ struct megasas_sge_skinny {
 } __packed;
 
 union megasas_sgl {
-
-	struct megasas_sge32 sge32[1];
-	struct megasas_sge64 sge64[1];
-	struct megasas_sge_skinny sge_skinny[1];
-
+	DECLARE_FLEX_ARRAY(struct megasas_sge32, sge32);
+	DECLARE_FLEX_ARRAY(struct megasas_sge64, sge64);
+	DECLARE_FLEX_ARRAY(struct megasas_sge_skinny, sge_skinny);
 } __attribute__ ((packed));
 
 struct megasas_header {
-- 
2.34.1

