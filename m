Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8E5C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4830722B4D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oDMqReuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgGTNiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgGTNiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:38:25 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1602AC061794;
        Mon, 20 Jul 2020 06:38:25 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so8697082pls.5;
        Mon, 20 Jul 2020 06:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uomQmJlWIjhkvxxLfQSyf1nH+prda88V/9IK/Q2lWjA=;
        b=oDMqReuO6Jhic+XYaL95OsSZOx2EFUg2Yf3XDHPc0PvD+RcT1g8EtT3CMrG41D2ZiI
         Ga3VZsqM/NHDk1FgyIgwyq0ma2vRuUA6IqAjpvl/fTgtPY2DhaNOZjXKRUNUAWyd1fQk
         /fvqEKSePC7GcXz9CVZzL/SK8fMFKuojHydPsWB24d516D3ofSwwLHjcYZL5DXxJ6Y7f
         1EJXkaSyff50tb47qyo2iw6Th0D/dng4oEyqX2h3GHxBFtyrWz6Uuf6G2DN61RzBjZIj
         Qzbo6VtnMxea+3kMREDRAD6jbqwTIB+hny8MXD2m5D1LxYonLt6Y+j6cIx26cY6CBVVN
         4RfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uomQmJlWIjhkvxxLfQSyf1nH+prda88V/9IK/Q2lWjA=;
        b=snk1mUyQrtZ2bXUn9Jo+zgME+ZkvgNH4/WdVQdk9/aa3l4W/uTwuH3mnUHuC8HXpQC
         HdVYBP4+ysoWWhofWzBtf9uwdCuBhEriznWKr9a0NVo9f7W/2ujDpu2Hb5pjUNANqX9Y
         c4YbvrVqyImqsXPhHtm/NfG1Xu6Tfye+eKDSwK9FKD72JOu2aChnOFnY0gC015YIMTKq
         YxhHtWQ0CsMJwXj2MtoOS+FlBJuWYRlwxJic0ekbdFYBgFbUMQc7XkCsU+AURiQkN8T6
         rLqs5dv2xmpIdnewFycaPnHZx0x8qd3Khw3ytDZqRzBBODxlAAVxsv+rR9a7QfGrrF6O
         iA+A==
X-Gm-Message-State: AOAM5307Ek4iIlAtpL88bCZ5GxiKadZhJPHMTgcSRvd4XITcK86xiNZD
        cgWs649e4JFzTHnEKQ5Bz/Q=
X-Google-Smtp-Source: ABdhPJy07IxvZsf+X0sxpkIKdzybCMuvJg6FciCqDb2umwS6WuPUKGqh7ccqB3LUe9m5IFpGMrv78A==
X-Received: by 2002:a17:902:c181:: with SMTP id d1mr17792705pld.176.1595252304597;
        Mon, 20 Jul 2020 06:38:24 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:38:24 -0700 (PDT)
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
Subject: [PATCH v2 11/15] scsi: hpsa: use generic power management
Date:   Mon, 20 Jul 2020 19:04:24 +0530
Message-Id: <20200720133427.454400-12-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
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

