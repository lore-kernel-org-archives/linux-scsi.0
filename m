Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582E2EEB56E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 21:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241837AbjIHVHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Sep 2023 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjIHVHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2023 17:07:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ECEE46
        for <linux-scsi@vger.kernel.org>; Fri,  8 Sep 2023 14:07:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bf095e1becso4264225ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Sep 2023 14:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694207233; x=1694812033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRKEa/CY/U/2y8kmmXWkghfIC2mOr39+66dCxV2EImc=;
        b=rf2eKTrXoYxe3brtqJ/knZyH63rmrFYdB12PcGFiMpCWTBRK0NEbxHvGt7CIkCMMIZ
         SeN9KMw92J9XoGIadaVp+Pz6KLGc7tlwR1n0DYLQ6UvQwzZFWP7Sq+irY7BCWoS+IX1i
         rkj7vhTHzF0uU6QP5PYNaV34yedjxxlvoIjzHZ/i9W/FhMWzDsSaCrqMglMwhB+B0hlr
         YVHk8HVeUCRnQCNK2GgP48Efw5aCcbD1J7FBOCcsW9Pl+Y5MGpcXHM1DjjbQeFdEWaa8
         sFryow9o5A1rH3magMi0BhPsJkIg+CAsBE1JJo0vZj9ibGk4wB5a27n6ErO9qwESvC10
         bsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694207233; x=1694812033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRKEa/CY/U/2y8kmmXWkghfIC2mOr39+66dCxV2EImc=;
        b=SwY3WlqHHC9lQqKH/yxhNIsk3hywCKn/Y5DTPGej0+WTlUq5UUbwleQhdypR9NOqbl
         8WMfu6uLas9oB+VHvCiqGzbdQxiaiCbSrg8+ubXDeSNaOxBgo+C7X7Cf6XiQqUk3qdZu
         gK6e06nQgRTD+w1u9JaCi1bWtD4QU7M3vM9/oFijVyKxsVEa2BYKswQisCDYzQ6KmegF
         8iLmXRNsSDXgo+w6VU9bR75woM50L65hltQja3uH9BKsvuOkakhftrwmohsmNTwQ6Tsz
         7wdXvbxg6Nj4lP0xUOZU+bGwL34c3knygR150wv1W1+zmSZ0AZ76VYVYY3oWL7fR729i
         OB7w==
X-Gm-Message-State: AOJu0Ywwi7ycp8bI8d9hk3xCHELtp8GOq4actc3roqUIgHvaFbjPC0kN
        RfkuzPT1yI/wMmzF+7nT1tcWIGYImDI=
X-Google-Smtp-Source: AGHT+IFKzzk8pMLCz8rDNo+L5rANlAvsD7/57KLl9LB5Yvptc7hFL8LJo0BYMZKlV5b9muYzGTqoyg==
X-Received: by 2002:a17:903:41c8:b0:1c0:bf60:ba4f with SMTP id u8-20020a17090341c800b001c0bf60ba4fmr3823363ple.4.1694207233451;
        Fri, 08 Sep 2023 14:07:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g22-20020a170902869600b001bdc3768ca5sm1992021plo.254.2023.09.08.14.07.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Sep 2023 14:07:13 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/1] lpfc: Early return after marking final NLP_DROPPED flag in dev_loss_tmo
Date:   Fri,  8 Sep 2023 14:18:52 -0700
Message-Id: <20230908211852.37576-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a dev_loss_tmo event occurs, an ndlp lock is taken before checking
nlp_flag for NLP_DROPPED.  There is an attempt to restore the ndlp lock
when exiting the if statement, but the nlp_put kref could be the final
decrement causing a use-after-free memory access on a released ndlp object.

Instead of trying to reacquire the ndlp lock after checking nlp_flag, just
return after calling nlp_put.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 51afb60859eb..674dd07aae72 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -203,7 +203,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 			ndlp->nlp_flag |= NLP_DROPPED;
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 			lpfc_nlp_put(ndlp);
-			spin_lock_irqsave(&ndlp->lock, iflags);
+			return;
 		}
 
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
-- 
2.38.0

