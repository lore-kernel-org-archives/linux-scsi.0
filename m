Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1576230EF6C
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133178; cv=none; b=iKAHamokQY8oxiYnhKXqPUQacYUyYAM3dkAUrscE6/Rrr3bFJujRgXutj93tdiy1WfIXVpCF4Y2x3pXFFRHb6OrTJ/lEWH5QCRiPJLxFdYon84wwybm12ftUCd5vCcTFol7PxlCIrG3B1JsrEwRz29tgIKyDZe9SD/2I7+POo84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133178; c=relaxed/simple;
	bh=CbLF+wunbjohe2LNJ3BQ980wWChJkplbqjAJCnbAtkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzcSmy45y+SgsmZIotG1YyA+NGjG7OOVCwL/6CBwC/Ea955ntcZ7DuKKxR0igva5fFUPdJCXVRU8IdRlJjs05r1UGN0gqWiklmFebmP4OFa7hTtxaQMZFPLfGnN6qkX6imcyfbZ/k+IbJorBqEHQaCJCz5akAhv7681FNFWB5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=emCbZ+/k; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="emCbZ+/k"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLESXG3851326;
	Tue, 14 Apr 2026 02:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wO6w9BmSdjFIRWgWIdSbc3glrtnLi46DjH8jipkp/Mo=; b=
	emCbZ+/kPb0VMN66fyTwWLs59IC3iKkN6MAOiZ0GvXPkQRTAGlWV0jAUVr2bu9BF
	SUos2UDixR8xuWiAr17zL77jUQX8WFNLYKPxymL9ZTBXcISBBX3THufUxJstCMEW
	iarEOvIb7cS7ECRJY8wLWBrqODrUu9cBWzfRPrxr7tHDlaIzf5vS/g/QCsozeYQr
	YIut/RP7fNwKLpq0pdv4O6RfCC6LhLTX054oxP+FtXuQt09dtDmfvtZd1/rti/4e
	fXNSzvjyAXuPIHWDaPUMYp9N1xCDVjO91aGb64izvjA8yeJagNuj5xwDpQNzH8k+
	2y40GxL9NNgsKMosXMzp7Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87m8ag4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63E2EK0P023590;
	Tue, 14 Apr 2026 02:19:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nj0nte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 02:19:32 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63E2JTjh036955;
	Tue, 14 Apr 2026 02:19:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dh7nj0nr0-4;
	Tue, 14 Apr 2026 02:19:31 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Use nr_cpu_ids instead of NR_CPUS for qp_cpu_map allocation
Date: Mon, 13 Apr 2026 22:19:18 -0400
Message-ID: <177595422535.3963380.14788785659785183.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331053245.1839-1-lirongqing@baidu.com>
References: <20260331053245.1839-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=821 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604140019
X-Authority-Analysis: v=2.4 cv=JKYLdcKb c=1 sm=1 tr=0 ts=69dda435 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=IVV1xvooITwB7EEMI5UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _XrMFYJmMLbLMSyc3GYDgFL6ZUYcALvZ
X-Proofpoint-GUID: _XrMFYJmMLbLMSyc3GYDgFL6ZUYcALvZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDAyMCBTYWx0ZWRfXwP4+MiwCbIbI
 HTHI3CeGhh5dJW4unCGHOjp23Q8e2bvBgX307EeKZNW+Hos00Z9Av/7x9PI0tzgIB7Zi5RGgcpx
 TDGCYLJmLR6VzNZCb5akPn5EJVzxZ8ND0W1tMaE+RVB62wJOQdhChgDZM9CmaGtWVTkIUZAMYz6
 XHP7w0Hl3Pz85G6M1ChFiNxL46jOUL5AODqhueLRh5WhC7CG1hfaN4jgEzfpJxAo8+hJW40fArb
 L3PwT6vnc8ao0B73ZLrbDL6wKUz8q2kxAwlUEcP7Rwvw+rv2JbnoW42a1RnQVN9oaOxOJ/baNNQ
 lhgFTLBk/JRpViPyIjbQDyUhkdEycx5se0vUAAccScj4WYXN3vl7XqBK6iVJDJLbZNP4o8laGf1
 8R6ssqutl1BVajAOVbVQMaphh0AR2S7KNE0trFMWl3zaz2wktr2ngOnp+2B8U+AHfaUyGBMfzs4
 Rw6Lqpvxp15rnH6s0aw==

On Tue, 31 Mar 2026 01:32:45 -0400, lirongqing wrote:

> Change the memory allocation for qp_cpu_map to use the actual number
> of CPUs (`nr_cpu_ids`) instead of the maximum possible CPUs (`NR_CPUS`).
> This saves memory on systems where the maximum CPU limit is much higher
> than the active CPU count.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Use nr_cpu_ids instead of NR_CPUS for qp_cpu_map allocation
      https://git.kernel.org/mkp/scsi/c/271aeff266c9

-- 
Martin K. Petersen
