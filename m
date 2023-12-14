Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IpkUwNWa"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F31111;
	Wed, 13 Dec 2023 20:29:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0S8PT014198;
	Thu, 14 Dec 2023 04:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=n39mVTkPVz6dQ6k8si0hmgulTiuGKemMH0YL3y2LjAM=;
 b=IpkUwNWaZxdlIBJiQCbiXR33Wed3e3eR88PW9bFlSShaUdSci/FfMKIsYlLiMYzS1iqH
 dsSJJswoXWjiH5uhiryB1uEniJvgCY1fx/HEEO95bOwhP+Z2sSLAvVzribBbODfqW0aW
 H65LRqnw8KqzXY9vrxka24x/RgqCX61svCLLoYVKIl4uw9ZAM1O3C0EaS2aLvuYKSxXa
 u7Y3PqoHP5Nastya1PUGr12HPs2jqP2gyoqehDrLlVnaWnNjTpJY0Lq6KJF+DLOzLlyL
 ZaSF2/FYB040jlVk0T5GEpAKTghIaF4dHPRwoTmYIA8R7tNXdcV9vZk5c+ZCe/7Q089I gA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwfrrr80p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE46m3q009809;
	Thu, 14 Dec 2023 04:29:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQMK035965;
	Thu, 14 Dec 2023 04:29:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-9;
	Thu, 14 Dec 2023 04:29:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Azeem Shaikh <azeemshaikh38@gmail.com>, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: zfcp: Replace strlcpy() with strscpy()
Date: Wed, 13 Dec 2023 23:29:14 -0500
Message-ID: <170205513094.1790765.1831681257602752476.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231130204056.it.978-kees@kernel.org>
References: <20231130204056.it.978-kees@kernel.org>
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
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=942 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: rUSrRzEa_gMTd1iA_Sn-t0nuVLhPretp
X-Proofpoint-ORIG-GUID: rUSrRzEa_gMTd1iA_Sn-t0nuVLhPretp

On Thu, 30 Nov 2023 12:41:00 -0800, Kees Cook wrote:

> strlcpy() reads the entire source buffer first. This read may exceed
> the destination size limit. This is both inefficient and can lead
> to linear read overflows if a source string is not NUL-terminated[1].
> Additionally, it returns the size of the source string, not the
> resulting size of the destination string. In an effort to remove strlcpy()
> completely[2], replace strlcpy() here with strscpy().
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/1] scsi: zfcp: Replace strlcpy() with strscpy()
      https://git.kernel.org/mkp/scsi/c/0d224b1088af

-- 
Martin K. Petersen	Oracle Linux Engineering
