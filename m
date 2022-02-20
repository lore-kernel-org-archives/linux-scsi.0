Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18ABC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbiBTDTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbiBTDTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:10 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCA0340D3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327130; x=1676863130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPLB3X/uRqDQhm7Cw3AJNnBX3Q4TxG2g7Ya2O0duFBY=;
  b=buzQDHdQiTvJ0KrIzxpjNq8KMb+Of3ZeXq2v0k6H8zcZa0TbwKB+28j/
   XqaXd8GyMge0xkf7XHzsQ32IRrENYWhzVzbjMT4ANyTJWxqTNE0bsO5Aa
   uOHdQMxisel8A9KvhsadSViOcoo5R9kBxL/MlyKPV7S7sWrtIXlGqNdAd
   WCyI3gn7N1YhBPsZqD9s/o90HwVWlGQtNwgoY+4w/enVepLqK7ZeppdB7
   PnDG2dsxtDJSDLFWSGLiEVkcjk/iZ+Szxvq412UhIimcqmk0Gs4LDBrYl
   ddvcN9Cn9T9PzMMQmZM9lGN1RalSpgzL9ayw1zuvoXGTJu+ZRWnUGJ+OG
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405814"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:50 +0800
IronPort-SDR: VHXm+/0ay6rRVTIBii80CZAoCkTIge4bJZK6DnVqWTgDuZbIDUuyQC6/8NyjCUdlqhXUI4z/LU
 NQ5sJ/0kGXPUT0CQqzHxmoNW/JExF2tEarvP/DJPiu3hpDfoyZMywIP8NSSe5HBD3MyJJhKAvR
 vApQFVfBHOXCDfLagQLf20RSJLgCFr/Luozjdaznkr9TdmPJwXnZ96VolW+CarmeM2pZHO413U
 zQlGBfECe+btGPcfKI3+Zlh2T23Kk2a2AVxgt8Jfir19UYhAkHwFFXorNuUEoTynVBwBBzjwHY
 vaE6IMbJ4DJw2LpbGLKxcsZh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:26 -0800
IronPort-SDR: UkePtRH4qOfvuu6287E4TXBcZBoiHUk/4TaPcxztXTyEwxn9Je7jDG3g6pHcVFi1dB+1seKsIx
 klX4hzvO5sy6/maQYF/0lFbmfVCWbMNTeEIQlxhM99dOL4g8SKUBKi/Z07RaVZRk9ai0Nss7f4
 3cX/2Sn+8xD0BZldqX6gWylFxmHaVRgopJ/oSWWnVhCHIaEddRYbp5aTtT9kivKwLw6S3arMsR
 wqFS4k5Bly34vTgFuNU++WXm+fmaLBwvxF8JBCsUL8cm978EauUkVdvKxZUXgNRgXvmY7W1IJV
 Edc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyL1zrDz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327129; x=1647919130; bh=uPLB3X/uRqDQhm7Cw3
        AJNnBX3Q4TxG2g7Ya2O0duFBY=; b=Pi5adARpJPCAGTOGcVE/gj4tXK42dENJEe
        tfEo/2Fw7Eg7y56WHBngGXCiILNS/fqLaTrWCEazLQN2oywHiB4jsaK+DyfynhKm
        SVqljQSkXufGNO9g5a4RlVgFWVI3waxFcvmSlWJqamURggjD+ohpl65cTr5G1wAj
        WV1Eg7sML1jCnFBOBNfwsiLM4FhnzExcaPvbma9WMfS3RhxC1b4/ip39oTEpvHzs
        AEUGKM2TDxIV5+MXfkoye7DcB6awAI5xS2J77KTtsctiHIFi+iUyGzAA4qXF9CBq
        AmioT1id2E7Tc2OT+5kizN24sKCz+TdeCM6bh4iuhxWKttBoegWQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1TIvplhhi_uU for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:49 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyJ5ZJGz1Rwrw;
        Sat, 19 Feb 2022 19:18:48 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 25/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
Date:   Sun, 20 Feb 2022 12:18:04 +0900
Message-Id: <20220220031810.738362-26-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
index b41f3aa6ce3e..55859d24edd3 100644
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

