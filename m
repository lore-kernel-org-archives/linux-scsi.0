Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794237134;
	b=VyNTfOSFLEHRJ3W4pucK48LjbCzZeBW59nSUyINpx8K5P0iFrcWX8fRH9s0rHAX5Awvj
	 T7oYunrCdacDlTPOuDarh5JY6eX4nYVpQ/CQEAW+kKqu9/yu18MIchKxNGpbS8Pxzk8MU
	 +jlvl19AWaysOWqxyBSQbza8qPF9lSJOHhnfJSoQonX8rTLQ3YYXVB0XB2yDZc0f0XGsB
	 v8AoS0PoLR46D11ocQnr8sG/Wsc9fmLCauW9IZxa+8y1ki5QW7j2/82gtrMX8uZi6XqgK
	 J/vJ3xcPkAR/6wqaxsXIm0SOlTgZk3QhVjjRibcjZ+d+Zwwgof4VV0i4Wcnu5jqRC5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237134;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
	b=x24YvxXweMKMZrIxXtYelDvwIlbrQiOipJRww6ZaeEee6KcxPHURNlvcZXOImCM66z1a
	 xnL96pP9KH8WkHLCcApdqvXScMfda5+TXRGUPXW8S5402ItwIqacNCTKgASi5gWuS9eC5
	 DV+0r5fK7ldQ8Ztxw0+YLd8ZsjXZsD36GaV+TM831kW+xBS92cM5bmteZhk9kmQc8ib9R
	 goK0tq9qAKCyA94CJ/pZC+1X/G/fklUnsbjKsLnA9jLSRzNNrTMw6deLszWh2JW2BwF0R
	 /bop0rMoRhSjN95WxGjudfMBDU9NPgmlVT6OR2qosfudIJCGplzth0vjjHa7k5Mf+mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JVHA+WmS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bIrSQFS5;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7372E606A332
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 15:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7372E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JVHA+WmS;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bIrSQFS5
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9DF0n22927803
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2026 15:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=; b=JVHA+WmS28WTu51A
	alo4QMvr0WoiXI1XjKsBEXyVuK1q94o60sR1tEhkiY2tviOamIxSXbW2e4SvWI0B
	FTkucu81+2EXGVGJ5suaNaLkGLtqVzxKWtq5ruWvOOwNBDZI8/88FOsPRUA5JBHv
	JACpPjvZIITH3FJcqZnm9Bm/J0R+cyiE6IYGLJFK8oO7l309Hp1OjCX0HhYMm7Po
	btMjZ1ALCHvtYmQq86wiBt9nEtv5ydZzL5OQA1dARTOb2/BpGIxuc2TxWsSA0U8s
	SRIa4+tiSHSiIPRLKDBLsxrgw25FmtzCpVrDJlCpin4RqaRpkTqQZu+KTy5h/1ec
	MSZ0kw==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hubt8s43n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 15:12:13 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-7cc781089b9so17137137.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 07:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794237133; x=1794841933; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
        b=bIrSQFS54jIdF4P6guxFfiAzGIywaL3HcI2CYKiZk5KShXVQ6LHaUI2qAuwOyPWpRw
         xzfuvK2o0r67SnIflhrl9zw16CC67EqRne8OQFuU5E3F2mnYa7/4IlAf3C5Ho221FobL
         MUwgyGtBjh4n6LF/d9m/JQ357ZnuHtLaD7Cq1EMyjDyZfTd5B+EhzTgX+uPhK5gG6Ftk
         iKdSSKA+NDnD/Ck74XrYb7w0tldFtDH471GRhN14JPzJrq4cg6ae6XdIVK8uI9S1qoOh
         fa2WzJoIQKQpdigRZRTw7drea02PGQV8R/jN/nPrkpNaYuTnO5sCoXD++Xie7/gJLWME
         g4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794237133; x=1794841933;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
        b=rzN2EmyKfstgG9qH2B0TN1ji3Yuz3XYRE2OrDktWGP2yzNDzFziCBDpz7bWje1uZ3h
         hBbzeqzMLS5nPrvdgcta0ZJ3ADK28u1eeSfYWetpIsLZ5ibjnYL8iY4z4Vkdz+fTrkmM
         2+2XDmYCngoy7gGQ/cXkLSxv0/bP5Dse5k98EH9Jxld1Fi9iyeS7FSr7MQwjS0FLcpGa
         9VZDvhPl4bE5/8664nLU/1K4LHhsAJZ2sOyeHbz26JhmrG23SEk/1wBlq7JYMDXjW6y+
         AV/PauHJID/ccPt9m5s/HAiG9NE9s2Icg1oqg1W4lUvWUFFRdjM3kpfbFd6iNWH65cZd
         4+fA==
