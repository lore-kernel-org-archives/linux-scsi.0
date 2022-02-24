Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C4DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiBXXbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiBXXbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:34 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CC22399D2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745464; x=1677281464;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=unaPc+bJDjDEi5zJ5BafAvJLsHIWC/zgKf9goBf7tAQ=;
  b=QPpRHhX9ryeM46aATz4OFt7wGL6al6d3f96J9+qKeu78R/DHyl84fhI0
   SeUoPQNxzNN/M7HuU5O/H7Kju523h0o5IR0IqX1P9eVzjGHDyywm1qIJD
   gyGZ7Y3eCHR7+m3i4xhWdyc5lyaSAIpZIW48klIHij9tHNHvxe27y182i
   JDU9mR/w0tI3rVVy6DPVNr3+7d0UFaCzIFQkrjz0izkObsekEB8oz0zZR
   L8/8otVDEKqliMnTlFUpdSMddX69HohM6KMibqKvI8oKaeFhGU/idpVgE
   PBK0ppLzaVPQLa/W7ARi6+XCNZFW8ahd0sWRjohlky6bqJugxHYeiTUN4
   w==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821977"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:31:03 +0800
IronPort-SDR: CCw7tk+DbMHNXka/ebbc14eQb6W9hY6USDVkQSL+hRcTWI6KHTwBT5MbH61ANOpCtW4nALvpHN
 wZ2Sr+lKcaPZtwo3gVb6m/ZNSD/htBck8dnfOpLntc7yV8qqt9i5rzqMmB6BRn4dxZhUxyvb6r
 QEeM3gqITF/xABbg4LlUe+qoBJaLJ57z7BiYhOrGjLIC2NIzpzVnBQZZxL6ux7wd1jl355y0z9
 rCkKUZLIJYtqJsR33yCw5F/Jjm4mnRGi8LJ9OcoucdsBkP3V4vsoh5vC5m3Aj8LiwaAgv9g5FX
 IdOB5fglJ3xpS+ml4y3ODTK5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:33 -0800
IronPort-SDR: 4NBi6PNwkGm4iPiQ2HPtgwM82aMTwogy0y8you9XfBEireF2bzGsD7JSY3G0Vu1O8ywsqSycl5
 RUtWk0NKAG1Dr+QqvajVTmUGg8/M3PqAcOuzmIwUh7OgLDatsrra+YkakrqSf9wUqSxFX0OGZk
 TA/tqAXcA3Zg/RuRD5HpLjo1i3gPlTxL0diG5GQNirEJxrldyL/VY29IpioOr43loWvQwXMG0p
 U1vuGKUMsZTiY++YiCDsyD5pRp/jHNxVMo6K/RVWUJWOHiIi4PHZu2kKVdm3oq59vmRWynQeJm
 OHw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4TgC0y8Cz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645745462; x=1648337463; bh=unaPc+bJDjDEi5zJ5B
        afAvJLsHIWC/zgKf9goBf7tAQ=; b=eStP50CLmlFL4Xcp6FKFeA1VR3uQk39VRH
        XfDP3i4UFpx8mHWqfYguz0x2R1hsDehzkRNQorW2RSYx5OndhakNtilG4q17edey
        NJKrztbnOq/UuucdhHEQUp/NqPWdrg/PAVoDbfrr/b5AFx8Krp+7/H48Hcr9/Fbx
        BkaMVn1DWEFOVfPkY4DAwFzKzmryWqs3adCoA1y7MXhiK4q2x3mofzNSpBRYb7ox
        SbKZFSHwxLD3Xyo1wYj5zTd9Xp0BykpP5LqwIlL9aktix6CNxPmNAJHvoLudB4MI
        j96PWz8qXPEIz1btNGTjzemVCjSIemec6bSxBsAqy+p7OM6cllTQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rRSPNAwp3euX for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:31:02 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4Tg94SqBz1Rwrw;
        Thu, 24 Feb 2022 15:31:01 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 3/5] scsi: mpt3sas: fix ioc->base_readl() use
Date:   Fri, 25 Feb 2022 08:30:54 +0900
Message-Id: <20220224233056.398054-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The functions _base_readl_aero() and _base_readl() used for an adapter
base_readl() method are implemented using a regular readl() call which
performs internally a conversion to CPU endianness (le32_to_cpu()) of
the values read. The users of the ioc base_readl() method should thus
not convert again the values read using le16_to_cpu().
Fixing this removes sparse warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 6ebdfedd84f5..5efe4bd186db 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6925,16 +6925,16 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADA=
PTER *ioc, int request_bytes,
 	}
=20
 	/* read the first two 16-bits, it gives the total length of the reply *=
/
-	reply[0] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
-	    & MPI2_DOORBELL_DATA_MASK);
+	reply[0] =3D ioc->base_readl(&ioc->chip->Doorbell)
+		& MPI2_DOORBELL_DATA_MASK;
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
 		ioc_err(ioc, "doorbell handshake int failed (line=3D%d)\n",
 			__LINE__);
 		return -EFAULT;
 	}
-	reply[1] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
-	    & MPI2_DOORBELL_DATA_MASK);
+	reply[1] =3D ioc->base_readl(&ioc->chip->Doorbell)
+		& MPI2_DOORBELL_DATA_MASK;
 	writel(0, &ioc->chip->HostInterruptStatus);
=20
 	for (i =3D 2; i < default_reply->MsgLength * 2; i++)  {
@@ -6946,9 +6946,8 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPT=
ER *ioc, int request_bytes,
 		if (i >=3D  reply_bytes/2) /* overflow case */
 			ioc->base_readl(&ioc->chip->Doorbell);
 		else
-			reply[i] =3D le16_to_cpu(
-			    ioc->base_readl(&ioc->chip->Doorbell)
-			    & MPI2_DOORBELL_DATA_MASK);
+			reply[i] =3D ioc->base_readl(&ioc->chip->Doorbell)
+				& MPI2_DOORBELL_DATA_MASK;
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
=20
--=20
2.35.1

