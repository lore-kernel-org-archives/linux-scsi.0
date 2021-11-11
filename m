Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8EBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D06C61261
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhKKDh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 22:37:26 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12908 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhKKDhZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 22:37:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636601677; x=1668137677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+eLG0ew8fKkuzFl36Eh7RZTLe040vxndE1bYKICuEy0=;
  b=QYxjnT7mtUJ0lJvq3pKfonpigzhhLsNPtWEilhiTugIyXeRsAm95y8p2
   /jJLAhzAxjdkESXPgMETI9sCtEZ0/WQPpBgBNSBGMkk6PQL4Pwc4mheqd
   Y2/jAkgrmUrA2KZek4jgNs0M6PLlwcSDrfH/omm6E233hgfaJgczrypoG
   qDhWZGw+BPrrP4zzoK32LF9PDktQIkXJcWYpxRA3kbWDL+2Nb0aeHxkUU
   XaGaBbLlu2C3B/6ld+LpJ9JfrGOq1YJWa1sfw68jDycpLXP2w2G/gPWHI
   wIbUmFFDrWK9KIfQpHrylhG40G4ndWZO5Wg0se8Lq+sXphRGb6cCl5V8o
   g==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="186299368"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 11:34:36 +0800
IronPort-SDR: iSHsjnxzqjT7cT42t+F5OfjOvGN77Lvu6YT84LFZYMLwRs5p9i7BIUXfXDQmzQE/Oi6AgOCWOL
 P1KZ9dFR09IQmJRUhTnKq61XBfSybnlwZi6Wj0rUHff2NCel5Jp3gXH9D6OCW3utqFgP+NpcO2
 lR9fPfM/ZsBFsKUs4Ct53leJqm5+OEJ44jHZHLVUvDabk29KBdy+kvE7SuNbB7+5Y8T+vCZxyL
 YuZa9Jk7H4lVNqaAordKKmD7mkjTCUnFOFpfoVm99BSp34h49Z+uLf4KKrya1au+tpnwsATzTN
 /iAsNaoHHU2rLsGx1kWOor56
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:09:45 -0800
IronPort-SDR: hU0fB44pWoV86uro1210nhNTUAgcmX9dUSA1CRGK+Bv5shPBTmi5HSxHxXXwCIw09EiIimdQBo
 96zDdRWG4xaZu6w4o5BJQXivvrEVjETduFfu+A4NsbN9gUavvFGsYbuIKsQuvCglYok8VxMoP+
 hFMuCx+zPRXWT43QdmpgfNEWMgGP80WO6nnGDsfJBldjThShbJ3yKmj4h05gnVoTV4u6/v+MOd
 Mr3DA3f52D9q0OJKKAyECdK8NdvOO4FAHsWUY2/eFP4iVPG688LG+xn/F7JLuEfGSGqky9Ayx9
 vKk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:34:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HqS570LwGz1RtVp
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 19:34:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1636601674;
         x=1639193675; bh=+eLG0ew8fKkuzFl36Eh7RZTLe040vxndE1bYKICuEy0=; b=
        DWBIIH6q4sEcrUPdVgKCTCGbPMaL5oIzh93GJmDgHGgn7VlqyVl+WR/PChcDZWGc
        VYp8/O2nFJs18dLJPyYZa24xRsEA+kXqfslc0YZgGvCBkRVDH0HxaYz0E4ZSzGV0
        rn0ILRkcBNUI5Zdhi9Ihe3P+kuo35o4Q6iw5FQF5I63WGY4+Md4PMbEy2UQ6LOng
        nRTvf/BqT33BtTjeAfDpu2CXs1ZxdenqRlCgZY2ar4PCXeyd2KonJGjIQX78/4x+
        oAmx2tLDPkvW7ntamQkMQ+zBQrw0b4hjRPXHfByTb0+x7STuKidvy4833+BTJTQ6
        D1Qkb0SA/IpkTaiT8abEpg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id a8RAkUZezU2o for <linux-scsi@vger.kernel.org>;
        Wed, 10 Nov 2021 19:34:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HqS556SMBz1RtVl;
        Wed, 10 Nov 2021 19:34:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] libata: libahci: declare ahci_shost_attr_group as static
Date:   Thu, 11 Nov 2021 12:34:30 +0900
Message-Id: <20211111033430.296597-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ahci_shost_attr_group is referenced only in drivers/ata/libahci.c.
Declare it as static.

Fixes: c3f69c7f629f ("scsi: ata: Switch to attribute groups")
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libahci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 28430c093a7f..8a6835bfd18a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -131,7 +131,7 @@ const struct attribute_group *ahci_shost_groups[] =3D=
 {
 };
 EXPORT_SYMBOL_GPL(ahci_shost_groups);
=20
-struct attribute *ahci_sdev_attrs[] =3D {
+static struct attribute *ahci_sdev_attrs[] =3D {
 	&dev_attr_sw_activity.attr,
 	&dev_attr_unload_heads.attr,
 	&dev_attr_ncq_prio_supported.attr,
--=20
2.31.1

