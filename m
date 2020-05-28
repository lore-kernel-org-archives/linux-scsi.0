Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0320C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 20:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2177207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 20:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="EW9a3uYA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406955AbgE1UOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 16:14:04 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:59524 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406949AbgE1UOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 16:14:01 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 49XzRs0cPPz9vrWR
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 20:14:01 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lqq5N2ugNYIz for <linux-scsi@vger.kernel.org>;
        Thu, 28 May 2020 15:14:00 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 49XzRr66VDz9vrWJ
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 15:14:00 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 49XzRr66VDz9vrWJ
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 49XzRr66VDz9vrWJ
Received: by mail-io1-f69.google.com with SMTP id j23so34414iok.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 13:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=U7D66rZ3bV/mdno+N6Y057Ta6Mf7fN3AGEm3ICQ61Jg=;
        b=EW9a3uYAYxVAoF/74DWigOh60vuyrSoIJXn/zN2njgaJY+rLuRnWb20OuhePu9eGzx
         x+biPSLnq17WzRzA3wiIIhVLLXsSfoPGbePDH/GgJGkqi3xCqp7mwyApibjbiF8CJOEw
         gqLZEjO0l9TEF1LPlW8L0GLN+M4RsxBCCRVCeECOz+b6VXA/LhuAex6ca1b5FPEwCo1q
         FJQ4cIVwIUalpS8dUxzFPJ/dACsFu+3DKkKqPBcbUvLGPkorZTdNo3ItLGTPVnd891n5
         5zsDqKKeVcm6bZXFH7whDD+b3vAuIq5FU3XQ7lnE6dEl8giPm3tQNFGBw2p/yFLvN11u
         u33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U7D66rZ3bV/mdno+N6Y057Ta6Mf7fN3AGEm3ICQ61Jg=;
        b=TgoHFpgNUkGzBO667uVQUooGKhkJUJDG25+z5YMftZu2IZi48Po+fzXO1r3SaFq/tS
         QPegyYQH7Jq3dtgYW5CFoVBy3DUQ5KAxVMWuEAINdH5Rpmh3yMq59cXaRFVMGs8uHGuY
         Bd4OAMCGqfFZV1WZsQzjVQi8w2VFsNjIbPCP5unCoWs2KkO4qVzBXTbvH8aAPygMJo7c
         YiAiGupNpVYpgTDVa1tTaDB0Hxb+NlmVxo3M2NAPQqTz/Hsc7KUH1AkbEbOz2Nxh63HP
         7SgbtVDmPsDN/uHfKECndrJyBrjudxmEG6PwP5OtrFuKFbbfqJJUmGqMwaafIMu8vm2f
         jlAQ==
X-Gm-Message-State: AOAM5338nRcaqgF7ybcOksrUDLMtBPbzA4vmDk8ncn10+VbH4skfj0bx
        WMSjtdGOd2xyvUlO9ADr1ZTW2DNB87FXs9b6aINbSCmDXbIk2IfB+hlopMOskrPIEJikjUM4Nhs
        Y8Td62PrvEYDekY8AViKcFY/B2g==
X-Received: by 2002:a5e:9b10:: with SMTP id j16mr3809159iok.49.1590696840391;
        Thu, 28 May 2020 13:14:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZhwnn75y08LB5aGQ6JOpTV5oB0pOWzycl/FkLU+GqywfvLq+r/t8EuBVFSGqd0pv6K7Re0w==
X-Received: by 2002:a5e:9b10:: with SMTP id j16mr3809135iok.49.1590696840039;
        Thu, 28 May 2020 13:14:00 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id h10sm3027690ioe.3.2020.05.28.13.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 13:13:59 -0700 (PDT)
From:   wu000273@umn.edu
To:     kjlu@umn.edu
Cc:     wu000273@umn.edu, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Fix reference count leak in iscsi_boot_create_kobj.
Date:   Thu, 28 May 2020 15:13:53 -0500
Message-Id: <20200528201353.14849-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

kobject_init_and_add() should be handled when it return an error,
because kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object. Previous
commit "b8eb718348b8" fixed a similar problem. Thus replace calling
kfree() by calling kobject_put().

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 drivers/scsi/iscsi_boot_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index e4857b728033..a64abe38db2d 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,
 	boot_kobj->kobj.kset = boot_kset->kset;
 	if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,
 				 NULL, name, index)) {
-		kfree(boot_kobj);
+		kobject_put(&boot_kobj->kobj);
 		return NULL;
 	}
 	boot_kobj->data = data;
-- 
2.17.1

