Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C563A901F
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951689; cv=none; b=X7u371z63qjjjz950nziG9B/G9oEg2yG9gJASY/dg6n0Px28x+Ba4k3KSjxNVYLyDz/jfNDpgymphRX7dy+ZXN4z/lWT0i/M7cIBhuKL5TOhumvxbZwYcjCzSiUrB0NMZjgKmNsTTlrTgEob1T8vDNKr8Saf7W+zexJQhI4I0Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951689; c=relaxed/simple;
	bh=LmbiK4TtYB12U+O8mzjfm4Gio5kPHNej5Qp5ngyl32I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiTd4KkvhmHUK0xOvN+38WMvSs2Ushl9DUQWH/h6nSA/fTGwGvm240lmvUKm399MK0H9UYVxofUhHuXhU0XGFohw3LV82s18bjNfYOfdhrr6rWD8OfNGBIsx+QhbfaOTNOorj2/xtg5IpL5qTszVmxqCDG5fDqHGvi+QWpTD64o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O8HLNlvg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O8HLNlvg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMpUu1492592;
	Tue, 24 Feb 2026 16:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u+wmuvTwWcaz2iLiaxBCSL7eo+hQo1ZWQjevCfxckwE=; b=
	O8HLNlvg0KK7netNMX1TSvuzSdSS8m9xKgu6v/dx/0IGCvEh3xjSNj7wptH5Vcbf
	1rGEJgV0SOjyQcA9pYktgCxJipqm9zZPGeHNJbt7Ss9hLybvC8oVCr5lQfPkJciv
	hGgvptI8G018BKGoza2brWeXL6JG/PbWNHsLP2NKvckIoaiUgDZoUR6fZbQRJS+A
	fKfF4ocm0i2vfoaKMXQs5H5y0mmGCVXRzCTEra2NkK18T0boYHpj1lMeO0Dw+snu
	j+WlvpPdN6tlB/MX/j9dIex95qn9F2NPYsBOl5UilRTKQGOPw3A2JaUXYNVfQj9a
	E+MlthvzuM3SqapyDDDeNw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbcmsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OGPlTD015713;
	Tue, 24 Feb 2026 16:47:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6kne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:47:59 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4j012936;
	Tue, 24 Feb 2026 16:47:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-4;
	Tue, 24 Feb 2026 16:47:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart833426@gmail.com,
        justin.tee@broadcom.com, Mathias Krause <minipli@grsecurity.net>
Subject: Re: [PATCH v2 1/1] scsi: lpfc: Properly set WC for DPP mapping
Date: Tue, 24 Feb 2026 11:47:43 -0500
Message-ID: <177195161140.1154639.2872261637824879366.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212192327.141104-1-justintee8345@gmail.com>
References: <20260212192327.141104-1-justintee8345@gmail.com>
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
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfXwQUfHp/IlmlT
 xdDAQCJPiqDjfHK0Ko8xDWeAyVSUFJp6Yx55Bh12zqKWRMokJrOmGanw3XkbENz6alIEBLbjdqv
 LcIENb2CqCpQ++4ip1j4BtRV9n0ZY1f/1dWb6yhLv3UbS+mTkQN83udVVsAPqZndwkjYIP5ulMY
 CUd63wv4+ArzThemwYhA/WcXnYjdB1Y6DQRbQ00Wj9JAnaI7WQkpktlsQZ2nt6jWaY3YsFMwbs7
 d1k1SElrm2nkakaraok0lFbuFwWf1WNQcDo5T28AssRHSuMs+miLKPl3TDT1jix8+wg61M/69GZ
 WymSQo2WOAZKXN1aVFIfzGv7w3+g7fM3xpmFzBVenEOK35D58yzEfDg2JHj3qJJBBj8Kp0UR1n1
 s9OkOLDpRumcRpAY7BJKqZnbWvuxSeesDRBfy21FndGQOjs0KctUwaT4IAUM3UjZiWJHH8ESCaR
 wibxDUCVcF90uPv4wWg==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699dd640 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yMWgITdBATrRiJyjUT0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Dti7GhRI0R_CruFbe-iUoCVVSyEP_cX1
X-Proofpoint-GUID: Dti7GhRI0R_CruFbe-iUoCVVSyEP_cX1

On Thu, 12 Feb 2026 11:23:27 -0800, Justin Tee wrote:

> Using set_memory_wc() to enable write-combining for the DPP portion of
> the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
> only, not MMIO mappings. In fact, as used currently triggers a BUG_ON()
> with enabled CONFIG_DEBUG_VIRTUAL.
> 
> Simply map the DPP region separately and in addition to the already
> existing mappings, avoiding any possible negative side effects for
> these.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: lpfc: Properly set WC for DPP mapping
      https://git.kernel.org/mkp/scsi/c/bffda93a51b4

-- 
Martin K. Petersen
