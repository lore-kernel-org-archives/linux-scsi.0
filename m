Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640221CA85;
	Thu, 29 Aug 2024 02:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899889; cv=none; b=O8o2yReFb77mcZWVqjV+FxhzhpTpyp1BHO60GB3u6TS8RDn0pngRwtM2o1Oeoyhz0Z62UTpQqedBJQXLhDquWoUDMqECJvq4ut7KAzCg/+8GIUFVnplWgf7siq3B/zrgrCe3jwS56mOYrjXt0Iay+MLA7TPCEZMlaFafuiYGB5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899889; c=relaxed/simple;
	bh=DbVWBaVYgpFhAwu7r4Oj998xnmGt4qakyjFmow2k+TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Au4751bpyO8Rd6EqYewmzgEUhCxSJfLAdRdcGme9bJJglmjjOauw/+9k/d1b/AZNGli/4gS7+T40W3Mnz7yl++3LFsvNmx05LK7I269M+n3I5Gt4m+mVIX8pw3pnvKLtdgfYwWYY/Rb3YBPhBKXKlEB6gEUI00+I1TNeqhs82cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CQZ0IOyq; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQZ0IOyq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1g0Lq000310;
	Thu, 29 Aug 2024 02:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=2uSJYGwydZjzUrTDSyp6CvtjVTeip9BjVGNOmsfHU7o=; b=
	CQZ0IOyqPCjVZCOOseJywsNkqeeXEU5WrUNgxf5Laz/y27/IqC6XY46pQDE14MGz
	UBXb7RKBlijtXSrei0KPqZiGR+s7i2gkba3TIaOTr7jIGsDaJsHdrIZ7JkR3QCbm
	nLeDyhrT4KH7dJB0IVzJ2O0NnorriKZ1xb/m4A0RR0AOfUVn5qjtUTF75Zn5uruB
	7u5lD4ctF7rMOUg2VUJ2lOwaAO+IWAD7MqiNxhrUPYZrqMt2QXUl3KUBdMR9SAzA
	zZf+4Q6dthjPRF6HTVFXVfazQTHz7pKSIJ0pJBjECIw6BEnygaOIEORnLjdArpo0
	7e1C5MEJSuyi1aMdY/UbRw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419puku6qe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T0oBdq009848;
	Thu, 29 Aug 2024 02:51:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q4qk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47T2pKYk013333;
	Thu, 29 Aug 2024 02:51:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41894q4qje-1;
	Thu, 29 Aug 2024 02:51:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Move UFS trace events to private header
Date: Wed, 28 Aug 2024 22:50:42 -0400
Message-ID: <172489245030.551134.15298336041884706255.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240821055411.3128159-1-avri.altman@wdc.com>
References: <20240821055411.3128159-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=785 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290020
X-Proofpoint-ORIG-GUID: rZ5BLbU-61OkADoUVFfWfFsKlRmaeVy-
X-Proofpoint-GUID: rZ5BLbU-61OkADoUVFfWfFsKlRmaeVy-

On Wed, 21 Aug 2024 08:54:11 +0300, Avri Altman wrote:

> ufs trace events are called exclusively from the ufs core drivers.  Make
> those events private to the core driver.
> 
> The MAINTAINERS file does not need updating as the maintainership
> remains the same and the relevant directory is already covered.
> 
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: ufs: Move UFS trace events to private header
      https://git.kernel.org/mkp/scsi/c/89835a58f5f5

-- 
Martin K. Petersen	Oracle Linux Engineering
