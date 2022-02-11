Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649E5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbiBKHhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347741AbiBKHhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:34 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973541156
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565045; x=1676101045;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=o+9qq7zUJxoUK8qHjvEKnFJaU8c2h1gMU0ygPrb48cs=;
  b=e53hlkAXWjfhZFVifZ2yNRq90zAnYhmQjEciRKb79CQxozIpUfb/WivH
   dUAMfGFSEl1mJ5A1I7NnI4DxbimIXCExrP4WNyXmIer0jXfKSVdnwYP/h
   9Eb0vZv7/tfgvnNr967TqrXQ95dBihPRpyHyDfTfdyfwHYPlJ6rF/6GWy
   vPpnJOo4oBxT1EMH86Jl9gOxVl/ffTWiXvsx0hWap6nx5fB8DyNBADpNL
   wj6rG1JeQ1P6NNlf1NrHVmjrJ2j5P77T/bpI5SF0B0HuCJS5Aq8J2D9zq
   KmBoC5cJgNJicRst5qH9o1Is6cXXUkhkMo6M/U4BBqSrsU6mlRGOFZ5ob
   w==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675151"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:25 +0800
IronPort-SDR: DmJqril3cJnyjgF7N9H7/ZeSG1E1g6eIEIX43ssvKvHECS3/ikt8Wr6xWMO/i2ezbfhmykKs/u
 XCgc4mZpfL3Va4vdUghd4TLqpncrdJVECdbFz/l26kakX8EbhecS51EZr+KocE5+Lf7/g5RrKw
 uGjyXAEOyXjndSzvflo5ABeB0rkCC6i0u6mUTk3r4GEfN+ijJloPd2+0pyapR/BjMuuR5rLNW1
 OouSGwiLq63AoWGp2ESEIx2toDFv7AtoqigiobMN51hY2hVD+RVDuv+SCztlQk5JQxJQcjJd3V
 IWlsctiaIz2F/UWMDUXYpwgf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:13 -0800
IronPort-SDR: M/FllstpcMx/5x10Inmz83jrGMBsYKy+w9B24/jnJyHvV/e5vKZXXw3nGwMob7vz0AVLGB/de5
 z563iDqJJCIHkfKZC9Ri5LGGSTspy9LSyq6g/2+KxWXYPUpxp9suTBicK542o8V5+U4SC3rBmA
 Em8dGA85V1gl1i8UUg9J8ZtLhN8MdJuBNglLgXWgRqsDHhZ9Zf+ZlI+Em+KjaHecQBaQgp8VSG
 3A+QEtk9NJR/bb6xU9tevrzYyAnPFKoARgnCPkwQO3jLMTs5X2k8zJUg+TDu3Z6o5ITl8rmrYB
 N4o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56v1T3Gz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565046; x=1647157047; bh=o+9qq7zUJxoUK8qHjv
        EKnFJaU8c2h1gMU0ygPrb48cs=; b=jXN1lqkKwDgyJkDci2HbVJe72DU2vazSd5
        8lLyg7SaiFgW+vHWrYbCZtnzCWj3AAB6OkeuxYfoc6HKafwDocri2E6+6L016kAS
        ENympFfvDLKMW1O1sTcL4YahMXznJWm4lFywoWK2xkK98FBSVkvKexZUdd7JqaxB
        TT5jGPBkGGko/vASKCT521zSfo2HhRkbMQ9wH5ObIB2mqK5Lld9d6/vO4S9weh2O
        2bdc0Xyo+zZgyRTk8mkJGPgHTXkZJm7SR/KPNBmUjbCpTsv9mitw/65gvxuAdiFh
        FX+HtVAdzxWPry6qYfl6eD9hK7eO3BKEybUt1Lvvyoo+0Mn5IoNw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id suFf1xduNFC9 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:26 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56s5fC6z1SHwl;
        Thu, 10 Feb 2022 23:37:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 16/24] scsi: pm8001: simplify pm8001_get_ncq_tag()
Date:   Fri, 11 Feb 2022 16:36:56 +0900
Message-Id: <20220211073704.963993-17-damien.lemoal@opensource.wdc.com>
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

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 60a56a18e60a..e72006a23c1c 100644
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

