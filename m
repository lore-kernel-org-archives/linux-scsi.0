Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A6747E
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 02:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LoNDLmJi"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0Jnfh025828;
	Tue, 19 Dec 2023 02:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=FutU6KlvSw9IqwIsXW29jR8RfzJqTPV1hiO4BTF8au4=;
 b=LoNDLmJift5VanM2ZfFsoBwcnt9FjMybSxZaWhYW5c1BE7E+j1RGGANsQArbB+uQUvHu
 9w6BN/iB/GFdy5cFsgPX7pcEf7LftaNzME//mSLMxKqY4cQTw/Gm2veWdHJf4IzCHLrc
 QA6V3CzQKGYnS12N9DknYG1Vdg4bG1Bkt1HnYQ/cPpJLeOC6BC0jKeIk+JpBCN48Sy49
 j8jvZcW7TucBH8++nnRy7kJFNVoicTsks2IBc/BdJ2hAj+rE6H8Z8AkYYgeh6Mit6jCz
 aE1ITAYl4c7zM/TRSFkf9sSpjX45/qUdDcUlWN8jXhB4lmH8kO5I/OQX0LA+Xa8fTnBY dA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12p44upg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ1p41F027486;
	Tue, 19 Dec 2023 02:19:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3v12bc5j4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:46 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJ2EbhX009328;
	Tue, 19 Dec 2023 02:19:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3v12bc5j3x-3;
	Tue, 19 Dec 2023 02:19:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Maurizio Lombardi <mlombard@redhat.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wei Yongjun <weiyongjun@huaweicloud.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()
Date: Mon, 18 Dec 2023 21:19:37 -0500
Message-ID: <170295223222.2870516.2622033685137977637.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20221114110626.526643-1-weiyongjun@huaweicloud.com>
References: <20221114110626.526643-1-weiyongjun@huaweicloud.com>
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
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=590 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190017
X-Proofpoint-GUID: opHR4erCHYQk_tEYZFIB2wr0qj2E5JC6
X-Proofpoint-ORIG-GUID: opHR4erCHYQk_tEYZFIB2wr0qj2E5JC6

On Mon, 14 Nov 2022 11:06:26 +0000, Wei Yongjun wrote:

> skb_share_check() already drop the reference of skb when return
> NULL, using kfree_skb() in the error handling path lead to skb
> double free.
> 
> Fix it by remve the variable tmp_skb, and return directly when
> skb_share_check() return NULL.
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/1] scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()
      https://git.kernel.org/mkp/scsi/c/08c94d80b2da

-- 
Martin K. Petersen	Oracle Linux Engineering
