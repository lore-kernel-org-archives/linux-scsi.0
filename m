Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6453E6DC3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776948922; cv=none; b=AKeZqipjpTcmdbla3gLDtdoq91nMqLdIQDcwMskIWE2v/fm/EoTcRcd80FmCGYVjvS0+TDFvOLeeoG811B8ObsLpD78du9PRpKayEM7sB0vKVmjue+ytjjYPQTnlirRGKM/hXQntVxXvHnGyHO5HqdxTmO1Lrbi0nE713s1ZX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776948922; c=relaxed/simple;
	bh=/U0+AhQjNBpLSjc2P7sqUUfBZy0Jicg5NVul6rhY7lU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O07xKUUL5jJ4GdMHJ5QdlbXCMBgEe+h6OIbm50Nnhfb9Cn7EqNGoPjmZogNNh24TR1ooZLXL7Mw8ZsVL6w1GgK9BjMLxwbALzvD9MyRYWT5H7BxvqlOcvKCoH+w+6j6dnOvZDwRzo8N3xbLoo+7jj61LrxUFrzNaUmgPzjHw8bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JCK8kuJG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SM7XqsVM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JCK8kuJG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SM7XqsVM"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8uFl03044126
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/U0+AhQjNBpLSjc2P7sqUUfBZy0Jicg5NVul6rhY7lU=; b=JCK8kuJG83gIw3u9
	oSOAIgGzun4EEOKmLc1QIVbqF1hZhnBbJcVSzA7jeWZoIvrCokLBJsZn7Ybk9qhB
	y+ocaT9L4cfGgH1vrt4YbZZrUlF4byasAQXuuZ1XNCp+o4eQfI62TZjm2QhOaIOX
	BEY8PzPrkF01eg4Vl6yYiK4/VfIj8QwBzJjjfrC5wVE1APYn76/E2HAoOCRCE9xi
	wiH62URsEKjawnF9gvYwzD1kWddyjmQNhl4FGtxKH+6uLZFvn519RrFu/elJrj6e
	Ir6i+aQk6JBVWdwXJ7661uXayMMJek67U46s13agfM573CnJnUNm36x/40iILIU5
	eXohAQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq1jh3y12-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:55:20 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b458add85aso67175645ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776948919; x=1777553719; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/U0+AhQjNBpLSjc2P7sqUUfBZy0Jicg5NVul6rhY7lU=;
        b=SM7XqsVMeGA5g40uUVQFWDKlmWBKEgvMQBRqj3vfIWgrxJ3VQxNSXwkq3GwSVexfF+
         hoaARL6E2CUl6kVUL0E9CBAaosHniuJT/wDOoUTfvBvSh3MoOgaZqPbWKa1a6ScQo1fg
         I5C3dXM4b0ab36/4bHPuBlCFnNpTLUIimeq8s6w/sOWDSEFomOjum8yyvKm9RZEYT1vq
         88l8T4XUsO6fKX9bcMQYR3fGkrxu3CTtbBIraDDwchqLYuEvfLK/9xExwJkzdy+6iNCA
         5rp8lLZGt+1UHX75psg0YMqUN/QGrmjzoZwU1Aj/09vp6IL32azhjZKuMBEjTFMGp1Lf
         +kcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776948919; x=1777553719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/U0+AhQjNBpLSjc2P7sqUUfBZy0Jicg5NVul6rhY7lU=;
        b=fFJAY9w9QbUy+mrVHbFzC5aA0vT0gCyRIzu5lv1PhjVy/rHZQvhUcOQWjOAoWgvNCc
         Ehjahhk/FCwFVHlzDbW0LCVvcK34KP5s9i8/qrN3oGjztm3iXLznzG1HgltpjEoZuoaf
         +WzHsUMfS/kQGKcEEhNWhqBdXQxRwxA0Fp7zT/Px+fBwUhAg0Q0pS3UOpfB/aByMRqCk
         6ZglJ3349d3yUol15A/yNe5nvh/iZlGF8lImOjhuFeIJ8k0F+JXHB/pB24IdQhYehqc5
         cBm+ffPXhK8uE52g4yebDrcTv7MZX2dr+T1PfyM4FVuoi/92N8zr+eGLDVkP/pnbIRiy
         eO5w==
X-Forwarded-Encrypted: i=1; AFNElJ9cmugjUYXt+DJ3zdwfVnURxH+NPKwvjW+SEoYSz2hXVe/jQwDFPEbJHhTdJnQjRYAQOSeRPuu7Plu+@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5ur+0CjvGmkp6rMApqtqru+XOKOMas73/crYu2oGBloOGv8OZ
	kpepjuOQeQH2Nvq6Rnc0iEAWxh7Lkh9vrvPbxrKCpx6GxDydYRJv44R3ZBSubTyHjOjnksacqu/
	KgYjVIZ6zscw5Kjtw/cHpitOYZjdbIXDV9okuyHHOrACWAO37Yo6OFSM733MKJQlg
