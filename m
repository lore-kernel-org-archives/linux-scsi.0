Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2637269B1C;
	Mon, 16 Mar 2026 01:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625319; cv=none; b=Z0wwJzALIatVSLaRUC+bIvAYB1n9TlzBYBhARC/7TVISAIC6LaT0aXqaM+f/A1z3C8xzrlJ53sC8RiRt8YfV3KpI8EnlNQLe8DMs28GCRYk6eaBJi+yzJ8TFvsm9IvC/Fk+As8I///XvQwZIXg5EvYBgyU+IrP7FN40qwhPwpQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625319; c=relaxed/simple;
	bh=G9N3pxDYCtXEU8gkiju0jj29AZABVvgW+Lq/+PRTTGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpVkVA7gFpS4qJQb80MylaWxOL5B1MxkuYFvza3eLggOeJNh4GD3f4qJBMNTqfUW5l0nAsPBioaTakBQWzoJEvT0M6qG5mW+nAs8j1VZTJJRYtW+jxCDQqXdxhHiyO4TFdj3UjYpLLyL1TRjtF2Gu40xTGWtshFAEW2ydNdpjXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lWLg6KOL; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lWLg6KOL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0sH7x186601;
	Mon, 16 Mar 2026 01:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=suO7F5vGzZA48m7KKs3KaYW/V1xP8XrXB6W+a/oGxlc=; b=
	lWLg6KOLPT4kFOfI+43n9UGClbyzULyNHnwicszinAdunddPuaimolARDVPYBHPv
	6PH54xDI7Cv7A2xohjUGjueFt1lKYfdZii3P3BZ+arGgm8ZP9xA+ntVoCIVU8FWg
	oms/gi+fLGLjiLT633uI38e9KInJcXBsQybzik4nQXlB5xo3REEoBqznIIA3p0eI
	lUvaZeWEDclkHfeCEw47ALA3W8DLUxh2gU1vQ1Bwv2h/nWjMZsLC0oITkcZnCbtV
	1IZ4FcrVAmTZGl3aVLWc0q4/PQWttyP3XdMc0B2RcYdsoN3x6pU7QMn0EpWKFxTj
	01UivGCv6MwbR8xzmW47gg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cw07r9aqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FLi4Xb002902;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhR032070;
	Mon, 16 Mar 2026 01:41:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-4;
	Mon, 16 Mar 2026 01:41:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangxingui@h-partners.com, linuxarm@huawei.com, prime.zeng@huawei.com,
        liyihang9@h-partners.com, liuyonglong@huawei.com
Subject: Re: [RESEND PATCH 0/2] Clean up the hisi_sas driver source code
Date: Sun, 15 Mar 2026 21:41:23 -0400
Message-ID: <177362524484.2599440.11472669101588910168.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305064700.116033-1-liyihang9@huawei.com>
References: <20260305064700.116033-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=554 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Authority-Analysis: v=2.4 cv=HcsZjyE8 c=1 sm=1 tr=0 ts=69b75fd0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=XK1gqvEq3fAbpJyagg4A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-ORIG-GUID: 50AJ1yQkRsrl84FqTZJIn_YMlXg-l1RJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX80YMmdWxcnL2
 7Mw5BIJtSRopD+ZVDyXMODzV885uxvHlJBWzfvHO04kQ0zEIkvilavko5YvVpGjX+JHAlds3UCr
 tcAvga/jCXZy+nqtVNExb6nU7c03VPZ4LPI4TQdF7Y4liUzAWCpl1C4IfRsN00atuo/72150u9j
 VObh69IsK8xComoCRFnNuPiTTFoab+b59cqe6As9yGnTpXcHTkCz/Wfn7Xuu/O3MqXWVbW7oDhd
 Le/s0Lz3Cdhv3S9oTME+PpoL5t0tgwY4pt/Q6/RCShFKA2/a1KW1P4Uj7Tkd6YVOMkhGCH9KGLG
 lC/nIVNqYhDhKUFXqsY1yJ2cUtNX61n3jVnUP4Gwg1dRWmk3ZCPO4tDJGt4mYCM2ZHgGBc/O9+t
 A5fTzZ49pU6DpVeZFZqp304IKJbg0883rCCyblzohYEmnPRp8uN/pE+2mX78dpw7gpXOioYyQtN
 6rebwmROGI0ZijV9wl7yMW7pp9lLvS8+foJ/LxLM=
X-Proofpoint-GUID: 50AJ1yQkRsrl84FqTZJIn_YMlXg-l1RJ

On Thu, 05 Mar 2026 14:46:58 +0800, Yihang Li wrote:

> This series mainly consists of some minor cleanups, printing format issue
> and risk of overflow in bitwise logical. No functional changes overall.
> 
> Yihang Li (2):
>   scsi: hisi_sas: Correct the printing format issues
>   scsi: hisi_sas: Fixed the risk of overflow in bitwise logical
>     operations
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/2] scsi: hisi_sas: Correct the printing format issues
      https://git.kernel.org/mkp/scsi/c/87a629fd5e37
[2/2] scsi: hisi_sas: Fixed the risk of overflow in bitwise logical operations
      https://git.kernel.org/mkp/scsi/c/c420f7c4ac7e

-- 
Martin K. Petersen
