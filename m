Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD6AEEB56E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 21:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbjIHVHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Sep 2023 17:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbjIHVHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2023 17:07:43 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D1E46
        for <linux-scsi@vger.kernel.org>; Fri,  8 Sep 2023 14:07:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1befe39630bso4890795ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Sep 2023 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694207258; x=1694812058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Nf0u4ogCffDxE08j9QV267NZXB3azJx1DU6+f3NfbQ=;
        b=gXgd7ys8DpHshX7BYhrvrwnIbqgsE3qoIV/OuWaVYOt632UYz4Do29P+5+pVudV+S9
         NcHyZVCtUJDp+rOiSXt1HjwojNuRNTzEiL8Tj9UWwW5u4lvZenEjt0GQwYcEb2pR5GrE
         CMLuTUnVhFM1mpQVWSIwxoeNcJ8nGZzGPdUDMWwkg+17g6pmLHB9efpMqz9vwuS0ZAH+
         Qd1EH6Gjdv1PTB171H9RhF0WDJGnCZQJ7y5IgK8dPCYcVZ+9Cw4uc9USuN4LMiP2fjH9
         WSvq6vry9Z11NALZKNgoQGFfs6biWGtymfOff+hVFx/L+3BAoMutMVC4M8hUi6jOu5hb
         gRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694207258; x=1694812058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Nf0u4ogCffDxE08j9QV267NZXB3azJx1DU6+f3NfbQ=;
        b=p6AlJTLzqQzDVTs7Cfv6Fxq0Li3Ydl3bSfP98HUQaAb7ovvRIVGQQG/lbu4xBcgRm3
         rArqYFlYV94Xu5SCFKTuePPGBcfLu1ePIpYMfyTMCUDsPYCGrcN3ap9xHe9aoFudhz8A
         xjBnnC3rvxc+BYANyj2BJDr2bbG5e6MY9TDKv6ENx5cFPG7ox5k4+AnAYyNiXZPNfOws
         cdNc8kwRwLRHUyiIBW7EyUZ8WAvFSJRVpJyVZYXbOCAyUxEE3n1fQKelALwvcgxn3wCC
         vH0QIBUG3nLd/OgV93cyEY1/oSlWE8AKTtgFhUYLwDgL2XdyhNWYpsqBmWfNqfICc86p
         NRSg==
X-Gm-Message-State: AOJu0Yw/o/6I5yalMyIJQSV5YZLf28U7xP0aNAt54Pml+i0U1T6hozj1
        ysSUCmEhe0fkMO8mhRztSerzK3y3oUU=
X-Google-Smtp-Source: AGHT+IH2nm9mqsmNnk8oilMBdaWN7Y4YLFP3P05/1Li/BbK7HDyCNVcWWTzVpJhrLMWbVqZXg5XMvg==
X-Received: by 2002:a17:902:e546:b0:1bb:9e6e:a9f3 with SMTP id n6-20020a170902e54600b001bb9e6ea9f3mr3760516plf.4.1694207258315;
        Fri, 08 Sep 2023 14:07:38 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ff0200b001b83dc8649dsm1985712plj.250.2023.09.08.14.07.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Sep 2023 14:07:38 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/1] lpfc: Prevent use-after-free during rmmod with mapped NVME rports
Date:   Fri,  8 Sep 2023 14:19:23 -0700
Message-Id: <20230908211923.37603-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During rmmod, when dev_loss_tmo callback is called, an ndlp kref count is
decremented twice.  Once for scsi transport registration and second to
remove the initial node allocation kref.  If there is also an NVME
transport registration, another reference count decrement is expected in
lpfc_nvme_unregister_port().

Race conditions between the NVME transport remoteport_delete and
dev_loss_tmo callbacks sometimes results in premature ndlp object release
resulting in use-after-free issues.

Fix by not dropping the ndlp object in dev_loss_tmo callback with an
outstanding NVMe transport registration.  Inversely, mark the final
NLP_DROPPED flag in lpfc_nvme_unregister_port when rmmod flag is set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 ++-
 drivers/scsi/lpfc/lpfc_nvme.c    | 24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 51afb60859eb..b7f922f31e26 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -199,7 +199,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		/* Only 1 thread can drop the initial node reference.  If
 		 * another thread has set NLP_DROPPED, this thread is done.
 		 */
-		if (!(ndlp->nlp_flag & NLP_DROPPED)) {
+		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
+		    !(ndlp->nlp_flag & NLP_DROPPED)) {
 			ndlp->nlp_flag |= NLP_DROPPED;
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
 			lpfc_nlp_put(ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 39acbcb7ec66..96e11a26c297 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -228,8 +228,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
 	spin_unlock_irq(&ndlp->lock);
 
 	/* On a devloss timeout event, one more put is executed provided the
-	 * NVME and SCSI rport unregister requests are complete.  If the vport
-	 * is unloading, this extra put is executed by lpfc_drop_node.
+	 * NVME and SCSI rport unregister requests are complete.
 	 */
 	if (!(ndlp->fc4_xpt_flags & fc4_xpt_flags))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
@@ -2567,11 +2566,7 @@ lpfc_nvme_rescan_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * nvme_transport perspective.  Loss of an rport just means IO cannot
  * be sent and recovery is completely up to the initator.
  * For now, the driver just unbinds the DID and port_role so that
- * no further IO can be issued.  Changes are planned for later.
- *
- * Notes - the ndlp reference count is not decremented here since
- * since there is no nvme_transport api for devloss.  Node ref count
- * is only adjusted in driver unload.
+ * no further IO can be issued.
  */
 void
 lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
@@ -2646,6 +2641,21 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					 "6167 NVME unregister failed %d "
 					 "port_state x%x\n",
 					 ret, remoteport->port_state);
+
+			if (vport->load_flag & FC_UNLOADING) {
+				/* Only 1 thread can drop the initial node
+				 * reference. Check if another thread has set
+				 * NLP_DROPPED.
+				 */
+				spin_lock_irq(&ndlp->lock);
+				if (!(ndlp->nlp_flag & NLP_DROPPED)) {
+					ndlp->nlp_flag |= NLP_DROPPED;
+					spin_unlock_irq(&ndlp->lock);
+					lpfc_nlp_put(ndlp);
+					return;
+				}
+				spin_unlock_irq(&ndlp->lock);
+			}
 		}
 	}
 	return;
-- 
2.38.0

