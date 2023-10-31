Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6E3C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjJaS7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjJaS7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:16 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F35E8
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ca85ff26afso11041645ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778753; x=1699383553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwY0abciY/5rOgynozGa1kZPjEvQWzBEbUsGFTHsmos=;
        b=WTJUl5YBXYLoMscKZgHDkvDMj5oC1x0NeYXRPb0lkhbmJ6Ai0EjO/wrnlyL7t4y1bg
         tUQlSUK84t+ys+5eO4hLiafOGDwlCDYVG0BpmdYvK+XHX3jxIcWpPGXscmRjsbKxy/7K
         P3dfAuB//BxvS1snz2QbrpCDBZCwSvJP4nLy/l07tXRAp7ndI3gz25jkyaB0cDhjQNWt
         g6ovfKkQ1Wz6W2cAjLxrYRg1G3kct2HAJ1ErIC9MdjnltzaviIM4/3teWHmI7nXgK2+9
         4Ez9OBkI6XlynHMjnBnOdgDZVTAKzXZlvi6lHQ0LEQcpwFyLPC/KsZ+2VzKT2kCtTh53
         35KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778754; x=1699383554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwY0abciY/5rOgynozGa1kZPjEvQWzBEbUsGFTHsmos=;
        b=T+C7f/TDafj5kTz0g6qKDj8nGSpn7ZnDt+NnD/83FQ2xwu+7rSrOmKxBvybhyYv06l
         AlpmtjbqMx4bfEXvSSmxPzRKPiQ1MwwF9Qm8uZeVeqlimCUgmPFE+22GdluFw0y5KYqU
         yZpN/IzYKbszWW1s6b+xA8x4ZFy53Eux+WAoIgPi/JsPJ61TMIDxSJAjVGLD4ZkkERi+
         qgqcHFlNzcwPgSrn6+QcVcwNG4Hw4J2BM9ZFew6tMgxYlCksJQrAC78arb6Ni0x16E6U
         soIsJMh28E0jorFvbgz7HY2YxRRpCWm5dhGEdNnIq0EN0bjFLg9zJntgFnI+6aVn1mmh
         Chpw==
X-Gm-Message-State: AOJu0YyEgZPGdb3SthXVzjTjfaF/EAmY41SGh9X8E0jx4MwRjJ6oeAqr
        P9U8EIw1P9VN3srnp8Y/hAMPb8akL8o=
X-Google-Smtp-Source: AGHT+IEjld9aJpYeVQz0ZLsIf1FqbWanHWmTPUnRP/JmhJZmeYEDU2x4SdoScw2EG14t/2Xj2AkT5g==
X-Received: by 2002:a17:902:f214:b0:1cc:27fa:1fb7 with SMTP id m20-20020a170902f21400b001cc27fa1fb7mr11602811plc.5.1698778753687;
        Tue, 31 Oct 2023 11:59:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:13 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 4/9] lpfc: Eliminate unnecessary relocking in lpfc_check_nlp_post_devloss
Date:   Tue, 31 Oct 2023 12:12:19 -0700
Message-Id: <20231031191224.150862-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_check_nlp_post_devloss, retaking of the ndlp lock in the if
statement is useless because the very next line unlocks.  Simply, return
to avoid relocking.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 7ef9841f0728..f80bbc315f4c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -411,7 +411,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 				 "port_state = x%x\n",
 				 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp,
 				 ndlp->nlp_flag, vport->port_state);
-		spin_lock_irqsave(&ndlp->lock, iflags);
+		return;
 	}
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
 }
-- 
2.38.0

