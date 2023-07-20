Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36D5C001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjGTArg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjGTArf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:47:35 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA901BF7;
        Wed, 19 Jul 2023 17:47:34 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2b9338e4695so2850841fa.2;
        Wed, 19 Jul 2023 17:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689814052; x=1690418852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uou6LBIfWMhwfme+l6VMfuCiY35xYiDS51Hd2okOGpY=;
        b=gbnSxRewkNmQEGEV3ieodwFcbIF88kcFsT1Od9yruFyfnSHPcBwfIduilP6mGLrYxp
         ImWy0ixuFo2fgDCiIz+n1YqTRHGvq5v1VcGUNXBnEnnfIhemh08ww+UVhs50b6sSFzd1
         /5f2OzF6LJ1VK5H+B/2Rahch/rG9Nd54uFVKRyjJWVcJZLZqzPwiqDrsVU+bcNBzKzVQ
         MqXBBWaX1Uo23WYWbKFgErzlWEYMCHwV4a8cBJHzxbjRlCJ9v0ddS/7chcvNJpn9zzKx
         jVEMULhNhviU+Cm6hDAI3yjWSwrqXSQFgdp1JGgkjqBGefcRmOYkbImeb/IFy9PQmJCe
         r0Pg==
X-Gm-Message-State: ABy/qLYItz6OBRKmBTPo6KpctJvVan3TgtpJjEg4v3Gy3pyNHr3kZ7c4
        cm2vmfvhEqnveTABMJwu5fvoW8NNcDEIdlX3
X-Google-Smtp-Source: APBJJlEYq6pFdNJXkNbjqfls2hGfDkq/jp1yjJ+UT0Fw5loMnFLs/1mdtLhohp6d+XuhC6as1DUzrw==
X-Received: by 2002:a2e:6e13:0:b0:2b6:e2c1:6cda with SMTP id j19-20020a2e6e13000000b002b6e2c16cdamr610736ljc.46.1689814052500;
        Wed, 19 Jul 2023 17:47:32 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id e15-20020a2e930f000000b002b6e3337fd5sm1285700ljh.7.2023.07.19.17.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:47:32 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 4B8F53EF1; Thu, 20 Jul 2023 02:47:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689814051; bh=GTatBvSlriM55n+5U4VYVyvnjmt3esNwCHNn3DmLhPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/joq1c1Ahjewz6Rpx5MUfBb8PZvjImam80ZKnmVtuStnpm4inqgdJgmPy1XIs1Ai
         8mZ/l13z2o8dZGLzA+cKyQtmcDlGS/OLbG/ZpYgUfXWUX67d0Ex/+PAM4ur4kVsuhv
         VMtw/6sv7CnAjsOUX69WO+s0lZuk2VNxngluCY3U=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 17FF63F0E;
        Thu, 20 Jul 2023 02:44:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813856; bh=GTatBvSlriM55n+5U4VYVyvnjmt3esNwCHNn3DmLhPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfQtURXNr7L/MqFCUFi3oY/Xc1pofVTaAiD2sgskAV+yi+twAQ6yMsu6hUyk4SkXp
         GEhoqbX5UyFLxq40f9sU4aiA4GT4LbGUQbI/F4QThzg5VqlfhM0B5jOBaaoeRVBxQY
         FWohFTL5UM0LJUru/eJX23Z2JV8vwsIej233kKDM=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 7/8] ata: sata_sx4: drop already completed TODO
Date:   Thu, 20 Jul 2023 02:42:48 +0200
Message-ID: <20230720004257.307031-8-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720004257.307031-1-nks@flawful.org>
References: <20230720004257.307031-1-nks@flawful.org>
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

