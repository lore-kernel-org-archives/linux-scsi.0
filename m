Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC6BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347725AbiBKHh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347713AbiBKHhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:18 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757A4112C
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565035; x=1676101035;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=qfUTrMyD4ge///nHppeLZESG5QBSI+5fOiZvflIP3ME=;
  b=OSXoW8Sus9C0zMgk6W+BPIcGheLlxIHQieBYkk1gR210QLuwMD5STJBg
   Nm9HpFH2u6URd+Aa/8skrygoz/zvVrEaKyML0dddvfZKI/UW5xPBIcH4s
   az9Y+B/HR7sNLt3dNcAGQcvSkl9+l4j6f7TgHNmyIcX6fY+2a6MqFn0jI
   vkZkc3t/ojiFTizREstubIq4pLq9N1ezR5hW5O7NI7AKGUcp0kHUc851+
   34M1NYA1qQ5+FoKKio0NlWH9gAJG0idfrZH9cMhpcpbxKuDYkbyVkkCZ4
   E92lwLzJNLBokuIIZhZjuoX3Ge4QIg38JU5K8fRXx7pTzFkvkgDtGYDDd
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675134"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:15 +0800
IronPort-SDR: Lf8lUYKWaADQRj9JY/rB682pE+9x2eZ35xpywohv1FSmwikuVDZKtZORHjmw6m8baWHieXPYBz
 4a2hNkrPsN1Un8LX3p/5vHHen6o7YXaBxqWrFMOuzZ/1zgsgoJQPmGEDBzp0RuHq/IFYsgavEC
 LJXGO5/PmyhrxSuCpDVq7V8SjuOmgC0bnCnAu5hUGJitusMNSi1GFQGN1bBh556rUiftLORHbs
 9oAYqfbwKfUqjTKuPNgcVWEOaal2IJuOiqKnO6wy8FjK9I+NYWuZm3bwL92OUyFKOQVpP4fckU
 +b9HM1I3y8N3Vd6TiJtmRWV/
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:03 -0800
IronPort-SDR: g3kQ2Tt+ndqkFrBhiKgl69KyVZJIlA/tnKpXw1thyo4P/l0ckq2RT8PmCaNEJnlfrRffPYclvW
 gO78D2EDd0CGiIi+hoPbBmH8YNZKNHhjeWDRg3kOcuJrSSOG8SosQoE/mWcJ0+EWmDEcWkxW2d
 mxJ25mJQRLv5cpeaWH3BmVLNdkaqxvN11DMwfnMuCE/e9NcN8gjNwjChYWNSc8gu8n+Zo6qQZR
 j8oCPUvnJ7f3q9YLD7dbJZctXglyxKwMqehJ6MSs6kaRsLkA2IKMM68ZPHLOnaZimYkmtx13Ii
 0Jk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56j0CDYz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565036; x=1647157037; bh=qfUTrMyD4ge///nHpp
        eLZESG5QBSI+5fOiZvflIP3ME=; b=m9rB7bfCrQ+It0dReh+kBsr8EOIdY1f3pv
        cuqc00/K02Y5H0tzT4tT4n0ahAa8Dx8tyl6n98mS/drLF6pf3gkI04fT9EJXiyE+
        0YXge7FwPsUeEhamWHlDTfiVyW9rXC2afnghYHUY83iWgrdfME5/rQ/bi8tbKtS9
        9GH++KZuSbMnC6+L5/SBtR4XnTjOdgLd5l8VI1ujfdImEY3osd6wnuO2Z8bITG1u
        8ci96WXPHJxtua3C3MqX/maUVHqLJNF9mbtrA/jirAgzT5yM/Kp2ACbN+elGFCZR
        dR2BgRojYf3Qzeopz8IC6Mpr9uoyyoejHgs+wcMYt5G0IauIX5wg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ch5jMOzRfC_8 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:16 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56g4lpvz1Rwrw;
        Thu, 10 Feb 2022 23:37:15 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 08/24] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Fri, 11 Feb 2022 16:36:48 +0900
Message-Id: <20220211073704.963993-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The declaration of the local variable destination1 in
pm80xx_pci_mem_copy() as a pointer to a u32 results in the sparse
warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Furthermore, the destination" argument of pm80xx_pci_mem_copy() is
wrongly declared with the const attribute.

Fix both problems by changing the type of the "destination" argument
to "__le32 *" and use this argument directly inside the
pm80xx_pci_mem_copy() function, thus removing the need for the
destination1 local variable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index ec6b970e05a1..b04ab4a1822d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -67,18 +67,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shift_value)
 }
=20
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 =
soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 =3D (u32 *)destination;
=20
-	for (index =3D 0; index < dw_count; index +=3D 4, destination1++) {
+	for (index =3D 0; index < dw_count; index +=3D 4, destination++) {
 		offset =3D (soffset + index);
 		if (offset < (64 * 1024)) {
 			value =3D pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =3D  cpu_to_le32(value);
+			*destination =3D cpu_to_le32(value);
 		}
 	}
 	return;
--=20
2.34.1

