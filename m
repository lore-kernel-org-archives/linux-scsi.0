Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA771CAB5
	for <linux-scsi@vger.kernel.org>; Tue, 26 Mar 2024 01:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416129; cv=none; b=ob2AhpuhDu0ZQx6E/NMSYcQ6KKLqw/hnPPQUm2ZVQ8OEvFl2eUNHNINd1XHNszm5w306VuFvw3wTldqrlwU0f0pPzm+c83lUCb3zNYFsI4JH7nHiTO79VHypPWmLGKzpd0z6LXdhqZVrWTgbLiTqkd50mCKtIaU33i1dNPiLZVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416129; c=relaxed/simple;
	bh=fpkuXu3toF73tE4C0/UgnIlwrJqGT1hAv9VPGCNuuA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMl34AhEIwDSLWWyPHLABjxSiKOXpVaz594HkyWkwYDGA30kzvyehKfWo9kQfVGZNLjf4KA2DliJadyjQV58/LuRZJE03Ld751bqCdePRS6bUBE8C87CIXPyJGIjI6FIM4St+Ktb0lSf4AQijSjGvfAHhXcSfaGwgnrQ1bm++Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fqVePHnq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqVePHnq"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFsrQ027120;
	Tue, 26 Mar 2024 01:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=QItjxnb9sH4xH4iuDyNmiQ6Qgqx+hys/WgNMjuKydZM=;
 b=fqVePHnq3d5Yji4RTaZ1IjYbcZ7fKWSbCEQ4cHh/zZe30+vLznwTiBoncL2+bVamdAS3
 a9CU8U8373KVXlhjXIvSvbd3vHWZ+bQ6/JnOGGoe8d+S74akV912kLpS+XUBDti5Aeuu
 xYzBN/bAu2pJcCR/8zvv+rQmjxkG+wW8++v2s961D7y22Zsou7gxFgShdbJHnWaQN9KY
 6jAX7P/oNpegvtkloPSHBMFopz1jcBY7XP1pgyj+KVyPyhe729OVOULPFRn3vZejYd+J
 9XhsQgmHMpWGudY/fB7zv9ZlHpvPHLg+KD8UTQIX+VZTVhPgTlFlqr/wYHINRTiwq+4V yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybkw5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q10Hhe024407;
	Tue, 26 Mar 2024 01:22:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6hfsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:04 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q1Lx4E002449;
	Tue, 26 Mar 2024 01:22:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh6hfkw-4;
	Tue, 26 Mar 2024 01:22:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Date: Mon, 25 Mar 2024 21:21:46 -0400
Message-ID: <171141606214.2006662.17226837967143528490.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240323084155.166835-1-shinichiro.kawasaki@wdc.com>
References: <20240323084155.166835-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_26,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260007
X-Proofpoint-GUID: x7fpNVPQg1kHnDzKjwVAG8Kdg0v2p07g
X-Proofpoint-ORIG-GUID: x7fpNVPQg1kHnDzKjwVAG8Kdg0v2p07g

On Sat, 23 Mar 2024 17:41:55 +0900, Shin'ichiro Kawasaki wrote:

> When the "storcli2 show" command is executed for eHBA-9600, mpi3mr
> driver prints this WARNING message:
> 
>   memcpy: detected field-spanning write (size 128) of single field "bsg_reply_buf->reply_buf" at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 (size 1)
>   WARNING: CPU: 0 PID: 12760 at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 mpi3mr_bsg_request+0x6b12/0x7f10 [mpi3mr]
> 
> The cause of the WARN is 128 bytes memcpy to the 1 byte size array
> "__u8 replay_buf[1]" in the struct mpi3mr_bsg_in_reply_buf. The array is
> intended to be a flexible length array, then the WARN is a false
> positive. To suppress the WARN, remove the constant number '1' from the
> array declaration and clarify that it has flexible length. Also, adjust
> the memory allocation size to match the change.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
      https://git.kernel.org/mkp/scsi/c/429846b4b6ce

-- 
Martin K. Petersen	Oracle Linux Engineering
