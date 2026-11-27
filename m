Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795788450;
	b=dTzcIZWFwO+GAuDX9padVXo9XvpAJ0yYtpcP3D2FP/W8mVIkHkgfGrrzbZItIS7cLJ51
	 lqwH8h2CeLBkNbh5mLNhkVfMUv9wPfwgd2laonyPAmKm20qUJ+bK1wUy9CsijUiOaoQRh
	 ln4xyQwx5M0cpqj8QUphpkNjZueSVuIlGPRoRaQ0H87vR+W6Csf93WAW96MzvowtBsGnd
	 gkRHPX4PAA0azBcb/pFPpXkqbsOZiCwi2eErJlOsgW1ryA2dcvJFT23Hv/w5oYLSTTspz
	 /IaXvYYw2RDc/XWxF8HieOLqucrxWz7dfzI7yNJwMl5ervqo7oRWiJE1fUgutP3mA3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795788450;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=YfbNWHn/IWj+x0bqlZdsPj/C6tp7qzwGnV511Fr7BTo=;
	b=Lw9exKG8Q5ePzf9DHQHcmvz05nRpDrmT4xp7BkadeCDhABLyRD7abOU3JsITImUsBJUF
	 khj0mNsQ8g2LkeazCdqeKifzgZ9x1u9xW2m8GbwoLsd9D61GCEWqNvTEEsGCo2wYhvdDp
	 Q2wn6u7nHFVETbBjhkxFa+YUb0koC2dTUmTHRurltHCeeYmZHQ3DuIjvLRGgaroSSwxd9
	 CWmfky80gThnQQX5OKK8axANJuDH8TIG7K7jbWL+rHrORY+sV7CmFIvuiGXxrRBAuEh9X
	 xv7n1qjX/rsbpjGPJ0eXdClB+d6S2wy7FIZaAHyR50r8AvcRlbO7gP/i2voWwXKDPrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bMe7A6H7;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Xnv3NMK9;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2368E606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 14:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2368E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bMe7A6H7;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Xnv3NMK9
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE1sSa466782
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 14:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YfbNWHn/IWj+x0bqlZdsPj/C6tp7qzwGnV511Fr7BTo=; b=bMe7A6H7rINkNX6B
	tJyA9vfBd9gPTs1oO/dYBnZpI3HzGyk7uzG12g2E88LZkqyOjF+LQiFT2XHonoe2
	zNkZnVcZxmGmWfXAgNOH5iTo7w/m5scnVAqaPbLWGXoSUxYoKL+smb2QWB6c05m7
	GD7Tu1rnekQv4hKH9gO06IDsoFiX9WN6OKmKrWD9kiRJfbVeYAqpcrQqR6Qp6Z62
	BDxYiLfTLKvNCTiWYZFe3oGrmfM6x/ef59MjmJshz8mCBFx061w1XR6iou0D7G5w
	HyBBSR+3St9M9O4cItvHhIkz79YUml+ZeRma1O+wPVpool7OBLn9QOJ9gKxu4kiA
	usJXlw==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j74g6srnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 14:07:28 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-71ac732da3eso195703eaf.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 06:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795788448; x=1796393248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfbNWHn/IWj+x0bqlZdsPj/C6tp7qzwGnV511Fr7BTo=;
        b=Xnv3NMK9Eiil9yGrafgxmdi3RhQ70D0RVMepl94sRnyPL296QYn5DXXgrf8Lu8g8ee
         qJHsWOCNUb6MWl0NLNjB1DTyGtUZsEoT/cr2Bd+01uOW0I8ZF5ux+tTpBXPuS/5eMgHo
         qZv2V9UMJbMu5JKJeDrv4aAHboXQxCBsVhKevoek1NG5UXgitayd+RikhAXfv/1HnIvR
         QeHKcmLNLozsxfjLkf1iEg/xw8cNtba6j4uklUkDNaXSbtuedBnScQESaLSDwYffVmZv
         L6ym6yPX5NGWKV33s0Ux+RETCFMETHxOiJoXVUQB0tRH6xolpyJPdjtZ8ixvLehNeKHw
         Mmgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795788448; x=1796393248;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YfbNWHn/IWj+x0bqlZdsPj/C6tp7qzwGnV511Fr7BTo=;
        b=gWTa0HqRPqj8wsocyA+lWNDynZSllpbiinmGuTJ9G0R+rCIXGIyAw4hmiaXITG0C8k
         I8BfiCATGqq40e2ZGcrieOmr1CC+vxJ1t17+g3GgNjV4W1A+715VuhdD1eeoxmNUdHwj
         DQDIDQSt4lgugKeqymxowJeDbalyO8UPBGyNXBp4hjD05lkqpOyFYaS7/95+P5yhCEXs
         3P2nCpqneOVJGtt6oVtdayvLZimkXXfKkq4c08Gn+Az5y19mE6rwztLRLOS2fyx9k3yp
         ZQZwA7KukouOVKwe0a2IeHKz9RqHrwRWtFmn7Z+KXS5hffAsl3g7ziXk5RL7MBbuRXYy
         6TYQ==
