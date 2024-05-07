Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD56E4A0C
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047289; cv=none; b=Nkx6xHCNBYwmYCZcv+9QHFKmSOUl5npT+V2f2xkDhdkRabF+uwJOzqHOQrv4FOIzYZaRcZllKScZnKqSLUw++uQsb0YY7PQCbqL8PqN0e/n1fe2vDbI/r2GOXGQBD6I3UmrjVxP9N33CfkErLEjdBHAeNATcweGcrD2xI3k8HMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047289; c=relaxed/simple;
	bh=XTGPyTWklYmwTKxC6S39h5QTY6qu8XMX1EolcuKil8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPR/rwoMIIF9VW2JwrWkmWuBwo3Xf9/YaN6mXmEdimS4gekono7rNPrdqqJP64gquCpzhyhJlCVZLrRPWayWsNo07L/Wldx5SKfi3atKlnkNK73wuf2tbFK8iIHbKeMOHLD4eE3mEbqaoUE/lzYkPEJhsomV6LCDuKv397n2gqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IkZ5OEQ0; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IkZ5OEQ0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqOK8026428;
	Tue, 7 May 2024 02:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=8gRfJ9RtHsMPUvdlkmcWiaLkw6hm5ISm3AYAXHTYAIo=;
 b=IkZ5OEQ0DcTs64/TMlenBKIr3JmQVZEIClWOXE8sNY5OAvJoPQOkMPmY/rc51tTRQ+LA
 bS51acfpAQrZCDyhSo0aaohdaNPJwf+zXfP+73OsNdmXaE2yajlbDpUG5VQPLN7Ztvfm
 i1fiQZWuzI3C9Jj6/AHKaEexhFCmP8TikpjZelU0HEPVHZsRPfa/hABZAMS7+O7sYdnn
 fI6sZgw/CSsUv4JafyqZwkMAyCHixS9nybzaHVy3mZRPU7Z/QkGhM2uBPUOtONrio+JS
 QHrTaqaZQuKALakg/9IuGhu4aa4xbVNB0fsVcgj1wbM6k9py6UdcYTgTswEwQU3wKtfG 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbxcux8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4471o01c006878;
	Tue, 7 May 2024 02:01:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dby4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Em7034149;
	Tue, 7 May 2024 02:01:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-5;
	Tue, 07 May 2024 02:01:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: libfc.h: add some kernel-doc comments
Date: Mon,  6 May 2024 21:59:52 -0400
Message-ID: <171504445060.1494912.6470724368629001838.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424050038.31403-1-rdunlap@infradead.org>
References: <20240424050038.31403-1-rdunlap@infradead.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-GUID: HLxzTMzKmcZqbW4LgmHiaweP2PwYrfCx
X-Proofpoint-ORIG-GUID: HLxzTMzKmcZqbW4LgmHiaweP2PwYrfCx

On Tue, 23 Apr 2024 22:00:38 -0700, Randy Dunlap wrote:

> Complete the kernel-doc notation for enum fc_lport_state. This fixes
> 7 kernel-doc warnings.
> In struct fc_rport_priv, change 'event_callback' to 'lld_event_callback'
> to match the struct member name.
> In struct fc_fcp_pkt, add a description for 'timer_delay' to eliminate
> one kernel-doc warning.
> Add return value notation for 3 functions. This fixes 3 kernel-doc
> warnings.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: libfc.h: add some kernel-doc comments
      https://git.kernel.org/mkp/scsi/c/9cef74a9bc26

-- 
Martin K. Petersen	Oracle Linux Engineering
