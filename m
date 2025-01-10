Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA2C20A5C0;
	Fri, 10 Jan 2025 21:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543860; cv=none; b=k8wS2RKLtg7Cl8GrZHSEuT0wX5YobodAlgBh5Sq/sm75grArb3qFN4Z8b6YcS5br/oNjpFcFHX0G4tUIE90Eq39AYYVcCrpzNJC0tnh5brFXUomgo3CDPrRfc8FtgzGOjJL9t+He3Y0OBC8ZwtEUzqWj0r6Y6btAVUT83e6Vjjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543860; c=relaxed/simple;
	bh=kaJRI4DDyMDj3gAaTVrP8xilYfVAS4A7RfnPPrSq4dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mE+F412via6MUWznOfK3wo+F86apwShYMWsUaMBGSy2R9sEBmdgIci3hpddB69w/aRKQwpgKgtMfi1O3eiUd3C6FqZpW1GlmD0L4WEQr83icnRaGtl10jwpIaY2FGaFsxpvY22xJqr4C+wJ5Cjs8bnJlHXVcdT3QjnZQoXg9Xe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Evetu7Q1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Evetu7Q1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBqgV014729;
	Fri, 10 Jan 2025 21:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=EG3ScjH7dj0J5I7+YQqqmnOi7jFfSesOfuS/ZXu0L68=; b=
	Evetu7Q1dJeG64/i/e4iuI93QIDqSBvcaF902Gl6SB1atRAxP247s1UvGv/tOkzt
	hUOBHdgi3e4LdT9+PkWLAHPQ6i2E9PBVIWmGWk69WI/iKfgO2wqHZjqoTv39FDw7
	v5quroPQvDzWfmRF4YWSBNAiqiHYt4TcUd4B/ENdtNzm6o3inew/xVmqm8+J4dc3
	815QnHJ/4QHhOtRglsR1TYSboz6c52D2WYZpDLqcL3YN2NqGTxn7hIQL8KMw1EZn
	aL9eMi8LifbatbEfxWxYoC4gykCHd/BAG/gfcuYB4vbp98gnTpgMmC3m2ixx0U9Z
	Kd41CeXVwfR+LzLqUFJMxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442b8uka26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJaviq027615;
	Fri, 10 Jan 2025 21:17:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:36 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ24034137;
	Fri, 10 Jan 2025 21:17:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-8;
	Fri, 10 Jan 2025 21:17:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, a.kovaleva@yadro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Remove unused functions
Date: Fri, 10 Jan 2025 16:16:50 -0500
Message-ID: <173654330165.638636.13956963717713262964.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241222213524.270735-1-linux@treblig.org>
References: <20241222213524.270735-1-linux@treblig.org>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=745 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: 5aAKljG-y5A0Z_RvCAUn9awmwLz-2kS9
X-Proofpoint-GUID: 5aAKljG-y5A0Z_RvCAUn9awmwLz-2kS9

On Sun, 22 Dec 2024 21:35:24 +0000, linux@treblig.org wrote:

> The functions:
>   iscsit_check_unsolicited_dataout()
>   iscsit_fail_session()
>   iscsit_create_conn_recovery_datain_values()
>   iscsit_create_conn_recovery_dataout_values()
>   iscsit_tpg_dump_params()
>   iscsit_print_session_params()
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: target: Remove unused functions
      https://git.kernel.org/mkp/scsi/c/4d43d350a4b0

-- 
Martin K. Petersen	Oracle Linux Engineering
