Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EE11F91D6;
	Sun,  1 Mar 2026 02:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331413; cv=none; b=KMbUJl9QN48pzJBr533T9clPyYaTmUMxguyHWIIm98zUVdrR+ZrjLXMbvE63PTz3vY3qdsnVC4bL0JTuEFFwYBNrDcA/OTez5/ceCkPc3btHCxCRio9yIXdj02jOwczf4K8VTQWQZDhkZbFN4WIwFY21zgfjggBB9AL3/+TI0f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331413; c=relaxed/simple;
	bh=YVPkE/NeCyhbYL0DiIp7U+8LdjWl9ZnsqWu08ZGDlg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPjhCRT9zbwMvpuwjhm022VNf9oj15uVnMwGKsLYr/PBTVcS+dnxE4g4Ab0njm2P5lSAsLevOR6uqYK/QcPnnAYtUQq9sidq3mr1j/RmZuKhwncOmsVo8CM/2RwUPmPseAiGTd1yo2JkoemVkwMOM+8Ocz3xmL6hZp5CPtBxPZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=camKT9r6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="camKT9r6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6211gbm92760378;
	Sun, 1 Mar 2026 02:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rcuZYhgDbmvntPnJSE0MEigsu1v7wThgSt5wpUTx35w=; b=
	camKT9r6l2DvGktu8bsR7qbGShPTVQAhDVPG5mkVidjrzRqTiWdAp6txVGHG7udy
	3gdSwmaTzS07kR6FGdvP5mF8O2TbvW+1f8ih/jFyZN0nL8aNzdeYJs6zMaI5K5i4
	+aFRCaM2yfSGEL59F6e3CnugbdTyiuNCseob91rT7WeB4rkaLwRPKlf+W+ZrsRBz
	0A9VoHyMx7bw8o3tuSKTtuZwC/mtJ79C2v/ECIVitRZMMlvR8wHaNuZPtLIkkO9k
	z7Rpl+aRQc9TMELy59q/utJBobH1aNsYARL9dqhLfa6e9Q/V+OvsO0zwXyj8jH0Q
	BBITSDWIKOuMktb52lR7jw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshn0pfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0gPt036974;
	Sun, 1 Mar 2026 02:16:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7ehj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:41 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212GXt6019643;
	Sun, 1 Mar 2026 02:16:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7ehdg-6;
	Sun, 01 Mar 2026 02:16:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
Date: Sat, 28 Feb 2026 21:16:19 -0500
Message-ID: <177231727960.1778274.16035222472937487567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224144828.585577-1-thorsten.blum@linux.dev>
References: <20260224144828.585577-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=907 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010017
X-Authority-Analysis: v=2.4 cv=RsPI7SmK c=1 sm=1 tr=0 ts=69a3a18a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=YR8jykVuY81jn_sEDjkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RJ4F4Qw3FhMsa0ed0BSaJt_35Gl2yYpY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxOCBTYWx0ZWRfX4PR8/RiYowL5
 uUiJrsFXSPvn8YtnHh209inR7+T+qgk/jjlxiWrQwohpQU3VGs2GoQbHswjPhb71klkJkfyw5LK
 UmKVXyuCLbZTl0vW2Hbiu5pK71s+A/TlCZTx5pMsT0SuCSUBuesQe8dtOY8LWbkIRgS1cSQQ/ek
 FFFHqxPOPX+p/f0BGSylYOtblnfly+mZ7ejbNyuNmbFHZTin+0ubNzzTNFwo2OuKITmMWzi3A3J
 +2d53FFyn4dRc4+3QWh+EY0gOTiZgWM4Iwq4loNqnwfxDnbNk7Vsg3qQrBAvJbwz50qi0/0Y4a8
 4zKWcmMgI8lftV/1pZkUvsKXZK6U9+YpBTy4oxvyVNlOQDfWtIPdK403u1T2iPQFaez6QqyHad8
 HTnVFa9ZRHXL2LpFsV2DayYK/A5Hiu2dC8C8XcIayEwrileB3GWSwjZ9vQ5pQ2GCI44FbPpGVGu
 7CP09XTQIyUq4xX0BVQ==
X-Proofpoint-ORIG-GUID: RJ4F4Qw3FhMsa0ed0BSaJt_35Gl2yYpY
Message-ID: <20260301021619.08FOk34Htk92Zx_j4_rmp9dXp-L5XGesFPf8Z82Za8Q@z>

On Tue, 24 Feb 2026 15:48:27 +0100, Thorsten Blum wrote:

> strcpy() is deprecated [1] and using strcat() is discouraged. Replace
> them with scnprintf().  No functional changes.
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] platform/surface: Replace deprecated strcpy + strcat in blogic_rdconfig
      https://git.kernel.org/mkp/scsi/c/931c105de11c

-- 
Martin K. Petersen
