Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E7A1FDE31
	for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 04:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779683055; cv=none; b=ih06XooRqy5FPf3EThT+XM9UZo0wi1Hv14g1Zi55flqObukxZbWlfAcxm5kO3Z/wx+wfAhHypPmMuMrDlo0Sv+Oel2NlqPG6+g1K7uk3hmQfn/mdMf3tvHVfhz/9j7yw+SL6zDWpXvwFvZumqWutMJ/pDHXn/eyv5hrtMVTXWmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779683055; c=relaxed/simple;
	bh=3zNJzPapyLUZGmp22HFClkEK0g6yGt94lWseoKICRSE=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:Cc:From:
	 In-Reply-To:Content-Type; b=AUAgJSYnuxS+hadBxzP5Do4h7vLR+uYlM1q7+qf5fOm2HZ3Lhe9RF+dExQEWeY1d4NH5dRFUKJw3Jn+tF+/ddTPYqgFln5uyGgJICdXYBn94uKQe9PYVIw9axlmzvXNty1ap441et4nCKwZZ3o2I3mrOUyY4MHALoP6yKD42TgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=paZq2Zie; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="paZq2Zie"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64O89JXS955810;
	Mon, 25 May 2026 04:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D/X8iF
	J3yoL0+z6JDYUwxDizqupTEkkgAPY+YWp2iYY=; b=paZq2ZieGqO5f/0EuaEDFb
	LPJxDQHAg766k6eJPupzpYH7fhZZTNAgBIPNK7y6OyvAH0lNsFPQsKZSHZta7L6L
	ehuuwuyE4LErFV7lbiIJibgeRSvXf5qr6//A/jvYX5RT6PLvYPHHrQRK1CKK0LCv
	MWHPZW4nUhjCh+SYvdC6RiB2/B2iNtLPhHJCwUdk4U+sUNboY5cBW/01LOMzQDL7
	HFuN6/1r8/VTvIdi5Tg7fHAin7duS/uz8OIVuyg9gg0qj8af9+SxuJHDJfiAN68e
	+ugWfJppxR8LSgsvmCb6Po3aYPwea0tS+GMrrCKvxYXqU0zwpP7Akz5oxVb66SOg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nue4x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 May 2026 04:24:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64P4O6Zr003003;
	Mon, 25 May 2026 04:24:10 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ebs8y3fkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 May 2026 04:24:10 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64P4O9jZ32178764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 May 2026 04:24:09 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A116258055;
	Mon, 25 May 2026 04:24:09 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A6FE58043;
	Mon, 25 May 2026 04:24:07 +0000 (GMT)
Received: from [9.124.216.140] (unknown [9.124.216.140])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 May 2026 04:24:06 +0000 (GMT)
Message-ID: <4cd39454-63c4-457c-a8e1-071ca090f8b2@linux.ibm.com>
Date: Mon, 25 May 2026 09:54:05 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while
 passing through
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Language: en-US
To: linux-scsi@vger.kernel.org
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
From: priyama2 <priyama2@linux.ibm.com>
In-Reply-To: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
X-Forwarded-Message-Id: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDAzNyBTYWx0ZWRfX33/nL9b1TF9G
 AfPG6xWkW5z3F1DygsrTzGxU2Q6NQwAjE1LhQRJ5m8zaDGBRmSFAdBTxbxPoMGciYvLycDoMQ5k
 tnINXMNBGJsTd7JYmqUXHSf1OC6xOGEeO2KLvBUSMgsnaCyf9nISo1KzUjFtcMGfRAlj3T+V+De
 QoTtNzUHdcZGU8FbIj6rgPLwwqhl0qvwTS1CJXa/2qzbDnKtHqM68oilXpttrUtscMr1xFm2FSr
 ZcAUc82Y0R5cyokhgMTEGUNaAZ4587apoSB49B7Lbg8jvnY1vnMvHSoyY0Bav411lWWDIb1v1o5
 N1X0JeOuSDTvCV+2HsDLzvTEpTRXSrl7nd7wff+4I4NAlDphDgIt43ZzQC2xteF5gjGOymZcPS7
 /SbK//HutWISOrs8vu8FqF/VZGiIJvZwbVF+2kjqsWDTc6WixlUSVOn3DN5EFSEcXI6qBa3/QFL
 kzxp/96bxXA+q/tEOTw==
X-Authority-Analysis: v=2.4 cv=UtJT8ewB c=1 sm=1 tr=0 ts=6a13ceea cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=M5GUcnROAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=Ikd4Dj_1AAAA:8 a=eWwfjLbnGiDjUh8komIA:9 a=QEXdDO2ut3YA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=zSyb8xVVt2t83sZkrLMb:22
X-Proofpoint-ORIG-GUID: 92NZF9Ngd0-TN2mIBMdUvgkNQuAJPabf
X-Proofpoint-GUID: 92NZF9Ngd0-TN2mIBMdUvgkNQuAJPabf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1011 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605250037

Hi Shiva,

I have tested this patch and can confirm it resolves the issue. Could 
you please add the following tags to the patch in v2:

Reported-by: Priya A <priyama2@in.ibm.com>
Tested-by: Priya A <priyama2@in.ibm.com>


Thanks,
Priya A



-------- Forwarded Message --------
Subject: 	[PATCH] [SCSI] qla2xxx: Handle the INTx not connected while 
passing through
Date: 	Fri, 15 May 2026 13:45:18 +0000
From: 	Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: 	njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com, 
James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
CC: 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
alex.williamson@nvidia.com, Kyle.Mahlkuch@ibm.com, sbhat@linux.ibm.com



The PCI_INTERRUPT_PIN reports if the device supports the INTx.
However, when the device is assigned to a guest via vfio, the
PCI_INTERRUPT_PIN is set to 0(i.e none) if the line is not
connected and|or the platform cannot route the interrupt.

In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port
number becomes -1(255, uint8_t underflow) for qla[25|27|28]xx and
qla2031 devices. The flt_region_nvram is never set, and subsequently
the lun detection fails. Below warnings show the NVRAM configuration
failure.

[]-0073:1: Inconsistent NVRAM checksum=0xffffffc0 id=HCAM version=0x100.
[]-0074:1: Falling back to functioning (yet invalid -- WWPN) defaults.
[]-0076:1: NVRAM configuration failed.

The patch handles the case, and sets the port_no to devfn like
its done everywhere else.

Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if 
no pdev->irq")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
drivers/scsi/qla2xxx/qla_os.c | 15 ++++++++++-----
1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 72b1c28e4dae..a8d6a0a021f4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
else {
/* Get adapter physical port no from interrupt pin register. */
pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
- if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
- IS_QLA27XX(ha) || IS_QLA28XX(ha))
- ha->port_no--;
- else
- ha->port_no = !(ha->port_no & 1);
+ if (ha->port_no == 0) {
+ /* None of INT[A|B|C|D], may be virtualized by vfio */
+ ha->port_no = PCI_FUNC(ha->pdev->devfn);
+ } else {
+ if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
+ IS_QLA27XX(ha) || IS_QLA28XX(ha))
+ ha->port_no--;
+ else
+ ha->port_no = !(ha->port_no & 1);
+ }
}
ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,



