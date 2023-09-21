Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02550E7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 18:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjIUSgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjIUSff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 14:35:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D3EB05A1;
        Thu, 21 Sep 2023 11:08:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDA5C433C9;
        Thu, 21 Sep 2023 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319714;
        bh=GTW29Tbo2vbr6MXSdFJhe+fVerKvAHx6guP8pG4B20I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9xjB7o0jOzbqwk57rIT09TZjHTN0XwA14WHPRqogmqjSJx1ryhH/nUfREujR73nn
         4BDgQ/JoishRJX81XlLCgiSKL5TG9SIOb6mI5JpLE3wc9fmXvBqUr9mQPaEFCiG6fu
         9AFsucINDFc5GfGYAPKpAZvExCflsmHEmBi1jhaF6z7cen8ThNzMVhNJSAJjhRsplr
         x7FfG9308wNXqawp5iQ/6Bgg0sbZCZrVlfWEbYEdyxA2jt8F9XPIV5YPow49COiUZ9
         95qeZXvprI5kzIQjpp8JPjMu7eXLfrUhnW43EK75I9DYanV3MF0RkDVsVVnRNoMd9F
         6zomXlZ6Xbrew==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v5 18/23] ata: libata-core: Do not poweroff runtime suspended ports
Date:   Fri, 22 Sep 2023 03:07:53 +0900
Message-ID: <20230921180758.955317-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When powering off, there is no need to suspend a port that has already
been runtime suspended. Skip the EH PM request in ata_port_pm_poweroff()
in this case.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/ata/libata-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b46980fe69b4..35112f9e482d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5215,7 +5215,8 @@ static int ata_port_pm_freeze(struct device *dev)
 
 static int ata_port_pm_poweroff(struct device *dev)
 {
-	ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
+	if (!pm_runtime_suspended(dev))
+		ata_port_suspend(to_ata_port(dev), PMSG_HIBERNATE, false);
 	return 0;
 }
 
-- 
2.41.0

