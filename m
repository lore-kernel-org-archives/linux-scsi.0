Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E12AE99
	for <linux-scsi@vger.kernel.org>; Sat, 20 Sep 2025 02:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758335107; cv=none; b=dE4sZMGQJSz7lYJ+y9P8HQUKTws5Dyw3O23ODW2IGa4M9GMEtWOfOQZwsxMfhk+rO47DLW4DZ3/F2w1Cp9frGKms3EHjdZdEu91lESNsx56eeKLblyuXiK0uKxUuR/wSVfjuiYxmiB2KABhhTIvUon0MTLUu1mE72btG9tKrHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758335107; c=relaxed/simple;
	bh=P+TJQLVM3tukyC+x4KlnIDBn4wS4Sj4qZTB1+60Kob4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aPZjKFzHshJw20FX5/6vKFLNjp6nnhYHkFCPQ0myzDG39ScDh3fr0fEjuy6sMpY4CiUvUnUG4TfPx8JTbRCSf06wiByyoHfqCOoXvJovjQsreSglWgDp5PqWzUjottXf5nAylrCiHR449LzBm2PGg8y5+JJYObJRGxzRySie9FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NctoaGq4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NctoaGq4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58K2EAOU014713;
	Sat, 20 Sep 2025 02:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sg6u+8f/eebPvYdY301Mcxwb91gxVvch2lB+qoQpXDM=; b=
	NctoaGq4FR3ORYJmFogjan5UIZPa4ucZvIp2qRAo914jD5Sy2CzcGvWPpdG+oYnS
	iCr63JgI6VE7ychrPOIX45+z//j10bws62wJ6mjpJs+uxd7iqnWWNHIjqXnULoFV
	V2cDJ7E0MHkD+CGrsy6lrhsSkqt0myqTyPDKTM4zqf8ctJTxfFfBSctOq1YNcwiU
	HMrpueroyGYxxgl4rcoYNsZwqIgMbVh4UKorzyH1GrvRicUXAfTBT1VTHTjuDk0T
	+DGM4YwPPz96deY1bPN7s6Xq6lmoLjMPaj/m1A1uv7qlxSZuiCu994lDZxZVpQ/K
	RgZnw59647NuoBHCvhIjPA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbxksx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58K1XfU9019582;
	Sat, 20 Sep 2025 02:25:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq50p3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58K2Lxgh016735;
	Sat, 20 Sep 2025 02:25:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 499jq50p2b-4;
	Sat, 20 Sep 2025 02:25:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/14] Update lpfc to revision 14.4.0.11
Date: Fri, 19 Sep 2025 22:24:54 -0400
Message-ID: <175833431703.3341211.16355196853401156032.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
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
 definitions=2025-09-20_01,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX9SoBIqTagAD3
 MyVP4849y+bMaGA8RxangqzRD7t7kn9K8CWFi6W52RsUccqg/t+r4a9WfEWLHIpHzzA6Yh1wxKo
 RUDH61S8op5rdk8qONj8nQqkrf81AsGQcGr/xfCxDyIlqj5B2AmnuFh9CeKuqqnQHkwgeH4mYAz
 zc3xbUQFOZs4/JF3mA5Yi5h43HoLA5UNcGaspiBh4BmJsa9R/lFXFujN4EAXoVCAiIR96Zb5lNK
 Zb+CAT6R2eZqdjd21OVssRsjpaeAstqh85ilslcyo1tTMGgKXXqLtxK0WnXKzpxW9d7d3JYXXhc
 upOvL7CzhSuW/PeY7RDDEtO4hMvCypUSt+7f1Ts0MARPWI3DB/x+Zu13uiugn8aZx1zRiCGZQUs
 sOYet3owHKmRab7G/GJUfhTDlqQ9DQ==
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68ce107e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=_41jAbYRzWp0kYeSqRgA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: wJzbIeEpD7oY_i65TNKkHTm9kS0e4cW0
X-Proofpoint-ORIG-GUID: wJzbIeEpD7oY_i65TNKkHTm9kS0e4cW0

On Mon, 15 Sep 2025 11:07:57 -0700, Justin Tee wrote:

> Update lpfc to revision 14.4.0.11
> 
> This patch set contains clean up of unused members in various structs, bug
> fixes related to discovery and resource allocation, and updates to handling
> of debugfs entries.
> 
> The patches were cut against Martin's 6.18/scsi-queue tree.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[01/14] lpfc: Remove unused member variables in struct lpfc_hba and lpfc_vport
        https://git.kernel.org/mkp/scsi/c/12ff7c579282
[02/14] lpfc: Abort outstanding ELS WQEs regardless if rmmod is in progress
        https://git.kernel.org/mkp/scsi/c/dcf5ea65cff2
[03/14] lpfc: Clean up allocated queues when queue setup mbox commands fail
        https://git.kernel.org/mkp/scsi/c/803dfd83df33
[04/14] lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
        https://git.kernel.org/mkp/scsi/c/a4809b98eb00
[05/14] lpfc: Decrement ndlp kref after FDISC retries exhausted
        https://git.kernel.org/mkp/scsi/c/b5bf6d681fce
[06/14] lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
        https://git.kernel.org/mkp/scsi/c/f408dde2468b
[07/14] lpfc: Ensure PLOGI_ACC is sent prior to PRLI in Point to Point topology
        https://git.kernel.org/mkp/scsi/c/2bf81856a403
[08/14] lpfc: Define size of debugfs entry for xri rebalancing
        https://git.kernel.org/mkp/scsi/c/5de09770b1c0
[09/14] lpfc: Fix memory leak when nvmeio_trc debugfs entry is used
        https://git.kernel.org/mkp/scsi/c/06d3c77c520b
[10/14] lpfc: Use switch case statements in DIF debugfs handlers
        https://git.kernel.org/mkp/scsi/c/5d7ef44d8ae3
[11/14] lpfc: Clean up extraneous phba dentries
        https://git.kernel.org/mkp/scsi/c/8221b3450501
[12/14] lpfc: Convert debugfs directory counts from atomic to unsigned int
        https://git.kernel.org/mkp/scsi/c/a045ae21ce3e
[13/14] lpfc: Update lpfc version to 14.4.0.11
        https://git.kernel.org/mkp/scsi/c/546ad76b2a9a
[14/14] lpfc: Copyright updates for 14.4.0.11 patches
        https://git.kernel.org/mkp/scsi/c/a28205c2bc22

-- 
Martin K. Petersen
