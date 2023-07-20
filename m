Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E3EC001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjGTAql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjGTAqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:46:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C951FFD;
        Wed, 19 Jul 2023 17:46:39 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4fbaef9871cso362537e87.0;
        Wed, 19 Jul 2023 17:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689813998; x=1690418798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFKqSI1dZOSejkI+CPMvjJBhoTp4XhKtY/ICFtgTOto=;
        b=U0R5QE6TrnaLXa6cAGAm5qWlSKE09Su5CzIZ20UnapyRzFrZ8UhiRFzjSUe+CddEtZ
         thvUZ9Mu+ztmITUqMxA92Lr4dduKCE8vIxJPAEoWyKtMSBGVjEa/eZ+iaeAFI/9p4BZg
         FfeRTre5UzVkXXs/r7SBlJTY0OIV0g+K8GRLALkj9tmPMK9dy17ZxAkoKgaFR5FObxzY
         rbkD3TvbTGZthhbpapkRFB6wLy9td0K+sByztuzjlQk8UgcxwJq0AXWgfcsED06hsTDS
         aq6o3sCRZ3Trfsr6i6dywkgqRg0iisG8UDGhqh+wJNXJWBSmvPS0+hcP3IPXhvW1pxZj
         /xYg==
X-Gm-Message-State: ABy/qLY11h2xQ1IOzCKau2ZN4TZm2JZj1GSxtrsDzzVlH5IgOIWdoaYB
        PHDYuVAARNBmSGk8YzwuMrpug8a9OqxUX2mI
X-Google-Smtp-Source: APBJJlGiRuOJ76WcFcb9IUftpexyWWRLSob980cB6GbrWIdPqjhSQJ171qR/VSAx8MgIZ09GMcC0aA==
X-Received: by 2002:a05:6512:398d:b0:4f8:75bb:3301 with SMTP id j13-20020a056512398d00b004f875bb3301mr1316952lfu.20.1689813997584;
        Wed, 19 Jul 2023 17:46:37 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id t25-20020ac25499000000b004fbae25fcc4sm1197318lfk.61.2023.07.19.17.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:46:37 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 823773EF1; Thu, 20 Jul 2023 02:46:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813996; bh=rTVNoZ+0a+YA6IWcZMJinz17z2JRqQnxx1lIYO/NmU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OttbO2osSZz0xBSRsGp89n2hkKTL+JCm7JaMPbf0JMwmUUrWn6rveXuuGBTp8uui4
         nmX9BKfojV66UGr8wuyAkqYgQ54IPJ1xw9y+uIBfprpaMFDCkJ9yim+6Zu96sEmwH0
         Sz6p7EpLu4h3rZOadawDEVfek8exUqmkzQAPLBWM=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 37B6B3EF3;
        Thu, 20 Jul 2023 02:44:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813853; bh=rTVNoZ+0a+YA6IWcZMJinz17z2JRqQnxx1lIYO/NmU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxMuCpvQOiaoz4qD7RXSmilcZQXREZ/ACm87Hp5STYvLRwclnTAaKN62zH12338T7
         Z7axUrQiEcauXsEE/4pypRJDtTU0eRXIbFzeJOerCrR+8meQ2tREqhyRjn9T3jx09E
         4tWiNLFQMdKR7IaWrD4LIevnnzdepfQR6FqB9Tcc=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 4/8] ata: remove ata_sas_sync_probe()
Date:   Thu, 20 Jul 2023 02:42:45 +0200
Message-ID: <20230720004257.307031-5-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-sata.c | 7 -------
 include/linux/libata.h    | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b5de0f40ea25..23252ebe312d 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1157,13 +1157,6 @@ void ata_sas_async_probe(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_async_probe);
 
-int ata_sas_sync_probe(struct ata_port *ap)
-{
-	return ata_port_probe(ap);
-}
-EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
-
-
 /**
  *	ata_sas_port_init - Initialize a SATA device
  *	@ap: SATA port to initialize
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 53cfb1a4b97a..86490718cd0d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1241,7 +1241,6 @@ extern int ata_slave_link_init(struct ata_port *ap);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_sas_async_probe(struct ata_port *ap);
-extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_sas_tport_delete(struct ata_port *ap);
-- 
2.41.0

