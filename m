Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C602EC001DF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjGaOj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjGaOj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:39:58 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD5898;
        Mon, 31 Jul 2023 07:39:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4fe2de785e7so2516667e87.1;
        Mon, 31 Jul 2023 07:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690814395; x=1691419195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xS4BSNtCM8QPszrM2uOPIUUqPohq4b5SBY4337MvfXc=;
        b=Lm3rebF6m06lA5OMuOPmG4rYIdZKxwdMlMho9SUKL0Cr270Dj5lPJLrFAjDbYnpI6s
         zW1Ol19Tv/rheBQbJ2t/RR9BIHsGQ/XC+wN2i5+dnIRawmVqVWjmB86EGh3ZYz4kkcFM
         d3IKBTrFE2fS1kApSjRhoYdm6I8/kLOvvpsy4Xz1d6GpCWYp+/F3av/K3V/YmIg8gH4u
         PA/QJ0wi+txhHyf5/vRhlo39aq/8YHgUvQcY8xap7ZyVI54AX4zzL6TOgbbRjJeuSjeA
         UPbigOieTECXg4IKM1eFQsnOpO3fZQo9qfzdRKDTbZ/dF0VeSO4uVz3huT7gv/MkafcX
         s59A==
X-Gm-Message-State: ABy/qLYw/n8ocBFKvvLZwr0SwCT9t3P8aRIMMejTJEGznKCtHfrud6Hd
        P9HfX8jRcLelKkiAsHk3Ll0QkG685rp35A==
X-Google-Smtp-Source: APBJJlE4d2f7BW/V6oWUrg+kS4SGY5P3tmuh2R7HQ6ZgB0qaAbM+DoIuyARLqHVestBalcOFqWyDeQ==
X-Received: by 2002:a05:6512:3ae:b0:4f8:4177:e087 with SMTP id v14-20020a05651203ae00b004f84177e087mr2501lfp.47.1690814395465;
        Mon, 31 Jul 2023 07:39:55 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id h24-20020a197018000000b004fe36bae2d6sm520530lfc.81.2023.07.31.07.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:39:55 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 4BDBC3F16; Mon, 31 Jul 2023 16:39:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814394; bh=ELnVuTXctBQjkuk5W9EeF+K2wH7nuVg+vU9Nx/2DtQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMWV81B3g0SCjfmW66t9LQ8TFlOrSqXCC6AssfRRHxfeL2fo4jYbh1Sz/Qbv2AMbU
         mOWFyiIyoXA8HdVoYfLD5nV/dvIMhDWW7fVQveodv2aXXqW0TDxtrmMiYjAROcxzlj
         uIL7s+ReteeqFeHLPyK2H/UsasbWmoSSbWlYv1+k=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id B5EAF41C8;
        Mon, 31 Jul 2023 16:35:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1690814101; bh=ELnVuTXctBQjkuk5W9EeF+K2wH7nuVg+vU9Nx/2DtQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9LWOtgPn6YUQWhM3YbqE4lUvZAw4JU4QSEtjZ/8a56/ESntc2Sq4beUwhggdWar4
         0G/nwMWVYNavCYrrOwmpnuuW/M57M01IsYYifSopZMIr1OU/J4IiCNixclzwqw82Pm
         s+lRciuO6bXirjJQyf3Q6zvuif5z+/FVJcyYIi6M=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 08/10] ata: sata_sx4: drop already completed TODO
Date:   Mon, 31 Jul 2023 16:34:19 +0200
Message-ID: <20230731143432.58886-9-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230731143432.58886-1-nks@flawful.org>
References: <20230731143432.58886-1-nks@flawful.org>
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
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

