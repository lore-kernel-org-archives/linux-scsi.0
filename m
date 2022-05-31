Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2111DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 00:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiEaA2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 20:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiEaA2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 20:28:18 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685286A413
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653956898; x=1685492898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvwJUeh1G1EhgQnygFzMq0KoKAOqJ6TIbhUh6ZVZxRk=;
  b=XDXt7NQ1QZFNRUCZHrfINL+YXpzEbhXQlQ8MI4S21eYySs3ox0GRXG3H
   SFNAIqXLljzsCygYexySpoEXjl1uY1rgfKL3fwLY0gfVYB9aI2NLtRbyq
   naT9hfWHWrZRpj5UmpPBe0VbhGuOoi120U3l8GFwqfAB5GyGX8dWv/Yv9
   lc+LW4OFMC4AzhuBmIH/U6I88F6aRHIy6tgXt/2c2UkwodxbVEfYySWWP
   HppaYBZR3ssKgkK5Suta/qPekSC4VFRXXD48cCzTSpbhJbNe736yifYCA
   ClkAC4+w626kkmT3KpqaJaOasiyuJahqudzK/GESIFOXx8kCDGOU9TT6B
   g==;
X-IronPort-AV: E=Sophos;i="5.91,263,1647273600"; 
   d="scan'208";a="202641867"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2022 08:28:16 +0800
IronPort-SDR: 3Y3W0l3HFyD4ETkdoF9VCfcB8RQ1wCMuPFOJbQS07XMebxSup9a6dEUj1v5Nkq8IJ9Yr1Di+zY
 3yWKLh4m/zHWUS0DHGSypLL+y8+Nqd/Vv7Q9tNppeW1hwKN4Mo2oeINbhfs+sk/IxALh+UYG+h
 I7oJAtv4lTezfxV5F7vV6gQoi+wqFwZOn3/GDh67hBPINLdp0rz19fzP4xSHNULhNjzEgq7iBL
 U5MEDF6XzRJC0r6c5IEAtt7J6UcPCPMRqIQzv7imyUPyGtnxkx7O8pCTIpawETYO+4tcWerg1q
 m+bsubgImoty4sm5eKhE+TeB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 16:47:40 -0700
IronPort-SDR: R+hz8/LXQHLtfTQUpPDy/J11buAn5P1fP1s8UXTrvOS1eZNSJXpoNbG4RxPx+nZNrPMVo28IlW
 AnsPKIw24LsdDqNHnGofnCcJZZoMXdlq02wLWIRargvr+nlMScJ0DH34jVxED+yciVIa2t+aSA
 7f031HKXUA6pYxvVMhQrskJkl0s2TswtKayIafsz6GSuJA2FEVVcKY3HbLjHgKEE620JSe8uj9
 ZapjMlrOV0PE7yRu/sIPRCttj/WsB4smsYwq1+NQPfpf4hzeguhB6qIMMAcNsZQq1vk5mWU7OA
 9aU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 17:28:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBtRM3Stkz1SHwl
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1653956895; x=1656548896; bh=yvwJUeh1G1EhgQnygF
        zMq0KoKAOqJ6TIbhUh6ZVZxRk=; b=s9iJuEDwnq9jsqpczB00BDWE1/Liv+eOSR
        ZLkBG1XLMgsvZZubkhQPA26viq5LqH8jXEnaN6bJ0eCCuufUqpYbiEEPp9R4gKCk
        XP4w9b9vswUy15Ao7u8ovqNSsN+DfANXb6JNkb/0Lk8laWo1/SzFnfv43XzI48Xh
        WGgzIsbt09N8w7l95HwYTvYwx51sTZkfakvATEILvseOjasSb+5Y9hmXg5j5OzrV
        pveWNlaw1ADazJXomjnuem3AAMsmOsEJywNXckC3qWRwCrvMu5u6eBKmE7qFntEJ
        dGVKSxyTFzM+a/Hzg+FY1fKSlJKDcaM/SSgf9jrEN6J8lAPLnILQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L_8V8aDdYSe7 for <linux-scsi@vger.kernel.org>;
        Mon, 30 May 2022 17:28:15 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBtRL4Qqsz1Rvlx;
        Mon, 30 May 2022 17:28:14 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v2 1/2] scsi: sd: Fix potential NULL pointer dereference
Date:   Tue, 31 May 2022 09:28:11 +0900
Message-Id: <20220531002812.527368-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
References: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
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
Tested-by: Dongliang Mu <mudongliangabcd@gmail.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

