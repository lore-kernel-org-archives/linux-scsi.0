Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66E617550
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459463; cv=none; b=fo5jDf8iI2tLkthUe9yKMAUSbc9TIJUC5LsUYTG4dhj3Sd1oc7jGueCo+MMzP0IFASAMJ919Cz/guH2c2VLKbzOPBVFr62rqlkZAAAZDH2sxpk+XKicDvydBPLrhF7ugSpn+mbWry7y+dFwMtjWZAHDxwhItxQueBwlAFjU9ZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459463; c=relaxed/simple;
	bh=SCl/zSYItgObLr1gIt1k/vrjvYGxQ9IUMj6WfsvdbIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R17WOYyu9fsTXTAZPsJgTApfODJ4UXCFLX4k0YOfJyHBmB60lUJNW0DpQnEWm9yGpfz0NsN4CAScAL7B5KB96Oy00uvlWTljCto23H1no7jmeK0ScAD8XVvqV/ZS8YoqBhPqoiTETAmIZmFmyIm2LIoKoCc84d0IIQfQLRt7Qqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cONjzSoY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cONjzSoY"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMTVK006662;
	Thu, 27 Jun 2024 03:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=bw3fOpqF+A0mMuSWU1JCXb+mpUYxQAPPeIpx3eON5tw=; b=
	cONjzSoYAhG63uVqD6waaPYr4eHe4bwp8PAsVR4o8BxoBNHoWPVWcaMnFrV4uMg4
	K+CVA4Todrq3RGMJhTiM1fspzrOW3xvRdilqLHNvgDU0J/5y+vcxfnajXxcd0zuE
	DytrsHdY6DaxYyafLue1OtCoM5RNKaStk1tJ8K4Ngc5kGdIZhZ8bg+81vS/E0+Zw
	epf/X2KWbWjreHgObCJ0OcZa8G4BJboR4w/Iyd/qk0IMafCkClH2pV0nTfOzXYDU
	eLPzAXlCXZQxAZ26V46v5admxpVsvC0sB1zx6rIgofUA5cKePG7e2bSva1EGZko+
	hABWsaLErxivI1UXLf7qvg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 400ttn8e00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:37:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R2RKbx037120;
	Thu, 27 Jun 2024 03:37:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2ac4cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 03:37:29 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45R3ax0A020028;
	Thu, 27 Jun 2024 03:37:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ywn2ac4c4-1;
	Thu, 27 Jun 2024 03:37:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix create target debugfs failure
Date: Wed, 26 Jun 2024 23:36:49 -0400
Message-ID: <171945940407.1436776.7942049337619395057.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619013803.3008857-1-ming.lei@redhat.com>
References: <20240619013803.3008857-1-ming.lei@redhat.com>
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
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=655 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406270025
X-Proofpoint-GUID: _EWPsUSgsuSA_-5o9u1zIEDKClFSD0bU
X-Proofpoint-ORIG-GUID: _EWPsUSgsuSA_-5o9u1zIEDKClFSD0bU

On Wed, 19 Jun 2024 09:38:03 +0800, Ming Lei wrote:

> Target debugfs entry is removed via async_schedule() which isn't drained
> when adding same name target, so failure of "Directory 'target11:0:0' with
> parent 'scsi_debug' already present!" can be triggered easily.
> 
> Fix it by switching to domain async schedule, and draining it before
> adding new target debugfs entry.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: fix create target debugfs failure
      https://git.kernel.org/mkp/scsi/c/b402a0dce64a

-- 
Martin K. Petersen	Oracle Linux Engineering
