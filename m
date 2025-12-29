Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7092E290F
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767010634; cv=none; b=TctL1BXAgV3nNcq7kQzKqfOa61qO3aHXk3OOox3i/ppt7GQoo5zr0xXQeNciX95JKTVojQZsJRymue9DMhBOqatQNZKDwapynfrau81W/gLrjcsnyfcP/8tE3fFCCcrFUaz6sIbwxfZGNOqVIpOjlJbx2Dyh1+IXcSGROniiAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767010634; c=relaxed/simple;
	bh=59K1BDOrwc8DN4VEuImzU0+sopoS73fprGxjSI+1Qos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FePTKibRGB4TV5mCBdPcIdx2VdT90TTKr995XAGRkxVL4gNHGxoe/Ec5jDO9Dn5eBNo2b5po3huUpZYLrucdPe0QDhNQWMNgz4NlKejfK7F9XmUGgrad65qSEyY6OotyLv+/rLkrK2LIksTMB0eNHKx4GU2GrhQyQFPSpRJR/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dK1uKpa6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Sjo5wdwm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dK1uKpa6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Sjo5wdwm"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BT9cdO73777085
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EOUwAf42MijL3YJM/xZIFeL0xBoPqmYThITGffes7rw=; b=dK1uKpa66g7C7aa5
	V8sLIEBk5/Il/fRr5Wa8Pd/nPrd1I2GDld3IenNkG9JfmOS/pNVWCdKt3Eqg/z7Q
	QJu5lEu3+JP94QM2ZtQFDNjI0fpgyoqKGWOq9P3UKICBdSLTRR4rhYuTfachUH2n
	QRV4EzXW4JF9813uHFHok6g9OowxWYJUMgwZ1LTRp0Pmy9s69qlZsM2RrhaqxkT6
	s29c5lad/x//rUCL+Oh/PWMKK6BUC/Nc9vNUuUuTuNbbu0lNX+T4gvGQ8KcWCeEU
	t4lMPQbH5dJLhjhi9Ec4DbI9VQaF7vwGmnvZjK0kAfQFEMSsnwC/MmNdkifhAMxk
	ZqAmCA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba6dr4d0w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 12:17:12 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee23b6b6fdso23230011cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 04:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767010632; x=1767615432; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EOUwAf42MijL3YJM/xZIFeL0xBoPqmYThITGffes7rw=;
        b=Sjo5wdwmd12sl4K3z+LfaKUmWZk28WKRFu0zDlisub2kSJDy7HeEWUDGfW4D8FmZ9y
         l/yVfb0bKrYLfiGy9FuvFAnK9iQvFYlhky+eJcvsuAzZcB9GR+RSlhL+9cLJSEAFzwtz
         3Q5IESFsV/s4H7SwNPlIPIhL47963dNH2LM86YqABq6jfXGklj/mkHfOl2ge9PGX82my
         OJfu9XWfQCKlzsP4R1AIUJFuaT2eFmHPjKE6ZF0Hak41CZvnuM+qJZ+lwmbkq8+nMRIx
         bZReSmou70wsU7uxC6Q6kMdaW/f5PFUZNukCuyzqxSgjjeE+Yl50+utpDxc1y/jyX8uH
         H98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767010632; x=1767615432;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EOUwAf42MijL3YJM/xZIFeL0xBoPqmYThITGffes7rw=;
        b=vhj5cWw2fH3tziUIF2OMrII9Ea1EjyQj5ZZxCkOSZeMn8SxnbK631F7eDD6d1GWZ5s
         of1Gj9Ck+C6AwOCai65OFk5jJQmT1AfOzh5BOE+boC0siLhQeumHwDSO/9gGnI+/clOP
         9j+jc1AfTnBP7IH314Y/UTgkhchGXt9X0OLsdedGfPAAW795ZZKwUpf4s6p3ld935zr7
         KBy7FO2CIG3SFhVHDBblKVBwlySg3GUO91pOSt3ddz3FqD6K5eJYvzrOsBeu3YMxOMWT
         8Y5iLVcik+LZThbZpxApi9L9VeUqogMC0jSe7czEJVXSJd7Dk758DrRg36VOKI7tzxYo
         PUyw==
X-Forwarded-Encrypted: i=1; AJvYcCXLyZDwS8zpYHhN0MyFy0mvsNkVHi8IPTnSXNjPxBvBE7XlvBMW04jGwpF7O0VA/GM9svoqDlpTgyHJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwcAfv3Sd0gZCDJkh1mwZTBdHvZ9HxFU1Lq4t2EgEsWVkqheesr
	zoPJOMaPt5Sw3EXdNTgqRJ5inlPWxwH8EgNzdme50GViDM/wDGP1KvRw6VGpl40lXL7HZBI0or2
	EDQBTtD4Vra6ReMtcH8yrzifx0qAqg6QQ4mNUOghw/aoA/TzMv7OjFT5/TPqxJ9HM
