Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8912DECBF
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 02:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194990; cv=none; b=JbvcsNNwQzytmz6JM4MtnwcWO/pCpR8ozrDtzdYOcGJ+y8QKrQmH0ft2zCW2p7by9AoHRg/ynWDzHUoKSBfbjNjYHKYWjgXeAbl6mO/tTRYcVq8MqfT6J+yIJX9S2SjZoAlXcyrNhfdPt9zLC535Rt0sN0zoE46BttmDU0bT83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194990; c=relaxed/simple;
	bh=/Cb1tr8j1dKA21uHsgC8HDNJBYZe1G/5dOj0DXDCIM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4nCI3xyPz2ZdtTevCRKyH+N4xOupN15PC7fUsMTgdvxS260VHA986sZqkr+/NPM5ePk+pYhWX3NCmj/7emQRgwMYMvqjw8yvua4bm2D6tMwSW8AJRP0w+dROQ7vXvKJK8olynNl62OtEFXqj95+iHcQ3gLqMmaMzVtQIx75Too=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m4LEJqP4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m4LEJqP4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AJCaSu1627717;
	Wed, 11 Mar 2026 02:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kLZKT6+qawDAfTgh5jxrCJSNNDl5H+/TgfxXJBBMw3I=; b=
	m4LEJqP4u0JK2HniXzraGVbG1CtMaUjzUGkV5+NW4d8ckkiHIvV1fuQXeSC6mY5v
	4PNH+pF2ahH4fpaCFT2CEfzqFwn+pzL3DY+9GhyuQFp6NtE5dGhiGfA7vz3FN6dW
	5HUgDLEF2yN6/Z6w9LF3xYBdQZp3jBcnh7FXTI3sA81/fGySV6I8Qb6jqvdYXxMX
	IIhieeH/0sEND0bDwawXxKxaNNUHI3z6MJL85XhyUXWTplJJUgjqTIArpC9GcKff
	E4h8Rde5MJXPVN8JNYLQqYYy7jpuoUBByxy/SWIPzwd4hL9WRWHdtYYGxDGImcY4
	36HjLGub69qcih3L7MAgcA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmps44db-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ANZSDt013580;
	Wed, 11 Mar 2026 02:09:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffewue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:40 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B29c9k018454;
	Wed, 11 Mar 2026 02:09:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4craffewtr-4;
	Wed, 11 Mar 2026 02:09:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@iokpp.de>, linux-scsi@vger.kernel.org,
        wanghui33@xiaomi.com
Subject: Re: [PATCH v3] scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend
Date: Tue, 10 Mar 2026 22:09:35 -0400
Message-ID: <177319446949.2524613.4552713745618708517.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307035128.3419687-1-wangshuaiwei1@xiaomi.com>
References: <20260307035128.3419687-1-wangshuaiwei1@xiaomi.com>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=913 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Authority-Analysis: v=2.4 cv=IJQPywvG c=1 sm=1 tr=0 ts=69b0cee5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=Og0uWtgEV8ecH7RMSB8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX+V7nO/bYbmIl
 8/gdRpJbWZ7LFM6K2/2ZNikb6suNemgDEGzu3SZ125BRiHO9ea+WkXvXZMjh/rVUBCM/v8jo3uv
 RK6qerYAwYA9Q4kpzQ/A/+Qn/anCV4tqhAvcDNmfumapQQmx4c7IxcDbsjSVRLG+1rufUMFKaN8
 MVtnDukeaEEuHBs8Ei/XGTGTBlEkQEa1Pk3yaP80aIdt4z1NVZVinrV0JmwAgc5XKb7Vh5Cqnl+
 HDDo/Q8QUQIlVUPJA1I/N3kGbwv8P5dSoKhcjvmAu/t6Z8uxSlNZuO0jyWRrmc37tAgtPwuMp1x
 7dKJKn6yyXziitXhPRRKQTt1+NuzbtT7W9z84eQ1H5zGZbc7SfC/o++U+c9tK72emvQo3PfAUMD
 8ZkM4xn39FInuhTPX9CxJ3ytFTxR9wwLXiftMZgTa2MGxn0X/gLTmv1ZlOaDQWh6rk4VA3xaou8
 oBim7HDTURV0gd5kg0AYEGxhoxc71wn+1B1/303U=
X-Proofpoint-GUID: usyAhaZ9x5Eff9CnI3BQm80ebrED6vvH
X-Proofpoint-ORIG-GUID: usyAhaZ9x5Eff9CnI3BQm80ebrED6vvH

On Sat, 07 Mar 2026 11:51:28 +0800, Wang Shuaiwei wrote:

> In __ufshcd_wl_suspend(), cancel_delayed_work_sync() is called to cancel
> the UFS RTC work, but it is placed after ufshcd_vops_suspend(hba, pm_op,
> POST_CHANGE). This creates a race condition where ufshcd_rtc_work() can
> still be running while ufshcd_vops_suspend() is executing. When
> UFSHCD_CAP_CLK_GATING is not supported, the condition
> !hba->clk_gating.active_reqs is always true, causing ufshcd_update_rtc()
> to be executed. Since ufshcd_vops_suspend() typically performs clock
> gating operations, executing ufshcd_update_rtc() at that moment triggers
> an SError. The kernel panic trace is as follows:
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix SError in ufshcd_rtc_work() during UFS suspend
      https://git.kernel.org/mkp/scsi/c/b0bd84c39289

-- 
Martin K. Petersen
