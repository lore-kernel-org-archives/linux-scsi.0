Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA56306D3F;
	Sat, 23 May 2026 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506128; cv=none; b=tW9zgcjacE0nhohIAz+eS4PkckwO7yeyr81xp7xb4e7q1TvyyXWGKCPZm3jWvvCyRQ2RNulQU0rey9tJBGQ4bGe915y1TId+9zWttmcUBdviiIxsNx/fIHWbWJ7xeesOsgY9NJw93PrxOmFlCmKXeQpIG5YRENONPsHmclTejLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506128; c=relaxed/simple;
	bh=5QymYsdVfV9hz8sP5vrLy0HZQgQAJD5wMtmwi6bHoRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dM9ktwnjCkY/VhCW7s5W9YSzwB9viuo9xHwBl2XEBKq/0uOTySeXQdrnLCohSExS+utO7E2/GFVfWQrYFo/DiINpAY1b6h1DDD7ml1QFvoHg8wcx9BpJMG0N4FX/z7VPj9ViNTgrl1sFRarCNc9aOm6ThGkPHj08so1JdV5+V+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V9ew2Sum; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V9ew2Sum"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N1bpSg406848;
	Sat, 23 May 2026 03:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4YCrH2y9aZIpADHKddxuZLqpk1yXiyb6dwiFzJl9kZ8=; b=
	V9ew2SumnNGjcZox64m5+oZ98d4M2WpvPEtgCX12NQbjXwwkCurnHISZLG3gK/6J
	reNiPVTsN94l7zwTRrbooxDpGHQf/XHIfs/ZD4yJhfxUhJcIct3ILgzEglQ7eITs
	aHLnz/jQnv9QBg6TWi08ZbVTEB5PzUyRy1Q4ti7EjTTkohUmgSrG3RkmOae1qxTD
	n0qtOgY8VlQRTxanPGD163yBeHvy4d1QxJk+GB9OZC/nDwoiL0wHcNkEM5Puny3j
	907wbT9+xhJGYv9svswhVWby+ZuEQbhyOWwtBgo5yR+bL/sLAa/2QcAzZZPVWc/R
	Sciy11+S1F0oLvkhWiqKQw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h4qcct3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6hw032311;
	Sat, 23 May 2026 03:15:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:21 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eE032824;
	Sat, 23 May 2026 03:15:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-11;
	Sat, 23 May 2026 03:15:20 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Sagar Biradar <sagar.biradar@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Don Brace <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>,
        Kumar Meiyappan <kumar.meiyappan@microchip.com>,
        Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>,
        Uday kumar Bagam <udaykumar.bagam@microchip.com>,
        Advait Churi <advait.churi@microchip.com>
Subject: Re: [PATCH] scsi: pm8001: reject firmware update in fatal error state
Date: Fri, 22 May 2026 23:14:25 -0400
Message-ID: <177913641791.1181900.14663720936303186596.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260416153757.414896-1-sagar.biradar@microchip.com>
References: <20260416153757.414896-1-sagar.biradar@microchip.com>
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
X-Authority-Analysis: v=2.4 cv=NdnWEWD4 c=1 sm=1 tr=0 ts=6a111bca cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=R5KDo11Cz1VF5HMyZIAA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: jWLjxmFzrwl5QPAlEquJmbohHyBiXb7-
X-Proofpoint-ORIG-GUID: jWLjxmFzrwl5QPAlEquJmbohHyBiXb7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX0xq43l0cAPJH
 raClauBlM4yaoaANDT245f67QiIybqFoB7teEMKH5nXTxA8t6SVocQdgaTfuT4T7IdlRMLiN2Td
 Lm7fi1zkEhX80H8TtB/FCEi0BnEnLPKxMSAA00j9OwXLoNmsE/K0Ewut+my5Fr0Xhve7zWlgG97
 S1Nj5hZO87omI6IRnCLBqAp7IaSNGqbDSaOfrW9xMAbpJm7ch5kKF25+yFmzp5Ly8S9Qp6ryre+
 2MEpeehTxihAt1pADFCdXPtGzS0JoC/qHoAxeLPtMuF5GsnwBYzFGlhkD1qIfqhfAEFqOnUL4XV
 H3H47qkxOtWssFZXsj7naufOspicX3BTJJ4z3w4aYXj9Pw0QDlJHqFcRCV5fYsFvBMwNMY3y15k
 x6YNr73wVNIA/x/LCTxvFCks/4gS33dQhZlE8/QkLqcmjXDGcbNl33xrYGPqiWcJMx1J+lFd56U
 tI8UJsxzDZZUMThzOiA==

On Thu, 16 Apr 2026 15:37:57 +0000, Sagar Biradar wrote:

> pm8001_store_update_fw() allows a firmware update request even
> when the controller has already entered a fatal error state.
> 
> Firmware update is not valid once the controller is in that state,
> and attempting it can lead to a call trace. Reject the request
> early by checking controller_fatal_error, set the firmware
> status to FAIL_PARAMETERS, and return -EINVAL.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: pm8001: reject firmware update in fatal error state
      https://git.kernel.org/mkp/scsi/c/2a8fbcfb04aa

-- 
Martin K. Petersen
