Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC46C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8558C60FBF
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 20:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhGZTjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 15:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhGZTjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 15:39:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF32C061760
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:36 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m22-20020a05622a1196b029026549e62339so5158842qtk.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YZiRJCULAk0NgZWlw4NhyxwOUxRg8I5AfZi4pSeW7rI=;
        b=oQk1seDxX4hy9rYxFNTS4Ro/4O8OjDW/nJG6LXNJQ4gEQfyB7E2Ki+yYYUKVihluxW
         mhc4l38AX0jaJzO8qyMuIKSCGO54O2pLS1Nf0LTNJQOZKdhWC6DCxAfYbYTgGLyS84n1
         fi8eBKB3R5lruvnoxW4nlI2YsNcVmcJsc1sn8RCxtMWbQ6kx3FotZF7Vu5DjrXyghHP0
         bIHkLLUA+e4f5g5wqnjpLXfmnhNEpchc2rrGsHnBlshsQt8PWdpmPs/I6UkTQbBOELIS
         Vh0UCpQNPD0OdL1XtUn4tS9qZBQb6yBwgiFyFx1Uqhgf5l1iDqaTr4xSIBGvtWcJCRQu
         Npcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YZiRJCULAk0NgZWlw4NhyxwOUxRg8I5AfZi4pSeW7rI=;
        b=RCJ8DzSso8yoS/23g+Zl10+FMcOq8gusgfEsXIDivWVneCLPEKF4MD6qGwJ3GM4zDd
         85UJnN1+gBAgUmucFplZX0worF3oqAZaLQExb+dzhSmi/Q2U8TDro/2McVoRno+jZ0E+
         L6KNJObBLEGYeFusSbW8KPYmeDgAAYVUx4Y9cLy9ykt2fXMLcFzTXxoePnk/MeIGTVpu
         NGUDiUFvWsk6/MDNySA9sc9nrwxrB0Io0uKrTL56vbSuoCrXnvLoJwVn1UHsdDv2O7YK
         VIbvpFiO+2j4qDLxiiap9AexAXlwL56doXqM41Bbb2f5Hulrg3DkvyTKq7uiwUo29xDP
         u3Pw==
X-Gm-Message-State: AOAM530Yj9Q/3obf6DfISUQGoIS1y9QgrREFmDb1by7t4g3lmHRYblBr
        hrZm4tM2A9h8+DTvfSbnW1aZl01c
X-Google-Smtp-Source: ABdhPJy3LTbBOQ7NzZ8565Lly5b5AVSH3LlZs2RZM9CPhqw6+vphE/8RaBXr21HOSoDuH7z/OqsDJOe0gw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a05:6214:10c8:: with SMTP id
 r8mr19696156qvs.28.1627330775317; Mon, 26 Jul 2021 13:19:35 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:24 -0700
In-Reply-To: <20210726201924.3202278-1-morbo@google.com>
Message-Id: <20210726201924.3202278-4-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com> <20210726201924.3202278-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 3/3] scsi: qla2xxx: remove unused variable 'status'
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the clang build warning:

  drivers/scsi/qla2xxx/qla_nx.c:2209:6: error: variable 'status' set but not used [-Werror,-Wunused-but-set-variable]
        int status = 0;

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 615e44af1ca6..11aad97dfca8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2166,7 +2166,6 @@ qla82xx_poll(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
-	int status = 0;
 	uint32_t stat;
 	uint32_t host_int = 0;
 	uint16_t mb[8];
@@ -2195,7 +2194,6 @@ qla82xx_poll(int irq, void *dev_id)
 		case 0x10:
 		case 0x11:
 			qla82xx_mbx_completion(vha, MSW(stat));
-			status |= MBX_INTERRUPT;
 			break;
 		case 0x12:
 			mb[0] = MSW(stat);
-- 
2.32.0.432.gabb21c7263-goog

