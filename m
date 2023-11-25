Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z1Jd2iBt"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5141990;
	Fri, 24 Nov 2023 18:53:53 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP2dChY004721;
	Sat, 25 Nov 2023 02:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=ePTKydImVNIFpNDWnTWJEULjDXSFh4p7Dw4UCqdPR+A=;
 b=Z1Jd2iBtvUI6gc7xkAx/ZbhxI+lGf8QMqljrQLUaX+CQmHRub/cPnewWklqnlmXO8Mvs
 P4HFlRDCkAyxWQ3BMsQOLltE7zF1Ma54sOrk24zB/+yYu4I4V/3HUhR+eCHgSUFwAn6i
 NHfVYCdSy9O6mEjS+lKpO+N/p4a7blXJJbYv/I7K92dDwhmwghbCfaxaVp2WBPm0g2wY
 XjovDYg6I5u8fitulwSjnt1Y/tzI/6y0Z83SJWzujse9c5Y1xUNtcEuGFf4MZrf790Tw
 q5hUAwwTMTps+RbYJ/7BNcYCCljYgyPqWQ5mZ+YStkQ9U0oFb9kfFn6UEulDNuYwfJZ4 JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uk7ber1n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:53:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1YJRV013555;
	Sat, 25 Nov 2023 02:53:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c8sr38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:53:46 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AP2rjMV036557;
	Sat, 25 Nov 2023 02:53:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uk7c8sr2v-1;
	Sat, 25 Nov 2023 02:53:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
Subject: Re: [PATCH v2 0/2] Fix runtime suspended device resume
Date: Fri, 24 Nov 2023 21:53:34 -0500
Message-ID: <170088060609.1367702.5631085509425573780.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231120225631.37938-1-dlemoal@kernel.org>
References: <20231120225631.37938-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-25_01,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=616
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250020
X-Proofpoint-ORIG-GUID: CegJFLZjVS4wt4lgnFCqsOnuH2m0HgP5
X-Proofpoint-GUID: CegJFLZjVS4wt4lgnFCqsOnuH2m0HgP5

On Tue, 21 Nov 2023 07:56:29 +0900, Damien Le Moal wrote:

> The first patch changes the use of the bool type back to the regular
> unsigned:1 for the manage_xxx scsi device flags. This is marked as a fix
> and CC-stable to avoid issues with later eventual fixes in this area.
> 
> The second patch addresses an issue with system resume with devices that
> were runtime suspended. For ATA devices, this leads to a disk still
> being reported as suspended while it is in fact spun up due to how ATA
> resume is done (port reset).
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/2] scsi: Change scsi device boolean fields to single bit flags
      https://git.kernel.org/mkp/scsi/c/6371be7aeb98
[2/2] scsi: sd: fix system start for ATA devices
      https://git.kernel.org/mkp/scsi/c/b09d7f8fd50f

-- 
Martin K. Petersen	Oracle Linux Engineering
