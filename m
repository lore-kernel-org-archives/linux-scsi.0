Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AA3BFE44;
	Tue, 16 Jun 2026 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576780; cv=none; b=E/cRvKEP0djl37bQEdWrl9FyWULFz/TYujocByTk23+eJ7ZO1YWggASQ0GRJczyyuQi8LLPQVzqRssEZAHSIF5Z0++iqCrsgtu8FM4mC7nKGs1Z15aUaj6g+Y3AoM2ouBgI8xLRHaDzvRawsCA22ozAu3hq9vzeBYrz9XIa1Ob8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576780; c=relaxed/simple;
	bh=EPQDYqAi+QMRuyyuNXTiKynL5b2hEqzrhRkRhjqjzF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAHChB1LA3tCJz53fp2FD+j5vhYwY89CXNtE73sI7paFV7AdZBQkOLXW+/vBMBYpSToPn3cC17i24sVOH6PZx3QdwR9HJRrkE2mvPwji+PO+UjMjmxEtzRaSL31mYupiypHS/Dvlv6LTqd1okoZgRwf8JHWMvqDJTQwE8QD1AF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ze8Mo7zD; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ze8Mo7zD"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FKiaAu1304546;
	Tue, 16 Jun 2026 02:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ncL/8xhn/8YQRJcXFueLCD7uPN2/36VUocLuBsvGSgg=; b=
	Ze8Mo7zDTDXDI2GnVTEbHj+kyu0Z1XIuYw62EwMfdrwoNyR+Lhrb6JkcH8/FhY2p
	StpGwCFbmXJ8NjI+IGIHwFXYqtjX+eiTbqdr0u2LU32yZ/8denmP3F3A+gvjyOjI
	ArnKsMrqMLLgmoogZlkALSszw4E12eUalXQgieGofW2i84JGMj3kD3txnMXt49zK
	NC/UgvGPupakZ87HecAY5FrUkEu91FbWeHViAP8RMmNCCFELGYhYxHSDRMNLAiuf
	anfpGo/g4qcO/Y+ObVx/JPkY7PVJw2Eq6DcSaiiCxHdvVr4tNZ2e4LSZYyKpSpeI
	5KhsVHd/L5FuT4q6UUubsg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1hxkjsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2NZbY016491;
	Tue, 16 Jun 2026 02:26:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnykr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:16 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2F023822;
	Tue, 16 Jun 2026 02:26:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-3;
	Tue, 16 Jun 2026 02:26:15 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, josef@toxicpanda.com
Subject: Re: [PATCH] scsi: target: Remove tcm_loop target reset handling
Date: Mon, 15 Jun 2026 22:26:07 -0400
Message-ID: <178157184626.1899010.6380556511974602739.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530052349.5134-1-michael.christie@oracle.com>
References: <20260530052349.5134-1-michael.christie@oracle.com>
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
 mlxlogscore=669 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfXwktNIC9ceLCV
 RSyykyDF8tKX3mufCv9h233kQQ7XDRHbghcUtXcAXXwn8mVkddHM5tbmAmjm/puP40hUUpkTf1Y
 zCN28V/eRAoUP4AaXlmG8QB7CaejfGflXRawy6Pwuofw/e40bIK7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX6P2HQfiEqz74
 /IivoichyALk4tmsxWD58lYSMMo2rtp67TU0QbzWGdsj5BVQG10XmfL8XrKH0GtvnuLSo47xmzM
 AOMbmRuYWsWZ3YI+yDDKm0p620ZN/ta6JFp/dEgD8wjNtye2BgynGW0xGu4D0fZUM1XdkUD1JTD
 nHt71D6/lY6i45gqnMtKHw3nYZWeVgKMf6x8NMbpjndSqHlSWDanJzGMLkri5BSzAAKTPGIu3Zh
 eLEVlH6Xw0xhSS94Ocb80ncOYjxnSV0WVCMAAvt2txWofDXI5ekKrRLESz+zcST3VF2zdLOgMDc
 YG/Sl+I7yL1rXNibYYX4ngtjHQOTlzRMF6cf4y9gXaV4H8QplpWgLA5QaDn5QyHpdGHbD7ZoRwD
 dmbA2ZFuDwjOOXw6Zq0NZSstYE7YUisfmp6gqq+CuPyewyBV2pz8L3oTXTqw0iRegAkT1Uh0Dbt
 xnZycXWBpYTxa9hA4HeNCPj+UjMxo9HIJDgjNNfI=
X-Authority-Analysis: v=2.4 cv=I6pVgtgg c=1 sm=1 tr=0 ts=6a30b448 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=xHR4Gg2pkDzugfHY-2IA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: Z5qlQJ2Hw4S4tyKoJVXqYcQZ2JpokkVT
X-Proofpoint-ORIG-GUID: Z5qlQJ2Hw4S4tyKoJVXqYcQZ2JpokkVT

On Sat, 30 May 2026 00:23:47 -0500, Mike Christie wrote:

> tcm_loop_target_reset is supposed to handle all the LUNs on a target
> but it's only doing a TMR_LUN_RESET so only that one LUN is handled.
> This will cause us to return early while IOs to other LUNs are still
> hung in lower layers. This just removes the target reset handler for
> the driver because LIO doesn't support target resets and for the
> common case where this is run from the scsi-ml error hamdler we have
> already tried an abort and lun reset so waiting again is most likely
> useless.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: target: Remove tcm_loop target reset handling
      https://git.kernel.org/mkp/scsi/c/7c08d430835a

-- 
Martin K. Petersen
