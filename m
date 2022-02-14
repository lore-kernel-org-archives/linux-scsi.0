Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20AEC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiBNCUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiBNCUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:11 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3080854FBF
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805202; x=1676341202;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=iRh5CGn4AxAnjVSvzjlfGKllQH5klDLzFx5AieHDi/U=;
  b=Kqj77OGQjOlpEq9riM/8WLJgjlDdt3kuXrKJhTMi69ra8V6uRiMSpA2n
   Kcpzi9MTir8mhu2XMiu/t9A2U0rGEIl0FnOfIHPPylIvUHm4sGEDPp0rG
   uuvT2mOhjlReguvcuscb0SI0AsHkI+fZN6qrbDfnAwQyMCjlyHirQ1tsP
   Tq6dbCb4KjDqOE0WE+4q+LIKn0BJadVwV1iBN4ue4anr1hinUUdGBWCxQ
   nVu0c9MfPo5svz6Dsd6nG5gwDqa9fYY34+nT+HD8otMff40rIXyQhGRq3
   gbNxWgx+fHHsLSh4WoFFQHE05GSk+gj55qVNxvqd22I/d4EonEKhPp2IY
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819821"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:02 +0800
IronPort-SDR: MjhJyQza39Q8EppzBW7AtBLPbAoovpaor/RwxjjvNA0JXgtFV0BHOrFQ+sxIKjullrSXqm5ld7
 Belxb16+y3jVEa5IbdQ0T92IclTuC7WQC2UcH3XWE/GN3/6GXf6fGnQOb9wHIhcykZz0b6MVfk
 3EPDN6LjbIm494JZKmK4daEvprR3XQSp0BoynGDEyGDRSfJf4II/haTJTiRerU9IuudmZ9iXlB
 CmZ15zu3XLbmU6Z18EjEuBYH4cZHyG0XjllhGkLv3WstiVtf7xsPkZAIIStVHAXJNkyp7TaA5k
 1fSc9jeuuxcRd+Xw4t5TlG+d
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:55 -0800
IronPort-SDR: CsnaXVFhnIIK114zvhtgLUPAi1q00xeT5gsoXv7dRNrDFR+CDX80dol1AguI6Za0Kb2lGjMmXm
 wZRPa2PrbG+8rScIwNDih8ueofbQApXYRegGwuMdf62rdwJBrBJxHTp9SKMooCj0sA7f87s7kO
 v5//FPMKUxSQBiJ/Fhf0F35mOSEAHytD5zUssZAmbHuEFzMQZn5Oafefgd7b1Pcc/SglMu8ZXS
 nYduojXEd7hUXLJJpZ2WR9sCfH0FOBhhXazT5vzg4KJZcAsP9Etd3kVhV40ufjKkK+cftKd62c
 FY4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxH5ml0z1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805203; x=1647397204; bh=iRh5CGn4AxAnjVSvzj
        lfGKllQH5klDLzFx5AieHDi/U=; b=Wh88EpKHJpG60smkFG/zgz1EyJim+QxoiL
        50NJckVLyzCAZeXOuf8oSQmaSx5OFoa/OORDFmAgbDy0rkl0HggG/oJzvhx9UBmB
        MvDX9giOTftfa+Ce3TeqomFekpYg5P2+lZH+BYAYDxQhocGaHwgckQ3EBwJiVmju
        QaUpuX9mgeh0VJDC3XPtHCU7wi24vvgC1VQYeQg26IdzRhOGsMKSircwo8fPI+Di
        bjeoCb0c7TrbVhnb559A/KtC7ixa/uy4Fk/pjOzmk+tQQCpOkbZXd9TxPM5wri/m
        mrOAwgINEn1JmAgOh7l4BbStWW4efYNVEgnIzNgnRuUCPXM4rFTA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qGSQFcsEXdpr for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:03 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxG3j0Hz1SHwl;
        Sun, 13 Feb 2022 18:20:02 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 26/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
Date:   Mon, 14 Feb 2022 11:17:42 +0900
Message-Id: <20220214021747.4976-27-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 1e7031400294..cbcb56b56a2f 100644
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

