Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFEDECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 13:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiIPNBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 09:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiIPNBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 09:01:22 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D58A3D78
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663333278; x=1694869278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJOGuz08kWrKRpJmH4Xbw/JiycyuiYnU6kfNtqwhTDI=;
  b=BdjwfhH3O4txnHQ3W5bzMTAyuZC/6Gky6fU/nkoBziTnhvITgJvbudRf
   7S9I+uv3pytpdcIulQSA05MDpZLqE2gJvuq3IQ1xVGgW9gvweznmjsCZr
   a4RHjH3mERH90skG/HeF9z7U8gpXrBCMwdO9Fp2nAUYxZ55+i1bGHazcV
   LCmu71+TqG9pWgjc5n4NBrYcKO1Kc7EXp3HYdkVdO+Tq2AMPbhj+s1weL
   gRnBMkk0ChXp/A0dkmFXL41282Y2khovVJ8cSXSwRIgMqhzt5WYRCYMb3
   ehWl7wDf1/vCg4MABht3LR7BfHqskyK10fW4G0XZIjk+OV6gIddZGQWYO
   A==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654531200"; 
   d="scan'208";a="216702740"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2022 21:01:18 +0800
IronPort-SDR: abDzfFV/EsWWC8KTxsp1yiHi75Iiq7EqF1qYPZgfpcZAy7wWaodV+jTKGglr9NXfBaZAyPVFma
 dAKnw8HbO+kBzOtqFHtLas5f/AK7mYTJvgKxv3mnJ1ABf7VcklronsfTX5yKb+T1DripI1Rioe
 c1c1yCyEJFnTmxqQjB3tW2+o06xyuObll/uBOOwgDXUXZi+7AzPiPACJRuCH98oy1MUcGfLIDh
 dPkij1Ux1tL8b+kJSmfEeErWnC4MiMMYQSdHLAUrYZte/NgFf78tzr0Y7ElQC5hxqcxeiqUyIV
 uDj31TcIo3tnsYDzDzBjCCkP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 05:21:31 -0700
IronPort-SDR: s8Gz7+kjdguSK2+8vHAQxJ6GpxwulPcd/+BvNdDavTwxRRlZmHNxu6+RahSHDYyflHd0OiKSlG
 46E7OyGENQ3YCCFEgAqLlOZOUI06Swx0C0ttPdrSDcnntS3dnI8WPl/Gk3n430Y1Fn6U7EGZ5T
 QTkp4PT4EoS7bO6hKP2rwgoyvpPkIxjoys/mv9t9mLT6+dvssvpn61yhNxqhH7aF/B3kgj0omA
 Bzj7VmQTYhpKiP5jxeRgagQnnZrwN/NpobpOLkY7V84IQSS41M1c0p44cEso8Fs+38CWEeRJZ6
 FJU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 06:01:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MTZ2T0jGLz1RwqL
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1663333280; x=1665925281; bh=FJOGuz08kWrKRpJmH4
        Xbw/JiycyuiYnU6kfNtqwhTDI=; b=T1qnFwX0vFEYB7Eo3A3meiL9d/QFW8J//L
        trRgB9vcol4rrmd37LmxX8I14fSIJH4d6+8QOoJwMVi2iuLwYMfU35W9j6nP3nXK
        a5lFrKx052OOZXhgpmAb5URfqyDviGp/1jCbXVQvxqx1QcHazPdX3ZLC6RpwR710
        YRy8mnCFIvJFXyxnB/4qLajJ/f04IwLrZA27Na0KbfIlP8+7U1imjeXhVyS2+qWh
        cyGX9re86qHY4Ef8oTBYvJY2pUSSnhUR2KofdHEwroxcWJ6gyMyZsAH/iEVee+Ns
        mgKenrzVyzU0lok1cLcm+yME60DWG5Q9pIHDMsYQ3wU40Z0sLANg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bgMGDRJeSl73 for <linux-scsi@vger.kernel.org>;
        Fri, 16 Sep 2022 06:01:20 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MTZ2R1ZXDz1RvLy;
        Fri, 16 Sep 2022 06:01:18 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     matoro_mailinglist_kernel@matoro.tk
Subject: [PATCH 2/2] scsi: mpt3sas: Revert "scsi: mpt3sas: Fix ioc->base_readl() use"
Date:   Fri, 16 Sep 2022 22:01:11 +0900
Message-Id: <20220916130111.168195-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
References: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit 7ab4d2441b952977556672c2fe3f4c2a698cbb37 as it is
breaking the mpt3sas driver on big-endian machines.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 1c02159e45ac..f0088a0cb685 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6914,16 +6914,16 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADA=
PTER *ioc, int request_bytes,
 	}
=20
 	/* read the first two 16-bits, it gives the total length of the reply *=
/
-	reply[0] =3D ioc->base_readl(&ioc->chip->Doorbell)
-		& MPI2_DOORBELL_DATA_MASK;
+	reply[0] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
 		ioc_err(ioc, "doorbell handshake int failed (line=3D%d)\n",
 			__LINE__);
 		return -EFAULT;
 	}
-	reply[1] =3D ioc->base_readl(&ioc->chip->Doorbell)
-		& MPI2_DOORBELL_DATA_MASK;
+	reply[1] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
=20
 	for (i =3D 2; i < default_reply->MsgLength * 2; i++)  {
@@ -6935,8 +6935,9 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPT=
ER *ioc, int request_bytes,
 		if (i >=3D  reply_bytes/2) /* overflow case */
 			ioc->base_readl(&ioc->chip->Doorbell);
 		else
-			reply[i] =3D ioc->base_readl(&ioc->chip->Doorbell)
-				& MPI2_DOORBELL_DATA_MASK;
+			reply[i] =3D le16_to_cpu(
+			    ioc->base_readl(&ioc->chip->Doorbell)
+			    & MPI2_DOORBELL_DATA_MASK);
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
=20
--=20
2.37.2

