Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161DDC001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjGUQgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjGUQfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:35:47 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9B30D6;
        Fri, 21 Jul 2023 09:35:31 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b962535808so31522571fa.0;
        Fri, 21 Jul 2023 09:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957328; x=1690562128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dr70+Z75tYrGf88HlSjFcEUL6QTDE8kuKhOVcTcbLHI=;
        b=kyvYcuIIsMzVw+TaR7xFZHgmRvNz4OQ0fXWyFiGTNHiI2EadXL8Giy++tQkdP1G3j8
         H8ZCKJQroLpnvjf4zsmujv0gm98X4HZ0urAhihqo1FnSStYt6DH38COVS3Uc6YiJlhID
         2OT+btTwxOTzri89VFZrapX2aHy7feyRp2v+el/9tLG/8MNaqTUYJCZap0wK9SBzJ8vn
         D6sqpkg+jp/gzTj0WfXJUpZY9k5/m+TtLCqlJI1B8yO10K4g6M+WmVwVH32Pd7vESZZM
         QlqkR+B8m9y41Q3gfKtkRJpMZ9JC3PACb3i83ArmDrhjZRtkKsDD2Kb8+4/4J+9CaLE0
         7ZFg==
X-Gm-Message-State: ABy/qLbK7xf2I9J4s6kYoFd/39Ltg/OuFn9wIfycnhzuD1v2ZiwI6EJU
        U4AfIPdTbeYdMz2XE83LoVvFbDaz8eHPgg==
X-Google-Smtp-Source: APBJJlGa8SPLW6IGAcZQB47HBrpCFBmN3yknrGzA527IxXeV2aP3xfFcXUSWLOYOxqcPw5/h48kZcg==
X-Received: by 2002:a2e:874c:0:b0:2b6:d7a0:c27d with SMTP id q12-20020a2e874c000000b002b6d7a0c27dmr2184694ljj.37.1689957327693;
        Fri, 21 Jul 2023 09:35:27 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id n23-20020a2e9057000000b002b6dc99f858sm985646ljg.66.2023.07.21.09.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:35:27 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 10F933F16; Fri, 21 Jul 2023 18:35:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957326; bh=kwClP3Y5D25jBaL00RqAtMgYr0Ny8BMLvJQpPWYEnAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayFoYFneg7mhP+io7goUu5gIteWkoM6JqxURLAE8KqmAxEQrdFUrQ3IR0SmbGMhDE
         EkxzSrNhVtpQCUyZjcctisQxT2vbEH+O6D0/EUliwtPuwKUaVM2eerfNWAAn76u0UV
         MA5NBsDkZQegm5r9inks9Ew6SwgX1KrExrUXt2i4=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id CABDD3F3B;
        Fri, 21 Jul 2023 18:32:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957173; bh=kwClP3Y5D25jBaL00RqAtMgYr0Ny8BMLvJQpPWYEnAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eum67rs359CvstgO1AEG3T1RUSzjySx+/lH1xE3x4w0M28hlgVh1LN+J0XKXRsEGJ
         DehEot8d9rBkPK/PdMV+VkzSqQjfzdIxMsy5iXuzshNlwav6XndAiS9RSPZ++7feCx
         K2DAXLk8mkDivpiLKGVi5s3L0w4ySDMGu9aITJ8s=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 3/9] ata,scsi: remove ata_sas_port_destroy()
Date:   Fri, 21 Jul 2023 18:32:14 +0200
Message-ID: <20230721163229.399676-4-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Is now a wrapper around kfree(), so call it directly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-sata.c          | 14 --------------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 -
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index a8256cb08763..b5de0f40ea25 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1194,20 +1194,6 @@ void ata_sas_tport_delete(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
 
-/**
- *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_port_alloc
- *	@ap: SATA port to destroy
- *
- */
-
-void ata_sas_port_destroy(struct ata_port *ap)
-{
-	if (ap->ops->port_stop)
-		ap->ops->port_stop(ap);
-	kfree(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
-
 /**
  *	ata_sas_slave_configure - Default slave_config routine for libata devices
  *	@sdev: SCSI device to configure
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7ead1f1be97f..a2eb9a2191c0 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -619,7 +619,7 @@ int sas_ata_init(struct domain_device *found_dev)
 	return 0;
 
 destroy_port:
-	ata_sas_port_destroy(ap);
+	kfree(ap);
 free_host:
 	ata_host_put(ata_host);
 	return rc;
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 8c6afe724944..07e18cdb85c7 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
 
 	if (dev_is_sata(dev) && dev->sata_dev.ap) {
 		ata_sas_tport_delete(dev->sata_dev.ap);
-		ata_sas_port_destroy(dev->sata_dev.ap);
+		kfree(dev->sata_dev.ap);
 		ata_host_put(dev->sata_dev.ata_host);
 		dev->sata_dev.ata_host = NULL;
 		dev->sata_dev.ap = NULL;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5faf2d5d3da5..bc755a1864a0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1238,7 +1238,6 @@ extern int sata_link_debounce(struct ata_link *link,
 extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			     bool spm_wakeup);
 extern int ata_slave_link_init(struct ata_port *ap);
-extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_sas_async_probe(struct ata_port *ap);
-- 
2.41.0

