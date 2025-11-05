Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1A421885A
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 04:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315352; cv=none; b=QxFQV/6j8dOhXq4Ik2SI0ciL49rmsHOUufKOSp9QCwUHR3VqJgc2jR8VFY2mHTpsFO/XlNOVrUMJ4RIR+K4SYmPPRQUNbslCvB6XpDMk7E+W/loTi1MEfhhppXEJzmN984/oKZXpdOd9aFCZ1eWjF9fG4Qccq6wavZsmrlG2pfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315352; c=relaxed/simple;
	bh=ZcE7+JL6YQckXGHMwypIgjYqkVbjycxkA93KppiR854=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3odp/oujUWh1hnn3Ckphp8a2j+LZ2kJD0FO5WygN5oIe8WKYuVkpiIuGGk3usqFHtnkOh//VJo1ghyz0EIntSR6TKpbmSyXUmdRv9CiKMdXI07oquB8mSlyN+8+prBAplU9c+vKSbEsHF00Bf51s9y7zRq87ClzWXC32Vbq40E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sen1sq/n; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sen1sq/n"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5401Pv025661;
	Wed, 5 Nov 2025 04:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GjuVwc9rRjmPkrrHkT9N9pULlVVpXWMmWvzdAUMmdJk=; b=
	sen1sq/npeX67KIDyF1UM43fI4/NvusrLSW8/AZngBsaOXpIJRYX7sovhc+etFQF
	xaceZAbY1oVoOiJKzvUuUYagQ9yioHtpBIY4Td2zyuT1drUoH/OumHgYJb1GO5Ub
	VoRO6WPMpUzIHef05DmmGEh20KCCb8bpOw/jVp90eTcWRXET7wp1R/y5QZZBVXD6
	1qbL6txs3lo3W39g8eJf7tgBCEBqDRkbUyby22lMi96hCTgntAxcuqrK2+25odmb
	wDbDt+W8IVV7iz43kAu39nPMaA29EU/ZAXWz5BnWwkPJ0JBfxTegu6wIfwQ+u4VX
	qF049QLQLRF12+eqN5vZxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7y5m802g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51owKC024856;
	Wed, 5 Nov 2025 04:02:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:25 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Pre005395;
	Wed, 5 Nov 2025 04:02:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-1;
	Wed, 05 Nov 2025 04:02:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Improve a SCSI target configfs show function
Date: Tue,  4 Nov 2025 23:02:15 -0500
Message-ID: <176231440748.2306382.16221615984221991437.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027184639.3501254-1-bvanassche@acm.org>
References: <20251027184639.3501254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=464 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-GUID: 1Y9rqoMjIEZcxUx3UP7byLhDO2yf4Bfc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAyNCBTYWx0ZWRfX8IVswxS9RJnk
 Mz/MctGq1JSgUZIaC4qlC3F1twzoOmT7o96/XFF/BNGkK6hTpH/QQUOzw+MC3CZOe6uXtZn2PKF
 snGsSsuDjXnMhQA5WIGcD2LK7MVINTXpe3aGxBcWbJsBixk9b/WFI3O9y5mn9BcjdFwVM0EsZFj
 MiUjNkEX65aAXtzGOKEVmtd/SePxfTy18/MYJpC0jfXMzuYGXkL0e9GZ9XvhmQBhGZSddDVo50N
 KOcwbdU6VR37P+4jmE9QVoTc5Vg0Je+hUizEO4xseVB7aaca/0cXPhj9gLg/Ic09sAqQdVBx8Uo
 9TWrcb7+r+wb+LRXaOe0+0jbyNRkIIJ1KI4H2OUXe5wrEIB7vT0nJDWOXMgZxbQbEuR/BwU+amm
 aHewnMfgFy71CJrWq3EqHmkbO0s18wYOhXLJTBRdy5ab5P2eI8Q=
X-Authority-Analysis: v=2.4 cv=F9Vat6hN c=1 sm=1 tr=0 ts=690acc52 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=kBQl_SByLiR99HtUR20A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 cc=ntf awl=host:13657
X-Proofpoint-ORIG-GUID: 1Y9rqoMjIEZcxUx3UP7byLhDO2yf4Bfc

On Mon, 27 Oct 2025 11:46:37 -0700, Bart Van Assche wrote:

> A recent security fix made me take a closer look at target_lu_gp_members_show().
> I found one bug and also noticed that this function can be simplified. Please
> consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/2] scsi: target: Do not write NUL characters into ASCII configfs output
      https://git.kernel.org/mkp/scsi/c/c03b55f235e2
[2/2] scsi: target: Simplify target_lu_gp_members_show()
      https://git.kernel.org/mkp/scsi/c/f010c39ae14c

-- 
Martin K. Petersen
