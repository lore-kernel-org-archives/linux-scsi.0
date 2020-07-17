Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56398C433EC
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34B5F20734
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBLuGtTd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgGQGiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgGQGiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:38:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597CAC061755;
        Thu, 16 Jul 2020 23:38:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so413172pjd.3;
        Thu, 16 Jul 2020 23:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uomQmJlWIjhkvxxLfQSyf1nH+prda88V/9IK/Q2lWjA=;
        b=JBLuGtTdxjZN44nn8hqq9uObIgSW8ePzEtt2BchSVq5K89r2ocBNQQ4lyftpFa6Znh
         z2EaOxTXhHRJWw74+Y2GDLelylLXzQ4aV8m1UAiwMg55kmJWWVA0/LIlCuh5IlgtEJJR
         +DdsHSUMq7IWHGQMnKz1CuE4wR/zMyJuPkHtLd59qwt/ANkVLF3XYyz4x+pt3OnuwY8y
         HROdBToaH6y7y459VaBuusuqp4J6i6bvH0+XFbW2cA0HuS5cX0SeNosRUH6MBAVQZ6HL
         PSMU3OdnvVR2vJg4wC9uOI2qBN9WSO+rxpORmmwFWJNZRVfHr3wA6T/y3D5ninKaWReF
         4z8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uomQmJlWIjhkvxxLfQSyf1nH+prda88V/9IK/Q2lWjA=;
        b=jL3E8LF7ElEL+T0OIqL6XyTh2BRCSCBdPub9ClnZvV7NCY5vqIU8vClizZ9JOpFm/9
         x2atPizM7G+4Hzv+3evWWq8pdgYB5TCXbmpNfPNi3KvvnkfBicmYh7PDNE7ccg2fzJZi
         G2TM0nGDn9Pl+5ZE4vSC4MTpiDq6Mvq4NWlDfdMbq44D25t5Ivbungza+6YT5xlMEIC8
         TN+qW4CywvZSzuIcFgCLkS4l/Z4sHmBHrkNuIBCV368gWe/pO56xIvA0M9hcXtIloQJj
         qVxpm9FxzAAeeKffvT7nqIu8oDI74JZXsz1WBiv8KXDjClotA9GnfHxfH/M4qeXDTZDE
         2wVQ==
X-Gm-Message-State: AOAM5302uxf3Z3QPp7L9Kd7nmSrX3D+a1w7hl3jGdJ/XNUv+94CEEgFH
        v/viND5HGpwhpLRDCrarMuU=
X-Google-Smtp-Source: ABdhPJykm4YgWd/rhDqDF2Ed98NUBkQNZb1lyQEz5xlLAVPJsuK5akLSYw/a3TjF41bmlHVzvXkXmQ==
X-Received: by 2002:a17:902:6901:: with SMTP id j1mr6316230plk.203.1594967894876;
        Thu, 16 Jul 2020 23:38:14 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:38:14 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
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
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v1 11/15] scsi: hpsa: use generic power management
Date:   Fri, 17 Jul 2020 12:04:34 +0530
Message-Id: <20200717063438.175022-12-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers using legacy PM have to manage PCI states and device's PM states
themselves. They also need to take care of configuration registers.

With improved and powerful support of generic PM, PCI Core takes care of
above mentioned, device-independent, jobs.

Change function parameter in both .suspend() and .resume() to
"struct device*" type. The function body remains unchanged as it was empty.
Also, bind callbacks with "static const struct dev_pm_ops" variable.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/hpsa.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81d0414e2117..70bdd6fe91ee 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9070,25 +9070,27 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	hpda_free_ctlr_info(h);				/* init_one 1 */
 }
 
-static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
-	__attribute__((unused)) pm_message_t state)
+static int __maybe_unused hpsa_suspend(
+	__attribute__((unused)) struct device *dev)
 {
 	return -ENOSYS;
 }
 
-static int hpsa_resume(__attribute__((unused)) struct pci_dev *pdev)
+static int __maybe_unused hpsa_resume
+	(__attribute__((unused)) struct device *dev)
 {
 	return -ENOSYS;
 }
 
+static SIMPLE_DEV_PM_OPS(hpsa_pm_ops, hpsa_suspend, hpsa_resume);
+
 static struct pci_driver hpsa_pci_driver = {
 	.name = HPSA,
 	.probe = hpsa_init_one,
 	.remove = hpsa_remove_one,
 	.id_table = hpsa_pci_device_id,	/* id_table */
 	.shutdown = hpsa_shutdown,
-	.suspend = hpsa_suspend,
-	.resume = hpsa_resume,
+	.driver.pm = &hpsa_pm_ops,
 };
 
 /* Fill in bucket_map[], given nsgs (the max number of
-- 
2.27.0

