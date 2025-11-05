Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAD71BD9CE;
	Wed,  5 Nov 2025 04:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315350; cv=none; b=jvroBZoy/gUmIfgOXfx2Py1oQYWIaZb1OdJIc78Mu80aOiip2yY73dcdJq1bFNNVazQhzP7RF/OemBpAOcOP/nmQdqb1YGWS47aI0kWOS9/B8beZv+H8J8E8csP5UqoXEli5HE97PcJxHBxNeKo18r9A+ZCv/jUOGikV1BfyD4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315350; c=relaxed/simple;
	bh=yQXSY/WrQVDYfWdO0SbyUMhuGmS/rYRQpjuHxFCtNFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDSD2Dz1i2qd3Z8uiDk0E94mNjcJrkhV9kuoxKRvZSv3WLBclpYJsLC2FftNHZ9xK4INr6fNiX2k+zyNT4wxgw/bv2GRqCdG/VqPFGAr6GL02iySiUdn/CF/GBPiXXQgKarnPBd5lKUkgV3Q0px4KxWnwkNv8+6QdZV5/eDCuqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DOVKNPI6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DOVKNPI6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A53ivCW028361;
	Wed, 5 Nov 2025 04:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lyooww/8Fnw1zaMTJvQpvCmFyUNEz2aBTccHlIHYh5E=; b=
	DOVKNPI6jBE+UqXCDl/KEJNlSewD8o9L7O0OYKEwRufuTDh8Isgf4sYF8VxQXVFc
	zh72H9FYMaEZrKFwlmP4LoaZEJUHAlci5BFeBv21PTImeI59BTXpfDgGM80p3FH7
	i9cTf/S1Ch3KSpducNVAJ4gRv97H+6olZKnqlB+Ez078l67JC3z/puPW0XS4zyh2
	dUQBgbkW4OiGf/cG2o9gQnf0Sq530QR7qLRFybO3lW+M8xuNWdhkhnd98E+UPfs1
	v3mAzmjuYZr9UAfH2gzrwsu+g+KLheaCJJQlAdzy46p8L8UVlxWW5KdAozBiEBwb
	OiMpO9/1Vy5p6j/79vuxmA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7xxk00t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A51hgIE024836;
	Wed, 5 Nov 2025 04:02:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne15hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 04:02:26 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A542Prj005395;
	Wed, 5 Nov 2025 04:02:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a58ne15gy-4;
	Wed, 05 Nov 2025 04:02:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Subject: Re: [PATCH v3 0/7] scsi: target: Add WRITE_ATOMIC_16 support
Date: Tue,  4 Nov 2025 23:02:18 -0500
Message-ID: <176231440746.2306382.5588735953059411316.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDAyMyBTYWx0ZWRfX2pUx9P+mFv9A
 1sTLj19nPCOmqEN30R5wHhaXMuht4tg1zqOPkXCOV6Z/ej00aL6TqFYkow1GLzrQ4Oa5eTXsCnt
 Y2KxsdkXHjOWyYYdzO4NMpFvsGSB1d5XcqVewd95MArKPnDh2tvyFXm+yXKQxoZu6Yu4I/Uq+1C
 viRqRzg5wI1c7s5q5QWw6lFtJL4ytg9ignJRd7Mi1OCukuAcw7OEBHRZqHnW/pHeUmUvdVyYdD7
 fMCvzR0MVKUpVVADBZVdBmbWHiUZd6xNGcpEgToyUhRwkvcOuPk3zSqvN3do/0HVlRQVtFvv158
 8f5tIbAfepHCSB7FYBW2ilvu429vlAHv4uZk/QoZwY82sRkZegDwxjjABjfq8ACD9lWepALH9Z/
 G2NGDzCqP2AieBC5fQ8dlGP8T7MGShyW0oRUGOPofnyc69n0WI8=
X-Proofpoint-GUID: PpZaBKnNKcMWaG7cfPMX3ta8d36SOTxo
X-Authority-Analysis: v=2.4 cv=PIgCOPqC c=1 sm=1 tr=0 ts=690acc53 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=YyQzooh1NaLyuLBRQGEA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13657
X-Proofpoint-ORIG-GUID: PpZaBKnNKcMWaG7cfPMX3ta8d36SOTxo

On Mon, 20 Oct 2025 10:38:13 +0000, John Garry wrote:

> This is a reposting of Mike's atomic writes support for the SCSI target.
> 
> Again, we are now only supporting target_core_iblock. It's implemented
> similar to UNMAP where we do not do any emulation and instead pass the
> operation to the block layer.
> 
> Changes since v2:
> - Fix 32b build error
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/7] scsi: target: Rename target_configure_unmap_from_queue
      https://git.kernel.org/mkp/scsi/c/3434be392051
[2/7] scsi: target: Add atomic se_device fields
      https://git.kernel.org/mkp/scsi/c/d505447b8d78
[3/7] scsi: target: Add helper to setup atomic values from block_device
      https://git.kernel.org/mkp/scsi/c/c486634fe2b1
[4/7] scsi: target: Add WRITE_ATOMIC_16 handler
      https://git.kernel.org/mkp/scsi/c/526145725106
[5/7] scsi: target: Report atomic values in INQUIRY
      https://git.kernel.org/mkp/scsi/c/710ad826e300
[6/7] scsi: target: Add WRITE_ATOMIC_16 support to RSOC
      https://git.kernel.org/mkp/scsi/c/2d9668883bba
[7/7] scsi: target: Add atomic support to target_core_iblock
      https://git.kernel.org/mkp/scsi/c/8e62d8f4b159

-- 
Martin K. Petersen