X-Gm-Gg: AeBDiev2ujkN89rQ0gCjt7jNcSC6Hu/AZfkKwZhz+A+Ew4NKlITMVGyhfJJF0AaQJvH
	yvbqM36T5FgtBLmBGQgjSNfxvcQdPK52JdWMsJNP3nh3RoE2CKObEzJzF8giiwwnf4qehgnbzS2
	V0Sb3MAMsrHa6lDZSey9Gn2Gi7U5t3wwm1HAD5JC2SeXc6Gq3ckEiWqWC9Xk6hAhcNw2AfgbKtA
	7PAq+WzV2jNOlxInFd5g5QRo1P+hWovfdoXFkDl98f/6bio8ZYBPqwDSy6bSfGyQifSFbXTTAUr
	RXdVAlPmRYNkLBkknOp3MJEXFN3f4bd9qnObuzatweGXKxKyX9THP0Mbd1jS6lLQyAzAa1yc4JA
	VLwChgRX2SFxWXh40sqLCVuQggMPZSm1No93kN5mL+NIKnxgVHfdMrNFlgSV21IYJQfMz7b+9ve
	AfGg3rS4j96tI91KbqsnjB
X-Received: by 2002:a17:903:1a85:b0:2b7:a89d:6135 with SMTP id d9443c01a7336-2b7a89d6531mr25581495ad.13.1776948919139;
        Thu, 23 Apr 2026 05:55:19 -0700 (PDT)
X-Received: by 2002:a17:903:1a85:b0:2b7:a89d:6135 with SMTP id d9443c01a7336-2b7a89d6531mr25580985ad.13.1776948918657;
        Thu, 23 Apr 2026 05:55:18 -0700 (PDT)
Received: from [10.133.33.37] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0c17esm191810585ad.41.2026.04.23.05.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 05:55:18 -0700 (PDT)
Message-ID: <bc962207-9813-4daf-9ebe-63fdb0156753@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 20:55:10 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
To: hoyoung seo <hy50.seo@samsung.com>
Cc: James.Bottomley@HansenPartnership.com, adrian.hunter@intel.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        bvanassche@acm.org, chullee@google.com, huobean@gmail.com,
        keosung.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, liu.song13@zte.com.cn, mani@kernel.org,
        martin.petersen@oracle.com, peter.wang@mediatek.com,
        rafael.j.wysocki@intel.com, ram.dwivedi@oss.qualcomm.com,
        tanghuan@vivo.com, vamshigajjela@google.com, kwangwon.min@samsung.com,
        kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
References: <CGME20260421110151epcas2p40628a13eb86c5c9b90626d14efc3b3ba@epcas2p4.samsung.com>
 <1891546521.01776810002507.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <1891546521.01776810002507.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEyNyBTYWx0ZWRfX8yVjUkKgUWxb
 Kd73PUz2zHHgqk9MiRoFfUez+aGms7/rTV+55E8NW7Jtr8VhrsGwuLDwZmz+IGepYo/3lS8xJBp
 Hb+148vbOVhfwtWMJvjNtnf2bUjjlXIWw7xlkvURlWEkgOdWYCVMtm8G4fyhvFDCMdhEr/F2l/S
 Gw/tHANIKI8CkO8xKyNxGJEgavi2kfcO7tDfs92TCx4l0w/6D9bRu8QiNCymfZQq6TYdSxLje7A
 J4+IX//UcU3OwRgws1uJFs4o/Jr3IXgeMzO7dUXWhEO+QmTDprKXMTA8KaOClbmCo1duRw4D1Yi
 tNCDtFfEcW91RV2VSnVC70Ryn1a8UUdoPdNEp8JpN2jDA9z8telD11MfU6i3Dd8zDYeudnceRxy
 4W51h+v39FAPH0hdNTkqR5i0SkuMRZNgI0tpvp629MFV5PdoZ17Hk6Oe8bnRWSOWjevW/H56hEe
 jRjRMlyE8PJQtdTeP1Q==
X-Authority-Analysis: v=2.4 cv=OeyoyBTY c=1 sm=1 tr=0 ts=69ea16b8 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=9uCRR3fI0jiCCddHergA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: NDdmu-AAiESHg7ju4RvqJ-dhrqpepvtK
X-Proofpoint-ORIG-GUID: NDdmu-AAiESHg7ju4RvqJ-dhrqpepvtK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230127

Hi,

On 4/21/2026 7:01 PM, hoyoung seo wrote:
> Hi,
>
> How about you to add EXPORT_SYMBOL at ufshcd_query_attr_qword() function.
> In the case of ufshcd_query_attr(), there is export_symbol so it can be used in vendor driver.
> Likewise, if export_symbol is registered in ufshcd_query_attr_qword(), it can be used in the vendor driver and the pair will be correct.
One should export a symbol only if there is a module *really* using it...

Thanks,
Can Guo.
>
> Thanks.
>
> SEO.
>
>

