Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBFC1798E
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 02:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887542; cv=none; b=b+DEOvc+mH12xykIaqJLvoGCLWAV+jsyYnL01qnuY0CLMVpnMNQSnvrLKaIE9UUhtzJKq/aaO4v0tZPwOmJlnZbKRtIeZXH71QjIyEq1nq+MwvpTYh1EKJxgEF94STaO7PjkJMQpUvIXuIH0vvSh3KescH0IwHpFbD1ZYjETt88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887542; c=relaxed/simple;
	bh=GI+7cfyeM1h/ZjzCz2cvv5sK5/qHCALomTHmPwGPtyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uzfk3MtYKd/ypkK6aGtnLZSDpZeDrlsJu864Rl7XalonLcW76CStJLJPuDvnQgXIsy2VkLDqne5YIldHAJSRg8jc4l8XmCugjCFLce5sT6tbvQQT5ZAM49QDx4zxyJxAFtZ3FFcrJuC/oxa6zF1h5CBxLjSaC1DjHTCLdn5TITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S8KuhhwE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S8KuhhwE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43C1DDQp029787;
	Fri, 12 Apr 2024 02:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=6VprvQ27IZuWvZx6xizDVe0TkEFGWownXnMn0BMoKUw=;
 b=S8KuhhwEsEPZoxaEQ5y7W/h65edUhjJIEODl1xcx/kMkRb2YOflRntbCy0IPRVd8MKkt
 uzLlBfMDUe9ATypeMVQ8RcWEnS3JxMuiNuTp+XQucVXaerxg/2VcuKoT4ygQLsQ1GSnm
 ww3goTlPMcH8/v2vXZiXQ7BqnUGQVfxFpFPPDaH2bek1Kh2bglU+TuXzM2BfMVtYWxVj
 m0oKTPoG0RGG3FV3rQ4L8hZlbcxW3pxj+XBeZqQoTKK4YJ4FEsiUIRaxe4vnV8ZrHMa9
 E2JOuFjEzdw8mSKiR1Ecm770ELI8NHYTctu+IuD4Qg7CxuvnronGgJcdQp7+n9nzwBYw Zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xed4jsnw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43C0fo2k040115;
	Fri, 12 Apr 2024 02:05:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavugmd31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43C25UFo013100;
	Fri, 12 Apr 2024 02:05:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xavugmd1x-5;
	Fri, 12 Apr 2024 02:05:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Prasad Pandit <ppandit@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>, Arnd Bergmann <arnd@kernel.org>,
        Prasad Pandit <pjp@fedoraproject.org>
Subject: Re: [PATCH] scsi: qla2xxx: indent help text
Date: Thu, 11 Apr 2024 22:05:12 -0400
Message-ID: <171288602647.3729249.8215736146907203000.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240321112438.1759347-1-ppandit@redhat.com>
References: <20240321112438.1759347-1-ppandit@redhat.com>
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
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=992
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404120014
X-Proofpoint-GUID: cLbrmjz3tTyOz6-5qA77dvX9xMTEbynH
X-Proofpoint-ORIG-GUID: cLbrmjz3tTyOz6-5qA77dvX9xMTEbynH

On Thu, 21 Mar 2024 16:54:38 +0530, Prasad Pandit wrote:

> Fix indentation of config option's help text by adding
> leading spaces. Generally help text is indented by couple
> of spaces more beyond the leading tab <\t> character.
> It helps Kconfig parsers to read file without error.
> 
> 

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: indent help text
      https://git.kernel.org/mkp/scsi/c/1bf1f5756f3b

-- 
Martin K. Petersen	Oracle Linux Engineering
