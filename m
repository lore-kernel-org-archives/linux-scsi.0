Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571863;
	b=aLAoNZ0RenSqBqF0OtsJeTNjG/IA0zV9wHRddUSNGKHm18iKp8cIV76uFIeN31VU4cCm
	 Wa9kc2fdNjkCdswxhfWeUkI/turdJonWX+SaYdGrJFUyuMTDgVwV3oAHqeKbW7wUmHyJx
	 +mLxllQUgK8rOJZmM3st0e9XyuhUBPmhjHdUlQXhtXQTK6L4W9zXgvhpd3Z1hx8xVJhEr
	 LiUYYn4GurnTopOtut+iWjEjHo3kH2RHjOWTRuiLIWR+FjpKpn7l4YofN5QzStksNPT5X
	 UrAt7JVegdxgPAfSwhx6k+K4nR5HoS3TBwH1UeGdMvpwZml9oS6rsgukkxnbZETOyQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
	b=IVvNXQd55M24c7QNpXk26ssQbt9xcPOWJgciY1Cswdg8BHG2dngliNxc8o1EI9HUYq87
	 4eOA+1aMH+MYAGgBtV8mezfOvp4wCnEfxcbgorH/eZgP+goDC1zylaQSDO3CtzWVSjbgi
	 Yy2vYoCU7gflj9JGMpjfYFdd6bTMZjVg/e/klmZHRDIHXlWPdeN423OKDaWxjlYkhW3C8
	 L+ZWnPAXvE242ANiKJyhmncZcCisqjFZOHOtXJYPR9G2VmAb8DtAjGc47YPteNHLK0u+c
	 +0yyKsenGpTrrAM+u0Ku3wDqbMsO5iIIq2v1z9bUuCHRXgCPFdEeh84xQ3qnwol1dQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEFiQ7Cg;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="gmBZxwg/";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5603A606A321
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:11:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5603A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEFiQ7Cg;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gmBZxwg/
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADC0ujc2741852
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=; b=TEFiQ7CgOeSRnQW/
	Se5AoZ7dU6cjjcaKCcUCdHvC6glfYOpUgtIi46FqA8lPXUVJgojFjfTr5Twfu4Mp
	CQbbN6g6pHf3PwdXgHahKEHyyYCJvFy3uK1ZrPlHyfhXCDZPXP7l2zI3/X6YRhr9
	P4cuWfILX/CScAZSIlXC+90djbPnxUYlMfurTNDWM2n9N5nRSr3Zm+vlX3pnFWhZ
	As8+Ov7kfmMtzFJB0joQo73uFu88E+LeiTT/JhxBaznhr2QHYE+waIvCpoMzvaU1
	mUm3VHg+zCXtMTkhyvJzq0nOEheAZ9Jegsrr/fM1r+Ndg83P6CJP2LKdzamirrDX
	+ZsSTg==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwvu6s7sy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:11:02 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5ecbb3b4696so50956e0c.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 04:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794571862; x=1795176662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
        b=gmBZxwg/XbqtrqP2oY5LPz0tR+Xlsf3EK8DvNSJ1rLx9AofPyhzm2VQVvXVe4JZBqx
         OxgSJOVwbJ0o5JaQMKSlltQMxvdvq4J/n21qNljvslQMWk621bEdPn8ttOu+Lbe3UH7d
         +3xKZVHZ/L43kTKUZJ2vU/LUqd+LJrcYZ+SxgNovrNfnrwkRs3rK4WZG2ml2tSK5p+iq
         iecQvJEjCJPeJ+s9iggi4m4wOyMTontB8DhfUyM5I9auPFyujfzSGzZEMHi2FujjyKVi
         VR5uXP6/MOfEY/p8Twe3ZB/IMLUoBomk0ofKmSVtF3tp5YjlI/roFhNUgEOHp0CHwICf
         Sd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794571862; x=1795176662;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
        b=czdW3vpEgx5p7tEkvcy3lHoPiQw1JkSbL9uDL2YlK7bFicmFoHl7tsqqWSjw45Mc9U
         Rn2tEtjJXLiPAqDRe3WMNGoN6cQj41Bn/045Ps9Aj8FcUoOMeQquPo9mLtQ+/Xld4TX+
         iAy+mrghsHO+o+Zei9rjxd0V37P8WqlEoS7FsMouek0QAbUFIPCHLEzPS04DYR+Lp3uR
         5AuutjebfIYa3wYDcNKrtt/LGzVHJLJeWaFk67L0E4SyNsLmKqcXtQVc35jm8XBjbQZn
         y7iWYG63pQ6ipYBKPf5cV6EXrK6HyIkTIc55LDop1M4lxIPN6KtuCZkfSasDZlKMsEJf
         JRdw==
