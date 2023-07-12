Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EACC001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjGLRxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbjGLRxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:38 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DB12109
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:37 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b89b0c73d7so8802685ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184417; x=1689789217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QurXhSXDDYPQxS3eICl+t2t9QVG4jXmJizxwtttvDq8=;
        b=VITeadwyJcnpc0W+6hnNF9yVA9HgDdQTUMJQk9cnp8orRBiWkGOM9AWYTX6ChHhG12
         yYjdy3bit9GU3EmP5Q94Dsms3yEZgqOu3a9Wz9QywmmI3WO2JacTCT67N5POSwLtOAVv
         dmIRy7yNQML2bSmcrNYCvH544XdHQtOd12i8bKsCwuCzWGj/7XaQxENkYjCo9QtoQbyq
         ImG9oEy32HuG27QlbrhpH9fKi0TQV1hU1V0bbYMSNjc7FUq2Aw6yF2CqBTB+LtgV3Zzm
         885Ps7b5idAaUR/G+XuxaKu5cQU52XNzKDFd4R6msUaDhNMezDouE7seIjXljw8c7sI+
         LWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184417; x=1689789217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QurXhSXDDYPQxS3eICl+t2t9QVG4jXmJizxwtttvDq8=;
        b=gbC8o1S1UoCnXzqfDpbBA8XFU+ettK7G9NdfVKb5i0drU8o+wbfkaQQcpj9Gm90VxF
         NK9ikjTvNHcj7vl/WgHjoOQ55V4X1rkC0kMeVCQIEq95EfnMShfxqePreQfjRxisSRo5
         wOYH6PEcLFbAldLgkAywIxM2ZoyDP14BveuouvH5QJFmlts68RdI2KMPbttzSi5QFRTy
         yUPSx0HZwz3VVknhlAWKjUgKuWM1SQP8wJ6lej9E5b9z1TuAa1j7Ltx+ZsEwbpUkvvoa
         8h3FQGWMKkXStIbfaQ6I2WOYrRl1nzs3xT/yyhCiiH+W5bPC4YaNfzkAPRd2UoCRrXA9
         tSlA==
X-Gm-Message-State: ABy/qLacLvQE6DxL8fiFkccZ0FgjIODb4i5Ktz0n43U51dGNQcXO6dtA
        9LeSAeFKH1PuR3cq/EEMNXwI4D58COI=
X-Google-Smtp-Source: APBJJlFdV4daRCWvO7AW8/RfYP5xE7Nq6GsATEbLIeTke/5wGNeyVnyop6T7JFbhqWgW5ax/1+P0sg==
X-Received: by 2002:a17:903:32c4:b0:1b8:a469:53d8 with SMTP id i4-20020a17090332c400b001b8a46953d8mr162568plr.0.1689184416785;
        Wed, 12 Jul 2023 10:53:36 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:36 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/12] lpfc: Remove extra ndlp kref decrement in FLOGI cmpl for loop topology
Date:   Wed, 12 Jul 2023 11:05:13 -0700
Message-Id: <20230712180522.112722-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_cmpl_els_flogi, the return out: label decrements the ndlp kref
signaling that FLOGI processing on the ndlp is complete.  In loop topology
path, there is an unnecessary ndlp put because it also branches to the out:
label.  This also signals ndlp usage completion too soon.  As such, remove
the extra lpfc_nlp_put when in loop topology.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2bad9954c355..9a7b62d18455 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1041,7 +1041,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
 			lpfc_nlp_put(ndlp);
 
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_TRACE_EVENT,
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 				 "0150 FLOGI failure Status:x%x/x%x "
 				 "xri x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
@@ -1091,7 +1091,6 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 				lpfc_issue_reg_vfi(vport);
 
-			lpfc_nlp_put(ndlp);
 			goto out;
 		}
 		goto flogifail;
-- 
2.38.0

