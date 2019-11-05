Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CDACA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8200520717
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQwNPQr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbfKEA52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:28 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33691 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfKEA52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:28 -0500
Received: by mail-wr1-f65.google.com with SMTP id s1so19328979wro.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8aztGoepi10UDGmP6ajq8EjSLibXdwTIoR/Ep1twTI8=;
        b=fQwNPQr+0IR/kjXOKGnf0Tl9ZYjJ+uE3Jpmb1YuGHeVP2jBmXsNcXr/E5Oj4XoEi3Y
         lbsW5yEEeob1BLvK7+TuA+g0HgREvNFYEzbXomRLXmNdNsq01l0WK5yGsZUIqxj57yFx
         tvxDfMw9Ka8RdWCKC4yCtl1isUbSdwbYxF/OhXyvCJDCOn1pqT0ew0jyBdlTltuh+gER
         9uhpGEtFWywTLZh4x4pMkqAeO6/V9wwxSmOzXjqsvSAB96aufuWjJ6wUFwg3FbHO+lvP
         sD6ium9OhelywjfdtixtUwp1w/QvPAt3jPCpEyqskNkvqsUkgGtrU+J5z+wYe/b+qBow
         795Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8aztGoepi10UDGmP6ajq8EjSLibXdwTIoR/Ep1twTI8=;
        b=QSPAD95fk/b//AiyH5Qb2Cd3PNtipdvXQNy1cSlw09wlXL+oUr1Fj8Ntz9fqMBjEr3
         p74FkK/7eth7cjPHhuAj9tmxBZsi1UxDhmoDYNjvj2r2xNfDharopDgmHirAGJj9wxsE
         vsUIEE1/+fcWyUSxN3cqVmCzOPAmpi8/lzvXZNlBeHgodb4Gd8D6Nb9BH/iT7ECcoLLL
         9NtMjDsAWCjjBBkWsimYNQY8hKNTXjp7D0jQ38SZny5WSS6hCYgcI3m5tLxFcY5K9XQi
         ioIMp7QyInjbtvLfBZd8snthhunTzTg2SSuzm5n35XTTVF3GCtQ7qXzKzSjXuB1ryleW
         xo/g==
X-Gm-Message-State: APjAAAXeXDK//nsAAUPBqfT35xru0bIwoCsy1L2Sk3oY0rXrcBk0ANBE
        4mI8xOr4gTrIxsFAgig6FJTRjuhXizc=
X-Google-Smtp-Source: APXvYqzSLfkBPiqihVKu0heFEd2Y/atXwxXrNgTSzL0CuQXA5bJDUYCPz13zl/i6AAvU8Xns7Tg3QQ==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr24508986wrt.249.1572915445751;
        Mon, 04 Nov 2019 16:57:25 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:25 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/11] lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce
Date:   Mon,  4 Nov 2019 16:57:00 -0800
Message-Id: <20191105005708.7399-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com>
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When reading sysfs nvme_info file while a remote port leaves and comes
back, a NULL pointer is encountered. The issue is due to ndlp list
corruption as the the nvme_info_show does not use the same lock as the
rest of the code.

Correct by removing the rcu_xxx_lock calls and replace by the host_lock
and phba->hbaLock spinlocks that are used by the rest of the driver.
Given we're called from sysfs, we are safe to use _irq rather than
_irqsave.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 2d090ea2b736..3f30bc02da9e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -176,7 +176,6 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	int i;
 	int len = 0;
 	char tmp[LPFC_MAX_NVME_INFO_TMP_LEN] = {0};
-	unsigned long iflags = 0;
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
 		len = scnprintf(buf, PAGE_SIZE, "NVME Disabled\n");
@@ -347,7 +346,6 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	if (strlcat(buf, "\nNVME Initiator Enabled\n", PAGE_SIZE) >= PAGE_SIZE)
 		goto buffer_done;
 
-	rcu_read_lock();
 	scnprintf(tmp, sizeof(tmp),
 		  "XRI Dist lpfc%d Total %d IO %d ELS %d\n",
 		  phba->brd_no,
@@ -355,7 +353,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  phba->sli4_hba.io_xri_max,
 		  lpfc_sli4_get_els_iocb_cnt(phba));
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto rcu_unlock_buf_done;
+		goto buffer_done;
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -371,15 +369,17 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  wwn_to_u64(vport->fc_nodename.u.wwn),
 		  localport->port_id, statep);
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto rcu_unlock_buf_done;
+		goto buffer_done;
+
+	spin_lock_irq(shost->host_lock);
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
-		spin_lock_irqsave(&vport->phba->hbalock, iflags);
+		spin_lock(&vport->phba->hbalock);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
-		spin_unlock_irqrestore(&vport->phba->hbalock, iflags);
+		spin_unlock(&vport->phba->hbalock);
 		if (!nrport)
 			continue;
 
@@ -398,39 +398,39 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 		/* Tab in to show lport ownership. */
 		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 		if (phba->brd_no >= 10) {
 			if (strlcat(buf, " ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
 			  nrport->port_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
 			  nrport->node_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "DID x%06x ",
 			  nrport->port_id);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 
 		/* An NVME rport can have multiple roles. */
 		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR) {
 			if (strlcat(buf, "INITIATOR ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET) {
 			if (strlcat(buf, "TARGET ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY) {
 			if (strlcat(buf, "DISCSRVC ", PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
@@ -438,14 +438,14 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 			scnprintf(tmp, sizeof(tmp), "UNKNOWN ROLE x%x",
 				  nrport->port_role);
 			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto rcu_unlock_buf_done;
+				goto unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "%s\n", statep);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto rcu_unlock_buf_done;
+			goto unlock_buf_done;
 	}
-	rcu_read_unlock();
+	spin_unlock_irq(shost->host_lock);
 
 	if (!lport)
 		goto buffer_done;
@@ -505,11 +505,11 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  atomic_read(&lport->cmpl_fcp_err));
 	strlcat(buf, tmp, PAGE_SIZE);
 
-	/* RCU is already unlocked. */
+	/* host_lock is already unlocked. */
 	goto buffer_done;
 
- rcu_unlock_buf_done:
-	rcu_read_unlock();
+ unlock_buf_done:
+	spin_unlock_irq(shost->host_lock);
 
  buffer_done:
 	len = strnlen(buf, PAGE_SIZE);
-- 
2.13.7

