Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B151CD20;
	Tue, 26 Mar 2024 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416127; cv=none; b=FMivJCRjEirUCjDvZ+JVL4muGvVUK+LqE7BXxt+IlUIr/o2Zp3OY3uxiUV+IDJG/ZjxgEVgMNfpG4X5A3mmtGorv19y8SPwBK1RDvmB28OnJWyxBZkCOQMSXU1xZ3PRx3wtyuNeautIope5h/vsrzTsiZ3KN0m5kIFnLzT48KxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416127; c=relaxed/simple;
	bh=OlVzANSQ9am6E2FzboIgmxVeRzUn54+gnYTNEZ9zOOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1QqB9h5KVWEMfW3WfiTXKr2txlRDkGBtmpZ4Egwnlbwa6YB9REQnT/T1yjwNjeQRGSzb5AamVabtm6X5MCXzRJNEmAI3LeuTOQOUr8evOZFfkIZsqsDIoZrLRFfZHn8XMUZO3XaOacA8+jSRyfWxUxUfS66InWrUQTbbHPnGxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FYQ66HK3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FYQ66HK3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG2fx002299;
	Tue, 26 Mar 2024 01:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=/NinJEF5y+F8YOzQoRqHFtbkuS0aNAOkYsOP3Ok2leg=;
 b=FYQ66HK3G9OtI56v3CPHWe6Nv7XDJwVzAoMRkcpYHhkh7rjUP/ceSIn4Xi2Zfo6+OuGE
 aZFriW5IbbPprmLiwY8/nrv6IYMhZs8as0mcq8pVUyjX7I9TPGPmv2TQSpEfSUCgGqb2
 z35hhe83rv4g/n9ZZNosmZmwLjar7zoxtDvLq4mSfeNbqOXxN+jVsBUqQUZmw5mYgTIG
 lUKAk8DYAEmIOVwjrL8PHYhoK/PkK8WVWWoB7W0Wtg0VUVTkC9sTxtyS1gYPydiY+DAs
 O6I25S27bWQE5kY+kqLT7hL+B/+EuHX5sj+lz8bHiZODN+tQcBN2iD3+nfa4iu9pU0Ku cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2c0bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q12Z0e024295;
	Tue, 26 Mar 2024 01:22:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6hfqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:22:01 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42Q1Lx4A002449;
	Tue, 26 Mar 2024 01:22:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3x1nh6hfkw-2;
	Tue, 26 Mar 2024 01:22:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Niklas Cassel <cassel@kernel.org>, desgua@gmail.com
Subject: Re: [PATCH] scsi: sd: Fix TCG OPAL unlock on system resume
Date: Mon, 25 Mar 2024 21:21:44 -0400
Message-ID: <171141606210.2006662.1166110926534758734.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319071209.1179257-1-dlemoal@kernel.org>
References: <20240319071209.1179257-1-dlemoal@kernel.org>
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
 definitions=2024-03-25_26,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=882 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260007
X-Proofpoint-GUID: M9SS_9uBZBtELjlQFbia9VooYh_7F1ya
X-Proofpoint-ORIG-GUID: M9SS_9uBZBtELjlQFbia9VooYh_7F1ya

On Tue, 19 Mar 2024 16:12:09 +0900, Damien Le Moal wrote:

> Commit 3cc2ffe5c16d introduced the manage_system_start_stop scsi device
> flag to allow libata to indicate to the scsi disk driver that nothing
> should be done when resuming a disk on system resume. This change turned
> the execution of sd_resume() into a no-op for ATA devices on system
> resume. While this solved deadlock issues during device resume, this
> change also wrongly removed the execution of opal_unlock_from_suspend().
> As a result, devices with TCG OPAL locking enabled remain locked and
> inaccessible after a system resume from sleep.
> 
> [...]

Applied to 6.9/scsi-fixes, thanks!

[1/1] scsi: sd: Fix TCG OPAL unlock on system resume
      https://git.kernel.org/mkp/scsi/c/0c76106cb975

-- 
Martin K. Petersen	Oracle Linux Engineering