X-Gm-Gg: AY/fxX5sazimDYyBOmm0p8uGsCfdIfWOE3UJozAv7vu5QZKeu06fTJquoUKmH0+j3jx
	WWgccqTfn+9opXOmU+rBe+zuDQRr/V4V42B7EApegNIUfYCdChKugJFpHSpvCbIoTYW9FAS2bF1
	/ZBPd3504GXzdXnNAq/2zUVC0BBDdx03QDpzp2oi5ojmt4ZZQOMJXhTAIBvbk6MDPj6cAfzzdys
	Ljohrc7ydcsF7lVGaFmODxtFxiktp2m0TPbzG/8k7DJHcXQ2FZXOUqxUGDtNO/l9QWKDokgvEyj
	Z0NkVnwK3l5hwz4eTmAdZLeykES4AgxLEYl+GXXWpgX9K78XnglmW3XoOyCnEvHYZFqz4m+Zv0b
	gqTxv0klsDHJpaYwyTbZbIwmbHUzS4g8HPH5FwKISlicGGJzU4jK58s/2fwk0L+2iIg==
X-Received: by 2002:ac8:5a46:0:b0:4f1:b580:fba8 with SMTP id d75a77b69052e-4f4abcd86f6mr340173621cf.3.1767010631689;
        Mon, 29 Dec 2025 04:17:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvd4QH2ZZKAsfGoyIuTWAr/YsK3enb76pfOJPmIZdg0l6Pi41eVmcMWBYYNeGTL9K+dv4qSw==
X-Received: by 2002:ac8:5a46:0:b0:4f1:b580:fba8 with SMTP id d75a77b69052e-4f4abcd86f6mr340173381cf.3.1767010631225;
        Mon, 29 Dec 2025 04:17:11 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f3ffbasm3349064866b.61.2025.12.29.04.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 04:17:10 -0800 (PST)
Message-ID: <a33f5b15-d574-47c7-985d-f181c4784b98@oss.qualcomm.com>
Date: Mon, 29 Dec 2025 13:17:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-5-pradeep.pragallapati@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251229060642.2807165-5-pradeep.pragallapati@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDExMyBTYWx0ZWRfXwOqHqOE6izyd
 3NZjjM4dEt/r9cxZZ8Rbi81BubWhgS4eliZmKUQY8WVyX1oVq+Hecvaduk88IqA6zewaqpJUTEN
 oUD6wZSRAoXYLm/xX98A2Ubx1OYjG/bF5HfvmsMy46nDL93rloOGAoHao2ueXuxCLk+z1QcxLBO
 5NV1HnqlBGfqoUnfNSVc1B6+duEznKDUEl4RcTMCr/BrG7rAlW/nm5ntLpFx5rmD5B3ZwH2ftIa
 bkYICZMyFo9aN2lnCoaOhMHlrh1/7EtxC0EAiorB8Ng3kjvUZNJB1g+ZHbx3aIRgk7vDXx61r2i
 xEq+P04kPA7R4q2mnYmqJJA66Rpw3I7l2E1YRCJpRU5HyVdoVZqBjPeg54bMcPQpDgIEuTubQqP
 2viUrJiJE6C5aXbuY/n1F9iQTFiDv9PTls4B2glicqW5AtHqPcOEmYZEwW2TgEqOdUQ/Of7sW0c
 FRRzhEm5qnfwRmnabIA==
X-Authority-Analysis: v=2.4 cv=VdP6/Vp9 c=1 sm=1 tr=0 ts=69527148 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=j7HMW06gTmZkR37ntNYA:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: fM89Tw_jumpXuC2peffM2U9MsAlhLY5L
X-Proofpoint-ORIG-GUID: fM89Tw_jumpXuC2peffM2U9MsAlhLY5L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_04,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512290113

On 12/29/25 7:06 AM, Pradeep P V K wrote:
> Enable UFS for HAMOA-IOT-EVK board.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

[...]

> +&ufs_mem_hc {
> +	reset-gpios = <&tlmm 238 GPIO_ACTIVE_LOW>;
> +
> +	vcc-supply = <&vreg_l17b_2p5>;
> +	vcc-max-microamp = <1300000>;

I think they should both be 1.2 A peak

Konrad

> +	vccq-supply = <&vreg_l2i_1p2>;
> +	vccq-max-microamp = <1200000>;
> +
> +	status = "okay";
> +};
> +
>  &usb_1_ss0_dwc3_hs {
>  	remote-endpoint = <&pmic_glink_ss0_hs_in>;
>  };
