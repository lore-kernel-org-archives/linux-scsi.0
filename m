Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D8D1A08C1;
	Thu, 19 Sep 2024 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761237; cv=none; b=foFaTzz+ppYb2s0v991Dnj94loNiOPydamsyHUXTMQJHg9646aXM4jBCW/TWLmKZFnxRtKq3Hb4gVnEWc0FG//qUyBybEcJtFLEQBu/Rf5wxhRJydhU3EBIjb1XZBCfngNZzh3s0oqFUjxu2q0UO5MWWsx3IjsR20AHN2cIp7A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761237; c=relaxed/simple;
	bh=l2F5cQcF0+2f9krIyIxzMHCHibaEDkXjlT8VbB8oYi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oe8KzL6S8mgUq1FpUbXeb5GfiNWkPRF4YfTMUhKOTsblbMYXCKrqUSC3UIVJOFJOtmZq4s/kISe5BYMAeYMpTbjX3HXQ4kSWisHtDXJBA5M/MHhnftDr71BBFKFRDFMDCzwi1Ybt7XG608xVVrTodkIx29oBitmUFuK72GU+Qbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R5MGLX08; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R5MGLX08"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEanQo008078;
	Thu, 19 Sep 2024 15:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=lJRHcXTFndUviv/NsLy5iHBGwIGMxwDvy1eAP9TYsq0=; b=
	R5MGLX083i+qSOz68s6ksct8HGi+92IQCFnrRy4h8x8BMNQQCFjYpKygfWSQqhw4
	Am588f4wa8F7uezUyNvGxuSwnRIyyrOIMfNMZnOFdfRvSidH+Vk4gRJ8sW/va+4Z
	Pj0IOkPy5ozHa9j64Qauzi7+rMBzy6kXHqTdirllGU/JwYBDcgIJS9vYsNX/HBcl
	tbNnxJ0JHwHlbrdY1knSVjj0JNTyVxRCy3gNyN2w2IA4qcf63H2TqDeAKlypsCBO
	MN5a7rUWfBxi2L14XQxFxFNk894lMPAV5e4iWaWAPX2TYaZU8RWkg4ZoYqKZDEA1
	NGCfZCrfNUSKBJ+x1Ot0Zw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd4mfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFqV7T010478;
	Thu, 19 Sep 2024 15:53:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:50 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8n031813;
	Thu, 19 Sep 2024 15:53:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-6;
	Thu, 19 Sep 2024 15:53:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: Remove trailing space after \n newline
Date: Thu, 19 Sep 2024 11:52:52 -0400
Message-ID: <172676112047.1503679.11694948438656050174.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240902150042.311157-1-colin.i.king@gmail.com>
References: <20240902150042.311157-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=995 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-ORIG-GUID: niw9lcGSJU-0iehurfyCqee6KfjAv-Vl
X-Proofpoint-GUID: niw9lcGSJU-0iehurfyCqee6KfjAv-Vl

On Mon, 02 Sep 2024 16:00:42 +0100, Colin Ian King wrote:

> There is a extraneous space after a newline in two lpfc_printf_log
> messages. Remove the space.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: lpfc: Remove trailing space after \n newline
      https://git.kernel.org/mkp/scsi/c/c7c846fa94c9

-- 
Martin K. Petersen	Oracle Linux Engineering
