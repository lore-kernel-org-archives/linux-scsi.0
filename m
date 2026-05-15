Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C3C480DEF;
	Fri, 15 May 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778852791; cv=none; b=OewCGw3xR9EL2tC5g6fc1vC5SXbItU+DAgfQn275IML4l9AqbPMYgwFDwXtuk1n74GafIl6g6KuPaVWkXVNJ+cgMP4J/T5swDmPetf34zmIFnO7/ERh/DVGtc2VSnZ9Q3L0o8ZE9aNOjF2ZpVi4Al4jwQMvuCmQf4cazL0vRfnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778852791; c=relaxed/simple;
	bh=81UqEVkVLTYCPXj4aX2YNEUB7CL7+8kPe84x45UH1Hw=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=SJb09dSJ5IvZLJ8xLYalyFlSJoc5oKGKCUvFQmYthyhg0ubjciyDIXcYxtivDOL6vJamxkP+muepyjACOTBxpMv8tBcx7+SNjAQ+GQhjyqUbWqFu2EIRMMljbpE8Kb4oqZw6aIeZMRI+0QsviUJjrbWy8W4LSyerd/1OTUaMTq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G4NTAM3c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G4NTAM3c"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FAi3p21093132;
	Fri, 15 May 2026 13:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=OYft5ur67gi5+CZcF2zboSkju6tE
	SX/wLKq25VKxSAM=; b=G4NTAM3c+sML8yOVnBHAHIMl7QHGZb/rmnYcl1oqxkgd
	JXpJAuYfoH7hU0FhG6OXtJs1dZqTaxgw51ZWaNn2Y3xkFVo3D9fy5oWldf6XVqSp
	LEgtwrXASzqE+RNr7NesVs2H19UrSvy2g6V3DeOinV9CSfDtPpSbGY4Uk4GzlHWF
	FSvR+b6OuMh976zDT+XEI0ijx4IIU48wZmM9eQ+ItxIsSAV66vU69YzIxjtoyrxo
	2sU60vxoBG31Dt+sQdtW0NfrMqtIYXCMCMbycJh4TOzcOHrIC66ZOX974doUhwWx
	FWfqSKIqwexiPsumkOOcWLzw9Gk0AZLsJcb/Pk2ziA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e5m93baqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 13:46:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64FDdJwo011759;
	Fri, 15 May 2026 13:46:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e5m3aknwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 13:46:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64FDkKfB51511754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 13:46:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C3C32004D;
	Fri, 15 May 2026 13:46:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEB6F20040;
	Fri, 15 May 2026 13:46:18 +0000 (GMT)
Received: from [10.88.0.2] (unknown [9.5.7.39])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 May 2026 13:46:18 +0000 (GMT)
Subject: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while passing
 through
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@nvidia.com, Kyle.Mahlkuch@ibm.com, sbhat@linux.ibm.com
Date: Fri, 15 May 2026 13:45:18 +0000
Message-ID: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jbze0d6DuHwYyG3gd86o9fOWMTJwWMkS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEzOCBTYWx0ZWRfX7aPLQXQnObuC
 puHPRYM4aIngU5RTfm8gHJB++KgjxQ0Y+laNAbBybwczO5ep7Kk98eQyoqHhcVeubXucsuJimAk
 h2F6XtbbMjpPaqKMazxe7d76zmkwf1yWHZNxT76rD8T/6gu9mwDozLPNdXjR9WjMMdniZNo+uu3
 kybzQAu4FGmxZdDzrb4XWPJNeZgWG136e2hLnKBhtYSapMRARUimI2WdGssTGOiyofqkn012pZ9
 UlS9Uvzw3a3KYe9t1qO2skGhP0Kv+I4Csmp8BJaKmqEr2IcVWZ93XvuQmldPrOaX6nAK3+WTL5p
 YoDdQgqYJlw14W1rJDQdddO//ETWj26m5U5n3hZ+gs85OB3WBngujzAZo86NISCTQZvree9Bp3/
 Mo9a4Fr7VvmpkNZvWS93cbfgsgb1DiiYQeZbUJgc/18CUcef/jEGm9UahcIG/362eXyIBzXAmF+
 0a+VLb9JYXf+C5xeA3g==
X-Authority-Analysis: v=2.4 cv=P6UKQCAu c=1 sm=1 tr=0 ts=6a0723af cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=3Wnuu8rudESo8fSp9zUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Jbze0d6DuHwYyG3gd86o9fOWMTJwWMkS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150138

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

Reference: commit 2bd42b03ab6b ("vfio/pci: Virtualize zero INTx PIN if no pdev->irq")
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 72b1c28e4dae..a8d6a0a021f4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2803,11 +2803,16 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
 		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
-		if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
-		    IS_QLA27XX(ha) || IS_QLA28XX(ha))
-			ha->port_no--;
-		else
-			ha->port_no = !(ha->port_no & 1);
+		if (ha->port_no == 0) {
+			/* None of INT[A|B|C|D], may be virtualized by vfio */
+			ha->port_no = PCI_FUNC(ha->pdev->devfn);
+		} else {
+			if (IS_QLA25XX(ha) || IS_QLA2031(ha) ||
+			    IS_QLA27XX(ha) || IS_QLA28XX(ha))
+				ha->port_no--;
+			else
+				ha->port_no = !(ha->port_no & 1);
+		}
 	}
 
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,


