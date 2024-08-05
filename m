Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40C17278D;
	Mon,  5 Aug 2024 21:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892725; cv=none; b=GFsTTKV7A6iK/wcnsHF+bggS9n9HO6PQW+Hen3Nn5oWvGf8bYdB2FxjynnoOBZEo2enrD6f4HIdBLXabu5Pn+f0Z2eZoI0OY9BIM7JbWIUMJDnDImWopSkRJlAyYPIPKPLlucKQDC/gLkANTJScGRIBX0yNvMsyxk03Qk7O5gQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892725; c=relaxed/simple;
	bh=ZtYzxRxwWBp6bC31/4/B9/9mCEuN4MBBaKqD2IYjV7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fM94iy2TS7idUDEquTrhbdq9o30/J0vldEJkdoPoRZZq1+XDTj2HbGxGRjOGP1NyGXfZSwWdCR2mzQA59CVYTVc0F27Ypz810umFVKEG5sGuycwAI1Ps/3xKzAS9aoKm58BcXhFGpJiZZdJmkIGbYn/Q9dvRg/xvDAKRAKQbN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ABKQ2q/s; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ABKQ2q/s"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475KjSKL005293;
	Mon, 5 Aug 2024 21:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=+2mRglz8YMJu9tB80+gf1v8xPqsFb3Xw2pex1b3qBvg=; b=
	ABKQ2q/sHGOFY56RAbYBxbOay2oQNIio1gfIf6gRvL3IJ5x4q5AvObFn2B/IZ0Di
	dgLH05k28tHeFMLh2J7QR1/FNVSImGvcXQtOfY0ImKwZW+uPiGPxkkOPThz8c8GT
	PY43aVYNIAyvpEVA3yITS+rzMysCs/+nXrQ+ok2MNqX3W9cDLjnrYi4au7eUoxd9
	LX5ChtAmIHgnd+cuTpDUWLVZT8d32Xt0TL88YShhDqimzjpcSvfPPkUCOVPIDUL0
	uV3iqgZ46voi6sToj7nC7/kwVDnJ+nccDXE2+EPW0ljxL9RZ8Qk+7N7xy97q//PW
	DDaelZbNFpWYEgoCyMlKfA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sbb2krqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475K8BcZ034980;
	Mon, 5 Aug 2024 21:18:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINEZ035403;
	Mon, 5 Aug 2024 21:18:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-9;
	Mon, 05 Aug 2024 21:18:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>, Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace 1-element arrays with flexible arrays
Date: Mon,  5 Aug 2024 17:17:33 -0400
Message-ID: <172289240509.2008326.4613816844614756968.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711155823.work.778-kees@kernel.org>
References: <20240711155823.work.778-kees@kernel.org>
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
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=637 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: UNO7DzaUiH-vDDSw1HCJXzBp8hXTnJ7d
X-Proofpoint-ORIG-GUID: UNO7DzaUiH-vDDSw1HCJXzBp8hXTnJ7d

On Thu, 11 Jul 2024 08:58:23 -0700, Kees Cook wrote:

> Replace the deprecated[1] use of a 1-element array in
> struct MR_LD_VF_MAP with a modern flexible array.
> 
> No binary differences are present after this conversion.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace 1-element arrays with flexible arrays
      https://git.kernel.org/mkp/scsi/c/ed8ab02c85b3

-- 
Martin K. Petersen	Oracle Linux Engineering
