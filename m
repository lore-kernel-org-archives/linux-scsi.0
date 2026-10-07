Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F014756B3
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372990; cv=none; b=TZI1S8501RvZ7i5/tG+2qLCksJhzagZMCmZgW94q0nSrVfJqodMXXLMBSaSBY2LSnlfO8VHFHaqfIaUvH4CKJvtlwHCvU0q83kD+/viNXFOSgn84EQX1ddeJBr97s6q+Ce2Z0vAhglcyqdJqlO6BT8OG9yyfp3sWpnvKQRlsRUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372990; c=relaxed/simple;
	bh=WhMNysDAsjdB0e0GzptBue1GMJM2+L+NOeOJLaCa4cQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qihY8gL7wNl2hE5sgy3T/IITV2mNk9WuvFma1rpTOlhsuKdt+J+4LW3jgmGzAFt0qNuzYUd1Wcc4w0g90lr0OPSfPhMlDe+Dh9cIS2MABZYxR+x3+C+T5MoJGFIGjxd3we93L0yNQVNVg8/fhcf1e6OgJr7u3bSW4/PLJLj4cHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Fqe920Mo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jVWa/ebe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Fqe920Mo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jVWa/ebe"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BV6Ic609831
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 11:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vwMGznIBtX6JOyPsmXPb4KjWaatKQQ2Lg+WeL8PpwXY=; b=Fqe920MoUb00VojP
	VxM7Zr9DtCCPA+MLKhmyBzW1bET0goGGUG+BSz0SCGa9dPUtnKLhEE/AX5/8m1tS
	S/8jlVyUslhkzIctWeOFmwB7Qvp/nhcZ5XsIURt3SPEi9k7BayJ8YcBwfqtYagOO
	enleDw5jOlxChb1okef7cCNUD6B5dmFiPSO61r1HCvXkjusgfAERKk1BI0hZOzDl
	Z+zr3DukhTK0rygpS8+z4iyUOkZ7e7o509lSyAMzYbwZjYixtBOJ4WAu8eg2shD0
	L8ecDSJ0jcmo6oM47s9ftcM3t221of1VOSc1JImhfNrCHRdsgaFERcvdSn82pM5W
	v71Jqw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5fc597rm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 11:35:57 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so5780806a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 04:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791372957; x=1791977757; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vwMGznIBtX6JOyPsmXPb4KjWaatKQQ2Lg+WeL8PpwXY=;
        b=jVWa/ebe7lF/kqMMitkSzabh2+SVDkYU8I5vjl4uqRcwQ6IJUGiJuyVzQfy/HX474g
         YBJRxvFVV6ny/EmUMWIyugkSjCrAiYMeWmElDaW+Khb94n/6Qyg/2h3mTUmP4IZ1/9cx
         kbdpLWLU4127AgQGBWhO5Z6jEgKv/w4aSpCcCxO8nCwHbWO4L0BbzHaQZoOsubMXVDPY
         xJIlpFVt3KERkx1Veck5PE8vVthxhWtWAbAy5faNMRdNusq3VIETd9Fz4v7KFQQek+ny
         kFmYiqEXn3hPyaJp5zA0aUBmyTBHkQUurK4J32iHefKjkO+/FZfzO9uLO/vSIgzjOuXH
         NDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791372957; x=1791977757;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vwMGznIBtX6JOyPsmXPb4KjWaatKQQ2Lg+WeL8PpwXY=;
        b=i3Y3HrlyxlMMHausW93rccx93/YWUByDKKP/WMxK9/MtmJEz96pWt4TevuSDqTD7Fr
         WViKSXgTHYlneamwWO7lHpqT7Tp05eIggtwV+JTE/iNECSQdAN12trCsuaDNAqCIpYCH
         i8znDFf7gbPIbJZ9SRK8t1HYWM/26JQZVZbNctKXa2YMMUl3oUzFrkx3xSPjJ6RPXAuR
         hr19hzFtfyl+L4GX+Z5sHMZDS9BZWI7dOlASS39hDlhzSYVSNAi/sgpt8nUOXC2KNzCW
         ncbz2u6ubvnoctZj8m8UzIxtpIHjzdK0lTLaCW0/PZeT1HzW1id5QWqzaETysxqgReDN
         R01A==
X-Forwarded-Encrypted: i=1; AKwUvBy3qX/9QVop/6yvCEjpSLtyWHQVDVOWxknqBxgn1o8vpRk2beYM+834NGs3PJyCn7U1bDL+hnJ/UuYX@vger.kernel.org
X-Gm-Message-State: AFq9FYL8rL37zK1V1lGv8nixfk/js9jJQLOMxCdgc1KvbliafkuF+apT
	CUnnOm7haYU+j7HCQSdnvwHzhvwLZE6fdvzRZwercRTiAOH3ufXaNDREZfV1yoydhMVCChseLPk
	R2Tr0c9acYDfhXasOXFVRGpDDobXgC2BP1j441y1S2qUeLOSUPKPPZMRf6E9Ys+a7
X-Gm-Gg: AYBFou2iuXSwzmY7gYaOtZI+x/ogTuQ7pS7x7SvXQaVALbmTRubWj19U6QQEBe64n2n
	8a09cpnWaBNipTYoCoeZKfEy1z7bCuUNDSaOJCGnepxzYN2QbAj2yZd3f68WhrRUQoUPCMblrx0
	9ofWi7lVbPsKD2Sp10aXhF7Q9TqplsUStJe1kOFNo7HY3t/ORjBOEhnjhapSpsyr4VW8o67hirU
	TKwwkyxSNxYLVhhMupdrtfx1JdGINeaDXjrNKmGrnNBRhVXSxPLU0sTXwW52tEO/gcEWxEfqskg
	9tKW1TexBk3hyyWLG4hUukva6qjfgFg/5Gt2+dUws+hFRjzvZinSDYLjUJI38NIViOdnqevUBeG
	3AEc/bE7tT9N9AhcWSWsvtaDMxfb3v9ZOZ7f/r8LzMPr6i86NeL3NrQbXU0rxSe59ADZLx4AJZx
	h11nxACvAl94c6dTOhMw==
