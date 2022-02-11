Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383F1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbiBKHhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347705AbiBKHhK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:10 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373C710B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565028; x=1676101028;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=62dKy7FJi/LOczLf/foDrU5lssulm4RAJbK5vqkwQOQ=;
  b=T9z5/AS099YLB8/mDkcvsHIoekEkebYPXD2Ua1K3TRrOm0pEZ55UNYRM
   0Y9PtjDAGvm4qoQ9lPH1pjS1hBbeRQitrYndsNoWxIaTjjgW4hMJQR8Nv
   10B+vr7Ij1o4jRbPYuIPNml8arn3/PyL3sQVVcqhdl2ZDG4MahNtpyWUK
   ZLQwp5RygLlXrczn+JHCq+GsG2QCwymK3TUtfXgG89aMxzkFS9wA6RWAb
   2gKPALXl6WJ5ieNjpehiNfhxkWc2LgGSZtqrwjBYICcWK1yOBkhan8qru
   9/fbiY/4aQl0cbNsoCo3WdctQLzOdgSsxaOEHxxziPG9I2SZLFncMP2hV
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675114"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:08 +0800
IronPort-SDR: uLrAk+c1wl8cNxoWKLJTEA0XQLJw9vbZVOqIKZkfrKb+2wbJAQceBmgPN6X40cKJd3hVKb3Ajq
 /vGiXzPFtDpGuRanUiaGfngnuF8AufdppPISRk4Ieald2CxPGTprFfyMOkRkLiH7BlLNHj2upl
 KKNkccp+Wp9SO7FXyUZ4CDOdPVSrNeC2xpZ7PJFFZRDIDyql1QltcjEHz0CgyRJDjVZUWPDT+M
 vFrzWCp45tBWrGEfhrdTfVu4vR47FULiGWh0Tyxo2G7EmSdDOnxrOrWaCTdAhOz/fvvbEYvzb4
 IAicpwppai99FB7r9CSW0Fy6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:08:56 -0800
IronPort-SDR: R7b8/x9zVGeMdtlr2kwaNoIe4r63MfmBNi4EFyUmtvefPEqL2U4Nnc3LPigC0FuLcnjvs40fcA
 PsFS5d5I2TDwkuli0zjv32yal62h/RDvnD510sqvjfC7VwXqYoYoR6TYetSe2uPUf7fuCRRAiR
 00n0tjE7ebbh/rFJv77X7y6staIg7Njl0lMsCE2JqUc/cutOqnmbZ+LF1AMCRvlimj0otQz8sl
 48Py42knjMrOAiiHMZtt0etAcfTJULPuszkZLwPGBO+yvXXulZeEwpdwcCLk6G7G4aZJhC11AI
 7i0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56Y5gJjz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565029; x=1647157030; bh=62dKy7FJi/LOczLf/f
        oDrU5lssulm4RAJbK5vqkwQOQ=; b=uDeAXfYx3RwHrSl/Rz8PdWbkQ8cwSsppLk
        XB2jfDE325GcPDbeZbiihKRVml2gkRsCH8sMBZOR5CMoksc6dreoSNxVGa8mXQch
        NULZwfslTkLYjdUuMleG3x1js18jXtRc6E3+9Cc62aoxTa//0FKDkgwCBSfxJjSe
        un6FuA4YVhLEPCYJgz97pX4V/TgDE3bkMiBXBF/RLAccE4KTDyLSlQq34jcf7Ldz
        6ap/NYHSbbD765wulRZlf2jLaJFn52Rl+7c+lZB9b7KJ/y07uyKTqwg2KhL2FzrO
        cvoCFWBjJK2YV1avV/C8AgcA+C3t4pHyE0HFs4LNNtyKcRf6in/w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C-yaX5OlT9Qe for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:09 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56X2Ncjz1Rwrw;
        Thu, 10 Feb 2022 23:37:08 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 02/24] scsi: libsas: simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Fri, 11 Feb 2022 16:36:42 +0900
Message-Id: <20220211073704.963993-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index 7e0cde710fc3..99549862c9c7 100644
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

