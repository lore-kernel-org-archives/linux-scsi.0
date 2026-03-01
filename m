Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B942D8795
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 02:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331127; cv=none; b=cTrSlFj0+TmD84eC4nhv+b8aEpdsqAZ8VzVSLgQNurV3v0VRjel4rKhjy8/DtPH+fmITj2TGOdA+A02CicMjkZ1qv1kvzqdgLaaBnEz2V9ib9KJ+91/qAVGi9OSal4MSqp4Ua/vfdKqtd9k4psxoXJkUhBhl8c+ZS68kalJHn28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331127; c=relaxed/simple;
	bh=YWJrTkWcAvzjR/ycrCpej786S969aICUA7S+d/pQktc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRWDfR0pU/Pk87nqwpXIXehrfpIywPvs6Vipm3svGNvMhYZ+/52NE/D4x9+Jz50y0y5Y0LfGT5itTTBdusSonbLK8tQkOrcna1A4kpR9aOOK3KWJwc1x24PAwQsyOdyZhWbb+UmMR4iO5aivC7twgQdKTKA+cMuzrB4my4kfQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n89rCAQW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n89rCAQW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6211oimT2772583;
	Sun, 1 Mar 2026 02:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nlrYsCI112iEY9Gwd+lU20Tm6It9ErUcfrY+UEbQATs=; b=
	n89rCAQWjWfcVVJauZv+DGZyCxpMPbsGH95HlmqJCENLol957wf3khHhvQmbHINi
	P5e2F/ftXY+h2y+UFd87ckShU1aUzgT1p2a9Z+gQ5KluC3KQpWY4aX1Ek8/CqJia
	3L5f1i02SNSwmp5JMyxckdxvBbKUSh3asQtYeSM1COp8hxAj+5BKpNEWbMKchhe+
	2GtkE6Axr4YTJgkNjIPZIAC1156XX82s3Kc5kZaR05NtVigcfH0h6vV38poDoQ72
	KFZ7ervBDSrdLUHA7ZdkZxxi8q05ObE0q+IbQKO+AcPrb1Ypi2Rwt7rVfqqGYtBQ
	/abVvxaBwhKrSXXC+JkqEg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshn0p7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SNMsIL035232;
	Sun, 1 Mar 2026 02:12:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbpnr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:12:03 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212C32B009031;
	Sun, 1 Mar 2026 02:12:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ckptbpnqs-2;
	Sun, 01 Mar 2026 02:12:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
Date: Sat, 28 Feb 2026 21:11:57 -0500
Message-ID: <177233109535.1886347.8886032056814187007.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223232728.93350-1-junxiao.bi@oracle.com>
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
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
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=973 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603010017
X-Authority-Analysis: v=2.4 cv=RsPI7SmK c=1 sm=1 tr=0 ts=69a3a074 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=73EVitq7pRXKZpIRPpkA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261
X-Proofpoint-GUID: FTyrZRKy0dakJoPZDEIxZfW4EDTBucP3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxNyBTYWx0ZWRfXxWWC6DuyWxOK
 SFR1Rso9bi9o2JOZt/y5KdWHV9dWnHjtNBKbR0N45BzW1VL9+XQW5Xu0LJyIuC1+kGKeAiev0WK
 TotnSxv1dGiaXUyU/Urj3wIx7tJ8Uz9D3Q4XOpqWq69Gfq5l70YusSRtSj+zuiUqbEgp1HkzAcM
 IPdYh4nWkYObiZgo/Ts4RvXb6dAVU4rS8C1u1k3TJRFta3ZX3WSl34Aa02C2ojhCekcAHMKwmod
 gGm2lYAr9FfYNhgyjERN7XBAqRebAHPdUr5ypOO+XDV74kWC06DxHs8W1UzpbBag9XFJiZpLGGW
 riS9muSFmzTrv+0+UXrWAsIo8IZVV+u5UQtRqC+X1/TEIwPkuprmQGqqOEoFFIDfhkRwYHnCZAN
 wkaXG+TCSNbsAdFflCDeO2utuspcPPvUCedDjzIcC7WraGjrCRr7UEB6sjMwC8rVaLi0hDjYjLH
 VL1xoHyjPXmUaKxvh9eGxSSS/h9Trfj64myBB2R4=
X-Proofpoint-ORIG-GUID: FTyrZRKy0dakJoPZDEIxZfW4EDTBucP3

On Mon, 23 Feb 2026 15:27:28 -0800, Junxiao Bi wrote:

> This leaking will cause hung when tearing down the scsi host.
> This is an example with iscsi, iscsid hung with the following
> call trace after this kernel log.
> 
> [130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
>  #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
>  #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
>  #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
>  #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
>  #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
>  #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
>  #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
>  #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
>  #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
>  #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: fix refcount leaking for "tagset_refcnt"
      https://git.kernel.org/mkp/scsi/c/1ac22c8eae81

-- 
Martin K. Petersen
