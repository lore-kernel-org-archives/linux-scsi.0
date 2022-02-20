Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA7CC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbiBTDTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243405AbiBTDTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:07 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DE0340D1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327127; x=1676863127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wwvhY+uxe6LyvEGXqKRRT6frlKW9xOaFjjpahO0hdn8=;
  b=Pl8qZTrErVGoWfR1KRskc5Td71zl//d+fmxQnuPDGP/9Mxl+Jtfmi8i9
   5mjjj1rCgMRcgqvpW+sRub0fGRjV71Zy5iMgIB0+fmNaqSFWSBUfvWrf8
   3gLZUEP2Xa/Fz5wUJyVXJYAZ9Sw7vAI8LWE0Uy8wwmGqvw6HHU5tK9d19
   rF6fJlcrKV2W8JKdSke+6oWokVaUwNHdjkL35alvt6aBbni4U6NrEacP+
   6pxFjOs1kcU96Mdg8dlShUuKN3yyKF53d35JSfV55hAr7PJh/ehmsi7ph
   8vum8k3LuBOFvK0SdugpSjLa6U2LNls5Tyi+31aQlCi75uXASHtVjaXcl
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405807"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:47 +0800
IronPort-SDR: q1Zu0sKiF5ANnLyZxB4udf9Jih2nWj37cl/FSyqb2yfdPCZ50ctPJKa2KGXLmvi3Cq3zObBSAH
 To7yA2T963FkB64Vol4jm+wkIgkJbGQdbBjuRFBXoARlq+7sxX65rw+zNn/T5sAmXetNgvnXPC
 p5QQImPnx2D7TxKvRsAAuMestvm2XCr9uArEnBbmvAAG3lY0iJ2Htu4xWifg4xl/5PtrZwq1Is
 76cMsUBbdDgHANZ58FToKDxyS3lhVBOecnxyXgqsf0VxI4wVoVhazY6szR0lG3h1bN2ALwe9Bp
 qMS2FOCHTXQpswOHplMYa9Nr
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:23 -0800
IronPort-SDR: Q3sdhO1vj8qsv7KTGbOkG+W/AYipqp+JBpcrudUpBWZK8EKCy8XkyDo//kiTvpzxuiwvOXBcYC
 sCSSocor13GYyIoFfo4LxXzNZK6bdEBiS9VCQsVmvwz66yUZlKuqP7hMbB9jx7s4rFKegDK4JS
 iNj6+sd4acMIkqObHy7jvsxHxhBkcHdUqgxQDVBStYLozOvvNNv2Qcfe9wFbXtXcFRcKjYfBAw
 jhDKD4wDZtLeo+SPqrQeQI9o4APnDK5o8nD03laS9iiLjPpa3fcVfr1OOuNoLCtZQbrbujrk+7
 HIc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyH4b3rz1SVp4
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327127; x=1647919128; bh=wwvhY+uxe6LyvEGXqK
        RRT6frlKW9xOaFjjpahO0hdn8=; b=Dg+2G+R/k9vLB89sDhjjwsCRqx1q4winwY
        lQ1V7ay58sdssSB/4Z8IpiIxG1Vqs059k9qyt6tCg3+/gj4cOl6OIbUi05gmfone
        n2j6/tkikR4mJI0GLH8Ot8Cglb0dwAWeijputhf+QubELGjkVQgcPtBT46HapTyG
        UQQ/PXgekJjP5Q9xa9fVXabgMBA2rS4ffCLZ8pri3XYcdLnIjkGSLx33Cc9MZ4Sf
        jwNSG/LVkNW8MvsP/XoPtm6n3yR+cMWZvw8jPmwO31Y3u3WsdOTqAqSf2VEyEGcZ
        qYGJh+YmQ2oCX0qS4NEaNVcU5pGM1DARI64+wrEZJjKqbXJ0AxiQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aC345oKjeYFM for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:47 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyG0f7fz1Rwrw;
        Sat, 19 Feb 2022 19:18:45 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 23/31] scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
Date:   Sun, 20 Feb 2022 12:18:02 +0900
Message-Id: <20220220031810.738362-24-damien.lemoal@opensource.wdc.com>
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
---
 drivers/scsi/libsas/sas_ata.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index dd4ae5e8cb5c..d34c82e24d9a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -179,14 +179,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queu=
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

