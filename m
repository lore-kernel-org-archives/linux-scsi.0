Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97C93BFE5B
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 02:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576781; cv=none; b=Xfsqs2/rT+I3qiCgO2Zv+wVPScuSIQVmo1Dzs01PTdrxnbZ9ZzhvYwcsvw3zr+Zwgq3QeZ/lUD1mNdF2/eIJrsCyVkkXhCmZbguA4eNjDMOypI84kwYqPH48g7uIJQIofCPiIwRhAzLtqxdNstF0C1sZ83coNlVXWcFbQXIVJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576781; c=relaxed/simple;
	bh=WBponwDwkGQ1j7wyw3A8TXKOSe5s67DsuhaZJ1A6Zq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1Oe7cNbxTztENKrhf5N3jfqtlAJM5/fQYH1TDiYZfKgKr4mbBidDDY9QTgPJF6QbdlJF1hXIoXoOiHP2YvEJc4s37mstPJ2cTeZ8Q2udxIJ4YEBOykeEAP6t4qeC22aaL8WLuE38HdOleZJYDF6KU9h0P8UGLSZs4cUx6JwlzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=efGk1ga5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="efGk1ga5"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FKCPQe1349047;
	Tue, 16 Jun 2026 02:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y2VtqLhwHOGTdZZqMx7dhTuX3/QlhOtWB4SnEW9DCbY=; b=
	efGk1ga5ij0z5qkQmX1Ggs9ScRJYVPSAEFHSbSr2FFHDeJ4+oDNggfYhxcnfRn5i
	iUJWVGSnoyzf2Oawzs4a821hpdr8LoMcVt+STK9gbNb97STi4QWpQtrl+W2M/kG8
	wVZYokc2px496k/Oxw5qLwimCEKhlPKB01PZvNGkyOuCBw7p797itGAFCrNR4YFz
	mZn0Cp/DhkcnehIEVpC0DmywiGCooIQvUcak3ru+RCGrB4w8tsidTj41mKZvG9go
	hHq0SibASsxFMYDDk8FEyYBN0MySxcWCFbR7Gwhua3fqtGZ8U7yXTkz2GiTSF+6F
	7MMagoXwLNoTbID969GByA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1acbnyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2NgPX017376;
	Tue, 16 Jun 2026 02:26:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnyk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:15 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2B023822;
	Tue, 16 Jun 2026 02:26:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-1;
	Tue, 16 Jun 2026 02:26:14 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@sandisk.com>
Subject: Re: [PATCH] mailmap: Update Avri Altman's email address
Date: Mon, 15 Jun 2026 22:26:05 -0400
Message-ID: <178157184603.1899010.5241206290850182879.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
References: <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=685 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfXzdMCIxK/HZhc
 S9pN+CMAfis5FpQfEbgTu/DHOsfw9JTxHGmj1yZygHE+BzTaZfuA1GUs1NVY19ivxqfFzXDdIOJ
 ndseWfkkyxAQ2i+hGv/FyemkorqwrdYvRp7XaA/ba44ptUZkIzvFCUjDtE++2hvQ5HlblkDLbUp
 vMYwatLhLAJwZrblK53a6aCi69mXxsW6hT3NLHM0a+K0i3XJMURkE+JRaTU8zqeAA55H3WDiBsf
 F+o/qrFzy6Mf9E+tdsdiPcSCZ8apvNq1MQFBb1/+HES5VHB80i1ss7G4ZYlt1IRWHTbiEU38TDd
 0/aazkQt7bFPo83yicZbTEnxfrXRPKRXfG9hqarOvnjAU1MmY/Izz9EyHHkUDKheOGaqbG7rrK/
 s7WlpGOug0CuxNhQc9654wzGX3uObLJcMD2yXHw/PHxXiznWGCq/xv1rPW43xqKDEvsjHqUOoUi
 eS14yeHKMIubA66GoFJZy4TF6QQzdEedMNwwF0JQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX0V/zltEKgHXD
 NcPEmUQ0vN2LvyTNcCMBmleSSkA1OoAKZgQmyo9MJC+vWZ0G3FGI36Iv2KrtdfSeLM2IAfAF247
 bRWffPvxX6MQyjBF9Rd2TVLfsbYfR6ceihDbPc7S3pPByicoVY1w
X-Proofpoint-ORIG-GUID: h00APrSe_sVBRUBbRVZVYV36541Y1icN
X-Proofpoint-GUID: h00APrSe_sVBRUBbRVZVYV36541Y1icN
X-Authority-Analysis: v=2.4 cv=IqQutr/g c=1 sm=1 tr=0 ts=6a30b448 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=JF9118EUAAAA:8 a=InJrZTXqAAAA:8 a=27h8BskqGvvwzLFs-5QA:9 a=QEXdDO2ut3YA:10
 a=xVlTc564ipvMDusKsbsT:22 a=WwJ7OKCui7YMbFU4sWpb:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723

On Tue, 02 Jun 2026 10:51:25 -0700, Bart Van Assche wrote:

> Avri Altman's email address changed from @wdc.com into @sandisk.com. Add
> this information in the .mailmap file such that scripts/get_maintainer.pl
> produces the correct email address for UFS kernel patches.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] mailmap: Update Avri Altman's email address
      https://git.kernel.org/mkp/scsi/c/b65b608eb8ff

-- 
Martin K. Petersen
