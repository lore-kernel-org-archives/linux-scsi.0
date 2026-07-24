Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3824A06D
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 01:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784855452; cv=none; b=jv91uV3utNDnZ2rc+hw4HOiZMwGMtWtcd2U7hzqyUXYNHc3hxNWUGuRKk8bYyI1nhIvy+EyyiCfFXtMkALYbAIYS78kbEaAuVmI0GBsklewjWr8axwkq1fFA/uT5y/bZpW76Y+vFOJq1Ihd/sKk3ksENUAKz052jgdB6DS69Djs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784855452; c=relaxed/simple;
	bh=cKCXzL/Gz7oPhZJ4mW0g34rVgolKaoUYkZt4WwmXgvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDLjIzK0WZjwt7tK1x9GT0zpL8pm9WNJmmwvRoZ93qY+TdxiBWDUkc4N6oHicEiAH9VpPVXfOox3FTCb7hGptNWiml1u3/AoHx1Af4a7vlNSGIAK385uAoJBxx3BkTt6NsfhxAlLCpzBjyV1FN9OmtwRQJOlm/0SwGytWPq7Ts4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n5zFC0Ya; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DEiTU/KE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n5zFC0Ya";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DEiTU/KE"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NLedmn949238
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 01:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=HPYsD0/TeExFSSyQteQLZbxh
	X5u9ElKV6bb6GLLxXCE=; b=n5zFC0Ya9YRS8LACbWev7keCsBaS0bJa1bNnxKg9
	9VNXYkeRhLfjWLn3uMuUM4zNjUeDk955PYoQambYU2WXJEpPiqN+w+rZj9uZqXFl
	QmntrSOSB6vLxOQTV0Tn0FCVhHbbiEp1H7OnyDMqDS2X2NZfhdy6nW5cQ/W4zLVP
	pR2fy6V4TfRmpYFdiqaNcnFgaRrP2GrrPXfAn7IDZDk0Tql8k616EvEYPZkcvKnT
	zdtOVBkNLqVvEEjhe+k6cBe1GcmLVWEvOjppDcWQtb9oTI8+h+sjflKEBUKjGNdC
	m4C8ljugBVO/qPBqrF3uyjEUalCrOUOW7i9AyY175DDC3Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke0kv6uh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 01:10:50 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cccfa32670so16937025ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784855449; x=1785460249; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HPYsD0/TeExFSSyQteQLZbxhX5u9ElKV6bb6GLLxXCE=;
        b=DEiTU/KEpjqEQoIC+xBwTEyV42CsuNh+GKgyv8SIaZnkd7suyWfViP8+OnRtgV/dNT
         z+raT5AUySwyRrk0bcKSX1dn/gv3m/ufQUpO1OrH1thkZC96pr5lsk6t9vxnczRZCzBR
         KNOagFrJRjNsUOqoxhhlZlRTLv4ZiZ7CfAfIZRb28os/45v1sGAqtlRTHlW2ccVi9Lfe
         ie81OWQyelykOeAwK717hy/n5CG6ooQr0T9MquSkb2NlwyIOglHaaMm7QH9qq5rDs7a6
         hZskHFOT3I8wCYGDJ9CzUnXmtYkahACeco+qARIQITwxXI8XiYiMl2KdhNg0dmf99NVs
         yaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784855449; x=1785460249;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HPYsD0/TeExFSSyQteQLZbxhX5u9ElKV6bb6GLLxXCE=;
        b=LYBFHC7nz2A+AScaaFvtd+DR3U+H3n6zu3xGozhPCXC3X3g4kwATa13QSZZypWQo5T
         66lTqU87bdXxcq4UZchyfhOfrmJB7oCP9V8f7CZOW6oB/LBFrfGwDnIH8k99oUjraxYq
         NaKyYkq/o3TTtqShtu6PXyfQhMuzbKE873hNrxbSj7YCoPUIkvfdx9dsheVnOmWZFGWK
         pepef4cdaXyIw49JYqxOjxwL3C6r3OWw7UsBIYYtZxoNWn8+0Roy6FRdxL97xViK7QFz
         FoW4MMUrTGY7AxBNd4auCarZ7gC/I7APmGB0eZM0gzV1i7nWpZbqicbTw2yQr/fElsqy
         6cCw==
X-Forwarded-Encrypted: i=1; AHgh+RqVYu1zJf0PKoLGl3AXgxw8zbe/0kjCpH56Jb8XrOv6JuMKsorRnxf/IThQ/rdkXENMILMKTwIpt9Ty@vger.kernel.org
X-Gm-Message-State: AOJu0YxajYD1qRVkfwHYr/NL0Y2/P6g4etoJWJIn6oxHuR5ngdGYas+7
	s63AQOhrRVvA4tlaf/cHePKP/pwsjPrXf7jIEwGpOFE9PuMxDs46X1RqFEm+qAbGgfLZwEdt3mB
	LaXrT0tz4jM8yhuBP0tFZkokRAwY2AarDM3SNGmQKuaE3dp9IkNY/7Trm/wn15TBk
X-Gm-Gg: AR+sD13MwOaa9vwQv7ZALuobopgSIFeMDOo3x/3ppvwo1/WaLGQbnSxMZU0XHYyhGut
	q0tTqF6VIEcURC8o5MuI3hyrijI2pYdWKDWhZxkE5YeF5Rq9P2YQUm3686aschOsZKYD/7Co/Xz
	hAEWRcRh5wSbQVsgcZfTU6v2Ym0jkCzWT4PYi8gPorErHN65R4GsYWfJ7wSdy1kDDyDcvbtUMV3
	hw8AAtgPcmyNq4vQnSjkEA7qEUlT2aSJm2fy6ivU7I+J/NavRFRmRlcH3szdqV83aHKhZ8i71jQ
	kRyKKFJHV2YtWGPwW51BTVLqAEQwpTo2ceSNiaPFdo89pwi1/TZmtIeKuZIGA7bxHZcQtd28+Xw
	+RLrnRddrT925zWISgtZfL4oM1ox+R6Zcuvg9MwaHxWU=
