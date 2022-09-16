Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73F7C54EE9
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 13:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiIPNBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 09:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiIPNBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 09:01:20 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99777A9275
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663333276; x=1694869276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nZ+0NmZ2klA411R2kyIMC4Dv9J7mR010f2MVBcudF0A=;
  b=Vn+5kYTyVK+HSigmZWGQE6QkX/aCPso5VsqPQCb1Rel0Md+RZvBYfp23
   Rytc4aId3IWcsym4OfY7PSe4CiGXXsJYWoVZuSL4Is6VbsLxqKlHVYhke
   hJL1PVm7rImIp+i0epyKf7DaghIGNZ2T4Ofct6d+aDfssfmeho/KvSsoH
   QFerMQkgN0yMw2a+KYBqtlQKsFAgIFSnwspezQYaGf39xDK/ewfQZrauY
   /yIL8HrYA/qsOD4UNHNeIuWi/9y3MyLzoHLCdDZ2bh0n9jF9znHmR5xsp
   TvNwFyJv7YHR8AE3foSW0a3ZvE18sfy2b9Q+StHDxWOR8mmdBnFBOVsU8
   w==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654531200"; 
   d="scan'208";a="216702724"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2022 21:01:16 +0800
IronPort-SDR: aBRsLhOiTnwvgjir4DgNYfJX+lOB527a/KeQYJW7AV7ASgif4UjE4p356n9VOR67PzXaBTUor8
 QxuOM8flesWPFH1ec7EQrTgkpElZ/Lf1Lgigbmwz/oFB3ztQSbCa4QfSqh1PF3AgXQKzdL9/hM
 PMMXUBKYjdrY5CdzLi6NlrrA5CdUSIlFGTcd7NhVX2BdVJh1DZYnr7kYAquONRNgaMO0Sur1Oj
 B0Md1If7xqEjMssNLDxhrKnzqFBKhttnopDMoYbjbo/twVR0C/7ubVuaZc4fJ4MD9ErKol8PAi
 NBjTJ1kEpqE6YA6N0w2rbt1O
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 05:21:29 -0700
IronPort-SDR: uzG12f57tFJJSzo26+qdVLtoxB1+Y3YjrYV9Opd0bh0Q8zLXBb/41GCIGQfQnpaA5q1FkgvGWh
 JuVLHuFzhBIT5Ckvrd2XjDwgnymmVkO0rRtoRv4KXft0+fXMLb+vviUogUnAFzVYHw7nJOnhAh
 6ZeguNPW28UAfWUALuyETf59dtKu9F6njS0oh7uYRsRo3yhqqROQI4u1WbUA1iyyXkRDGL3ig9
 RT024nR3IrRPELvH6WE/7m5W/hDfd0hcyBnMUH3fKBFs102BtWyDeTpZfG5SqWh5Rb9xrdpenq
 3gs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 06:01:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MTZ2R0FNxz1RwqL
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1663333278; x=1665925279; bh=nZ+0NmZ2klA411R2ky
        IMC4Dv9J7mR010f2MVBcudF0A=; b=QSwODoywQwj1uoWfV+DGqjB1WI+bDcG8KX
        rowqUtsoDiXMosgKnOpcsqBy60LQC8QTT+wiFPrWFBnXi4NWr5TuBsJQrzCW+LJb
        YFn4WmdqanlqfpyVnrrKwtJ1vJx6r7WZaZPTtvRJ+lgGUP9mjBbJeDDAISZwGOBZ
        1BCwSH8LLfGeK8PrH74kkM9o2pMTzZpHOezhqrO7RZcc0T9shlD6etsp+V3dRhBJ
        rn1jaKa+b0WMOiJGwO7u4gd2b2mI9/UFYjLLI0GH9+iBAKS3c0lokmcBkJ4Dvul3
        fINRsOxMyD8NL5/8++bb3S0YrvTpwToUrLUK4TZgTLzA7QrZefXQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id W2sGDB4DQHAm for <linux-scsi@vger.kernel.org>;
        Fri, 16 Sep 2022 06:01:18 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MTZ2P1F2tz1RvTp;
        Fri, 16 Sep 2022 06:01:16 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     matoro_mailinglist_kernel@matoro.tk
Subject: [PATCH 1/2] scsi: mpt3sas: Revert "scsi: mpt3sas: Fix writel() use"
Date:   Fri, 16 Sep 2022 22:01:10 +0900
Message-Id: <20220916130111.168195-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
References: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit b4efbec4c2a75b619fae4e8768be379e88c78687 as it is
breaking the mpt3sas driver on big-endian machines.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 565339a0811d..1c02159e45ac 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4313,7 +4313,7 @@ _base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTE=
R *ioc, u16 smid,
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4335,7 +4335,7 @@ _base_put_smid_fast_path_atomic(struct MPT3SAS_ADAP=
TER *ioc, u16 smid,
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4358,7 +4358,7 @@ _base_put_smid_hi_priority_atomic(struct MPT3SAS_AD=
APTER *ioc, u16 smid,
 	descriptor.MSIxIndex =3D msix_task;
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4379,7 +4379,7 @@ _base_put_smid_default_atomic(struct MPT3SAS_ADAPTE=
R *ioc, u16 smid)
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
+	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -6895,7 +6895,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPT=
ER *ioc, int request_bytes,
=20
 	/* send message 32-bits at a time */
 	for (i =3D 0, failed =3D 0; i < request_bytes/4 && !failed; i++) {
-		writel(request[i], &ioc->chip->Doorbell);
+		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
 		if ((_base_wait_for_doorbell_ack(ioc, 5)))
 			failed =3D 1;
 	}
--=20
2.37.2

