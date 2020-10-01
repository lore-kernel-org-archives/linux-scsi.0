Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88387C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4583621707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTk0Rt4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgJAMcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgJAMcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:32:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F0CC0613D0;
        Thu,  1 Oct 2020 05:32:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 5so3930900pgf.5;
        Thu, 01 Oct 2020 05:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uVl3TCvbBhvJ5acgqRChRsAsShA7j8oIRrpWgA0mKfY=;
        b=OTk0Rt4jglWwZ+yz7PsVtVxG6KxnnckXVtI2Opq7bCjfEwQ5gtjDTxaVrUmOAMTg77
         lM1QfFnGoonQwGuBML+0QKpHkWM9Tx5oiHBxHrKYhliXy2Y9fSZVHDz+GwmVlfX8F9X7
         RXtqSGyQi7kVUut5IfbSV97vZEgNnXq9jjUyYL0ae9ibUv/7OqWh4ruqysGX5S6V8Syj
         yJNvRTuxy5QV4MVbzNkQiLI7byuedKaskDRu6vAS2/unGhLzsfADsp6RmVnC1tY41UV6
         gXt4UTFOFlR8N1/w0hEiM3TTz1DIGewXsc4/xurN3D1dntbsCsIlaqanAI5BHYBMLr2Q
         vXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uVl3TCvbBhvJ5acgqRChRsAsShA7j8oIRrpWgA0mKfY=;
        b=LD1vC3dbsNHhbXTCm6FwJqIzVMo7/uxDtJrg7Nv78UwYKDYLfYx3PtTQFDlgupSC6/
         uO1enctE5sgYI5oWmeiSDF4dfoTLnZcdyCnk82pep76e9fNlOt+8qU/pk7G6/C63DZ+0
         rSN3tWc1fiwn7Qr4NYd9/O4FwwfhCbuxJAAxVYqgx2+h/c6SKO6Dwx6sbBf6Xr4Z0hpc
         C5L2WgLdVMcrYeV1HonZiTiO19PVAYesrcupfqs1f70V9dJSOO4uRRUmu+xdPBiUSNoP
         QljypL5uzhlX0HkBd4I/dujw7ipIQ5oCoK0JTY53DLSf4a6IvkvKFv2ljpVUYUUyqYyH
         T+Xg==
X-Gm-Message-State: AOAM5300wEjivG1cEN6jTByiR733oPuwDVdOwYnlR6+FIzhObMcYj+kY
        RJv7DfmaEH4qa37qeS65AT4=
X-Google-Smtp-Source: ABdhPJyp/dES1p7s+7zMWL4diu52QUTY16wzfY+9/UX0IZaM5NkaxdbwHIPAKsdOFL6UeptfOPY20A==
X-Received: by 2002:a63:1162:: with SMTP id 34mr5512456pgr.329.1601555540370;
        Thu, 01 Oct 2020 05:32:20 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:32:19 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 26/28] scsi: mvumi: update function description
Date:   Thu,  1 Oct 2020 17:55:09 +0530
Message-Id: <20201001122511.1075420-27-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no "device" parameter in mvumi_shutdown(). Instead there is
"pdev" which is not described.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 6c710585a628..82dd7c37c14e 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2558,7 +2558,7 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 
 /**
  * mvumi_shutdown -	Shutdown entry point
- * @device:		Generic device structure
+ * @pdev:		PCI device structure
  */
 static void mvumi_shutdown(struct pci_dev *pdev)
 {
-- 
2.28.0

