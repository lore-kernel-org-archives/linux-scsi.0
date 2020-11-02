Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AF9C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D0822268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGndiWGb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgKBQyO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbgKBQyN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:54:13 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB36C0617A6;
        Mon,  2 Nov 2020 08:54:13 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id x13so11275252pgp.7;
        Mon, 02 Nov 2020 08:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y9mWg+/4v2UCFJAlCKvgYuV+7m/IMMSCBwMkcMZiS84=;
        b=CGndiWGbeSa0mZUzNP66q0m9jiwhXlWICOiDvD/aXAaAJaV11Abd15VLtUvUSiB8Oj
         7HbbO6v9eHhFuHCvGlbf7bKUBw8vMz1pct/80te2IDeQGdEEsZQKEdjRiCPqGa3A/jhb
         kxZStACpdV/f42s2hwn5yaSZ+B5YqtZQvCHktHJOzl5DI/8opJgVkeGZWlpXVBQmjuCj
         HwP1zLtTDbxrTyxo40PGgdgjtU0mylXAqS9dDbhPmynAscuBSdw4yZynqaoLNJEVH72m
         I6zx+2RpSG9MuYE1HAWlMp6lGsKIzWx4MkEriuyMomTbCi61P6XXeZdoyUZjoZ8KpxOr
         sWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y9mWg+/4v2UCFJAlCKvgYuV+7m/IMMSCBwMkcMZiS84=;
        b=LM/9AY5CWfS5iCxVRFc2rK65O/xtU+BDyTsJK8Kg8NtwIy2ZF6zcFNOw/kYQA+HrbS
         vGbpYQlMxu1QXIh0NZeAIo+yGu/2+IUAHsyslA90RgC5P72J4qK4HD7G7450Yn4HCnLd
         nsUcKSz/yRIcgZGq6XqTnT+m0zJhfHg1hYOAJj6yavQ3chrleXpUfClhmAGZBYg5M/vP
         co7qLfelNaEFlWY9GlWSJ9qdi0naXh2/2/ZMb3QeaCtPIh6njpxg1VLRT02KXWky6Ala
         wtOfh/+pPt8gH6d6sywI+BaDqFIPmPsS/jJ0tIVQSfHTRyH+7TO9Op4Sjo4O2Lfz6h8R
         gDKA==
X-Gm-Message-State: AOAM531royx4XnsWRY51q9Mdu9s6vlBoYkbDj/xV1fqOnork4vbovvDP
        RuqgNXWjJ/aioVFqWumXhv8=
X-Google-Smtp-Source: ABdhPJzpwB1ncwX9rI1DG4O7sobiR6+6b36+pLha0Afpn+jdJ0C7J2kMqfr4zgoRAaArG6s8YBucwQ==
X-Received: by 2002:a17:90b:994:: with SMTP id bl20mr18624263pjb.34.1604336053051;
        Mon, 02 Nov 2020 08:54:13 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:54:12 -0800 (PST)
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
        Xiang Chen <chenxiang66@hisilicon.com>,
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
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 20/29] scsi: hpsa: use generic power management
Date:   Mon,  2 Nov 2020 22:17:21 +0530
Message-Id: <20201102164730.324035-21-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers should do only device-specific jobs. But in general, drivers using
legacy PCI PM framework for .suspend()/.resume() have to manage many PCI
PM-related tasks themselves which can be done by PCI Core itself. This
brings extra load on the driver and it directly calls PCI helper functions
to handle them.

Switch to the new generic framework by updating function signatures and
define a "struct dev_pm_ops" variable to bind PM callbacks. Also, remove
unnecessary calls to the PCI Helper functions along with the legacy
.suspend & .resume bindings.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/hpsa.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 83ce4f11a589..e53364141fa3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9090,25 +9090,27 @@ static void hpsa_remove_one(struct pci_dev *pdev)
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
2.28.0

