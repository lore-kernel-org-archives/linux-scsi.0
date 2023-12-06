Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DMD/SDtg"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665581AA;
	Tue,  5 Dec 2023 19:16:23 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B61xv4m019441;
	Wed, 6 Dec 2023 03:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=Ndo+OzVgUR3TxIcbF2kTQPE1DcugcsGSIR50oprEUIc=;
 b=DMD/SDtgkrcZqnKphzMvXMk1UijBiOdWOAodW+nMSjM9iDdcWwrODQfefIFEkB9LNMAj
 WENykQkXceJa+UEqRDPD+bd4LNPzXrQAp9HRxc8j37F5EYANv4KrcbV67zyS2djLbHH8
 cQEcjImcKCAYC/Fdg7Q4P/v515ekX3g5HgJMRWNURRwvY0OjdtEx81qA8NldpmXRg1np
 22ovjsZy/UK+sr+ly9y4qeB5mygqeT9MOmqWgAAd9YllE2qiub+SbzrQiApxH7vZ3n7V
 +OlYAQ62FDjl9k05ezKgL1NeSNATbT8/bk4uFzt5xotbKYxGE10+vh3178vjIIifsH4T iQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdc187c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B62VZJr036659;
	Wed, 6 Dec 2023 03:16:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utan96852-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Dec 2023 03:16:13 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B63GCYN014062;
	Wed, 6 Dec 2023 03:16:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3utan9684d-3;
	Wed, 06 Dec 2023 03:16:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ching Huang <ching2048@areca.com.tw>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/3] scsi: arcmsr: support new Raid controller ARC-1688
Date: Tue,  5 Dec 2023 22:16:00 -0500
Message-ID: <170182644886.1446429.18288780625904064068.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <110bdc873497d3d5e090b908fb159b6155bb3a2b.camel@areca.com.tw>
References: <110bdc873497d3d5e090b908fb159b6155bb3a2b.camel@areca.com.tw>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_01,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=640 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312060026
X-Proofpoint-GUID: Yv0IVBcA5r_cIzs_a9Lj4HZ4uRve9ROj
X-Proofpoint-ORIG-GUID: Yv0IVBcA5r_cIzs_a9Lj4HZ4uRve9ROj

On Mon, 02 Oct 2023 17:42:19 +0800, ching Huang wrote:

> This patch supports Areca new Raid controller ARC-1688
> 
> 

Applied to 6.8/scsi-queue, thanks!

[1/3] scsi: arcmsr: support new Raid controller ARC-1688
      https://git.kernel.org/mkp/scsi/c/14ef4b001ae7

-- 
Martin K. Petersen	Oracle Linux Engineering