X-Received: by 2002:a17:902:cece:b0:2c0:e5ee:f55e with SMTP id d9443c01a7336-2cfa6a4b3dbmr64006255ad.7.1784855449125;
        Thu, 23 Jul 2026 18:10:49 -0700 (PDT)
X-Received: by 2002:a17:902:cece:b0:2c0:e5ee:f55e with SMTP id d9443c01a7336-2cfa6a4b3dbmr64006015ad.7.1784855448680;
        Thu, 23 Jul 2026 18:10:48 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e081978sm22045229eec.24.2026.07.23.18.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 18:10:48 -0700 (PDT)
Date: Fri, 24 Jul 2026 09:10:43 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
Message-ID: <amK7k-u9ibVz9D0-@QCOM-aGQu4IUr3Y>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: ZP6uV8Tzovt9nAVRss5vNcWs5yhTOKc7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAwNyBTYWx0ZWRfXzcd6FG3k8dEF
 ddYxaLX31ZZHHALrndcpRRNzx6J3XFomFcWOY/mDP/9SjgDKCePFdn30J/5fCzJTqpUIhH40Dg6
 I5q1SXPUJ7mLwguOCEVHWcvzqeq/W6U=
X-Authority-Analysis: v=2.4 cv=S7DpBosP c=1 sm=1 tr=0 ts=6a62bb9a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=PaeuHutDJpf9VW2w4SkA:9 a=CjuIK1q_8ugA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: ZP6uV8Tzovt9nAVRss5vNcWs5yhTOKc7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAwNyBTYWx0ZWRfXyro3mZ07Hir6
 Ur8g+LZxIPgavzV3i0rKVlw/iWa+fNUwYwXMT+Ve1G7+8hvewgYlq8NdkuuKZLDTr7/ElxeimA3
 TIls9qRbjNbudZrGaCraJufqawAF2AHQ7P90X7bs4v/qUGL8noFXf1/0ooxQH2cV0yoYls+MDvl
 PznMp3fgmDsRvojh3ecY1+fvrsvPYqrR2/zZyQ6RYit8uH83/7Qrb46itnFRJMj0vPr5IMws9t5
 1HLAMVjXem1J3PGtMKpnpP6xWiWykZN23obY4KPzDcGGORg9ckj75O1PqiGCySzo85xfkJIbLaP
 goLOKOQ+KL0Obumxu+Bp1SskulKUiZw+E8SFCbh9wbQ+Y9PHfADc4yWuFpWN7QMMRfiFYfVpDr6
 8qrDt9Kcw9ooEZTM9tGgzishHEPhYJF2XlSfIdzPYkctKLoCOerjR5lJKek0m4XQchcAstaAOoW
 eCVupIUsCWWFKT16VuQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240007

On Thu, Jul 23, 2026 at 02:47:33PM +0200, Manivannan Sadhasivam wrote:
> This reverts commit 85b2b966285498e1b551ac85f02c79cd06c0cff0.
> 
> Qcom UFS Host Controllers do not support scaling clocks when the traffic is
> ongoing. But the offending commit removed the block I/O quiesce in the
> clock scaling path, which causes below UFS failures during clock scaling:
> 
> ufshcd-qcom 1d84000.ufshc: ufshcd_check_errors: saved_err 0x80 saved_uic_err 0x0
> ufshcd-qcom 1d84000.ufshc: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 0x80; saved_uic_err = 0x0; force_reset = 0
> ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x2 with (MIBattribute 0x1571, mode 0x11) completion timeout
> ufshcd-qcom 1d84000.ufshc: UFS Host state=3
> ufshcd-qcom 1d84000.ufshc: 7 outstanding reqs, tasks=0x0
> ufshcd-qcom 1d84000.ufshc: saved_err=0x80, saved_uic_err=0x0
> ufshcd-qcom 1d84000.ufshc: Device power mode=1, UIC link state=1
> ufshcd-qcom 1d84000.ufshc: PM in progress=0, sys. suspended=0
> ufshcd-qcom 1d84000.ufshc: Auto BKOPS=0, Host self-block=0
> ufshcd-qcom 1d84000.ufshc: Clk gate=1
> ufshcd-qcom 1d84000.ufshc: last_hibern8_exit_tstamp at 196451913 us, hibern8_exit_cnt=20
> ufshcd-qcom 1d84000.ufshc: error handling flags=0x0, req. abort count=0
> ufshcd-qcom 1d84000.ufshc: hba->ufs_version=0x300, Host capabilities=0x1587031f, caps=0x124f
> ufshcd-qcom 1d84000.ufshc: quirks=0x0, dev. quirks=0x310c4
> ufshcd-qcom 1d84000.ufshc: UFS dev info: SAMSUNG  KLUDG4UHDB-B2D1  rev 0400
> ufshcd-qcom 1d84000.ufshc: clk: core_clk, rate: 300000000
> ufshcd-qcom 1d84000.ufshc: clk: core_clk_unipro, rate: 300000000
> 
> Hence, revert the commit to bring back UFS on all Qcom platforms.
> 
> Reported-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Tested-by: Shawn Guo <shengchao.guo@oss.qualcomm.com> # Qualcomm Nord SoC
