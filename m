Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1A63A5
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2024 21:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705527401; cv=none; b=Ot0Jp2bem3O+az2Pi+lCSsirJTHDX/Qbmeztff8obfntYpUaz+N1okT7KtkT/5sSgqNUHYxEgL6U8KC1bkdxrcKid329m6X92ING25EO5QYvAkqMwciWFQ3YLi/QRMw0ul0WRUudXT8uOoQabzmFN84EhCcOqxBLqPRNBkV0JWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705527401; c=relaxed/simple;
	bh=lA6M8gEUJLK7fCT56iIOKJrj+U4Uv9xtc45Zuw3Ol3I=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=oTJpe8hZPAIQ9WJ4Ks/Akm3DGpo/PVFuItZyCzTKLTKcUfGGlPNgxTiK+DJf9qluyKtBlsn46gQlIbNBQ/RRPKZxG197gsnJNhZYRVprqp9DirRLgGn10NMWaOpte/A5mC/GLGlNMr5X+sXCX9dLBKxbF6qpmAjlpqZlVfExRyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WvnnR2+s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WvnnR2+s"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40HLRm2L030191;
	Wed, 17 Jan 2024 21:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=M4I/ArEljxgtf0S/INVAsPPqpW8qbOPlLJ/YVrHGj/s=;
 b=WvnnR2+sQlLTKegtqHtSV8Z94X9HpHQnLkhefEfvNUtQ8x0abewCRaevOohBPs4fze4V
 NJ7D2b9NolCe86yVN+89LpgvGH6JALIdcrOG51mnziMCBSeaycqvYLd+iv6sScPjRPAW
 /swH5XWydThBpUbzVGJut+H9oFvGyJD6s6tHCdZvL3KRmsh9Rn0U0ZBzMdUxK7AdpTB/
 Qq79bGGIBC7KSICvvLUjhbu3eFcQfhrC/ZrK3nVEPzkBHTKGcnJliH1FQ/Zg7EM9SFhC
 nY3vmGUt1UT7OdT0IMfutN01TS2mfuJc8uHFw223Wr44rV6vIasTUhkt+zROUl+Xcry5 Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vppu1877c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 21:36:35 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40HLSnMB001283;
	Wed, 17 Jan 2024 21:36:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vppu1876r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 21:36:35 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40HJesoU000538;
	Wed, 17 Jan 2024 21:36:34 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm4usyyc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 21:36:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40HLaYjY19268196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jan 2024 21:36:34 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B01F58050;
	Wed, 17 Jan 2024 21:36:34 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68EF758045;
	Wed, 17 Jan 2024 21:36:33 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.ibm.com.com (unknown [9.61.108.244])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Jan 2024 21:36:33 +0000 (GMT)
From: Brian King <brking@linux.vnet.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] scsi: Update max_hw_sectors on rescan
Date: Wed, 17 Jan 2024 15:36:20 -0600
Message-Id: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RwzfGfw_LPYcDMEEIq2Usf_7lWqt8JWc
X-Proofpoint-ORIG-GUID: OmcSHuYNGY8LvQTd3vAufue5vzhWImoQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-17_12,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401170153

This addresses an issue discovered on ibmvfc LUNs. For this driver,
max_sectors is negotiated with the VIOS. This gets done at initialization
time, then LUNs get scanned and things generally work fine. However,
this attribute can be changed on the VIOS, either due to a sysadmin
change or potentially a VIOS code level change. If this decreases
to a smaller value, due to one of these reasons, the next time the
ibmvfc driver performs an NPIV login, it will only be able to use
the smaller value. In the case of a VIOS reboot, when the VIOS goes
down, all paths through that VIOS will go to devloss state. When
the VIOS comes back up, ibmvfc negotiates max_sectors and will only
be able to get the smaller value and it will update shost->max_sectors.
However, when LUNs are scanned, the devloss paths will be found
and brought back online, still using the old max_hw_sectors. This
change ensures that max_hw_sectors gets updated.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 44680f65ea14..01f2b38daab3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct request_queue *q;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 				*bflagsp = scsi_get_device_flags(sdev,
 								 sdev->vendor,
 								 sdev->model);
+			q = sdev->request_queue;
+			if (queue_max_hw_sectors(q) > shost->max_sectors)
+				blk_queue_max_hw_sectors(q, shost->max_sectors);
+
 			return SCSI_SCAN_LUN_PRESENT;
 		}
 		scsi_device_put(sdev);
@@ -2006,4 +2011,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
-
-- 
2.39.3

