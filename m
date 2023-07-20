Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E9BC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjGTAqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjGTAqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:46:30 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D0B1BF7;
        Wed, 19 Jul 2023 17:46:28 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4fb41682472so333606e87.2;
        Wed, 19 Jul 2023 17:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689813987; x=1690418787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMxYZCpwMe5CgoARsL0Kt6uVRuwHpeG70NtCytqu8xk=;
        b=CSMJmDGn4jO3BG9Y4Ls7uOAjR9JZs6KehYykJ7tfazeVmPFhIT60YHoiO6Cu7GCUlW
         3qTiaBSkgoW8Kz5HqOOT44KQZvCOET38NOfE5okRzD+PMkpaHfZbny+SL9xK8V3h6FBG
         EyblEsa7W4Aop9KLc6Ryp/VbzQiOC9+om0Q0MjfJRFN6qI4npk8l/SGiGpAe/mPv98UY
         Uvhog7a1ArkHvwLvShLM/1I2gj2BDxs1c9SU8KpFcTqFYeU1DaWAz1bx/ac+MlMQmYGf
         pNqEQfZ1PqIL9U9qNHwza/ZZoZZgUs/S97jCwlKg1c8UT93D+LtTsgkurjPhuI/ro+uV
         KsPg==
X-Gm-Message-State: ABy/qLY6vF75z2OmgFc8XmWk0u+Wys1H6MXBrpbqts8SpSAfp52pmcSV
        3T9uT5waJ2NsWwGa6IPlUBDXKlLnSa5UIBM5
X-Google-Smtp-Source: APBJJlHFH5ah4uTr811vcXFvIy4DUOZFesJXYz9h8CeD5Jnh1wfetDfMRxYBfkhG4ALswSc5AWZ/Xw==
X-Received: by 2002:a05:6512:5c2:b0:4f8:651f:9bbe with SMTP id o2-20020a05651205c200b004f8651f9bbemr883742lfo.54.1689813987212;
        Wed, 19 Jul 2023 17:46:27 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id t4-20020ac25484000000b004fba759bf3asm1183643lfk.281.2023.07.19.17.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:46:27 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 95F303EF2; Thu, 20 Jul 2023 02:46:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813985; bh=xLsXb8Nm1LY+FElXFXs5W95JlfbHUBK2k8B15OjU8cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAgfST4wBKH/NQwIGe661hQ8TkoB9hWHwoocle50aDo32JfSS/bBaTHLiUSTl80fe
         vrzbywEPHz7vXkD93qRvF+hM2A6avkYPqHrnHkLXBmhKlD3ysegF+z839ivP349yTV
         jJ1bXnhAulgWbBJNZEud0XSas+gOg6O1FDKM+0oc=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DB18B3EF8;
        Thu, 20 Jul 2023 02:44:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813852; bh=xLsXb8Nm1LY+FElXFXs5W95JlfbHUBK2k8B15OjU8cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps7DlJae6uvy1WGeyTUh00LrvDq2HIjfmWifx7uJoSVLsxP95wGxjKCXKedlDw6FS
         RsR0vPTjERZntFEtW53OohF/F5b2pEtT7+aYKP6NK5FOwLN0YReL/XQw/p/TWvoov0
         br5tcGW015v1nBzSLm+NeuYcLXqMe5lGfGto7gDI=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 3/8] ata,scsi: remove ata_sas_port_destroy()
Date:   Thu, 20 Jul 2023 02:42:44 +0200
Message-ID: <20230720004257.307031-4-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
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
 drivers/ata/libata-sata.c          | 18 ------------------
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             |  1 -
 4 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index d3b595294eee..b5de0f40ea25 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1177,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
 
 int ata_sas_port_init(struct ata_port *ap)
 {
-	int rc = ap->ops->port_start(ap);
-
-	if (rc)
-		return rc;
 	ap->print_id = atomic_inc_return(&ata_print_id);
 	return 0;
 }
@@ -1198,20 +1194,6 @@ void ata_sas_tport_delete(struct ata_port *ap)
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
index 9424c490ef0b..53cfb1a4b97a 100644
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

