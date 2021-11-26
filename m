Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80146C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 05:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbhKZFUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbhKZFSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 00:18:54 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6140CC061746;
        Thu, 25 Nov 2021 21:15:42 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so7158933pga.1;
        Thu, 25 Nov 2021 21:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKzwqlZ/U7YNENuKROdSQMpO6S/HGCWA7OjlBzmX4w8=;
        b=nCitiwdZTOKTdPmNQN+JLWqnGE2y31yMpK4Aco0Jja8dVpzQTGdHh15fFQ0CSGbr0s
         bVV3umujDDvLzJ0IlTMM7T0Na9kQpIs7OgW/pWaZU0SrtYbb5HNsxBB4+GceOhBQdlu2
         jVvclEdKTO6+c7ZVQ9CvrKsfja9GWkh25nE5CDi/DXgWktAaalIF3mRKxBWig8vB/5m8
         UbqnxrVkPRAbKhip/E8Oc4vIKb4XtD5AQ+Vqyv2+8zIUP1w5EtUs0TfDwVwfr8MYp+Ar
         Cby3aOeFr4wiBaYXaBqCAw6a14TxEb5o3XNe/M3YOFje2fJfRZRI5OMQ+IkxPK9eQTJL
         CrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKzwqlZ/U7YNENuKROdSQMpO6S/HGCWA7OjlBzmX4w8=;
        b=vlyer2uUeRQeqwhQSly6h75BV2wKuyWxdFCnww+4JeIfDkdJXezKMQSbqziCiwbECF
         EmZaqldZ7taYhlSAhF8+gvM4dQiWJ8o0ZFUEQj3Nk+bouztuQe4NeAOFLXMFUfDOkd4H
         y23IBVmeW2L4kXMj5AHkleOORlP917wsV4sa2WV2dlgZTLAqtnnOTt7QOjBoeap8yxYh
         V5gQ4fcoloEz9ZrOJ+PpAEidb2gx02h1kms7BkKn6BkVkSLtvp7rHmpsKrzjSlA0KhwS
         6rgwFMEGaWR0bh15hT/PT1a4SNXK6aN6qdv9jeaCUQESvD5mhOH7XcRU4umnwa2OZIng
         yDeg==
X-Gm-Message-State: AOAM532ju2ZUEPGErOuhjrFsDBK06iC59vYg2DqDNYH1f34XJk0PaU8z
        dw6sVrKVNaL8inwI5NynJUslzWaNJMApWg==
X-Google-Smtp-Source: ABdhPJwkIZdrdhIx9N9dz4aWGWTIxkxMngbh5VYC21Q+XBeRdsOhoXYwxVOD+/xW7OgWABSw1bV0kw==
X-Received: by 2002:a63:88c1:: with SMTP id l184mr5672741pgd.521.1637903741509;
        Thu, 25 Nov 2021 21:15:41 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id lb4sm10326377pjb.18.2021.11.25.21.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 21:15:41 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatting
Date:   Thu, 25 Nov 2021 21:15:29 -0800
Message-Id: <20211126051529.5380-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126051529.5380-1-f.fainelli@gmail.com>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The format used for formatting SYSFS_FLAG_FW_SEL_BOOT creates the
following warning:

drivers/scsi/qedi/qedi_main.c:2259:35: warning: format specifies type
'char' but the argument has type 'int' [-Wformat]
                   rc = snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);

Fix this to use %d since this is a plain integer.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f1c933070884..367a0337b53e 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2254,7 +2254,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
 			     mchap_secret);
 		break;
 	case ISCSI_BOOT_TGT_FLAGS:
-		rc = snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
+		rc = snprintf(buf, 3, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
 		break;
 	case ISCSI_BOOT_TGT_NIC_ASSOC:
 		rc = snprintf(buf, 3, "0\n");
-- 
2.25.1

