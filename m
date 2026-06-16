Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AFC3C0A01;
	Tue, 16 Jun 2026 02:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576781; cv=none; b=gD/4bqh0POKraYSsm+mcTqkYxKnkjUsgLaX5L9jykO1RhYCTRA0JMW7GXXkAhiGJU/7oWq9ZPu1Lerya99T/UKYYmQ6j1fupXhgc7yWq8JgXFH8HAUYH8+kgiXt49aXJIbrtZCCMMqXS6dk8xOsasa9cB7qQIAT/vbeEUOWNiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576781; c=relaxed/simple;
	bh=JvzatWJQlvfEvpbrVM+9EeUPq5HoS4Ph6UiA8H843BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OsdqfZGAWv5r2upBvUMVvXP/Sy5oblw2tjCTrEvWYrU3FvjXundf11JqCthYKJIfNJGL2BS2ZLc1qYvxgABYYbdT2hC3xsbmaOvMQlGPNiZhGiPY+0rNm4Gmsrcuip0g7Et6z6EeemvxC6dP4f5s8Crm3zokTevW4SJtB6r1wuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iWWRHKhQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWWRHKhQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJeWQ71343669;
	Tue, 16 Jun 2026 02:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UR8t08nvbo4L6jR6KQlZQmh8pAkNDorUX/FDzIUwj+s=; b=
	iWWRHKhQTQbs2zharPKTZ8UWPDiCojVl6rPFWUjf2ZrB4jtRe0CLgMYjg+o2146o
	GmefqXga9oChUYV46uwgr4xL1P2gtpfSqdf8eQ0w5IN4TeUtRzZQXtpyogByVNOa
	M4n7hDWkdexZWp2NQkt1bxha7w+S//fjXoVGWuTklcl1kcH+HcCIW6fVqHlB4EUv
	egN3GxJraRDRCsXSPC9qJqPSDWaP/OX+rLaad3P9IOZSyXC6SeAlaVJ4rHXEDXXz
	IVAL3wIOxCOplLuijD1NULTtzhjcpw5ON2+FHhlSNl+jM+06T2Fmt/PL2dmoMvZC
	ITqWlM9bcrZxEeAg63FGBw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es18m3kc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2Na0V016668;
	Tue, 16 Jun 2026 02:26:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnymf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2L023822;
	Tue, 16 Jun 2026 02:26:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-6;
	Tue, 16 Jun 2026 02:26:16 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Samuel Moelius <sam.moelius@trailofbits.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: scsi_debug: fix one-partition tape setup bounds
Date: Mon, 15 Jun 2026 22:26:10 -0400
Message-ID: <178157184617.1899010.18335501044919497120.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
References: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=929 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-ORIG-GUID: mmuufJ0Rgq_R3LwJbUM6k77IPp0vDuFy
X-Authority-Analysis: v=2.4 cv=ROaD2Yi+ c=1 sm=1 tr=0 ts=6a30b44a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=x_ZXPyUXYTCL12ctassA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX9g2kFocuuFSZ
 d9kWroTfmCZOIqNJDGwN8JJ+pTRrRhpGJwv0uxTZR7wOqyUvVE1xHaVIKx+rVHmGfy1H3Dj7U5w
 MiyBsjQLSAvO5XphaPe0JEZMqslH3dYh/0u5cCAf6KKhx183Pz0r
X-Proofpoint-GUID: mmuufJ0Rgq_R3LwJbUM6k77IPp0vDuFy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX76CXo9UAnYLT
 pOq9bGPh465r7ljJAOsNnrY97gy8+V/ESbN64hc4gNK8sgCwfr5tv0U8+jgJSFPJAOuQBFHLnj6
 MVlou/beHMVgOcq1D0cFa7iPFzha0w9LGClRG2Cl9yMiphK7HDSS8EzTQ+eyOBqDqwJLC2KwsMd
 KHlIN8jR55sU8b/XUMzb/edpwQqfG2TxTNI7GmOxLC5uEZ/UgpsKxb2u8Yva7Y8izAfeTlqJss0
 zrV3t9osiBqKq6O5znEwGFBQHSBS8GKyta8BzLrip0KwAUtugYvFBw6VXl/NzuGE5x+dXktNwDn
 LNmVh96W2i01TC6pskd0PSzUb7ROj4XLjNqgeTOoAAb2YIPyfVNylSte4dBZtdjAlu7EIiMi8iK
 gwrqmEJKSYjkCOsSShPaqANEajscYzqNiDcKJG0Aql2R9ZLY9thLdrA7bvWp+3iE7duNVYFWswC
 GyGwjPQJfpb+z4aLG47sVEGvv47rZ/k/63Eg6i8c=

On Thu, 04 Jun 2026 23:43:56 +0000, Samuel Moelius wrote:

> The tape setup path uses one tape_block entry as the end-of-data marker
> after the usable tape blocks. For the one-partition layout, partition 0
> uses all TAPE_UNITS data slots and partition 1's marker is written at
> tape_blocks[0] + TAPE_UNITS.
> 
> Only TAPE_UNITS entries are allocated, so that marker write is one
> element past the allocation during device initialization before any
> command is issued.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: scsi_debug: fix one-partition tape setup bounds
      https://git.kernel.org/mkp/scsi/c/3c08f6034d74

-- 
Martin K. Petersen
