Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870531BF47
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 02:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716259286; cv=none; b=efP6Z3uYEt7qMpC9HgKGAsFqKVmnIWUtrB5yYHwJWGDPpUxWZfnWR1hYOO3fTanqMikoJ9Rsus8Qn2oa6FNV0oljTOFhfM4Z7PC5W6brnvIIAUaAnxW2OVws9rpHgTYRQYDKiKzTZhxITciMhTt8bHkztxzbMucJ78+xC4mAmRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716259286; c=relaxed/simple;
	bh=EawEbKvoiSaYHEKVHL4ngDgC/+/jHSovHGtKNHXr06Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQkX/b4TGOew5VX9LuokGAOhKC3pkKqtUufCONgCDedDHcswdf/LBpjTsBHPP/UAyi3U4UVTOCVUPl5HKNC4Nxx5Q5HobOfl+2MPjqqDEyh2MFs6ZkyhVkYbS4hf92FxxBWhF4DLhDI/JWihN49zbCUL4OYyXmEdFG/k/ZnY2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CtwjhrOp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CtwjhrOp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KMxT6K004866;
	Tue, 21 May 2024 02:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=VOOL47AkbZkmGQmhzhtQg/FbJtK0xLiWq1y3pIdCRQA=;
 b=CtwjhrOpb357WijCpyOiIHGUdX9ALWRE60KFhwCyydB9YH1lEbHvVINrzWt52HVnF4vl
 KIsAE0yaGGun/ts9DzG0CXtpKUMTMoEzTTaal0NESpg+kcXmTr+BQ+nH6qRrlN6QeX5d
 TRvk/xBSnUHxCfocyboqPjJam1/Fn/ro+Tj41lTSlCxl51ktnSRk+OHhLKO1dHNzJSp9
 EwO3G7lZ+q04cyvZo4Kky6+/dtaEpveWz9tze+7UQ6bZKdvtcG+4mqED8jlZC5Tx5CQN
 mEKvxDRquKTb5N8SisXFI0By0+2/J71JxF9XsikKLRqWw60Ad3MxZ0BZhkJCSXFnrTNg HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2by7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44KNjb3V002698;
	Tue, 21 May 2024 02:41:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js72bg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:00 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44L2excm013516;
	Tue, 21 May 2024 02:40:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6js72bfn-2;
	Tue, 21 May 2024 02:40:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v5] I/O errors for ALUA state transitions
Date: Mon, 20 May 2024 22:40:15 -0400
Message-ID: <171625915909.2717551.5444740128351456696.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240514140344.19538-1-mwilck@suse.com>
References: <20240514140344.19538-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_01,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=739
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210020
X-Proofpoint-GUID: Y1QWCKzcg8dcmEFyBHAdOs9pptO4fEf-
X-Proofpoint-ORIG-GUID: Y1QWCKzcg8dcmEFyBHAdOs9pptO4fEf-

On Tue, 14 May 2024 16:03:44 +0200, Martin Wilck wrote:

> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
> 
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] I/O errors for ALUA state transitions
      https://git.kernel.org/mkp/scsi/c/10157b1fc1a7

-- 
Martin K. Petersen	Oracle Linux Engineering
