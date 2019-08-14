Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B2BC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6E1020866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oi8Wm57k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfHNX5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41524 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbfHNX5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so416431pgg.8
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XfINQM6wWP7zbA9TzJIKs7fJq+odv4gM+7ghNsZ2cUY=;
        b=Oi8Wm57kx/beF47Gg/f/X7I2L8A0GOiYXStgw304IHSKslr3WHxDaIlJjpIvKQ6O7d
         CoorRBXuRfP2UXCOLomJX1k7FPgkedHFefSKASC6HKjmiBbpWP3yHii0MjjWgoerkWqz
         GKcx+xtc1IGVF+AyVq5ZyzoOlwmdCSmsopmn7Alx8IfJW8Ag7ZINl8LUlq6pvI8H/+aT
         Gq8IJMl9blWpssx3/+UlXj29OMf1jpFItqeaSIuwosEpcLSPhI80SLcGne+vfPtnHWYV
         WeVqp/JRp2sETNflZwzJciTloC4UdtWp9efzY/FZzH+YKs4hSnxX/ALw2Ul6s+QYEkCH
         5F4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XfINQM6wWP7zbA9TzJIKs7fJq+odv4gM+7ghNsZ2cUY=;
        b=qFFG03VVhjeFDuEGnCihgEGbuyut5F37Y0x8PIfFGGHKQhieTe1j5feQE1dGdpS0ei
         eo6EEJw7GK9KCoO8l+8IgHbqtK9+JSh67CzxEnFgOkCEXexmsEFjmARPX6SOGf3mONim
         NhkuBtlm2tt3tzvT5RO7BsM1yEW6VOhqLBxXBk2hcR5E6EWqdy6eigIBZM9asd7mlTep
         yVwIl2hmTRKt4te1DpNNzAdwh32TTedbR+1nsoELxegeaxNnpDABDLGYiYZ1NPJ6qOiu
         8y5vCNTdDGa6W9zkJ2SWSUMx6gYM6Te+2N8t4qx/BC5GQRGvDVo7u5OGKF+2Ag7mxryz
         hb2A==
X-Gm-Message-State: APjAAAW805p9SLt24z5I+0+y1mwuR5qaMEjs5bKM5mSTN8Krgt8NtTAs
        K0EEn90Hc7drjM3UyOVJBGfQFuI0
X-Google-Smtp-Source: APXvYqwkhZBXNtReMhbFxM9FU2v6An/64LkOb2e7IVkr7PthnP2bDP6zSBTVxBsbuS0M8lHPZ4EN4A==
X-Received: by 2002:aa7:81d9:: with SMTP id c25mr2600340pfn.255.1565827058742;
        Wed, 14 Aug 2019 16:57:38 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:38 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 21/42] lpfc: Fix error in remote port address change
Date:   Wed, 14 Aug 2019 16:56:51 -0700
Message-Id: <20190814235712.4487-22-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a test with high nvme remote port counts connected via a
multi-hop FC switch config where switches were systematically
reset (e.g. fabric partitioning and re-establishment), the nvme
remote ports would switch addresses based on the switch
reconfiguration events. The driver would get into a situation
where the nvme port changed address, PLOGI and PRLI would succeed
nvme transport registration occurred, but subsequent LS requests
by the nvme subsystem failed due to a bad ndlp state and
connectivity to the device failed.

The driver hit a race condition on multiple devices that address
swapped simultaneously. In cases where the driver notices the
remote port structure came back as the same value as previously
(meaning a nvme_rport structure was re-enabled and did not go
through devloss_tmo/connect_tmo_failures on all controllers) the
driver would unconditionally exit assuming the ndlp information
was correct. But, if the ndlp's had been swapped, the ndlp had
stale port state information, which when used by the LS request
commands, would fail the commands.

Fix by checking whether a node swap had occurred, and only exit
if no ndlp swap had occurred.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e8924e90c4eb..103708503592 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2348,7 +2348,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				 */
 				lpfc_printf_vlog(ndlp->vport, KERN_INFO,
 						 LOG_NVME_DISC,
-						 "6014 Rebinding lport to "
+						 "6014 Rebind lport to current "
 						 "remoteport %p wwpn 0x%llx, "
 						 "Data: x%x x%x %p %p x%x x%06x\n",
 						 remote_port,
@@ -2359,7 +2359,16 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 						 ndlp,
 						 ndlp->nlp_type,
 						 ndlp->nlp_DID);
-				return 0;
+
+				/* It's a complete rebind only if the driver
+				 * is registering with the same ndlp. Otherwise
+				 * the driver likely executed a node swap
+				 * prior to this registration and the ndlp to
+				 * remoteport binding needs to be redone.
+				 */
+				if (prev_ndlp == ndlp)
+					return 0;
+
 			}
 
 			/* Sever the ndlp<->rport association
@@ -2393,8 +2402,8 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		spin_unlock_irq(&vport->phba->hbalock);
 		lpfc_printf_vlog(vport, KERN_INFO,
 				 LOG_NVME_DISC | LOG_NODE,
-				 "6022 Binding new rport to "
-				 "lport %p Remoteport %p rport %p WWNN 0x%llx, "
+				 "6022 Bind lport x%px to remoteport x%px "
+				 "rport x%px WWNN 0x%llx, "
 				 "Rport WWPN 0x%llx DID "
 				 "x%06x Role x%x, ndlp %p prev_ndlp %p\n",
 				 lport, remote_port, rport,
-- 
2.13.7

