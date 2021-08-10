Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A768FC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8667D60FC4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhHJEGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhHJEGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 00:06:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC32C0613D3;
        Mon,  9 Aug 2021 21:06:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so3382339pjl.4;
        Mon, 09 Aug 2021 21:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6N0BAQWqIGCG70KaJSvwhn7HVFBd23LUGqOl1pjWdBc=;
        b=n7zYqLMlnbTCPRqciEhJZGm7QNfHHw+f7bBaw6TxaydriNoApNDBwKySN/HHqclhFT
         RqYmn1Z/csUrTrchNgL/ShPIE1VraPv2LnG9UJKsecqpkwzfQ1pPXROa6h4PEcXuG7iA
         OWLmo60MDlOOntppb+vDVnF5w0dTTomnEqTCE9LcGamNIHivkzW0ALZsrXTFKXnwNXdl
         CBCFVsaNOy+UCW66Y/p6Rrylv3lJ73NV1UFT3jsFRll4hhzXgj/nrcNwdOo5jf3D8yxG
         nItMYS1PY4/y48Fj2F5UNMsRCBvWRMHrNyPHc81Q4ogHAKLiH8lgoBg/DH5iYVcg/T+P
         R7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6N0BAQWqIGCG70KaJSvwhn7HVFBd23LUGqOl1pjWdBc=;
        b=ZBKBLnte+Dg+nLEFHKOuFY1uvDSVvu96Ep1YhOtwTx6KRp8SyS0O71DX5g+HPRiilK
         7Zpo3qQr6swiGKola4Qh9uDrIgaU1860yPAJIma3X9f5bHc+ju054IiKgZZav8fU+JNn
         BeAkHuIby2NeA0YgQmskVF6VzUlILfpEPYURoyEsyoluayDQ4YEd6iGkFYIEhIppVKnc
         Y8q1y+dpiQRr/GMJw/jQ0Z5cfWZqvlsbhG96nPMPbJGqivDPQzfqDjcNKFAatzfIDf+2
         QnzJ3s/bIJjvdsimr/xrPW4Nml1qatP/xANYXXa0q9XAiRUeLAT6osPytPwT1VM6Jwxo
         4raQ==
X-Gm-Message-State: AOAM530+DE+myM0QhaLMM1Z9lkI/YC/y89kj6FtPQW9DmeY8JZ5eXlmM
        nnTs1/4MIiA040zzUD42psU=
X-Google-Smtp-Source: ABdhPJxTpRcRZtpoL5iMuIP30OCDIud6VfWt/11NbbIIa+65NLjd2rqyoYDwiuUiBPxD7Ti/aQWSGA==
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id l18-20020a056a0016d2b0290300200b6572mr21419129pfc.62.1628568388014;
        Mon, 09 Aug 2021 21:06:28 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.103])
        by smtp.gmail.com with ESMTPSA id s7sm21562339pfk.12.2021.08.09.21.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:06:27 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v2] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
Date:   Mon,  9 Aug 2021 21:04:13 -0700
Message-Id: <20210810040414.248167-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The return value of transport_kmap_data_sg() is assigned to the variable
buf:
  buf = transport_kmap_data_sg(cmd);

And then it is checked:
  if (!buf) {

This indicates that buf can be NULL. However, it is dereferenced in the
following statements:
  if (!(buf[3] & 0x80))
    buf[3] |= 0x80;
  if (!(buf[2] & 0x80))
    buf[2] |= 0x80;

To fix these possible null-pointer dereferences, dereference buf and call 
transport_kunmap_data_sg() only when buf is not NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
v2:
* Put transport_kunmap_data_sg() into the else-branch of the if (!bug).
  Thank Bodo Stroesser for helpful advice.
---
 drivers/target/target_core_pscsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 2629d2ef3970..75ef52f008ff 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,17 +620,17 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			buf = transport_kmap_data_sg(cmd);
 			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			}
-
-			if (cdb[0] == MODE_SENSE_10) {
-				if (!(buf[3] & 0x80))
-					buf[3] |= 0x80;
 			} else {
-				if (!(buf[2] & 0x80))
-					buf[2] |= 0x80;
-			}
+				if (cdb[0] == MODE_SENSE_10) {
+					if (!(buf[3] & 0x80))
+						buf[3] |= 0x80;
+				} else {
+					if (!(buf[2] & 0x80))
+						buf[2] |= 0x80;
+				}
 
-			transport_kunmap_data_sg(cmd);
+				transport_kunmap_data_sg(cmd);
+			}
 		}
 	}
 after_mode_sense:
-- 
2.25.1

