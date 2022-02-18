Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C24AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiBRDRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:17:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiBRDPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:44 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3801BBF72
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154123; x=1676690123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dsWEUSFRCeu5tdZvPF/qQ+3R67+FzF5PZKWqtJvVHGE=;
  b=Quu4N9cnA2mvj15T1Bo9cOQG0gcJ3e+wB9jB5/iIeGYLvCgfcAD9yaKZ
   o0T2WLs4lg37BUei7MmluEPOAme1ZVGZb5Y7Vnrc/fGTCj6BUWLrbQpkJ
   Q1PlPBYUi6U66ongeMTkMC4t2m1jnt2MEd5sSrf0UBPpfV6mjBRTukBZ7
   7mINNIE0pxJVao6JpOQ/EQCXk3YzXh0D0OHjhxNzZef7o7SiRBb8pMnpD
   uYcrC97eDM2tYGsv+3Tp/jOc9vjuPz7RP4Ur1zpt89y66FdWAYRJOfB75
   nm7QG/5mBXhvjBj3gkSes3GhYrUyyBc/iYcwc5ms/GSp1VfzcqM6TFtxb
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074200"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:23 +0800
IronPort-SDR: Sm1kUMbAd4iiMuCU2xL5HITMYogP5W62Q2VfcwjEfj16IeYcSV/RsHDwrRlpnWs/UzigqSxq3P
 t7DDPVv5PGqxF6Eah+77Me8Exo0zZqPoXtQMFU3WNsHFUHvjT9KWXMqhNCJsbT6UzdQYbj+HvY
 PRqj6jWcCd+qP3v57cvE946NYzF/ELHKcKhvOwslMnCZn6IFyX0XyO5kYL+st4WiIQf9FM5cV9
 ns3qd0cukEWoIn7zhxaD/ClDC3RVyeIOFqw+eHCswS0cDmA4EzrycTGPIk38oK+mXPNthWwcZX
 KMQHdPeAMqxIZXmwYe3pgIys
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:02 -0800
IronPort-SDR: O0idZ4vzUt+SC6rh6wj2fPeJUJ5hTVzDpXy7IibTUEAUTVd8V1wpnEiaBnHwroOkQXp5/TCaHz
 KJkCnXXJyQnQLhNvMu+7it9aYTIpyOrxHz2uroPPQjeylI4h3/zLTtejl7CPBTRKR4DPZM3dxm
 uaaHmodp/ZByrr3vNk5P3sASTaattP5Kjp6pLL9R3Jfp6KMnY9Pckh/M/u/2MHa1qv2yIiynXa
 S1BRKXHqVdAR8s/ztsMtpRo/+RdcRRJ4uoAsKN1iaSxU1FBtjhpVmkaLyiLYJE//LiqTQUr3UN
 ofw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzJ2Sdpz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154123; x=1647746124; bh=dsWEUSFRCeu5tdZvPF
        /qQ+3R67+FzF5PZKWqtJvVHGE=; b=C1npjBtvBIXPZvSJh+tCsEX5DhhN2weURT
        xbn31VYMxjeM2EFdGnam0zicv6rmrf5LCRyjY0LMOa84m89bqDg2oebGZUilKzMH
        v1MVkHqITTRrrOd9Zbj1iYIgq7Sw0J7zIFDoSHVL7EnTqylQO/Txu1F4ZPlgeGUa
        cTQXfNeQmnNbOYSyPhJ5QJTYlgcoS9DqA+ooJFvJHOtv3Cz9ngxHED+S8BCao0Y6
        eUGrpzj2qVq/Ugw+GDpjY+6yDLLE38j8dMnVEt/fsByPV0ATeZJQ7hMn4/i8DzIk
        /em5Z1MNiUYi+mYkvqajK/TtRcllVBuHnkU8/2kDPZfkz3T5DX7g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Lz2QO-fmeeaF for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:23 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzG5yzBz1SHwl;
        Thu, 17 Feb 2022 19:15:22 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 25/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
Date:   Fri, 18 Feb 2022 12:14:39 +0900
Message-Id: <20220218031445.548767-26-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 98a25f158615..177a9d194d18 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -304,16 +304,12 @@ static int pm8001_task_prep_smp(struct pm8001_hba_i=
nfo *pm8001_ha,
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)
 {
 	struct ata_queued_cmd *qc =3D task->uldd_task;
-	if (qc) {
-		if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_READ ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_RECV ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_SEND ||
-		    qc->tf.command =3D=3D ATA_CMD_NCQ_NON_DATA) {
-			*tag =3D qc->tag;
-			return 1;
-		}
+
+	if (qc && ata_is_ncq(qc->tf.protocol)) {
+		*tag =3D qc->tag;
+		return 1;
 	}
+
 	return 0;
 }
=20
--=20
2.34.1

