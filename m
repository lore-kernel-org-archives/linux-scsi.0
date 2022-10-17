Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F481C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 16:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJQQfy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 12:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJQQfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 12:35:51 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CEE642EE
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:50 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id s3so8028531qtn.12
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKGJw9sRGpuNe9Qxd5cTMnwtu/aTjr0G71xSCbQ8M48=;
        b=Uh5k1JWJhhNfnmJ+P2zpSGuXVEm1vciCsAkPtKw8pYZBInnawM1LzmuBh74DDR5hv9
         HzmWFhgZXcDn10lEOZRunZzuml29w243qd79gUQofd8lmTr96Eyr0nLbJLN5nG5Q+4jg
         D4o0qmD3JVOeIzUkZ4hq53axaJisG7eUTYMwqcSGNyd7pa36foYHRUKaPSXQy7gNsSco
         TtOMTuZuTBydsv2vdVtdAQ0gVbxOdqL8yjwt3OCY0MXmPLNRpETr5XIx3WxgKllhqaSQ
         kJMbQ8+dCeiS9DQsNdciAHYA/xOIzaAmbR929RfsesX4YNSokg+XnR+vL3Lska0eYDpw
         GmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKGJw9sRGpuNe9Qxd5cTMnwtu/aTjr0G71xSCbQ8M48=;
        b=BzH4XetFwA9kJnQoO3oeaaKAExmYpRsvkRp2bjyA6hmr1aMb+SkJewJf8vQCo5ihW8
         GBbOUNaTLuLiq2K47hDnl/1i7pcJFuUiKJNK4VWR9vssUocyVwz8Ge6XNCZD/D6dw0dh
         ZWOxYBqD5gpZ9ZSSeYTfA1QA582EeDeXgdwHGFXK3HNr7IavNoXB4gWO67Jef5pNLOEl
         5FdUpEUUZShTlaW58AHReiFa8tqpZmPwTqW3iD7KPE2SjUbAzkDFk2wU41UgKADWt41Q
         Y95+JB3Tk1HuEm/qeldL/BUPTR8kVlWhkt9KnTnRZQaIwHOposJGxMQDpX5k7eP19sUb
         lSkA==
X-Gm-Message-State: ACrzQf0MdwMY09Vk6HeApwDmwd4M/34IeRI1UcaAxd0vfkA2xatgAlUS
        gtdKFbmz5Vt2a1crvL/5durXi6C8nv4=
X-Google-Smtp-Source: AMsMyM4zoSaauKh6H8ToTqnBNITa7LjPofbgcEYXyQHYWqt7WVhlj/Uk56My2EhIqO3ik+6MzHqT0Q==
X-Received: by 2002:a05:622a:1002:b0:39c:d841:9ad6 with SMTP id d2-20020a05622a100200b0039cd8419ad6mr9418583qte.572.1666024549824;
        Mon, 17 Oct 2022 09:35:49 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm152235qkk.81.2022.10.17.09.35.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:35:49 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/5] lpfc: Update lpfc version to 14.2.0.8
Date:   Mon, 17 Oct 2022 09:43:23 -0700
Message-Id: <20221017164323.14536-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda057
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.8

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 192d5630a44d..378eba7b09d9 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.7"
+#define LPFC_DRIVER_VERSION "14.2.0.8"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0.83.gd420dda057

