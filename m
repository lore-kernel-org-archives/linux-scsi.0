Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D05AC3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A42A20820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tc5OUL91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfIVD7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:37 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44526 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfIVD7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:37 -0400
Received: by mail-oi1-f196.google.com with SMTP id w6so4977242oie.11
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DqC2A5XsNbaPeSm4AybGRgPdts/jzO9mY72hzhpSs8c=;
        b=tc5OUL913LnGXVFB80KmkrjJ8TU2CMS5yu4tYcFJoHkgU1QQIQbzci6xZT+oucV/ae
         o1ohZYaQVPXNfHNRlaE6QgN1nPt+M3lyioLpST6KfRpJMz3Rn07OHYN4uy6VVdLbWlv8
         Jrhis+RAfBTo0jN0cEKFso5hPCxaPoATK0rU+XVwqjZ50VMY/GopHixkxGXrwiJLb4T4
         Sqt9odtIyZhYvMlEBZ762Nzt36A1YxShOVprdS3ZvTBge3yswx7V40Mu1A/IqV+2PhKY
         uZCkZuyJlTUAcli1wuyLe6LAqOmiBmPVNinrK8E6NWEZPzuqR9y/zJ/Osl3SGy+/elLG
         G54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DqC2A5XsNbaPeSm4AybGRgPdts/jzO9mY72hzhpSs8c=;
        b=d1NZUI95FhXfBy2W8FC+4TOnXoYAGdYDFVXmIC7DA8ro4wm9HhYcrKoUgk5YqYaL2V
         K5JRfx04I06WxwAuI3IkQtHdxvijszBTGbDjKSOR+tCaNmaOHlIbTXyeAI6dR+e93dgZ
         VnlPUkz2ktnZBTuOtlB/J4mkCL8RJHn298Vad747RJoTe8evV9C6Y+LyWIHoeR9/048R
         zVtDki5ecAHyaZuNCb09eKtoMZ6qyOT37Ux2U2jNGFScjfMP27SKGnophAaEHDHAih23
         L5sk4bVckXpAxPrJ3BKV+7SkZoXfts6ExED5vLSm5ZZcrTKL+ORmw5VoQ0Yx5+uAzC/u
         PaiQ==
X-Gm-Message-State: APjAAAXWe3KMlsMjZO97MT/co3sy3QiS7ome41L4NTu/H2zi+iwtdWkM
        890gPsOLEfd+l9DO47NETyUh2Qha
X-Google-Smtp-Source: APXvYqymK+2Iyjze891HMVHFn8u6+5h1FF2je/tLQHbf9e1bi//EQyLhgqBCMLH3bN+PFeyhI5Ncdg==
X-Received: by 2002:aca:54d4:: with SMTP id i203mr9148748oib.167.1569124776607;
        Sat, 21 Sep 2019 20:59:36 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 20/20] lpfc: Update lpfc version to 12.4.0.1
Date:   Sat, 21 Sep 2019 20:59:06 -0700
Message-Id: <20190922035906.10977-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 12.4.0.1

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index b8aae31ffda3..d8839d95f7fe 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.4.0.0"
+#define LPFC_DRIVER_VERSION "12.4.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.7

