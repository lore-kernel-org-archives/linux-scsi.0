Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E7BEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjGLRxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjGLRxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:34 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFCC1FD2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b8c364ad3bso12901555ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184412; x=1691776412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fliTXGR0cbyCdFc6vaaV+Kz1HnP9oZIHzRXQ7Gq9GtE=;
        b=nKe+Ah9LPGnIzy4usbtHHQ8/fIUVYSMrZ/AqgTDwGQnk40kZ2izaU2wl6psJfp8WW6
         dBeyTNCyGi6/M+GwrYrCE7whNimr9E85XFfPjljIM0T3bHa9AVWbpEmcvVQwRQjKk+6U
         tfiQyDfTpFzUr0P1LK4M+jFScB+OJfRCi6ZX7RBsObR5h8VCiQnVFpw70PvleJWX4m7I
         DJuhAnkUlEZ5RtMQb3KHfq1ustTevSvhBEsFmYZtrIRY2iFMhkXDSJ5iscll6TRH3u9P
         VzHfHIvgkbk9EN0joqFONkDvNx2/ZA7mXFkZjNchl7WJAtmUI65c69OJaV7/mc4UFgf7
         NPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184412; x=1691776412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fliTXGR0cbyCdFc6vaaV+Kz1HnP9oZIHzRXQ7Gq9GtE=;
        b=TAtE4x0Bo4uE97XE0egaE/GKagHzXwBUH0j28itG07G/5AhyImjbV/4JorZtSzClxU
         DQcDCjCxA9NWXedtKKMXwD50VU1VqgmxCiVX1k/PiLqWS45Nzr/TBLjSKDY18wpzVcWh
         RlvGa+dJtfoX7Buf6n3nSm1APxau79NqEYjj/a4XnqdweDcxK7795lPs63UNneM5ECcZ
         qnriuO/o6b0bu7ZQmZUCN1m74l6qPIRkPGIHRQhMskUMJ1E3C1zWpIKHxyMiPb7KpHCo
         MafA/CyZFvTjUtq0otkUyDiMC8WvXYg/qqx8Y2I2Oo1RTW+8tYy6IriGU4cMW64gOQmF
         8hTw==
X-Gm-Message-State: ABy/qLY1NZvrrxX1WgAon/ft1hSfTLreXjntjMiCjAIUzm2RiKMJ2pXh
        a1DMDFlSPwYTm31gJk0PPZV2miJgpIk=
X-Google-Smtp-Source: APBJJlFsRPSk66mnVQ3d8dWtRvz65z2sEQCVjXFpmmdo7jnjx3MFRXEoPwKzinkXAbtdhp9BIIEYqA==
X-Received: by 2002:a17:902:ce84:b0:1b8:811:b079 with SMTP id f4-20020a170902ce8400b001b80811b079mr151181plg.0.1689184411910;
        Wed, 12 Jul 2023 10:53:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:31 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/12] lpfc: Pull out fw diagnostic dump log message from driver's trace buffer
Date:   Wed, 12 Jul 2023 11:05:11 -0700
Message-Id: <20230712180522.112722-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The firmware diagnostic dump log message does not need to be a part of the
driver's log trace buffer because it is an expected user triggered event.
Change LOG_TRACE_EVENT verbose flag to LOG_SLI.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 3221a934066b..041d6f0f2097 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2123,7 +2123,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 			en_rn_msg = false;
 		} else if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 			 reg_err2 == SLIPORT_ERR2_REG_FORCED_DUMP)
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"3144 Port Down: Debug Dump\n");
 		else if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 			 reg_err2 == SLIPORT_ERR2_REG_FUNC_PROVISON)
-- 
2.38.0

