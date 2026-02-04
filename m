Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABA1A5B84
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 03:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770177174; cv=none; b=UxibaWfWXxuqfPWVQ7XnpRgPTLztY7WU123x+bIOBi9OnWGjaybk/Ok/M8OvMBVHRAp/oAjkd6WkMGMP7FJ/NGx4pE3VLQFb6yne7FKsctrKaSbqdvgQVG5yu0vgEhBzJL8rT0ktaXeXpsjVPJ0lQ4C5247FgUlF95i1siEDOj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770177174; c=relaxed/simple;
	bh=OQtvjHC279Aa5EEwp/vZONM6DCvaXclL7bBvysT3kTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOZGHwzL+oOnPNrQYhpBP8GhuGNmwfWZmIwzEc/AfH8Rz0yPTdg59guqn088agTElIsd0QYamOnrKHvYRZPahxe2JX4MHlttD8zqJC0fJPK7skyFRQAk6Dl8Rc9E8ajJ6cyJRo+d7tkPESNHPFn+i6t6NKJZrf75ssskfQSCmEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OuMBLBS8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OuMBLBS8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuEdQ1423481;
	Wed, 4 Feb 2026 03:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XwU8o4x55MMFZ8i2AxdCpP8x0nyPRYVuIHlsuWDPK/s=; b=
	OuMBLBS8eULPfit2b0yCOSK7/C5KNIxVDPFXEDA7qVgXU51sbMMOZc9eNcnplD9d
	BkTqvWTmxFLQRQ2lKV7qXEAWRn0zaJ625MtQSiR08tUJT4wVex8Z72wj6lfv/pec
	zZ7poy/sQlQQqBCGwxgJtnzCB/lhZpRWN+W21LWOu/YVXu81tBrK2yOYjkel9+iv
	a94EL8zarVrlkiMEuZAp8mFx7x6uOxOU15nwL/7DBcU3aeDJZ2yAiz8o2qUL3GSG
	Kyv8RLIYyiIuMvqDjR4x6XeR2WehEqZ//xjevjNfPaaJMnVFR0kMA780qOZgPkWu
	MFDPsXlf4cO8+SV+5M7/fA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqh4q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6141SFMc018646;
	Wed, 4 Feb 2026 03:52:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nd32h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6143qlln024698;
	Wed, 4 Feb 2026 03:52:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c186nd32a-1;
	Wed, 04 Feb 2026 03:52:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/5] Change the return type of the .queuecommand() callback
Date: Tue,  3 Feb 2026 22:52:40 -0500
Message-ID: <177000116177.3467927.16302275018572892658.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115210357.2501991-1-bvanassche@acm.org>
References: <20260115210357.2501991-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=858 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040023
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=6982c290 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QG55CU4ml01ueB_kOIoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: OQmCoA0hPq5Y6qcgdQyVStg-Q9fvOk2u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyNCBTYWx0ZWRfXxkSRbmqNcDJi
 O69LiEx9JOaTEuwuipDAGMxSOXpmkVu608th/YDKsbjHqb3Uz9BxaiQa/qOtE7dFe9i1VbiiYny
 Y01wZt1FU3FUTPzY7/HreAZIuNsf9qHvx0jTgNMUXw3YV3jxTnc0PxZQYGlYynZ+MJAQD/0YakR
 Lrhe1msk3kkyOopJpM8GiCzb1+gLNnclXdPCKeGPV8P5PxgFgMjgcmai4y4vAcpD7H20qQShe9x
 flQ5cmrWEDcYikEVdLtWgpW2sf27g/zYDqDkswRZ9wc54s5s2a/atxKnuqkU46VxSsc7r3U1eqM
 RzOGH+8zP5qLqXM9SVvLkwwsMS1JoLX+vreX5AdWNh/t0lYitVv7zbzLebjBZaKeDYPqQyxlNdy
 +pJE7UqH33BQIZZ1gY8+StiimyRW5XT7CbBfdA50DdQMYvHgBCu+oHQDn8WdgNDtCe+zz+AvavX
 wGopFwJPcJKtc04x9jeNa5jMhBHZcBR/SjOE6+Js=
X-Proofpoint-GUID: OQmCoA0hPq5Y6qcgdQyVStg-Q9fvOk2u

On Thu, 15 Jan 2026 13:03:36 -0800, Bart Van Assche wrote:

> Most but not all .queuecommand() implementations return a SCSI_MLQUEUE_*
> constant. This affects code readability: in order to understand what happens
> if a .queuecommand() function returns a value that is not a SCSI_MLQUEUE_*
> constant, one has to read the scsi_dispatch_cmd() implementation and check
> how other values are handled. Hence this patch series that changes the
> return type of the .queuecommand() callback and also of the implementations of
> this callback.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/5] scsi: aha152x: Return SCSI_MLQUEUE_HOST_BUSY instead of 0x2003
      https://git.kernel.org/mkp/scsi/c/1bf0febfb262
[2/5] scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
      https://git.kernel.org/mkp/scsi/c/a9fe8cab1283
[3/5] scsi: megaraid_sas: Return SCSI_MLQUEUE_HOST_BUSY instead of 1
      https://git.kernel.org/mkp/scsi/c/a784911099b1
[4/5] qla2xxx: Declare qla2xxx_mqueuecommand() static
      https://git.kernel.org/mkp/scsi/c/5612404d026d
[5/5] scsi: Change the return type of the .queuecommand() callback
      https://git.kernel.org/mkp/scsi/c/0db3f51839fe

-- 
Martin K. Petersen
