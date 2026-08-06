Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D374C8FEC
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043209; cv=none; b=gvvG3AyNUeHI50a+6mp15leR4rcgWa86q4+yUgqVjVvRdnaJnq7ESIQUCyePpNgN23D26G7YXKxBhlhlnFkPaRZIg4bjVywQTH426Csox2gC00zDDpm25HN6Mna/z7yAiopqVHZ8UYCHI5qXxcRfI5GE3ARmmLTZIih4mdyO4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043209; c=relaxed/simple;
	bh=FbMfXU/xBgWG2Yj60grkrP62LVkD9CRxC8/t7pZ8g4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HltQFVtQ6/TpxOuh0lE4w757i83bRl1+OAYShUfd9cDus50JQ3clarbyNdKSBt2cqn5dhJm12JSKleRj/mBkjr7Fb7l7/qAMnnuu1dBRz8X70lCZ8irN5AuaEWQy0Xm6WdGBzf5JX3eBZAbG8nTnh5qQO1j8FcrwY0UIjGvf40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NZ1ctacm; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NZ1ctacm"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Fu2DR3283362;
	Thu, 6 Aug 2026 19:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xwBcVxIn5vJLMmYuA92mkooT8bkCdRYLHDFHoDk5Co4=; b=
	NZ1ctacmBYGMALMXkAWtR87ncB2F1DaJKR1sskc2mB4XAKTz/L6DZJ/+R3/pZ2NX
	K6Q5g3NCCUjUa4XsCA2yOG+RnITSbRkbwvg1Yvg9LZX54sTLCDzw2CABJvk7vw0r
	MqdoyhAUW8kZY5wS4ZPT7gwljz50ZMJ3aOc2wMEDYyZxbaTO/oJ1rU9GpRayIHop
	Jsm9cqDtnheXo+U6zseOoRSqT6bwbj3iukrBGvEMcOJo2885kZCDqtrPCmk4318u
	p84S/7ELWatPf6Z2JV4odPTEMCRbw7Jkun2Y1NeY/et1TUY1eItSaxyNMivHQKvW
	9e63GyLXkH0TFLvP9HamsA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p9e9qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0cEk024696;
	Thu, 6 Aug 2026 19:06:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:28 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgn011247;
	Thu, 6 Aug 2026 19:06:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-10;
	Thu, 06 Aug 2026 19:06:27 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@sandisk.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
Date: Thu,  6 Aug 2026 15:06:15 -0400
Message-ID: <178589207050.336697.8137292136805471417.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720013759.2979593-1-rdunlap@infradead.org>
References: <20260720013759.2979593-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX038ke34bxd05
 yBm4sepHUox+6PSZoAXSCDpHHcdkk9tIfHqpgw53DPJBhwLY4xeJBl8zm9x9QoSHF/ZZzJt0Atp
 /ZTQQs3n7/FilVSP8aY0fep7XO2PdDTY+A2cbm1nHG5b6kGHw6nr
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a74db35 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=ofeJa6bYm3wA49rNNkoA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-GUID: 2iwBW1JsS4sBXp7DLvRNPV0S4omXd07r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX6USZFJ8akhso
 oaxd1a+D1m75c2XD9OEhDNervB12zkICrcccNawA0D6ORSp1bdQoM1OA+K6U12nPGhh/p4EnW0b
 3X8hzuNnZWqTk/nF21u4gNQ80PDMXTsjGzv3bcaVm+AV8Ysb3el5vBeDDiScB/VUFIr7xe+71SW
 xuL8jl0lFtymRJNIMqiICrCVNCz7nyr3ipRsU3Ye7RzLBsGoVca6WkiZsiH5L7xoeTukQqgkdTW
 vY1hVhEowfNCKUDqz5frdGQsy/cYJ48nqRbUD1g8Y8YkvPLDBH1GdTtKl07jW0bN7nMnV2Rc11g
 nCSg45IF7ixe0cTNJDLBzl8cWvtcUXA0BSb05TlsmaBf0H5siHP4ZS+zKJiXhjMSRNmW53ZByJU
 ZjKwekT2W92ESnbmTa4E/QrpgNsS2M0xCDl41hSxtJwx9J3iOigCtfZE/G6VOYDv376oAfIRXck
 BpM2D2qqU+wr1gTUK8RNI8+T+9DMITYj275jwt5I=
X-Proofpoint-ORIG-GUID: 2iwBW1JsS4sBXp7DLvRNPV0S4omXd07r

On Sun, 19 Jul 2026 18:37:59 -0700, Randy Dunlap wrote:

> - use the correct name for a struct in kernel-doc
> - add kernel-doc for missing struct members or correct the name
> 
> Warning: ./include/ufs/ufshcd.h:201 Excess struct member 'task_tag'
>  description in 'ufshcd_lrb'
> Warning: ./include/ufs/ufshcd.h:220 expecting prototype for struct
>  ufs_query_resp. Prototype was for struct ufs_query_res instead
> Warning: ./include/ufs/ufshcd.h:577 struct member 'suspend_on_no_request'
>  not described in 'ufs_clk_scaling'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'nortt' not described
>  in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'trigger_eh_attr' not
>  described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'timeout_attr' not
>  described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'lsdb_sup' not
>  described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'vcc_off_delay_us' not
>  described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'desc_size'
>  description in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'res'
>  description in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1309 struct member 'sq_tail_slot' not
>  described in 'ufs_hw_queue'
> Warning: ./include/ufs/ufshcd.h:1309 Excess struct member 'sq_tp_slot'
>  description in 'ufs_hw_queue'
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
      https://git.kernel.org/mkp/scsi/c/98575b9ffc3a

-- 
Martin K. Petersen
