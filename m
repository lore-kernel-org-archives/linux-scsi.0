Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1F97FBA2;
	Wed, 25 Jun 2025 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750815879; cv=none; b=uVSyfUngGXfI6jzr5iGhG+oWLSwc58W9wRkYD8T6mwYFst87+4/bPzLi9q3QufAe1ng0LyNAX50bMDb2csdIyJ93pILYUzec+kpQCdH/N8VSDtSFKPSLReq7/uX1+mrqbZAcsbJ/u3d5VrzPw+X6ZwXuDihBA1hZL+iji1OBn3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750815879; c=relaxed/simple;
	bh=q+lkR+Q3myJnU2BTFnhJ0dpoNElPjaRLuyXtNOyzILs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3yhVXiBhLfcfdpZnz1JL3q6HgSdIkMqQ/H9YI9Y9Ydj4exTXDFen24IYteaMzPxII7RTYgnx+jJTurwA2iRl6avR+TSnY1s0K61NV7NBhil8MIYZt1pnY4URwXoWcg7Jzwh/8Kq4UfzzdlY/4afk6NxWM9+aAIPOSHEY4Sj7vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hoRdAXwd; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hoRdAXwd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMie1E029818;
	Wed, 25 Jun 2025 01:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HeMUlAcC4+ccYJknpN9DQDGn0GxQoyBhn8A0w16DCws=; b=
	hoRdAXwdgQUw8oQPjKghRTHeEcVeH7lbq6M9X84GD9m306IEgiCtEJZzQjxgdQhZ
	h4ulmRGqiJFqU0nSb6gBVG6DfmHCiYDBExXYfSlFa+A2EnNm91AUAYcWETyhTSno
	qLH9thQ6Dk92kpFPnM/dP41SqKkLUAoj/nREKgWs0XSqvJgaL7voUOfQwSq5TF3v
	NbhZobhCxHWJjoYGzyAmdEprJ7pp6aztmN/8KFKAouoTwa7K33uOqOtm3hi2gwnd
	fQR+0/uwcuRNhR52lNGtWexkET9eMu0ZKXsV0NJQ+GG2j3tLdQMv25pwmaOqDvsq
	Kk6B1zRPFHv6gT9TtNb2vA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8y6d1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55ONhWUK005652;
	Wed, 25 Jun 2025 01:44:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq4e6r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:33 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55P1iVGC007157;
	Wed, 25 Jun 2025 01:44:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq4e6pm-3;
	Wed, 25 Jun 2025 01:44:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Francisco Gutierrez <frankramirez@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Free allocated tags after failure
Date: Tue, 24 Jun 2025 21:44:02 -0400
Message-ID: <175069824519.1717808.5921410148275001864.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250617210443.989058-1-frankramirez@google.com>
References: <20250617210443.989058-1-frankramirez@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=715
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250012
X-Proofpoint-ORIG-GUID: fJJbJzNyZzigXGhNIDZXQd8AcV_14Ga5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAxMiBTYWx0ZWRfX/DPXXq22KPju SaiEYByx3gukV8Vssf9kjuOf1RFp5gbS3/GZh47nRet6sCKc8wILMeIdyqM+h1P0bqMivhMsM7H +5S0HN7kH7GOv5wXd2LuzT8lfuGMgVwtS3yd17CI48evNbUViKpSBmpk0YlAfH0WHs7NGTzNqJy
 vqPbIW/pQ2zyIzOhjlRdgK3KgV1ZtOkSqyYXCfVbW+iqMU/6F5ANoH7uBuGRzxXZ2ENH8HUWk9P IcdjZgvnXgXGpH8sr6LWP4jfgJ9dP9XbLkIqnSKO5MKD2sfFsyK9X0AB0n8k7IMiNH7nE1KNdEc kJP+Izam5mit3LxSt2IwaSU8PiebkTYMz4Ww7fTQn+Tp52/kJHjfb5ksWXOE8G0lr7qKbB2d8/A
 TmEjjFzTYvv44DqB4YoQ4tzvRabS37PQydRqV4Kzd8V9WE4pEyKWWGdgQu3uT0mtS3p10lO4
X-Proofpoint-GUID: fJJbJzNyZzigXGhNIDZXQd8AcV_14Ga5
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=685b5482 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=0gEqvKy8egvCYf2HugAA:9 a=QEXdDO2ut3YA:10

On Tue, 17 Jun 2025 21:04:43 +0000, Francisco Gutierrez wrote:

> This change frees resources after an error is detected.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: pm80xx: Free allocated tags after failure
      https://git.kernel.org/mkp/scsi/c/258a0a196217

-- 
Martin K. Petersen	Oracle Linux Engineering
