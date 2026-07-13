Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60F42BF3E2
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910036; cv=none; b=plaQaGadJnwWEJ6eTr3ejYLyJhD/cDzWbdHtPJrbGp0hXH8dUb8S6nEukyDS8Y26acTLe2qggu81A7/TjwLC5Zvj5ZRXT2puUOfwlbO6uIoCmAlJkH0c3duYsXT6cP2lFp6yOniUqGYDQbTZvO+KZ1hpflDYASA3yOzdjrFvkxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910036; c=relaxed/simple;
	bh=T7HRfAZnbU4USroB+4J4pdz9kL+/AkEjV0NqZetBPT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8ZZGOA4Kj/ntsNLvvoHaHIDCG1gyYhGsJl7LI7JahJzGAEXbrISiLZyHy0KkNNWhzLXYzLwlzguEsosZyHOAyF3sSJFgB/bGVAVbj/dmiGGvAp69jYYtjSQEnwt0SW2pF0yrx6IVZYmG3sSLOLCKgYq8cUSkYNJveQ7qGYue4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TDiORylv; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TDiORylv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CNLBuc074633;
	Mon, 13 Jul 2026 02:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i+X+pr0IdMc1WmFCvMheQPaMgpngwXMpOFAH7ValoAw=; b=
	TDiORylvbyEvkLcizYDe/LHaE/byKtZih+nAx2qV44iyLBl9cSOWqe+zdGyoLFbW
	QrhVF3FFbi2Ki+8soAx0wvuiI5yPxzSrvbXHZBnAMHShoKd5HB5KMn8kM2KFO6sc
	U+UP6ksbPlL/5M5cFaaClaWUgfhpRJY6KIkd54gIINYtUzHfWoeGYHqqmWZN2bnh
	Pj3l9lFNdGeXTCdwjgUOD3pLfDzfC6/fU5fd3zPa6dsqeJ26lZD7yLVqgca3wNap
	ATc6Ara6W1oYiXlltBnqTwAcPhdzO450g208xU5xD/zVurN6kaXcBbmLB49uhWFE
	aES9+qfRfIwyTM6mPIA7Kw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedhckb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XV8R029220;
	Mon, 13 Jul 2026 02:33:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fsst7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:34 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cj010878;
	Mon, 13 Jul 2026 02:33:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-1;
	Mon, 13 Jul 2026 02:33:30 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        David Jeffery <djeffery@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RESEND] scsi: core: wake eh reliably when using scsi_schedule_eh
Date: Sun, 12 Jul 2026 22:32:32 -0400
Message-ID: <178390967071.3399387.8706862617015147693.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260615174630.11492-1-djeffery@redhat.com>
References: <20260615174630.11492-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=808 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a544e7f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=hXtI5UD2RovJGREk3CkA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX4rooGzsZaCQx
 sT6kUIavVJjvlV26soBnjNOqB/m37mLzLdGK0RBqS3NM/KUi0E2FzwJiaRS15Hp0eWMJWPiOtAv
 DlAPaMCDCzcN4sGesF9WfqEP5WmW0n5cHpiD79dpjv3JWDEwf3b8JQdcqYVrN47rf92TnS3BqUJ
 BJtzNHDoJvyhExVUHE1oJAIjYZfG5U7V9QcOpL9jftuARRgQI75JSvA2SUZaCNZbjx58KRjNZoN
 /HEBF51rnJxJA01INCjeGrl6Eo5yKcCL1xw82z4Hg5TW+eQMfaU2U2X9HdVIf2QJW7osUb3AC+q
 qSSi49+2gv5JF7qmD0/cZx55yED1kPujot4NPQTEkUf7YJb9o6JeXC4fsbktFTcc216x9cTIivx
 D4UkgdqcGtaVe9dtUMf2iH2hz3B2kp11BIWgGjQXMyrKs5u6aXYgsYgsHHPPz9PbIw5Dk7yhJEl
 0N/78lKxNztyB5OezgDJvsrbMZm0HV31yFIIr3pg=
X-Proofpoint-GUID: nraKfAX2Vy2Yh61JeH64iHPPNm1et6TI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX5n8e3epNNZiI
 2fHSINtCl87s4L34fJuGCN2zpZ/QUYU1Q9D+29ytk9DimYql9pT02gVWWTjN7OsWHuU4XMHx6nu
 B0vqHrk7NAcDzocQVLEz+mtiSpCS/fs3iLd8kjVkrNNIrJudMMvo
X-Proofpoint-ORIG-GUID: nraKfAX2Vy2Yh61JeH64iHPPNm1et6TI

On Mon, 15 Jun 2026 13:46:30 -0400, David Jeffery wrote:

> Drivers which use the scsi_schedule_eh function to run the error handler
> currently risk the error handler thread never waking once all commands are
> timed out or inactive. There is no enforced memory order between setting
> the host into error recovery state and counting busy commands. This can
> result in a race with scsi_dec_host_busy where neither CPU sees both
> conditions of all commands inactive and the host error state to request
> waking the error handler.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: core: wake eh reliably when using scsi_schedule_eh
      https://git.kernel.org/mkp/scsi/c/dccf3b1798b7

-- 
Martin K. Petersen
