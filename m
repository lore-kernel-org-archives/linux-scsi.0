Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23C5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbiBQNbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbiBQNax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F532AF3E7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104634; x=1676640634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G72px9zteVEyav9xzEEG21fzNpn0jSxqg6FF7e4Vh/0=;
  b=PijNtGS1TnI4HxOXijTzAynLmUuhX6tq3IRfA+808gXtJijzQgYZaCZr
   +VW5JviXY2r5oa+RZiqFTlBZKu0rq5a4kOp+PvBDOc1cZGnSr/02EsZ7W
   dbMSScBiLOlzBqhElJ6iKT9SY8eimfLHdql55YG4UgvavwnXS+cpnvQOB
   GztkpJymp7I2NnBEXDEum7daWcWKyjgNJhsE7fxRqs2X0W8ie9XQYlOSu
   F5hTruv0+6O+ArkquMdjc7ISCxNfTy2nYe3s2G39m6qui/SgZssEPNnXi
   EJPMFQrF0Pf8Q8PHzdoTR1WzRsqgpZ7udMqkt6OGrHX4vA6DyWEihmJO0
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303229"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:33 +0800
IronPort-SDR: a8XuJJkoGdypEo+QJTwdAAAXK/3Tz3H4oNRjLLdY/msLCJkCENf6hsO7ljMbrtRObafm2YaCjd
 L1Ym/r0YkCm4I5U9vqlwQUk/9FRpdPVaYfxeOt8fCAs0LUyg5El9sFO+GTvLsXB3HSAmREEEiT
 IWA0iI/5LZFBInL6JwuBR0hzmPc5cYU0taor7hc+8WoH+7iA7a3rJgzM3Xs2OseaTyzK6WwFGz
 YY//oDoB0i4lNsNBI4HIMzs4InKbUrFyYDT80dTOkhPxivNA2GVO7NmAs0VjASHOZOjX5DxJ7/
 sYj420OM3gUtF/GKfB7IJ1jU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:12 -0800
IronPort-SDR: c83Sd0li7szUKFHpwxX8q3knFqr9/H84oxL2QOnpjFRQhG0MSY/ax4VLEPTihEdMAmITIi01Oq
 v17CHvCIkFF7U4MePaiLLkOb2DHWMoDmdYGBST1RicptRFUy7hOZQS8pHQBjbHlSzXzizPsFPK
 lkEgCQxp+L90ktpyHQJfQgZv6YkIcXKlyayOhXJX1uyfu807w4TErttJ+LVVJeyR1EvsshPfrD
 Fnjn0/oz6ckEXqahezGXa1KUj0kFrSeeJzr2PNktBUnqbcIsYpYTBl6VOXHYqOiPVcE5q3GrW/
 3xo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgY5Cyhz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104633; x=1647696634; bh=G72px9zteVEyav9xzE
        EG21fzNpn0jSxqg6FF7e4Vh/0=; b=NJFphoC0eNEXyR+V8aw4KpRake/Cdf7/cE
        Q24jyRVURAc4KLOSTDLYIOBfMnciilszf6EloHouoVuHjU9bSSMmkvvT9QXiQU7+
        iFywcAzxFr720Mx96xuZsDyi6Qm7/7dRa6kOqsDBU1xdrennps8/PbEgIHUDHKzI
        yweleZOfV2Q7Mdk5Vwwndy2vKvQ0ax0C9DSDYRYBqavBO9O8RC2zOEkuFZ5VXys3
        QS6ZW4JjcC69i5HTB7RbWOsJKH7FNQEXWA6CnawxNBkSrmoyeun4BW/dBexUjlUe
        rHnCoVfaa/EMIO7EGgFDyf+CBllefMEbEQ6qrGluDRrLZbeEJFiw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TVN5D-EZKGlR for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:33 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgX1gpKz1SHwl;
        Thu, 17 Feb 2022 05:30:32 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 24/31] scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Thu, 17 Feb 2022 22:29:49 +0900
Message-Id: <20220217132956.484818-25-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 50f779088b6e..fcfc8fd4b14f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -181,14 +181,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queu=
ed_cmd *qc)
 	task->task_proto =3D SAS_PROTOCOL_STP;
 	task->task_done =3D sas_ata_task_done;
=20
-	if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_READ ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_RECV ||
-	    qc->tf.command =3D=3D ATA_CMD_FPDMA_SEND ||
-	    qc->tf.command =3D=3D ATA_CMD_NCQ_NON_DATA) {
-		/* Need to zero out the tag libata assigned us */
+	/* For NCQ commands, zero out the tag libata assigned us */
+	if (ata_is_ncq(qc->tf.protocol))
 		qc->tf.nsect =3D 0;
-	}
=20
 	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis=
);
 	task->uldd_task =3D qc;
--=20
2.34.1

