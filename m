Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEDBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbiBJLm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiBJLmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:24 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660ACFF0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493347; x=1676029347;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=62dKy7FJi/LOczLf/foDrU5lssulm4RAJbK5vqkwQOQ=;
  b=SGSJGu+A44sb3MGsxXfGD3nvvkRLwJxzWFCaQuyN+WnnZDaTLqlL+myQ
   ktcTgsClbSRVM+DQZa9A61mhx4NMREsUmq2F5IGM1ZDTUQ2WefGQx1ZZg
   f3X4Y4LZce3z/M0cApUaLyeLlbPqI4ZjiZwn/SMQW6LtC4AYmCtWmOm/U
   6uZO6k8S4/Q+7s/SeuxLPgps0/7pqJ5OiNqJDmoup0R35OjoLhncf8Mc/
   FtpkDvxVsT15gws7ZHY7jyRp7S8JKwVepq0ZeuFronIqmVki6Ug7YN/RA
   aYTmdefZZihyUZ6Kj8taAsIVxnuibx5YuLaEmyDZOcwbEupGBnSvDSUdq
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575611"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:26 +0800
IronPort-SDR: HyM/g/S41QDTKCHJUHha2X4Rbe6MBLjwzgENFXf90EcyN3MTHUhn+LtR8pWJIRg37dCxhMG+V6
 7xDurXshIzWPF7yKXS6dGnJ755YIrnnf4Xl3b41BE7ZfkKdFwnJfCktJVC45D4ivlnVKdCH0Oj
 uGhFYQnxnESGPIp5+Tdb7mVn/IJFMLUqGMWhv4SIR/TN3+ZgiClzih3Vb2ZCrHITWhUjRImbJQ
 pmqLMrhTlI+wyUj40h/WPUin+3oGwCbDgwNa3c9caEcu3H/nHjveTw9IRLAC//Qm4Q/CM+Yr2K
 G4wFQxMsYsy/A5z3InOnmSPG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:23 -0800
IronPort-SDR: /ALfSRjzXC1dHwhIgW7BwVCcYowLliMAtOSQrkp/SsNbHRXRxLvYFhZEwLJmvjh92dWLCIyZvb
 xDvy4EdfooRv9/jI81sImp3t2A6zLt+Ejimki0dJUGSAP6QxMygtRfYCNQlLIAuGgtUEv8JliL
 bW5HayjIMvWkNOF9RBaf85mWmP1MAFdT7dyBzT/3qVUSrOswrCekpr5ePR3fftTyXwGmBLmbNU
 5m0ti0ISlhysVJcDH7/R2TPQi6vn8jAzgiir8wpFSmn4+JQUAdWOnYJN21dvPV3EK/IelvMTQK
 8ZE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc1703cz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493345; x=1647085346; bh=62dKy7FJi/LOczLf/f
        oDrU5lssulm4RAJbK5vqkwQOQ=; b=GfUqSHB9pDS/BdHuKIQoRzap/rgtYRG/eS
        1+mhFuRDNzIK9fcH2vhN4RMCwza0oRZTzjOXshTG3BNVdJfrfUzwDs1qoUSXmRPX
        nMJXxg88gn+9X1dqRMgnnrymQIEqRXgphwm5UJY/SO5s0OFXU6zcJwFL9SF/+rZR
        3cQWDof/sTahYbhyY2nHjZ5uACra68bIRIsmON0HFYP9JS9hq59dgc+Usp6p0nKS
        XZ7k6s+PBk16SwAnNfNqUP1VPX/+6ZJkVf/U9AFPbMzePQD91UA8hsjIAv9uplgv
        itIm/KsTjwV9BejUb8+hDfD4WtwQ0s7RhkCd0KHXYimRsnq+37BA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1tLKXf7jds3b for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:25 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc049vvz1Rwrw;
        Thu, 10 Feb 2022 03:42:24 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 02/20] scsi: libsas: simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Thu, 10 Feb 2022 20:42:00 +0900
Message-Id: <20220210114218.632725-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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

