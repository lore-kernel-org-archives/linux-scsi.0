Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55CBC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 02:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiFICZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiFICZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 22:25:02 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2687AB0E2
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654741500; x=1686277500;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TvzOj06tuiYVfoqEQpeq3IrLpPXX6Dk4j2ULOL54YmQ=;
  b=EtJ8wSXY3um+swxDSSUlXOLtUK4wOVa9HJUg1LhN/P3FFuJqkhwjFart
   +Tfi6UBpdjDKBhb50WsxtAZNbaNPAyz/Md059E6YgoigotrOlYFikL5ZL
   6tdc/0PeBKsUnBLmMvdM4WoPGWic/sVIxJH5/oekP+Yq80jk0UhYti6nk
   eggk7gUzMK+iJiHWpvOSaetbDOpP45uaHI5vePMwlEN5olkjZEY5/qpua
   byTigl3D9h+5Cxh2syt8Zfmkl1k+n2qBYIHX3SJzajXYjZtcawZLlqzl7
   x0YkM6v6GZbsqmtoXEncRynR2nalXsikuH8XGAnjJNCH4jKPgmzP7llYC
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="314703265"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 10:25:00 +0800
IronPort-SDR: TWwLtD2rY7OSKiy7Pc8NQ8JexhfMqpymHzFgHBeulXGYyR2BqCy+jQn9cqvvuUxd4+y/bRzCkD
 DoKJ5efKRjZiUYmN8tdN6C9oWlcohu/7jMtzQtO8T1i87Bn9qe5590g8fmzq7gmjTa1nPLranO
 gjgfLitAM6G3t4IfW6KOYrDCy0CYb2722aq+oyKjXQy0a70IhNVdhQ10yQx0/XJuILhT+K9wu2
 nggacEGU/jG1JibaPoyo09enSQfDquF/sI2jOx9HO7yZbHD3ZInHd4Pyq3L73debRPnnMmlglc
 ba/6k/veK//DYmT1Q2cCqxwr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 18:43:48 -0700
IronPort-SDR: KWZz4MX8dUSnhscylgg6If4fi5sUuHD8Xpg2GcEaGtu8JJjDJ6yimD2qnIkWQGvPbSv+UhcR6A
 Sufxu7ko5MxcUw1dcm0qg6Nc+1IYx3J0thxSY3a3nM79D1TbXKRfAmSEJagM3+mKPgsA179mGd
 BQRhRTjPUjMF3872NF+F7FELCPftbOFr3VaEWAkE8dZk9a0/EVtKYPUYtCBrnXDK+b7iX25Iv5
 HIqAcuaIkUUUGGQByvx0ZxaS3DL65Y7zkL1/u29AVDcdz4R5Lfgw0+U/bZP/40C0n1P1P/T9PB
 VPQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 19:25:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJSbv4Wymz1SVnx
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:24:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:x-mailer:message-id:date:subject:to:from; s=dkim;
         t=1654741498; x=1657333499; bh=TvzOj06tuiYVfoqEQpeq3IrLpPXX6Dk4
        j2ULOL54YmQ=; b=EwyYTe4dlkAzSqi8fjf+19S9d72iG+WPB/fE1S4ZWhVYa2mc
        i2J07g8iKfEP0LuhHBUDzPoXOywPEGvU1eik7Bg429vBemuhnI4I/pJ2Iuzn6m62
        MUTxZC/+Y1ZKICMbrSxuDgiybZqo9dSeE1bcJju7rrhzwzoCNHb+/z2x/F/9ZK8G
        X5JY34mdJ4mqxJ6bNXdXwlbYbsKMG5G36jd5C6/U712bxqT+CQSf3B9mmdS2y2Q8
        OJmIJEIR43TJJounVDnM6kQwvJP3UeHl2boW2omvzlgIh7qzETFrfBz66MjnUbVn
        JZxlrUs73wJzDzdPZ4BHQiYkbd+SdbwKIlrHGA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yWhaEWwr3-Ur for <linux-scsi@vger.kernel.org>;
        Wed,  8 Jun 2022 19:24:58 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJSbt1Pr8z1Rvlc;
        Wed,  8 Jun 2022 19:24:57 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] Fix compilation warnings with gcc12
Date:   Thu,  9 Jun 2022 11:24:53 +0900
Message-Id: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patch 1 and 2 fix compilation warnings with gcc 12, leading to kernel
compilation failures if CONFIG_WERROR is enabled. Patch 3 complement
these fixes to have a consistent code with regard to sas responses.

Damien Le Moal (3):
  scsi: libsas: introduce struct smp_disc_resp
  scsi: libsas: introduce struct smp_rg_resp
  scsi: libsas: introduce struct smp_rps_resp

 drivers/scsi/aic94xx/aic94xx_dev.c |  2 +-
 drivers/scsi/libsas/sas_expander.c | 67 +++++++++++++-----------------
 drivers/scsi/libsas/sas_internal.h |  2 +-
 include/scsi/libsas.h              |  2 +-
 include/scsi/sas.h                 | 42 +++++++++----------
 5 files changed, 53 insertions(+), 62 deletions(-)

--=20
2.36.1

