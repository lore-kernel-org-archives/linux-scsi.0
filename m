Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27750C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiBJLme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiBJLmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:32 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA201028
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493354; x=1676029354;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=nldFEaphJv0td9vVAodKbsUeQBGB9NZPcBJugf7Ye10=;
  b=eurk+owpt+aOChuyHcKIPbMKwZ+oStYBcLAv0forqlNVB9LzucQWHLmN
   3qgRn6D1vI8CJomMv9C2kiN6y3W5OmuEf5u9woD1XgdQu2GVt/JihInfK
   jiR7OfKWI808FGX32TQICetT3I1nyFbluLeYlEs6895Xpgc2G4QBaEZd5
   4TwY1IiU31Y1pgG10svyKGVxqExPtq9rOLsMne7lztFlzLDqfbMqhhmKO
   qBhGcNMBRK4iOtKZH5zswA5nK5SXrrgdvxxS45SeNv4fVN/nZ7WvbE+zZ
   Ty/mzgSaL9N5nIobqAJJIp0gmFmQAhRoeRMDuFyD/972nSznrD11dlFd0
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575639"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:34 +0800
IronPort-SDR: 0EctaDME7MRpCSKGtdRCHQGgRwDrmnx2OUwcb50v1SQhEnuPG1Q1oqucL6m1601/4viVv2kSgJ
 L0KHZIrmEf7n87eE3qXoNBSkNLBZ4o8LZm1boCXiCuqMBgBSty6xAie6rMSKl4QN3yLajRdywD
 OYz7nN9DVfZEEZIGD1f8rzQDEWIshslw6eZMExm3yQq4or2A6mZbrH10IuwPGu2pxbduhw9uF3
 uXaZmAxZcCfeCg+YjtCepai2ytfaq1cZuD7kYe7Ji4JudN9mxfPlaEeNKCgCW7FY9Rs18gmyOU
 8+LftCKdJukYU3YkIYKsH3dJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:30 -0800
IronPort-SDR: TrOlacK+xQite0rMiEUJZg9FkDHW7P1OysDQ4LZGl0rQBsPJcCQqlx8Pe7pbmvvTIa30DAo2iw
 cWuD22OPkAGBob1uXbbNJnd7i3jXFCu3LC9JE6ijaaXHNZr/g1yevGX3Z1OgtlMIVff0PwmGy5
 nj7+FGHQOkostAvMXpAS4cY4Dqb2I0GXPb9PKnDjoAjJ2jiIuX66D4UceRMW3XHa2JIB8nFijU
 IKsNUjSxn+3n0vaWz1lTVZn+dUSZIpz+JxfOLVXIZ9FsofAHG4g4sKm6tDP0QoVF18LR9kwGGX
 sRU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc93DT2z1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493352; x=1647085353; bh=nldFEaphJv0td9vVAo
        dKbsUeQBGB9NZPcBJugf7Ye10=; b=KmKsTm0NnvwsqVi4s7Jp/wHXjQp1zQbHZw
        9zljoxQfHMYBf8p3BvkQjH/tB18+4wtzCWtOnl3YC4yGGcnkVt4/JNRC2ktq3/pI
        BXlWvGTuRVfnHEOATSu/QvkpGn/k6uxGoBaZFbRha+a+A11Y990ick2qVpJUxoPb
        11XVJrDIEwOxdhSEr9a1JXIndmruUGH4Dc11DiBenUmrpHO/2DxxAA8yk7QDN55b
        CRflrAJZJlHwYPck39wqAw/SBS8BH9z+j34kcqkhYLHkXK/6NPVlehu7GzEUHyKx
        lZg/IlEhETVMqWOqtNklY6DjdOLzNcB9EXIvXT/atrY9Ev+qWJvg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 10KKMTgkXGAQ for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:32 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc80NSrz1Rwrw;
        Thu, 10 Feb 2022 03:42:31 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 08/20] scsi: pm8001: Fix local variable declaration in pm80xx_pci_mem_copy()
Date:   Thu, 10 Feb 2022 20:42:06 +0900
Message-Id: <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare the local variable destination1 as a pointer to a __le32 value
rather than a u32. This suppresses the sparse warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index ec6b970e05a1..37ede7c79e85 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -71,14 +71,13 @@ static void pm80xx_pci_mem_copy(struct pm8001_hba_inf=
o  *pm8001_ha, u32 soffset,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 =3D (u32 *)destination;
+	__le32 *destination1 =3D (__le32 *)destination;
=20
 	for (index =3D 0; index < dw_count; index +=3D 4, destination1++) {
 		offset =3D (soffset + index);
 		if (offset < (64 * 1024)) {
 			value =3D pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =3D  cpu_to_le32(value);
+			*destination1 =3D cpu_to_le32(value);
 		}
 	}
 	return;
--=20
2.34.1

