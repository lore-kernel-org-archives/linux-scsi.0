Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5476415689A;
	Tue,  4 Feb 2025 03:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640101; cv=none; b=N00i5AKfoq1FQSju+ZW8HKbIy70/vCswe2wINCG52+D7MGDmFp+tZRBKeAMDTtEY8qMWLhDCIQ2z++lbg4WiJkFLKB1toHQtUpO4SeMuVMpEgcokWER32iSQY8EdpB/N1JqiupN+yVstTrMUQ2j74d4x8JXnM7sECMHpdiMiCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640101; c=relaxed/simple;
	bh=t1qxkIUGQvLw4y4NaCHLJdEe9RciLcuD7CffbWwTix8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U3j3AI8eY3bILfHqejcJu4LOm+I0GhhBCJtsz+PNqYXt1752pr0qaEWkzPkVNAU8neoCq7fFaBn64obfyMXrGXBMaQxkgeL1k89OArG/pTZQ0Y/TRzP2MZ41gYKedKN6OIVaQN7P81cyTjPWBffFML9slBE2oZ/l7ejlMU97i3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YPOMNBQ7; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPOMNBQ7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NBwJ002509;
	Tue, 4 Feb 2025 03:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Sn0SZf7jkMhDLZ9QLNusNjUwdd3cdiTk4a9tX2clbwQ=; b=
	YPOMNBQ7cQuZPUu4N4k6j9PdeC8y65jCDgtdCOGN8uvDDCZlv7UexV186B8brU5J
	4mRp9ghVYLahkI3gE4Lpx4vUN6SgccSCHPfPsPi/jjGcObryMscpw6LAXHrub0bU
	wYFUUn4F2tUWPBiAoHpKvB7KV8HXGEre2i4/SLZ3VRErcN9VJAsGqrmGIyCXulcw
	iuWX+SpiTS3g6MkPjzgqCqaXvgfgqim9JvIQQvvd2UR0RvEhI0u4wVe9L9lve/2M
	vjWVbz2yG7NGKlia+/LTzJ/BsjUwiA7NA6BDM3wZ7CJynvOWth9UmGi3sQZNjB9i
	Ci4sNPyzgiChj9uPP1Ofxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7uuwqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:33:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51437Bf2038882;
	Tue, 4 Feb 2025 03:33:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76f0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:33:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143Xs6o015172;
	Tue, 4 Feb 2025 03:33:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76ex2-3;
	Tue, 04 Feb 2025 03:33:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Lindholm <linmag7@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: qla1280.c: fix kernel Oops when debug level > 2
Date: Mon,  3 Feb 2025 22:33:06 -0500
Message-ID: <173863996291.4118719.16494753585135920798.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250125095033.26188-1-linmag7@gmail.com>
References: <20250125095033.26188-1-linmag7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=912
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-ORIG-GUID: 7Au1NR_2QZtZPWbi7mdapItIWHJNjX_T
X-Proofpoint-GUID: 7Au1NR_2QZtZPWbi7mdapItIWHJNjX_T

On Sat, 25 Jan 2025 10:49:22 +0100, Magnus Lindholm wrote:

> A null dereference or Oops exception will eventually occur when qla1280.c
> driver is compiled with DEBUG_QLA1280 enabled and ql_debug_level > 2.
> I think its clear from the code that the intention here is sg_dma_len(s)
> not length of sg_next(s) when printing the debug info.
> 
> 

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: qla1280.c: fix kernel Oops when debug level > 2
      https://git.kernel.org/mkp/scsi/c/5233e3235dec

-- 
Martin K. Petersen	Oracle Linux Engineering
