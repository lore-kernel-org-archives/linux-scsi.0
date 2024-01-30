Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DFF52F9E
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581670; cv=none; b=Hnv3SJHiXU53n/35Vvl8xH4aB/zYTQNkfRwZwpw2UZvHBNGaNPskcngUsxsadKp2IhpsOBNWwEb3jMl458ks6N73ADAJiNse/cgZeIi4ugu9TOkqTgmK/TJja2q1LWydfpbc/yIomCwud3SJjFJH3cvCaNxMXTRoOoEDRnBT4iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581670; c=relaxed/simple;
	bh=gG0XTxPkQJ3tzk8RL9x3oQF48EB1CE16XF7LYkrThoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/yM6RsoCHm8zzZCapidGBisRZ41yjqHotQ987FeXIqVEKyi2J2NyX+ABddjhpjtJDr65OAWvT3cfT3vgtHS66JiTtPCK14wLeJrag9boahOa2UlpcjPh1fd4LCr3q+mNQqqXdctTTnPY/7UosRdZSrpPwPoSuDMWfUZJkgelgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BnUJmkjy; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BnUJmkjy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJi1Jt029605;
	Tue, 30 Jan 2024 02:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=nfgLpF3ODQ7xbw3V29YEkb6MSWqz0QubLI174xx+S8s=;
 b=BnUJmkjylGmDj/owjw1zCJVY09TJtNf+VIlSDI10gwmmFcWIbYnFI1p/zpkH9iQnE+5+
 nhjMCWKO4mBzSaMBU8MxvV0Ssi1IKoVpyVrUzXeSqfRpra+B2u5oW+zyHUgInELfTSac
 MPohVSZXI6neQhCMQEYvhk1ypa15yyItxW8tlBy1DwocmyUo4N7ZFSWQ6Lc3tUcjAa+N
 ut+FSvaqHRilW15QDV0h+5IFdZdb+qXaJKJwrV6kOHQUZP6nNgDXmLjb2ZFt5oYCHK75
 asXBplQd99O1Rw9fJLNYThRfUdte8CTZT8ZT+jWEEVE21kT5EEWK2ByBu83DDwHrWrUM 6Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8eddju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40U012Te014573;
	Tue, 30 Jan 2024 02:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96g54r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40U2RP06040916;
	Tue, 30 Jan 2024 02:27:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr96g4y7-14;
	Tue, 30 Jan 2024 02:27:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v3 0/2] mpt3sas: Update/reload SBR without rebooting HBA
Date: Mon, 29 Jan 2024 21:27:10 -0500
Message-ID: <170657812688.784857.10656645312371453020.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231228114810.11923-1-ranjan.kumar@broadcom.com>
References: <20231228114810.11923-1-ranjan.kumar@broadcom.com>
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
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=746 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-ORIG-GUID: KbVTsddM2GB5xy5Ikvw4oPyKp9Y9yEan
X-Proofpoint-GUID: KbVTsddM2GB5xy5Ikvw4oPyKp9Y9yEan

On Thu, 28 Dec 2023 17:18:08 +0530, Ranjan Kumar wrote:

> Support for additional IOCTL to set SBR
> Reload bit in the Host Diagnostic register.
> 
> v1->v2:
> - Fixed Smatch Warning
> - Improvised indentation
> - Updated driver version
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[1/2] mpt3sas: Reload SBR without rebooting HBA
      https://git.kernel.org/mkp/scsi/c/c0767560b012
[2/2] mpt3sas: Update driver version to 48.100.00.00
      https://git.kernel.org/mkp/scsi/c/a34fc8c7361c

-- 
Martin K. Petersen	Oracle Linux Engineering
