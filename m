Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C5234104E
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 03:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506168; cv=none; b=e6K8LAZ95ZHRJ2GniuctXOCWb4QL3zZ/7biAPKB1IBZ2dUfY/m+AngQ7htI0WVOpGg4QVmaAEhY+gnK3SSjl53DjUaRvIGvLBauNSVYii/gr3y3C1MOTwiMf3aob3CWyzCf8zarRVg4igX0wdAOmInmdS8CmxdXPFhYR0nUU3bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506168; c=relaxed/simple;
	bh=nQMSog1oFj+LXHApk/Ap20AWFJGYB28v5mwEggNtyVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oK8rlTm3HN43kgJ9fQGrpkaEjEbNXgMf4D+he86JWJXYF+9zt21s+G+xsQB+XMfkBqp00iJpw2gItytPo4GQk+fWHFiHQcGUAKIuqKoTY8/3D7d1+1Er7ZBglLvWU6xA/emM6CqGXUVfkSXmZ58Hz2s4QDdDHSpOwSAVCM1ubGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f4H+KpDI; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f4H+KpDI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N0rjpw1584126;
	Sat, 23 May 2026 03:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=julYlEjU+LaNfaTc3IQjbdGBGh2tOjU1XQd+3AUAge0=; b=
	f4H+KpDIBzmas+R0+LQX0CFODO7Iaqdzu/1twMoZh2aVsu00SKt5s//riBJnST6T
	tA2cVUYoBCWyIut1QFRClKR6LEVBY6lbAdXs5vQ5XdRRp6WazqKo3tkvTY27Njww
	oeo1UfJ2u2EQc1ibEtKzuFISh7ibsEDPM73rPSv8yTiU2ub6HmE9XHBEQbpr2xzv
	9vXh2I7rKRsRoTgExZiCDE9SBMwU5w0KCHn3VAhVyTc3qMsye+aMdND63U9FQtxY
	742hr0GzDBB9leplwkV3iDkvt250Y/677d8KEw/jF5tQZPK9+KY6iwBJ7y0wsjHr
	yFh4xSyur6Rl2cWSGCeW1w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h4qcct9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6FP032435;
	Sat, 23 May 2026 03:16:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:16:01 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3FvRO035132;
	Sat, 23 May 2026 03:16:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hstd-5;
	Sat, 23 May 2026 03:16:00 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Fix NULL pointer dereference on firmware duplicate completion
Date: Fri, 22 May 2026 23:15:51 -0400
Message-ID: <177950426849.1557613.17745766820578381973.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <agWAgtk6rtHqNWb5@machine1>
References: <agWAgtk6rtHqNWb5@machine1>
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
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=NdnWEWD4 c=1 sm=1 tr=0 ts=6a111bf1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=Pv_JfxWllDgZt25o1-AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Qe3RVMSoVWsG5O3rrPmv2Y-ZQmhifSRJ
X-Proofpoint-ORIG-GUID: Qe3RVMSoVWsG5O3rrPmv2Y-ZQmhifSRJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX9HUWbw3WQTUE
 K2yEdM7dr5ofAtJTuNF0U5L2RkuoEEMyXH8XQVWwTt9WkWbLy0Cgdb2bOMklMyROWSaCTLDRLOA
 E/6DNdgo93Q09DT/bQ22wd403+uo9lFVOD7/yMoANyhp7cLFHarG18XeajuX5NnUNMOMyBSd5sA
 +Xr7SD4J+BOXuyIKj+xEUSu0J3BhNVCu5YwrvsDTbamjzLFvftPkeO1GG3vvdSlfEVQBIXWtVGq
 ozt8NhzA65n26GbMH0oVuH4vRaAxyGQ+pPUCopjanhcbf09WpOfKHiYG9AQGogPq1en736FLENS
 TaptC/nDQTkqfobeIEvzN+uq/w6QLqoNLfsRrmAU74ogYxMrWSzcV/nsnemdFAzf5AwjYwhpKDY
 NuDA+Qa1wTXwMcRkgSCAJVikweE8r6ksWksu2yPXwQoafUem/HkRD32Hb39lFUS78FTYrk10lwU
 KuwJ7UtURH83jZblUnw==

On Thu, 14 May 2026 13:27:54 +0530, Milan P. Gandhi wrote:

> Add NULL check for scmd_local in the MPI2_FUNCTION_SCSI_IO_REQUEST case
> to handle firmware duplicate/stale completions.
> 
> When firmware sends a duplicate completion for a command that was already
> processed and returned to the pool, the driver accesses NULL scmd pointer
> causing a crash.
> 
> [...]

Applied to 7.1/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Fix NULL pointer dereference on firmware duplicate completion
      https://git.kernel.org/mkp/scsi/c/a4719ae23fb5

-- 
Martin K. Petersen
