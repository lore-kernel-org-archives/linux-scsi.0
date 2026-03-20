Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DB25228D;
	Fri, 20 Mar 2026 02:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974228; cv=none; b=gwstIt4IaC/F9v3L+m8+5DKXw4DLAEFzptq4Qv79E4cq/EDnBEGFG8ZNM44UC+rgTw+qzA8ItZrX4HidSp5hqMS26VhfeGZ11jXq/HuzJmIjX494M5v6Yq+zdYRkcF5GwwUg/bn0RJQy57GS1Fi4jkSfLxeCXX26v9Zn7y2hVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974228; c=relaxed/simple;
	bh=YVeZ9bpU50Ld/h/oOVq1kH6lX37abRxYRQZxsMIlO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M03d+OHk5EETn1Yofk7+zOw/atojljnk2t6Lp9+qpdQ0xHQ47Pjf0yiB1X7NZT9ZuEoAGCAO6Sg41ZK6z0qfSMwBOltlm67INX2seqwXnTbncEWNhO+31EH6JCboIiEoAYZOIUJ9OK87ZzJ7d53v611KRHgHurOeHZgst9Cp3xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HWDIrZsF; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HWDIrZsF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JH4P7n3798372;
	Fri, 20 Mar 2026 02:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zVBF5ZPd5Mvu6dwcbcrrntqHzE/2GM4nZmyGfUpJhlk=; b=
	HWDIrZsFXisI42wMqzg0nU+9OgyPsDwOT+MZb1O7sQnz/GIAHBHLfETCrPdl5EMq
	iqa+NkD8pf5HeaQXLDvAqo4DEWFdEGOoa04BJgSFWo3DB2y0/YpG4qXvBxPHENy9
	VK6BrS8B9oyIJMozOTraFNgvav6KEvYPkIbdAmZg6t5mv2j+lgCKKEEkgjZPfPCb
	CaGQ+XHwQMX2TADAUQ0bZiSbzB1w6fEL9s5kkA8/XQ5crh2C+4xhhNEzC/mEQt+D
	50YadQUZG7Nd4VIiR1v3ZXF2vVn/2ypfAgBBghXk+YTRhFR+Jemea9yvqfHPW81a
	gIf48b82cmN69B0yBYBwHA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqc0v49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K1oWZc003476;
	Fri, 20 Mar 2026 02:36:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp7dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aDRR020555;
	Fri, 20 Mar 2026 02:36:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dp7bq-5;
	Fri, 20 Mar 2026 02:36:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target/file: Use kzalloc_flex for aio_cmd
Date: Thu, 19 Mar 2026 22:36:04 -0400
Message-ID: <177397393965.2929898.13829631412694991402.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f1a2f81c62f043e31f80bb92d5f29893400c8ee2.1773450782.git.Thinh.Nguyen@synopsys.com>
References: <f1a2f81c62f043e31f80bb92d5f29893400c8ee2.1773450782.git.Thinh.Nguyen@synopsys.com>
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
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfX0cWWAqx01LSn
 OATiB12cNW5HZJ0kiy90X949wAl0820sCnInSWX67FcUqZfDLzLek27YLyoZXMlQNt7OeCi5Bh9
 gqd1DJQ/tWyXZzJRfTjVAcrMH3mmySctQVpagEzRWXyN8kiAT4dZf0R7TlfPyVCYaTzFDLQK/Mu
 t620A6yRsXg3G6HBhGm7Hkjz7r/vokVHQBzkRfUdm05dw5Qz1nW4/YC8C7D0vHLG71f8aKl+jYr
 vAprvboEn//OyZaRdl6FCbjJfq2gjrGBnRv5fnETI/OpWYF2Qn0DZOQmRY1itp8ttUpbI4RRCRy
 89HBMYEO2wM35gpFXWy2ycB84XATVbfd1TwiLEND+pkPM9SkA0XieljE04AWvAXofYq3nvnc25j
 oDw64YkIMTsaxgqh+rCeE2yst1JC58an0E/0dj1ugMMVNVL/luTz1slJ1/MZhofED25RKf5jGbn
 1JKCH1pbHISFK+Bbo/A==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bcb2a3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=ROUghZm4d6-JAQTG3GYA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: 0zyF3EMiNxUGtF8rtjr33ajOploLzsLh
X-Proofpoint-ORIG-GUID: 0zyF3EMiNxUGtF8rtjr33ajOploLzsLh

On Sat, 14 Mar 2026 01:17:40 +0000, Thinh Nguyen wrote:

> The target_core_file doesn't initialize the aio_cmd->iocb for the
> ki_write_stream. When a write command fd_execute_rw_aio() is executed,
> we may get a bogus ki_write_stream value, causing unintended write
> failure status when checking iocb->ki_write_stream > max_write_streams
> in the block device.
> 
> Let's just use kzalloc_flex when allocating the aio_cmd and let
> ki_write_stream=0 to fix this issue.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] target/file: Use kzalloc_flex for aio_cmd
      https://git.kernel.org/mkp/scsi/c/01f784fc9d0a

-- 
Martin K. Petersen
