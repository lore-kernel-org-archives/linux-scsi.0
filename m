Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BDXX+TpD"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B5210E;
	Wed, 13 Dec 2023 20:29:39 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0S68Q015237;
	Thu, 14 Dec 2023 04:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=RvdU+eGC4ngETt79/crTUc+wC58vE7cGMOLzTyZkW18=;
 b=BDXX+TpDBHFB13pjycojtoL1mHwt05O6N00njSUbe2NTlUAhgg01xRt8YXKfyOM2JDFh
 hCEyb3rOkq7AEHKcMjXsYhwSIooYafHAw9ZDYm2ivItTVX+CyvQxpEH0r8enSC7Jug/1
 5O9is5/D+dYxiDWRjCIKrqdyn3MEWn3pxMtVENDVXCBMCJBOYLbd6FAT2gi8QEEWIZzy
 OaRUB4RZZNwOkFUgfSn6X9lU5H0eGjge/KM/jzenQQKKkYfvxLa8PTsFC9iJUiqgTYB/
 YMQkmDwK4+Xua+r4lCDIKEAOE5tZOOYKfZZ8X/jmq4KMDTTI+dNBox5uBEJk6HALeDnf Qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3r25h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE3VDsg009880;
	Thu, 14 Dec 2023 04:29:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQMQ035965;
	Thu, 14 Dec 2023 04:29:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-12;
	Thu, 14 Dec 2023 04:29:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dan.carpenter@linaro.org, hare@suse.com, jejb@linux.ibm.com,
        Su Hui <suhui@nfschina.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: aic7xxx: fix some problem of return value
Date: Wed, 13 Dec 2023 23:29:17 -0500
Message-ID: <170205513103.1790765.4968317086023951869.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231201025955.1584260-1-suhui@nfschina.com>
References: <20231201025955.1584260-1-suhui@nfschina.com>
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
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=699 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-ORIG-GUID: 7M0uoYfCZcKvOF2q8Jvt-IvYvDZtf8zu
X-Proofpoint-GUID: 7M0uoYfCZcKvOF2q8Jvt-IvYvDZtf8zu

On Fri, 01 Dec 2023 10:59:53 +0800, Su Hui wrote:

> v2:
>  - fix some problems and split v1 patch into this patch set.(Thanks to
>    Dan)
> 
> v1:
>  - https://lore.kernel.org/all/20231130024122.1193324-1-suhui@nfschina.com/
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/3] scsi: aic7xxx: return negative error codes in ahc_linux_register_host()
      https://git.kernel.org/mkp/scsi/c/573eb4a3410a
[2/3] scsi: aic7xxx: return ahc_linux_register_host()'s value rather than zero
      https://git.kernel.org/mkp/scsi/c/70dfaf84ec77
[3/3] scsi: aic7xxx: return negative error codes in aic7770_probe()
      https://git.kernel.org/mkp/scsi/c/aef6ac123609

-- 
Martin K. Petersen	Oracle Linux Engineering
