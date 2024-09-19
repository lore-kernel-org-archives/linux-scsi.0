Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F11A3BCD
	for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2024 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761246; cv=none; b=fRMJZnLW6lbydx+54MKOKwNsS+8GiwdtRSUObxFgEvFcVppCA1b8VxN/wuNzeoK7uYMoMNivaehilCK2SAukUq/ZIKd3UK0VIgwVtN8btN35Ms3c6LvlWSC7FhtdtVUhndP8VIBc7xV6NCw/hPKm0HGyjUGXOq0kCPh3l6NhpTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761246; c=relaxed/simple;
	bh=ceYa7Bmyhn5UDoS08X3TkE7I8HMJLNN35Gpxqw/vgDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6WedolA8ZyVbN9zr5Dl+fjhCjkGCBpTXqyLHF+4lomElhBw7+1cBFuPGgLWAtTWoScwbAzlTIVtvGe5soQ7ezNp/WcXxWL7WrEGiEgE3j9pAFcmpcy/8oGiwZkuq9JA8bVkHw87X+ni8If/FQD3F1K6KjuWor//3/CYtHRQ8+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d3lRroSK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d3lRroSK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEnclW008100;
	Thu, 19 Sep 2024 15:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=zC84NKSRaURBu+dJT4XVylkcvtB1qELWEDEQqIDsKK8=; b=
	d3lRroSKuo/PI1SFut9fZQxLMwmTOS5UZPbjtNr5+AsIUmcJ/cbebpc8mxm4py9Y
	i12p78QQpp8n/YzJiSXAGDCAtB59Ib65S+FvszSt+UubP75qJoI/3U3CdDGNjJ+8
	IaPujIXCnBP1fDBhLAY4XWtSgYxNTqb5wxKOHlbV4XHaXAo0aZ2WPgx1gpFg6FR3
	Ap4TSjxiad5sxW8BdlYhdNWSd8Fk0A2YxJzrlFh1Z+6Ef/67aT4M44WHZOPDZQrk
	lFecl8bXi7jttZgo+c3QkHYJDmRndN0qFXVOiBex24RwKMM/VhWh0RZDyWyQeRP+
	ZrCnBN5leDitCiqyOymj2A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sd4mgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:54:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEVBmt011116;
	Thu, 19 Sep 2024 15:53:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:59 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri95031813;
	Thu, 19 Sep 2024 15:53:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-14;
	Thu, 19 Sep 2024 15:53:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
        jjurca@redhat.com, sumit.saxena@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: Re: [PATCH v2] mpi3mr: a performance fix
Date: Thu, 19 Sep 2024 11:53:00 -0400
Message-ID: <172676112048.1503679.6297062816182904132.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240903144729.37218-1-thenzl@redhat.com>
References: <20240903144729.37218-1-thenzl@redhat.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-ORIG-GUID: F2QNlv9FfrloEi95yM3fGcfrMvUKqdm5
X-Proofpoint-GUID: F2QNlv9FfrloEi95yM3fGcfrMvUKqdm5

On Tue, 03 Sep 2024 16:47:29 +0200, Tomas Henzl wrote:

> Commit 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in schedule_hrtimeout_range()")
> effectivelly shortens a sleep in a polling function in the driver.
> That is causing a performance regression as the new value
> of just 2us is too low, in certain tests the perf drop is ~30%.
> Fix this by adjusting the sleep to 20us (close to the previous value).
> 
> The '+1' added to the max parameter in usleep_range is there just
> to silence static code analyzers like checkpatch.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] mpi3mr: a performance fix
      https://git.kernel.org/mkp/scsi/c/24d7071d9645

-- 
Martin K. Petersen	Oracle Linux Engineering
