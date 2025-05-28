Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D578C1DE8BF;
	Wed, 28 May 2025 02:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398861; cv=none; b=izNYl1EFzDKnboZKPUTbhvwYjjW4AwiEYEYDourCYFDsULV6kvvB1XUv++XeDCIq6ki0kIJjkB8sRGR6LVoEATH+u/BsCf4P4JGYje3+bENZiYEGF8tdO2s1m9DjwwneG6WenmxvpqYOOKFHDawYgjLGZQOi6KMCKF3cW2SF3IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398861; c=relaxed/simple;
	bh=qIuRJdPlk9iPOEoW+bhE7qzFl0hYttY/pcI0npQnn/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmDaOxbXvOTRhBBSyz3lUdlr87OctSbLnAXbm9qhrYSG69ue3Pgyb66U+H5m/cpxDBjVMFeouPuqjqQ5h52lvG5XzgzTJICWOziKZwYVyOpwcVl20MfCzXzjP4QT+EPF3mwwoeOosIUnw1E7ltGfx/SsLrrSL0p7yOHdq5AGLNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nG8zrPhN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nG8zrPhN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1ftsO016682;
	Wed, 28 May 2025 02:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P1IP8AVEY6w5WTcs1bP5qgku7eLgMot5OZCffE+fz9o=; b=
	nG8zrPhN6iOITBi8gz2iKfPOdcRo6NJkQk2KcUsbvMOo8ljRlBEmoCOd7ZM79WT6
	pLmQ2I5GeOiopT1V8mZHxYEXcR9EsaFO8DLk0Uu7iOfTbfPQBoHrbZBS2g+Gpwyi
	HQDJPIqM2chYPuKCKgCctcvVUgzvCt02kv+GnmYFnBxLmCGnFUCAJvJOE1UBgvQR
	VI2Jd4R5H36nFP9/kt4N9y4vjodXcoRTmhqSBKucY+5Oyt89M9BjpwkT6l2ULU8w
	8xwxf2V7lCXZRYc0NqwxUwzFNnSeLonCD8V8hHodLnoo36pJ71JyRwiHKIR5xxhB
	JG/a9rZyIR19+Ej7qk6FPw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46wjbcgx0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54RNhjwg021160;
	Wed, 28 May 2025 02:20:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb22b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:54 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq18017834;
	Wed, 28 May 2025 02:20:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-5;
	Wed, 28 May 2025 02:20:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        James.Bottomley@HansenPartnership.com, Chen Ni <nichen@iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Replace memset with eth_zero_addr
Date: Tue, 27 May 2025 22:20:19 -0400
Message-ID: <174839736794.456135.4258752147841905282.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250519085457.918720-1-nichen@iscas.ac.cn>
References: <20250519085457.918720-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=596 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-GUID: 3QKgomSj4OUFxkmnkrFnMVOGOaIHUko1
X-Proofpoint-ORIG-GUID: 3QKgomSj4OUFxkmnkrFnMVOGOaIHUko1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfXxOXvBIA++m5C 0Xb78cwGMnAHKbO9b466pEPTOiblo8YZHObZ5qk3QxgdOnPDRU8MfWEUVhkbfk/HzV/3hEZSwGU ARvufNw0AMG1yf5G5qxzuI23y/hcsF8q3VwaA6/URky0TiKUk7BaPDJOqtcm+UK3W4na+LqgqIf
 LajbLOaB61mLHv8yNlK+ZfyQeIb3zL3IvMpgLXJ1uX3mUiaiY+jbyP7D916oroUa9wRS+U1V9y+ i7/IKP8B8agqHN5JVE0aQL20HJqgSWog6aJrvcYBrWUzckpmeBkp22974gyt2mGwpUxqfIdTFXc d8LPGaDJYh7FtxqVdKA2OZY1S4LWfdXy+pem+vpvXSTqtJr+Z9Ws0spf+ljHHrGNEbsl3CPeqf9
 f3S0H/eUL59AO1NuoQy1PRJpY4AhhcwkSSCPXkb/wo2WaayBfsrjJmofZx6vdAb6dzjKEpFn
X-Authority-Analysis: v=2.4 cv=c8qrQQ9l c=1 sm=1 tr=0 ts=68367307 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=Lz26-FXpZU_jh_p2JnkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207

On Mon, 19 May 2025 16:54:57 +0800, Chen Ni wrote:

> Use eth_zero_addr to assign the zero address to the given address
> array instead of memset when second argument is address of zero.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: fnic: Replace memset with eth_zero_addr
      https://git.kernel.org/mkp/scsi/c/9000f663c511

-- 
Martin K. Petersen	Oracle Linux Engineering
