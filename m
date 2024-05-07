Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FFC8BFD;
	Tue,  7 May 2024 02:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047291; cv=none; b=f68lIBv8C1xYR/ucAFW4l5ZTHqsRlRghMqWhSUb8kYfsfIUSICn1iU9Q/6Kb/Yd9LOOxZxZ4mbXxEcChmz9RoHhC44MZyC9JXABPafEQ9kff5p6rFtdi+qipqXIC7uS1dm+F5Hr50W8uYrTW88qReateAA5I/A3t9XtsW2nveos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047291; c=relaxed/simple;
	bh=zhqCH3hHgvkQOIn+zPC7WJDXhbrxvrIJqH7Krg6xoxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5IkhAu905nHRW0CoWPWLOHUegYo+3TYflJ5TIplsnqOXKUXV7mXG9CFmTRyKt+tgJt98iB4v1Yazo4xvrVuXo623mzs6iY+eMsT9XrbXaBw8z6qMb4kTD93nXPfbf02U4k5f6GcLBHCAT5JzkXRPlMkkNP5w6FUrwvtY6r4mL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FOqs/+9i; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FOqs/+9i"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqOZQ026529;
	Tue, 7 May 2024 02:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=3kcjbLcM8FEeLq+jbdrp/mHXgD7ItR9+uVUnrv9/JjY=;
 b=FOqs/+9iT0AMfD5cePiGJaol6rjeDpmpgAENkIg/2iyklh2AhELHHWUzzCl94WgOgcVB
 VkGI5vauanAXz6QLg10u/z5SW9FjOsh7teTO48ob45slM4/3j9Qke27LwbTn67W9xZ+H
 UfaomHqM5H/w96bPObRGrBHs6f43uJqA6lxH3BoWEiqTeIg/cipRIT/1MbIzkStT+tLb
 OFVDZxTlRkRm4DM5ijVS5eCR2KuY/RIoawLiDmPTLKyuzhu/UpmlVkTgiAOvIVNuc3tL
 /NWR+7hYOP1MkQvL1HGUKruMCbN5illukCvD2gsTjEnr7BzMSLQ0uJpgiX/6E4QDunAh iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbxcux8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44700Adw007053;
	Tue, 7 May 2024 02:01:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dbx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:18 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Em3034149;
	Tue, 7 May 2024 02:01:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-3;
	Tue, 07 May 2024 02:01:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: skashyap@marvell.com, John Meneghini <jmeneghi@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, guazhang@redhat.com,
        njavali@marvell.com
Subject: Re: [PATCH] scsi: qedf: make qedf_execute_tmf non-preemptible
Date: Mon,  6 May 2024 21:59:50 -0400
Message-ID: <171504445053.1494912.294565186998815330.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403150155.412954-1-jmeneghi@redhat.com>
References: <20240403150155.412954-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=722
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-GUID: 3vEkHMsyrT3Ms2VQV8_NQwm9BZd5Ujy_
X-Proofpoint-ORIG-GUID: 3vEkHMsyrT3Ms2VQV8_NQwm9BZd5Ujy_

On Wed, 03 Apr 2024 11:01:55 -0400, John Meneghini wrote:

> Stop calling smp_processor_id from preemptible code in qedf_execute_tmf.
> This results in BUGON when running an RT kernel.
> 
> [ 659.343280] BUG: using smp_processor_id() in preemptible [00000000] code: sg_reset/3646
> [ 659.343282] caller is qedf_execute_tmf+0x8b/0x360 [qedf]
> 
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: qedf: make qedf_execute_tmf non-preemptible
      https://git.kernel.org/mkp/scsi/c/0d8b637c9c5e

-- 
Martin K. Petersen	Oracle Linux Engineering
