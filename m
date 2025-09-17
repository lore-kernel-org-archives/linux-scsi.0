Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075872F60C4;
	Wed, 17 Sep 2025 02:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758076048; cv=none; b=Vwmg5dzsSgfKlJtoaqk1RmvOfobcTsZfX8SfBwCJL8VFndTKWlmu5NW+JRpDttWPyAqGFHiCJI6iErXMjeUfRSck51IB7YZ0SQpnW7xo9plKvv3qJ5lpc5GwzNbo0gUEUfO8ty2Xry9ni1r633uWuMjQqtVMoODFJhVGXVYmd7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758076048; c=relaxed/simple;
	bh=9Hvcq3I29CMyHbPrdGNNVOmTlzCY7bQRsnIvv2qhsBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdUXJ00VINpSdNw8+R2ymnSjhWQHBajZfhlxnLnWJVuqQ29gXV7WOoK93TeYP0ybbrJX7i7oKjWwTvNCkLE+zyfXpEbbAsVIPhCifhC2H4PWkuErwZOJiWivsrbOLT5t3LDnG+ZRFHBIHKop1GMs4lO62FnYZqRy4ryoMG7JOvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z7KU/EKB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z7KU/EKB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLZ14c012543;
	Wed, 17 Sep 2025 02:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Txiaa5BNsA9MDXMG+TjfAzJBFszpsGpWduNtIMzhpoU=; b=
	Z7KU/EKBTWRuxk4aEIQQhst+Rmr+rBZmC03KSqv2Z4/dNbc10a5khnXoSbePUJf+
	QtpEJTYfRCujjH1fV1wDuexSZfv8ngM8IdKFqsq89G/ihw8PI4oX8pulTC3tLvIi
	MucsbqEMyo/RUVubji6Q14fugiZQNnrEYw4mFvGaLOTbrThNUCxBw/ksJdpuRg5t
	5/DUMKE43/FTteV7NSg/fgTcjVixC39qxlr8J6uf/rh0StKRDkZAhGCTXFIgg8FK
	bTZfNK5f4Q58xfDLghVWZdqecq8pyIBQePcwkLQnoD01KJCBY+RSynPIt3su/D6h
	KrNLm0xkCHGPWODxKBj5dw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9r9bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0gSg7028794;
	Wed, 17 Sep 2025 02:27:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2d52fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 02:27:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58H2RHY5037520;
	Wed, 17 Sep 2025 02:27:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 494y2d52f0-2;
	Wed, 17 Sep 2025 02:27:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Use int type to store negative error codes
Date: Tue, 16 Sep 2025 22:27:10 -0400
Message-ID: <175798566833.3116853.69252163477869377.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250904132351.483297-1-rongqianfeng@vivo.com>
References: <20250904132351.483297-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=953 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170022
X-Proofpoint-ORIG-GUID: koVpCdHKIqhZFVFAswCqaNwLeuSiQfO9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8xJ8IC0+f3fb
 MFjvSIGN3W+AoJpaNpAhjIks8NPQ76ChWxg0FBOKdt0erTNcA9xpiRA8Rc/cNTcuMMxfnHkyjaR
 I5AAAICrCovhRZIvGeeOf1C9M+En0sF8clk3V0jovCFAKfc5HC8RQ/QNi8nDUG4mAQYvbJuSuYa
 pHcoMqKwxvPgyw4tT5nWSaCu3PieE+NuihG2cZrh1jAIwWVSjiSyVyb0OfK0GiVMw7Vy9cAk3cL
 PcHafcy2K2KrmSD8vJDm8fOhMdgNiKy22DDfuzp15qERNKh0Fu1mQvhsNBXcaG+6PnHoJRfxWqW
 PzJ8x/ritlQ4aylh+/LOXaySYNQDh/SEtKeIhvw934SPeb+arQWBurZQztxLKpDbcnZsdNaLdaT
 Bc80Nx+w
X-Proofpoint-GUID: koVpCdHKIqhZFVFAswCqaNwLeuSiQfO9
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68ca1c87 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=0YdJrSoTKAKcOoZutCgA:9
 a=QEXdDO2ut3YA:10

On Thu, 04 Sep 2025 21:23:51 +0800, Qianfeng Rong wrote:

> Change the 'ret' variable in lpfc_sli4_issue_wqe() from uint32_t to int,
> as it needs to store either negative error codes or zero returned by
> lpfc_sli4_wq_put().
> 
> Storing the negative error codes in unsigned type, doesn't cause an issue
> at runtime but can be confusing.  Additionally, assigning negative error
> codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
> flag is enabled.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: lpfc: Use int type to store negative error codes
      https://git.kernel.org/mkp/scsi/c/5cffc679ad1d

-- 
Martin K. Petersen
