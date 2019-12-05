Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD03C43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 22:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F99F24687
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 22:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aic1torb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbfLEWJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 17:09:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41519 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEWJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 17:09:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so5545059wrw.8;
        Thu, 05 Dec 2019 14:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZdWkas9byKVfGyALn++Pdl/V75AST1LWkimI5TQuCt8=;
        b=Aic1torb6kGicyy1Kxl7CYGpjIvGJzikRSSQi48R0AAciQuBLK8sm2M7Iz8otIBsDi
         vCmo9bbznvkuSV6xUvhc/r5ZIJ42EBlXJNcvJkzzPJtJQliGgot2Ep6IhoadKFYPRoUl
         ILOsLgX/qkJH3wB8jYUuAM7LDmzyXGra2kXLDw7zFjla0xAl/QevXLJ0v6bAg/XP7lnM
         lTlAVxfEJCBHQJUAOSsdVCmaq4XvyhAImLcVcvWXKmoSFivSpDdWePvIDmRusTRWS3Mp
         egUb2zTuJjM0vuXHSMd7kmXwtmqorXftYg9Dfdt2c/hIStv3DSHhGHEEmdi1sEOfDeOD
         cy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZdWkas9byKVfGyALn++Pdl/V75AST1LWkimI5TQuCt8=;
        b=nYg+kIUusmngIxzpYKcAQkkaO0g02cq5GVMZV1HkpFvIb9u5bIMRXI43xg3GL6mHwR
         YgLKnQMpL5ySUmzT7QOVEPkkcPp0Ah6MUplnEDuAW+zFKMjkVY09UiD4o7UnhTnV51+Z
         Kssseh4255U9eZ9fNpwTmTlC5ua+/qZA6NTinkpdNzXQISBV8oKRbOXnCD0WHar6zjzf
         i1djQr0THFCDnmKY7n96UfQZQBr+Da+gYE9ZvvMGCMsxLpdMTzEZXXt+oNKynicg+ZX/
         MhcnYCorBM52QKV3ItEZMJJMoa2fPQrCw7ZGsbcLdLIIa3vHkj9KKPnTrQZjruLthQJL
         csww==
X-Gm-Message-State: APjAAAWTEKoNCqJKYxyI+qOFHDDsy4Kusfeh2dsqIGP1AjrSVNlCf6z9
        pzMOjag7JA1/SH19DZr7NGZHMorD
X-Google-Smtp-Source: APXvYqxeB/YeEEM0D5Pf0nxgd8z88nl5855wEpEkfrtY49r648WrOwnowpSaVuHS758CiDlDpZABbw==
X-Received: by 2002:adf:f508:: with SMTP id q8mr9233060wro.334.1575583767329;
        Thu, 05 Dec 2019 14:09:27 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfdc6.dynamic.kabel-deutschland.de. [95.91.253.198])
        by smtp.gmail.com with ESMTPSA id n14sm551180wmk.0.2019.12.05.14.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 14:09:26 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: delete unused structure filed tr
Date:   Thu,  5 Dec 2019 23:09:12 +0100
Message-Id: <20191205220912.5696-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Delete unused structure field tr in structure utp_upiu_req, since
no person uses it for task management.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 9988db6ad244..d55f2176dfd4 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -68,14 +68,13 @@ struct utp_upiu_cmd {
  * @header:UPIU header structure DW-0 to DW-2
  * @sc: fields structure for scsi command DW-3 to DW-7
  * @qr: fields structure for query request DW-3 to DW-7
+ * @uc: use utp_upiu_query to host the 4 dwords of uic command
  */
 struct utp_upiu_req {
 	struct utp_upiu_header header;
 	union {
 		struct utp_upiu_cmd		sc;
 		struct utp_upiu_query		qr;
-		struct utp_upiu_query		tr;
-		/* use utp_upiu_query to host the 4 dwords of uic command */
 		struct utp_upiu_query		uc;
 	};
 };
-- 
2.17.1

