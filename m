Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E2AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 01:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiE3Bnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 21:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiE3Bnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 21:43:47 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DBEDEB4
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653875026; x=1685411026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ATYhnDpKjGF86MZs0pzDwMcHyXcGd6DSmhzlnusnbQ=;
  b=dihODXRCIi0V6I/FVYxnp+dtGd7xLtG5cvoOQVQC1EQcHy50lq4zdA6X
   92icJUdPLSUhC9zuR1L/t8cu0T/OV63utvpUXzJGGKnK5Af5U+XmC8sGv
   GLQX5P8Ba9Vs9OVY8NOGSSjTz1BBlKYiP/VjoXrp/uxhVFZK+3jXEmvO7
   jJqq/WVNa+nOgzShoswcnBJFUBdqF0AvUFwzzbW4afl0fEW1ZYc+HG1Fu
   tRkrNUAJ509V454Ra/NrFRkaXK14Gf4VBKoPY2mOyEFVoYOZLOgP+M6wz
   70jTR1luQtD1Og9Qv03aLkKAR1ecus/9wdjrrQ2ud2bxmuZvdEjUDiCDt
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,261,1647273600"; 
   d="scan'208";a="313773997"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 09:43:45 +0800
IronPort-SDR: IAfL1XAX5sDxRwYf522cRThFEEAkGYzvBAXjTbuWAY24PiUizVg+KAySsRotalYiYxNeH31T6G
 uAaYXfZRJ+/+GNEEjZ+Mh61d4flJaJ/OORsCJx6WrpSwI8kV/zpq17M8dtfrHpgKYYy9P+0Skk
 4vSjiqGKr/xX/mVZZNW1a5bSrlcCNR2OcoDxyHvYMVruqCWRHmcvrKo0TSFgbF3nM4zr6HtHZS
 fFo/NnXXnJ3z3cqZO2p0MOR+TWyfI4DavStifrNDTmQmpngTKSPcYgsc18oHrUaN7A7PxpV7n8
 ogVAkWeGy3l/qTJhnDtBrDUe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:03:11 -0700
IronPort-SDR: ScTCqxg9fw58gk0Zk1N0qkHQgS1qTOIj8hwksWsNEsNFjp/Lp0N/FMDIlB9uWkZ1GuKdRJ+bOn
 akUJvrw4M22nd7aszegUWFHzJS2Scl3n4wCjifHWJXk3rk3q5XhfQeKqW2o3j9Mqn2kOBvPuxG
 NRDv/gQz8yrqDdSvrJY2K1kghwK6bqXTddf1/EP3h+d/cBhmTa8xH3UuT0xOoXHmu474kSj1ZI
 xKNVgnl/9idOykgq+nuoxfHX0wo16Kjw0/LZhQb8kgaBfz2HjI+R4ynGwYJE2jNz64hh2v4Ybu
 Tcc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:43:46 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBJ8x1ggLz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:45 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1653875024; x=1656467025; bh=6ATYhnDpKjGF86MZs0
        pzDwMcHyXcGd6DSmhzlnusnbQ=; b=kgWZYNFlil0cBUS+oyv4HxP6ItrOiVVIMs
        /EICycxuYh2WLjao6GkfRuJw1TJ0BpXXZNz9znTq6pLDMeHO+SCgxoKspRqFXEeh
        ONLKKl0WBaL0EixjmAAxyBKufacAXRGuq5bqFoyaiQ7/SZ8qmEmXLbytGMm1JrjD
        8nLN/VlfthUh6itbFPaClftxMS6lISHQy3/W5M3RVSwSSmtzoWLjEUzL6m5eljW9
        +IPCYMiyliriay21jR3H17CasVowClAKvKJpactG4vhkQwLcajIszExeMgFscvUa
        CwUjS3/inEWKfplNzHeiO70lORls9z503x+nA+bQsp9Utr07NnQw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aLxCSTXZpd6L for <linux-scsi@vger.kernel.org>;
        Sun, 29 May 2022 18:43:44 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBJ8w1l74z1Rvlx;
        Sun, 29 May 2022 18:43:44 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH 1/2] scsi: sd: Fix potential NULL pointer dereference
Date:   Mon, 30 May 2022 10:43:40 +0900
Message-Id: <20220530014341.115427-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If sd_probe() sees an error before sdkp->device is initialized,
sd_zbc_release_disk() is called, which causes a NULL pointer dereference
when sd_is_zoned() is called. Avoid this by also testing if a scsi disk
device pointer is set in sd_is_zoned().

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 89d947561077 ("sd: Implement support for ZBC device")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/sd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2abad54fd23f..b90b96e8834e 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -236,7 +236,8 @@ static inline void sd_dif_config_host(struct scsi_dis=
k *disk)
=20
 static inline int sd_is_zoned(struct scsi_disk *sdkp)
 {
-	return sdkp->zoned =3D=3D 1 || sdkp->device->type =3D=3D TYPE_ZBC;
+	return sdkp->zoned =3D=3D 1 ||
+		(sdkp->device && sdkp->device->type =3D=3D TYPE_ZBC);
 }
=20
 #ifdef CONFIG_BLK_DEV_ZONED
--=20
2.36.1