X-Received: by 2002:a17:90b:5746:b0:3a4:b2e7:f01e with SMTP id 98e67ed59e1d1-3a8a1188428mr1499296a91.52.1791372957100;
        Wed, 07 Oct 2026 04:35:57 -0700 (PDT)
X-Received: by 2002:a17:90b:5746:b0:3a4:b2e7:f01e with SMTP id 98e67ed59e1d1-3a8a1188428mr1499263a91.52.1791372956413;
        Wed, 07 Oct 2026 04:35:56 -0700 (PDT)
Received: from [10.79.116.227] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a851630206sm9675364a91.0.2026.10.07.04.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:35:55 -0700 (PDT)
Message-ID: <c5f4e404-c03c-43ae-9785-7be1d8b25fe4@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:05:45 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong
 <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com,
        Taniya Das <taniya.das@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
 <a5p5gszuadvnvqcwffg6y55khdfhacwhegaxmmiwm72sfid6ex@cdwuo6sdmkgy>
 <297690cb-64d8-4e7d-9d97-66680f6a2b99@oss.qualcomm.com>
Content-Language: en-US
From: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
In-Reply-To: <297690cb-64d8-4e7d-9d97-66680f6a2b99@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXyTFG2GkvmDZs
 pbt/ZaqUEzjZ02vcX2BjoFrMuy51StaDPUyp5HP8Elm7RgRS4u9/2B/pZq1PYuQ87SsDjR0Rz2l
 SijsXu+OkI8469MJiHrgoXPx9fARmC8=
X-Proofpoint-GUID: poIpw3eExj3uN9Y27FFbQSaGqQAFIZfZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX6x1YpmMM0uT/
 jCqvYhnmv4DQt0yu3dfC8zHo8NtrJ13BYPsiCK/zJSakgGK1DYfPeqS40V73rgCdzlaVw13ArW4
 Y/018zoFWcYmTT9XAncOiQ6wxqKbHqti3WHdX1EgWr0ImXJyRrBklVKd+hUIGfsd2hsUBpE7GIS
 2HfOZ6/2WtDcGdO5HJlyB09+jKOuZLUfheCigtNiIhFdgYAuC6MhDlLuNDT6Af+pBYtp2HgSKux
 sHTk2VGxaaWSCTVGr575gADI3c9/Tc/bqx+lTp3ztO2yg+ymsnCMBPKX6pv/GMtCAjpMxt5TR3n
 yfJQyf6+IvPsDCKBxtP5oag5soRO/tLTvn3oTqgpYwwOinr1PabcKv3pjk+6Hb/3fhgxJHCYN8P
 oIJo8XSqQh9RsDaI/jsS8/pybTMWASyO41iGzsxGQuyIDJxZF06Oe9jxXJzdCeXsfE/Y15Z5PdF
 HUa2719AUInq90k7KSQ==
X-Proofpoint-ORIG-GUID: poIpw3eExj3uN9Y27FFbQSaGqQAFIZfZ
X-Authority-Analysis: v=2.4 cv=a6+lZkSF c=1 sm=1 tr=0 ts=6ac62e9d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=1LCiuseMYk0cAX_2M9wA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1011 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070046

On 10/7/2026 4:30 PM, Pradeep Pragallapati wrote:
> 
> 
> On 10/7/2026 1:13 PM, Dmitry Baryshkov wrote:
>> On Wed, Oct 07, 2026 at 11:59:36AM +0530, Pradeep P V K wrote:
>>> Add UFS PHY and UFS host controller nodes for Glymur SoC.
>>>
>>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>>> ---
>>>  arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 122 insertions(+), 3 deletions(-)
>>>
>>> @@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
>>>  			reg = <0x0 0x010c3000 0x0 0x1000>;
>>>  		};
>>>  
>>> +		ufs_mem_phy: phy@1d80000 {
>>> +			compatible = "qcom,glymur-qmp-ufs-phy";
>>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>>> +
>>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>> +				 /* UFS and PCIE4 share the same clkref */
>>> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
>>> +
>>> +			clock-names = "ref",
>>> +				      "ref_aux",
>>> +				      "qref";
>>> +
>>> +			resets = <&ufs_mem_hc 0>;
>>> +			reset-names = "ufsphy";
>>
>> power-domains = <&gcc GCC_UFS_PHY_GDSC> ? Or is there
>> GCC_UFS_MEM_PHY_GDSC, which is simply not described in gcc?
>>
>> If there are none, it should be reflected in the DT bindings, together
>> with the explanation in the commit message.
>>
> Yes, Glymur SoC does not support UFS PHY GDSC. Sure, i will update the DT-bindings accordingly and include the explanation in the commit of next patch series.

The support exists? I can see the gdsc in gcc-glymur.c
https://elixir.bootlin.com/linux/v7.3-rc5/source/drivers/clk/qcom/gcc-glymur.c#L7768


> 
>>> +
>>> +			#clock-cells = <1>;
>>> +			#phy-cells = <0>;
>>> +
>>> +			status = "disabled";
>>> +		};
>>> +
>>
> 
> 

