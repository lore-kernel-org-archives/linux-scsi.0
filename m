Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81027C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 00:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5500961396
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 00:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbhDGAba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 20:31:30 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:41032 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbhDGAb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 20:31:29 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 20:31:29 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 4FFQBl6ndBz9vCBq
        for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2021 00:24:47 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WxsHpYgdGB9r for <linux-scsi@vger.kernel.org>;
        Tue,  6 Apr 2021 19:24:47 -0500 (CDT)
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 4FFQBl58N7z9vCBs
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:24:47 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 4FFQBl58N7z9vCBs
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 4FFQBl58N7z9vCBs
Received: by mail-il1-f199.google.com with SMTP id o8so1807280ilg.18
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 17:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eCJcxMq9XZ++9qNavNyMD/aAoy0l305S7aiP1i3rmqg=;
        b=mb2tJAXU29fdFTkxo7nqslpfvc0HvmFoXGjkGRtJnPe1+AIgtWfzE9payVst0jmkgX
         O+0zJKAN0XUgyUbXSGZMX782GZNrXRenDyhV172TH0C1tX5oiytfgwnx7AaDxzgg0SSr
         Ice1JG1vM0e6U46szVk6XUt8fPdETgeCCF8DjT21SccvBO7ADxrGhDu4ND+EWAz30k0o
         r8G6kh5cMHVgAac+6/kLxSO+gLSvNoivr6/YaIZ+qNyfPawFuCv1rOPnSwTZlY3PWYUn
         z5LGV+ukBHuQ3U4t4pLbKJj+qczPPnW7zE8xJOtbCV91NxVjJvxQb4RxGReDAMfiHpGp
         H5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eCJcxMq9XZ++9qNavNyMD/aAoy0l305S7aiP1i3rmqg=;
        b=K8jIxWIw932tvK4sco2Cy3DBDGLy6BUShQc/XLM5dCkCBNXFkmuncdqKkA70flRgct
         OsVjUdER7nzXRFJ1CQFIlNzd3cterk351sC2pbXlNoNzifpkdel2GIoPYvl9tI8fs8p4
         eic3EP0ebIxl4FtJ99aSs2/K5qgiVeEY49pORt3J5xrOhL8ldAXf7svOCIpLm6ZkmxBd
         1FsTzZKZ6he8nBCT2Hsb2tYGiQE6z08RazcBCc9VyD3J/nnH61O9Wc9mBY16Ur98KOjy
         fk0kZGJYxvtxbn3wEfejQEZDCqrQqz9YJcOZ4tiqb9BAgpj2iH54KmmEczqekMZagJBa
         ux6A==
X-Gm-Message-State: AOAM533wsBI+/nHVz+H2N7ZEAReDUqhv3MWE+IFPpf/S6ZnQ+yssih1Q
        qXPMDTKU3WN//OJY5tj4nHGdbZdrUdoBmTQaKeFO14D+2AgQoMOK9vNIy2CriX83UjyKlgainvV
        Kw/ouzf0wxSlIu8XscVUx/o5QFw==
X-Received: by 2002:a05:6e02:15c7:: with SMTP id q7mr693313ilu.228.1617755087374;
        Tue, 06 Apr 2021 17:24:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGRsolhynPcwdmdikCWxWk9mcbSGu+Qg83CUnO520JGA9T6/ph1a5RkcqsyebjW9+7sR0qcw==
X-Received: by 2002:a05:6e02:15c7:: with SMTP id q7mr693303ilu.228.1617755087216;
        Tue, 06 Apr 2021 17:24:47 -0700 (PDT)
Received: from syssec1.cs.umn.edu ([2607:ea00:101:3c74:6ecd:6512:5d03:eeb6])
        by smtp.googlemail.com with ESMTPSA id r7sm9530767ilj.72.2021.04.06.17.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:24:46 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: be2iscsi: Reset the address passed in beiscsi_iface_create_default
Date:   Tue,  6 Apr 2021 19:24:45 -0500
Message-Id: <20210407002445.2209330-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

if_info is a local variable that is passed to beiscsi_if_get_info. In
case of failure, the variable is free'd but not reset to NULL. The patch
avoids security issue by passing NULL to if_info.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9..1ff9d2a2a876 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -274,11 +274,13 @@ void beiscsi_iface_create_default(struct beiscsi_hba *phba)
 	if (!beiscsi_if_get_info(phba, BEISCSI_IP_TYPE_V4, &if_info)) {
 		beiscsi_iface_create_ipv4(phba);
 		kfree(if_info);
+		if_info = NULL;
 	}
 
 	if (!beiscsi_if_get_info(phba, BEISCSI_IP_TYPE_V6, &if_info)) {
 		beiscsi_iface_create_ipv6(phba);
 		kfree(if_info);
+		if_info = NULL;
 	}
 }
 
-- 
2.25.1

