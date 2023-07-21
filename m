Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD53EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjGUQil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjGUQiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:38:15 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265DA469B;
        Fri, 21 Jul 2023 09:36:48 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b6f97c7115so31472401fa.2;
        Fri, 21 Jul 2023 09:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957405; x=1690562205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOxjOshFmd1CcswWqoqJvOQo7VAV/UnrIh8+gydP2tA=;
        b=jnGESW7nJ1XLMlHYpp/BpOJMmxniwVXsgStZyclQblw770J0KATXgE7yL29H0CBmMN
         YHMOi5724s0V/wqBjDFOtVdMKEcJD3dL4mv/kyGLYvSunq7xWeaCt7C76x6xGX6m4Y4m
         cw+R8JD4zih2VxEP6z2wljMa2iNK4Aafr67/yUalvzf3Kr3qHsjxZPOyph14Y0BpBCfe
         MJEV0TKG9UZXUSouezec1twcVf/E76h8JjXkjoAtxM5STFn9cywZM0SHt+gK7IaDTiRD
         bkHM59iRtmLjU4MdpGjNq268nPn9NyU014EbgOgw4MftdfsqvOlWX6jEkq6MQypkyRLO
         FqyQ==
X-Gm-Message-State: ABy/qLZZXWqoxe+QYbewOVqvZKMf2Lh4BIKMPZPZpqEXqUdqhSwu/UcC
        vqDHBAuCDKKZ0AWAo4PT3hxvtXbe8P1dZw==
X-Google-Smtp-Source: APBJJlHAMvvSBNw6cCY9Gmz930Rs8MPBTrbNLfqeyKjJOw4US7bAO84SgKXEQvr/t+7M7KCJrGyhCA==
X-Received: by 2002:a2e:b055:0:b0:2b6:d495:9467 with SMTP id d21-20020a2eb055000000b002b6d4959467mr1942365ljl.6.1689957404876;
        Fri, 21 Jul 2023 09:36:44 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id 5-20020a05651c008500b00295a96a0f6csm987245ljq.102.2023.07.21.09.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:36:44 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 66EFB3F2A; Fri, 21 Jul 2023 18:36:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957399; bh=YaMG3zq3zKC6vUFirZw5i02bAQ3zsu3y676GpUXUaMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xs8w97xmkymKOTm1+CrZ7vai6PvkrQ2GVaHG3yCnbZES/ncqzAyCmIuSilYqnUZ6r
         Joh4A+04f5GLqebc+ni4cib1M1TQfW2Hpb3NVeKvYxDuHq20d7EqEDsaRTXqrzYW2e
         yeJhqdRpgv/ltLGWPbbh6jaeV+AWY80P/N1vyV1I=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DDA873F51;
        Fri, 21 Jul 2023 18:32:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957176; bh=YaMG3zq3zKC6vUFirZw5i02bAQ3zsu3y676GpUXUaMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5Z7ViWajM9MpmNcg5YGcDMjpqc4Ly9iSkhY5ErYWr7XhN1nHZWFPNV8Q9VDEEN6+
         bDY+Gb9Yb6vFcC/s56LfOoEuF6Y432EiCbjzCPKkgYbdpvJLeYwkjnbr8Umj1GRfDv
         Msde35SAA5g0oWzAH7K3F5R2NtEn1REeWHnsH0b8=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 7/9] ata: sata_sx4: drop already completed TODO
Date:   Fri, 21 Jul 2023 18:32:18 +0200
Message-ID: <20230721163229.399676-8-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721163229.399676-1-nks@flawful.org>
References: <20230721163229.399676-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The TODO claims that the pdc_20621_ops should set the .inherits
function pointer to &ata_base_port_ops after it has been converted
to use the new EH.

However, the driver was converted to use the new EH a long time ago,
in commit 67651ee5710c ("[libata] sata_sx4: convert to new exception
handling methods"), which also did set .inherits function pointer to
&ata_sff_port_ops (and ata_sff_port_ops itself has .inherits set to
&ata_base_port_ops).

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/ata/sata_sx4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index ccc016072637..b51d7a9d0d90 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -232,7 +232,6 @@ static const struct scsi_host_template pdc_sata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 };
 
-/* TODO: inherit from base port_ops after converting to new EH */
 static struct ata_port_operations pdc_20621_ops = {
 	.inherits		= &ata_sff_port_ops,
 
-- 
2.41.0