X-Forwarded-Encrypted: i=1; AL+hErFFFXoqBMQvOoXb98edP6wB6bqoa4nO4NMZpm+3hpBAPyeZgRnK9x+Njstf4HOOU+MHhxFn9exsd0sT@vger.kernel.org
X-Gm-Message-State: APuU4Z9D84B6Qj69dU7Tjuj8t/jfJqJ8CVUYpRXLd4FMAi8S9GEYkUzc
	u5eOOENYVN1yygwprUPZgXWamCtqZuEDs0p3w7SrAgE1wha29ZzH4WTYSnlRvQkofXQ6d9jV0W2
	4K2V6qVEkmu83eZ/OuCs3ICHdA6RCyaOxxlPg5TZ3VXOYAjk4R8+jieOfg4YpBZRM
X-Gm-Gg: AZFdTZd1tDAQvEp4yc3gExD7jVoNQxSTMnZP/n1ru5D756aXNqar4qrOMgIiAx72fce
	zLLi082OS2MKMcPxvawr1LyvZPWFnbTyuEXdCoAvIGUB+xUVANxk1jMbAL7LYM3t+neSXJIU95g
	Fxgyvbv1tBLeOzt+/rbtfWtDbU4npyacyye+HTx/p37irKwN9nAFMTN8KrQyzuI0WnU4UBe+fAV
	+1y6/L6VRqbDdC/t4rW/iJXNZk9aXSBV/KlmHmfmjellOO7FqsyCmQLmDeBgsYd7kfEy1s242Pa
	vg41SiLCu93kckXcJ4kj8XgNMzZoteQroe+e1UQl4vYPrZjZkmBnp2uZx69Xs/SaKug/EP7DbBp
	fqWpvU2hUr5MQA/yzBmDnF6rJ51iAr3rkzNmLG5+ICxgAZWs0Vdf3JBvh
X-Received: by 2002:a05:6820:c0db:10b0:6d9:f62c:2698 with SMTP id 006d021491bc7-71b392f5007mr22283728eaf.1.1795788448247;
        Fri, 27 Nov 2026 06:07:28 -0800 (PST)
X-Received: by 2002:a05:6820:c0db:10b0:6d9:f62c:2698 with SMTP id 006d021491bc7-71b392f5007mr22283631eaf.1.1795788447720;
        Fri, 27 Nov 2026 06:07:27 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd0776edsm6211739e87.73.2026.11.27.06.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 06:07:26 -0800 (PST)
Message-ID: <da7b034f-d1e5-4e37-bdf2-22364d5c045c@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 15:07:20 +0100
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
Subject: Re: [PATCH v3 13/14] arm64: dts: qcom: Add initial Halliday dtsi
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
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
        Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
 <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: qKDguW1QMrZgdSG2VvPsQH0boQhQ91FR
X-Authority-Analysis: v=2.4 cv=U5kHnuru c=1 sm=1 tr=0 ts=6b098ea1 cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=pIfNyjNAQl_vEFP8Sf4A:9 a=QEXdDO2ut3YA:10
 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1NiBTYWx0ZWRfX9YHc68G88fMP
 1ePf+bj9dkGDSY1SoXKeiOfRuzHMfBsfUQ+TFfTREJFcKWTGX4oIcFwAoLW+0hFmisJBw/IQ1ZZ
 O3uPmmriy+DbmBINaOOvRHcB+WypbgM=
X-Proofpoint-GUID: qKDguW1QMrZgdSG2VvPsQH0boQhQ91FR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1NiBTYWx0ZWRfXwtzvhLQCaZjM
 xGwIK2VxDJkgx6yzgyuLI6jzbYTGVaTThjl4BomJ0e5KXk4AjOjMYyeGT8kD8fiMvNDEUef6LEY
 ODVxVeCakiYgiTQhoEv+aV1WTdzfgV3rj1hUTmjdsbBF5CmjhXjdbbTlPNR3GyfHWTdOpwrnB6/
 818Cq9Tcz8j9iSRCdJo5ad4AHa783HQdjVJy4nX+puYCcGqhL2KdT1FHOLsSlQ6DcTFWb0Bvv5J
 ea0Ds3FNhLMVI66e65YyRVlA/LCGUDS0mmM+4BT7J4QkejCjsLHNspy8FabYbEB1E/R37mJ0+/8
 nyiZVAKuFvaeFvhyjnmi+el7uwVhiTRxBxS0d0PdDH4MXZbtA0AutqtSwyrDkKCjL8wEIVRavcX
 8jgwWQSp7anl5ZcI4YlaTvO5fGvCrdQecr7u2mQji/omCWsfoldAfs+kMuhNT0ZqBB5F2f+P/Hc
 NM6oBm2FlLPedlciXJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 adultscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270056

On 11/25/26 4:43 AM, Stanislav Aleksandrov wrote:
> Add the device tree for the Qualcomm Halliday SoC
> (SXR2250P / Snapdragon XR2+ Gen 2).
> 
> It describes the CPUs with their idle states, cpufreq and OPP tables,
> the GIC and the PDC, the timers, SCM, SMEM, RPMh with its clocks, power
> domains and interconnects, TLMM, GCC, SPMI, the apps SMMU, USB, UFS
> with ICE, TSENS with the thermal zones and the PMU.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
