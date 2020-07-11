Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240F3C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 19:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E315520720
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 19:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jALCy0Kz";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HYQrtBeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgGKTZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 15:25:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41046 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728767AbgGKTZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Jul 2020 15:25:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 04ABC8EE0F5;
        Sat, 11 Jul 2020 12:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1594495525;
        bh=CwtrYu5TBeQCbhp8aSjj1KWRmXNT6xbBrxCmY0Y7L90=;
        h=Subject:From:To:Cc:Date:From;
        b=jALCy0KzJ7CHpLxRW3NrshcZ3CVIbQmfRkWwRCNJeDFMhzhP7py25vhWv0iddyV1y
         pkK/eUR+EvZzatwJtB2UexK76GVjDbVuXeNwGdRQ4svuMAUMn/HSHHs68HhTpmnLSo
         521qYTCVGPSHHmfha2TOw0KwwO552134xh2zobG0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M_zCCzL36q5Y; Sat, 11 Jul 2020 12:25:24 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8C06C8EE0ED;
        Sat, 11 Jul 2020 12:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1594495524;
        bh=CwtrYu5TBeQCbhp8aSjj1KWRmXNT6xbBrxCmY0Y7L90=;
        h=Subject:From:To:Cc:Date:From;
        b=HYQrtBeYSQB5kznCOtGq7jqZTI4waVFvFT7DvX1hFTVOriDUFRQ4zxU2V8n1dCBF6
         vE5STiGjlQyddBIKiokvo8CD6UGBqwxuOWYjsIeUuf3g7VFajA7JO4Bc4kit2I4vGy
         utL6M3K0aws5i85Mz46yGI5k4MfwFLRz+aqPv3Qg=
Message-ID: <1594495523.8494.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.8-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 11 Jul 2020 12:25:23 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five small fixes, four in driver and one in the SCSI Parallel
transport, which fixes an incredibly old bug so I suspect no-one has
actually used the functionality it fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bob Liu (1):
      scsi: iscsi: Change iSCSI workqueue max_active back to 1

Damien Le Moal (1):
      scsi: mpt3sas: Fix unlock imbalance

Johannes Thumshirn (1):
      scsi: mpt3sas: Fix error returns in BRM_status_show

Steve Schremmer (1):
      scsi: dh: Add Fujitsu device to devinfo and dh lists

Tom Rix (1):
      scsi: scsi_transport_spi: Fix function pointer check

And the diffstat:

 drivers/scsi/libiscsi.c             |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 12 +++++++-----
 drivers/scsi/scsi_devinfo.c         |  1 +
 drivers/scsi/scsi_dh.c              |  1 +
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 drivers/scsi/scsi_transport_spi.c   |  2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e5a64d4f255c..49c8a1818baf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2629,7 +2629,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 			"iscsi_q_%d", shost->host_no);
 		ihost->workq = alloc_workqueue("%s",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			2, ihost->workq_name);
+			1, ihost->workq_name);
 		if (!ihost->workq)
 			goto free_host;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e552838565..983e568ff231 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3145,19 +3145,18 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (!ioc->is_warpdrive) {
 		ioc_err(ioc, "%s: BRM attribute is only for warpdrive\n",
 			__func__);
-		goto out;
+		return 0;
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
 	mutex_lock(&ioc->pci_access_mutex);
-	if (ioc->pci_error_recovery || ioc->remove_host) {
-		mutex_unlock(&ioc->pci_access_mutex);
-		return 0;
-	}
+	if (ioc->pci_error_recovery || ioc->remove_host)
+		goto out;
 
 	/* allocate upto GPIOVal 36 entries */
 	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
 	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
 	if (!io_unit_pg3) {
+		rc = -ENOMEM;
 		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
 			__func__, sz);
 		goto out;
@@ -3167,6 +3166,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
 			__func__);
+		rc = -EINVAL;
 		goto out;
 	}
 
@@ -3174,12 +3174,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 		ioc_err(ioc, "%s: iounit_pg3 failed with ioc_status(0x%04x)\n",
 			__func__, ioc_status);
+		rc = -EINVAL;
 		goto out;
 	}
 
 	if (io_unit_pg3->GPIOCount < 25) {
 		ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
 			__func__, io_unit_pg3->GPIOCount);
+		rc = -EINVAL;
 		goto out;
 	}
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index eed31021e788..ba84244c1b4f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -239,6 +239,7 @@ static struct {
 	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"FUJITSU", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SanDisk", "Cruzer Blade", NULL, BLIST_TRY_VPD_PAGES |
 		BLIST_INQUIRY_36},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 42f0550d6b11..6f41e4b5a2b8 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -63,6 +63,7 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"LSI", "INF-01-00",		"rdac", },
 	{"ENGENIO", "INF-01-00",	"rdac", },
 	{"LENOVO", "DE_Series",		"rdac", },
+	{"FUJITSU", "ETERNUS_AHB",	"rdac", },
 	{NULL, NULL,			NULL },
 };
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4cc08eb47ba..7ae5024e7824 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4760,7 +4760,7 @@ static __init int iscsi_transport_init(void)
 
 	iscsi_eh_timer_workq = alloc_workqueue("%s",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			2, "iscsi_eh");
+			1, "iscsi_eh");
 	if (!iscsi_eh_timer_workq) {
 		err = -ENOMEM;
 		goto release_nls;
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f8661062ef95..f3d5b1bbd5aa 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -339,7 +339,7 @@ store_spi_transport_##field(struct device *dev, 			\
 	struct spi_transport_attrs *tp					\
 		= (struct spi_transport_attrs *)&starget->starget_data;	\
 									\
-	if (i->f->set_##field)						\
+	if (!i->f->set_##field)						\
 		return -EINVAL;						\
 	val = simple_strtoul(buf, NULL, 0);				\
 	if (val > tp->max_##field)					\