X-Forwarded-Encrypted: i=1; AL+hErF46ZLY+eijxHSkZF5GvOPBOj8WKxtvW6BbduLHkRJllTJm4e91EvDc3cvkZsg6J24dVDCQCKoGwkPg@vger.kernel.org
X-Gm-Message-State: APuU4Z/kWmc3y0YoTDO0T9+8tgfOEl4ySGnVrbgbvA6Q98TjKtttw9i+
	tT765/UXHoua2kHt+a6VD6QV4r7AZt75eTXJHoyUp2IsdXJVXS/PVvfzBRCB5GwJtGC7O4W9ZeQ
	S5JauZg0HxxdxueaSc7DgkZ1TeM0CqeRlQ0XY7XYA+L2eZJ/9fnA/SDRFZoECmSjj
X-Gm-Gg: AYBFou3CYEcvkMsjC7cxQ+1bKDs9XocnmoLzfVfYHaxBpZBwYXVbFscNcK6xjEf+NFR
	Q6sDBXO0K9SM1rkGoa0WxbT1kujW7+Jwc9KNuMRh7UX8lfD/Mq1kwqjI0Gyiea/DPNYslnVgdnO
	tVcWJW1Kfp3KMgJurEJjXY0Tg1nT//J96lzY2/b+UQjAczZ09wsQOORdnrhp2Ry2suxRYU10Exs
	bF0fCHwRq/Rp6MY8AjKAdbfHpN7ifao5fJJgipfszWFtO3EJcYbmBVrVKZ2ZEHe+0VCUxGKLKqC
	U/L+2Ja56lIAHfHGOnwN7zJ7S4Bz2aw+3tt103q/tSbYcAHArO2UnQDAPay59PawXLLJEl1KlS0
	WPi0HMGiU4jc/OQFm/9F+8SyHd4BJfbWweXqvyL44ifBI9Q9U6q/6qnYypmvn+TbBARqUtPE=
X-Received: by 2002:a05:6122:6c09:b0:5ec:abdc:bb72 with SMTP id 71dfb90a1353d-5ee346b6663mr738715e0c.2.1794571861687;
        Fri, 13 Nov 2026 04:11:01 -0800 (PST)
X-Received: by 2002:a05:6122:6c09:b0:5ec:abdc:bb72 with SMTP id 71dfb90a1353d-5ee346b6663mr738699e0c.2.1794571861279;
        Fri, 13 Nov 2026 04:11:01 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b56df7sm86814566b.47.2026.11.13.04.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 04:11:00 -0800 (PST)
Message-ID: <03d75b49-dea4-4736-a662-27ef64682157@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 13:10:53 +0100
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
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
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
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mfd@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
 <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
 <20261109170407.2073295-1-lightofmysoul@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109170407.2073295-1-lightofmysoul@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfX7X09X11GlPtZ
 szCzZBVPPZw3A/xFJxNu4dnSyaGRqM1/z+KtFGoRMN6YFbKQL/a4gyWtHjH4nEM5bM5VAgbeX+I
 St3LKyJLrgBvEUHuuBNR0zJdF84KiTZM6SadQX//1/vBlAcXJpZvBCqQGDaENQJMPqWcKU6MQyn
 et8tCIznUze+7z+CaI+SiTy4BkyP7sYbFYRg8AbRefaH5eEHAQwVWetZZd4tJFJ54XDrZx8koyL
 tcxV6ixRnsXDKokdd74GRZATkpGE9eZ07HzPpujnWbBoR1C/iD9wrf7e+fSQpW6WvJpNXz4CA6H
 aLoJv/2K4/YTtRQRaK7NQh2rp8kk4vzxusAZXRzDf5Uikue03aIUyNv96Hur06cDda8E5Y75dQR
 8EsunXusJ1DuzgWrcmFwyx987/+WCbxqL+Xmamz0mbGV6wIh8TH6LfUvUQ7kNuv5ZTaH9rxKmvj
 2w3j9Nwci94xU28dkJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfX4ZDsV7UmtTE0
 lh5fUl1ynykBGK21Oieva+CbiayWe+QqCMG6kyF6a97ObvR6aofmHfTslSGbYaVnp//EQz5VoKg
 SUjG1NX5fO5hieKVWAjigmuSGNA9kNY=
X-Proofpoint-GUID: 3iUXHeX1ZUHffLa4NaAXtzRn5Nl0vpEO
X-Proofpoint-ORIG-GUID: 3iUXHeX1ZUHffLa4NaAXtzRn5Nl0vpEO
X-Authority-Analysis: v=2.4 cv=JfcpPkKV c=1 sm=1 tr=0 ts=6af6fe56 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VS6XN_di3_qKZAQ5k78A:9 a=QEXdDO2ut3YA:10 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_04,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130048

On 11/9/26 6:04 PM, Stanislav Aleksandrov wrote:
> On 09/11/2026 16:12, Konrad Dybcio wrote:
>> On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
>>> +&usb_1 {
>>> +	dr_mode = "peripheral";
>>> +	maximum-speed = "high-speed";
>>> +	qcom,select-utmi-as-pipe-clk;
>>
>> Is there no superspeed / dp altmode in hardware?
> 
> The headset supports USB SuperSpeed and DisplayPort via its USB Type-C
> port, I just haven't brought them up yet. It seems we need a new driver
> for the Type-C controller.

OK, we can do that incrememntally

Konrad
