Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2070115A868;
	Tue,  4 Feb 2025 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640147; cv=none; b=OhVaWRki7Wxnmcf8n1qgjqeBLR6IENFPA6IOhtf3ZbY62DuEMaoV72LCA6NGOZ40yd/w9JP6lGK32bRDm7c06feYGk+VAaZJWGsn1X2FMR+Gf/e33iDrxMPOLZRzY5p8OfbBPTKRsOdjssQIgO+H2iFRRjwkOI3K06SyNfTP2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640147; c=relaxed/simple;
	bh=A8Xk2szka9yfL7FXFrdplMf1ZG8HHK3nd2SD6m1ubBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mPPE0fVphjiq8Gp0kkFj4Y3yFIVJf83KsevKo50k2wxvBF0Q4p3J83YqXFPofQqwgvHSWE06qSRq5SGIR5FyzquoDFgcaaQVhbqx+/p3b8MrC1MN5rB08Egg0/XgvnMti6r7u6SkDuMFb86oJhs7IJk1r8N2PDlSPr9lkwG40lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dDRgBXdO; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dDRgBXdO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141Mr1M008591;
	Tue, 4 Feb 2025 03:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JCQ3d+gj78UJ8aNKqfbgmNoKT2bTPl4Hls5WbAw9O3k=; b=
	dDRgBXdOBODr3gwmXhopVFY79XEYl9DDcOcvVaCg0Kn0EIIjgIATQOKE84uy6W8U
	oPoRAY3csuzpwjgEPYEz/gaDz07g2AYh5+bRy7jOPfwk6G3fiXli0HAsGgxRX+hx
	v/Q9DUU05f6fcZ1S5DXT8yXg23zSTyQX7myzdZQt53EDv8gqUxNO+OGmkC6j1n+R
	JvmtpQDeO4soWcm5Vo09loghyx9igQN2RAJmsobgx3Sq68OuYObCVNOTRKJxAu94
	t8TLOPZpZkuIX7DOeb8yR7M94XiXhXpAHgnlAoyhyajaSHCRDqvLMWq1ei1ZejxD
	KBrF9aPuceamNFpjLF3gzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhjtuy40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5140M8eS038975;
	Tue, 4 Feb 2025 03:35:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76fxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143VlxG009625;
	Tue, 4 Feb 2025 03:35:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76fxf-1;
	Tue, 04 Feb 2025 03:35:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: ufs: core: Simplify temperature exception event handling
Date: Mon,  3 Feb 2025 22:35:06 -0500
Message-ID: <173864009034.4118838.6935428912376140649.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250114181205.153760-1-avri.altman@wdc.com>
References: <20250114181205.153760-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=967
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-GUID: 6y6rpgnS2NJcXeiSO90tcPP0xg9IpkBA
X-Proofpoint-ORIG-GUID: 6y6rpgnS2NJcXeiSO90tcPP0xg9IpkBA

On Tue, 14 Jan 2025 20:12:05 +0200, Avri Altman wrote:

> This commit simplifies the temperature exception event handling by
> removing the `ufshcd_temp_exception_event_handler` function and directly
> calling `ufs_hwmon_notify_event` in the `ufshcd_exception_event_handler`
> function.
> 
> The `ufshcd_temp_exception_event_handler` function contained a
> placeholder comment for platform vendors to add additional steps if
> required. However, since its introduction a few years ago, no vendor has
> added any additional steps. Therefore, the placeholder function is
> removed to streamline the code.
> 
> [...]

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Simplify temperature exception event handling
      https://git.kernel.org/mkp/scsi/c/8c09f612b293

-- 
Martin K. Petersen	Oracle Linux Engineering