X-Forwarded-Encrypted: i=1; AL+hErGl2Th+50XEGRfuIGU8DQpUYlKKitLKbr1TS5vF/YKee0vuH+59aEjrSWbS6SvdBNDAIs4NWQ3Sryt8@vger.kernel.org
X-Gm-Message-State: APuU4Z9W55SDil4J1ck9GBdrIWB5n1GKkApOV1IphSVYzakF83v/Or6Y
	/ZgzT7HXdFCHxiDckKqdI1j1LjNGUCG2vsTy97NRQFsUjd76ATrG82jA+5t1AkvlYhW/uT2AOn4
	t60JsIKklo59XKoUXFNT5nLnxH2e7ffibrvL5xvuXEgDWVwANTmThCmZ4jMeeUphY
X-Gm-Gg: AYBFou3Jp9ZB10SDuXvraVfQahQStDPPwUjYyWxq/DGZa8I3YUb8Y0MSeFZUY+jJ4pK
	0tI4jw3VzO7MR8JoMq/PisgfrQU4MN2qGme2YSvQbSjmBNX+Lsp44EhZs8aP4RZPZCWyuzfrEwv
	l0vkJquVjwNNBPwCv2HDUxmAu8MboCkvup0pGccb+Tncgy4z3zCs0x56lx2GMVjQOjsf+2PI59W
	x3eCdVnyq70Cn5u2bQr1uWkmEBA8bB6PmCR7GzdTn2pDkltjbwBTFrMIpV5MmnSn8oKxE7UFbuy
	+uCxBQCmlniLQm9lpdxyXrTaR28LbVxAkfg/rrRTj06EN8CBRSInrpaBe5JeuCqVY9joQ/+3K32
	RsL0kaSAf5Ppvn/2v6INZvKPlcnY43jsy2Mxzm0red4vcS+UkOTbiIVQloiVdkJ84NTyO+w==
X-Received: by 2002:a05:6102:301a:b0:7cc:1137:9d98 with SMTP id ada2fe7eead31-7d2da6343d3mr1229155137.0.1794237132578;
        Mon, 09 Nov 2026 07:12:12 -0800 (PST)
X-Received: by 2002:a05:6102:301a:b0:7cc:1137:9d98 with SMTP id ada2fe7eead31-7d2da6343d3mr1229073137.0.1794237131982;
        Mon, 09 Nov 2026 07:12:11 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ed95desm1765456a12.26.2026.11.09.07.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 07:12:11 -0800 (PST)
Message-ID: <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
Date: Mon, 9 Nov 2026 16:12:05 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Lee Jones <lee@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mfd@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA2MCBTYWx0ZWRfX7VCQ1S1VuEcU
 KZBDSn+Q6alrg3DGeNuvLV9m+SITORYX66JMrM8/pyAoJAjskJ5L97tNbz87fZCsfCpU0tuA0Ch
 LGlNh5TgVcEj9YbJz3P5uyZP7OrCbPzHp0C1LckJem5QTOD+//D2mYsyJsUNpBbC/36ESgieJvu
 W3cPB3IaUFrBbhCURv5sQw1nGetJw14gx8qSvWo9E3w1ZXtg85lgSFrur8pzVWmLoXXXyTJ8Av4
 mtzwNUFbPRKZRKXxOloX5WcURmNfZQ+yLhpoyUZqXoRvT3zuBQg64WbkKRDPUtN086rcUKFOQzU
 tioIxn5Uqd+7jVnupqwpMbMPmsJoDM3tnD/l7sXuBlIjrt8kaHaPt4+A77xzOF0gRVRLOwVm76z
 E0xzX6i2Hfuk+hnIn0uJ8FtwCUd9tWOwHeuH8oiq+DNuWouvJTzoeTgwsZv3uPW5OGaYS7c0Nxg
 ZD4OkhnJyVrlXfSxdvQ==
X-Proofpoint-GUID: x20pYp4rvzwU_TgnExGJrWOOvAIbU1Lq
X-Proofpoint-ORIG-GUID: x20pYp4rvzwU_TgnExGJrWOOvAIbU1Lq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA2MCBTYWx0ZWRfX/4p3DQnLCqtZ
 4RrWKbWcoBgSrsur/jgKZTjGB+CqqrrC6xB61G9MUhBmwlPrmcuFKELcreyz+FuKhB8fnPEulOM
 /PSNydV+uxenqUPV2wUO8pJQC925mJk=
X-Authority-Analysis: v=2.4 cv=Yr+a1IYX c=1 sm=1 tr=0 ts=6af1e2cd cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=pGLkceISAAAA:8 a=Xzw-RmQiYhs1fFvV6_MA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090060

On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
> Add the device tree for the Samsung Galaxy XR headset, which is based on
> the Qualcomm Halliday SoC (SXR2250P).
> 
> Supported so far: the PMICs and their regulators, the power and volume
> down keys, USB in high-speed peripheral mode and UFS storage.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---

[...]


> +&usb_1 {
> +	dr_mode = "peripheral";
> +	maximum-speed = "high-speed";
> +	qcom,select-utmi-as-pipe-clk;

Is there no superspeed / dp altmode in hardware?

Konrad
