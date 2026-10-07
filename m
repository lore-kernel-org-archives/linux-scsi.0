Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550EF39EF0F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388063; cv=none; b=FflhKm7CkAA5mo0S0Mo6HBh0k0X9ZwjObx+irNKuoCDdM2fo11kqOtvzV6b/78PZoJm0kP+Q4qR/rvXEdN7U01bsPCpH9y/rw9sEwwoq8uPKfsjp7jrTTZmvhT4G0SfW8dqsP6cwy7DvnDWhvTpTcqhO1WhBJ77guo7oTiJCjpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388063; c=relaxed/simple;
	bh=URSPLh2bUnBt6WhRmDKNE1EsstWlz9OMjbqal72jSVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTlREl7Q7QHnR/ZM1JXlllRK8dpcawA1Bq+XdcwCib5Dyrh/XbXGUZCp8E/u2IqBhAOUw1/R0bOhgPD221GAKZ/tbf4hUbrlfjlwmcYhiklft+4zRfsxZBA8b5SPzq7Lm2pAS0js+6HjUZt8TJmPDw+gk1MqYUD7T+8eDpS4M0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YablL7o/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S4JhpEt4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YablL7o/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S4JhpEt4"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697Etg0h3909096
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 15:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ON1POuxQT8oQUVPgZEgmjC1U
	LppcBaLaYzlRsmpMyxk=; b=YablL7o/pPESIa7r70OHWBAefLpbpsHZgghoj/sw
	bWPl0OF7H5HMj2f3weN47jO4AgwNJIv2oOurH70gAm31L+lyM9ULTguZNWHswIQX
	aUqbLqDlidSzQAs7hOq05qz1aGJ2TJzUkOrmcrCW/1MmYq1CkgeF45KOQ6ggE+4B
	VtaRG7BMRZkNUb2+8nuX0bx5aW0x5kKVd6AmcfI6PZ3IMe4uL7OB/V6rh6kQ6gGy
	jtkqdEHZ4Yblrxwb4Ru6RgHaKr+mWT4Jf2HuCoe9Vynwpy97y7qtNOaMZ3WNyQUg
	bKXLP6TQFZbirwSj4I4LX4h98th9ConX9nolubRBRftUmg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c67au8g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 15:47:40 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93e92aad34aso362986585a.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 08:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791388059; x=1791992859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ON1POuxQT8oQUVPgZEgmjC1ULppcBaLaYzlRsmpMyxk=;
        b=S4JhpEt4T8I7mDK9AE9s6+dnD8xmA6KEHLk6Uodq0C2qjDO5qZO2HmEAW8nl8uDfT3
         1k/JVdWuxUyboiB97nUQt7UNBjYpBRCuqQq9N3coxdn9WBOJ2SsswLVF+ZJ73LjryUNt
         74XLVJZQlA6IvOnCIqPL6Hple0wzyL8jjwZdGQGrCATd69Q/NJBJfh1c/pRWCrSfEpPY
         UIacOVJJco7QNNnrh0Pv3yKFOD+EOmDbiyyU24Px1+IOy+CPgJ106Y5fodw8smvWYJ6u
         S6fIuoInIHGwysypIL+OUVQpxDvJzNgylMwrLtya01g1xMeM152/akwmAtYywIsSFkCg
         b1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791388059; x=1791992859;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ON1POuxQT8oQUVPgZEgmjC1ULppcBaLaYzlRsmpMyxk=;
        b=GRPHeSeVVkaSaYdEIMh5kKFwg9klG4rCLK/t2I642zEnGq9g66MhebJTdgruyrTL/1
         1kXgSZtxk4dyqZnVdJt/ErUzQQTPy0So30xqgxP7RN1SqbMMRkiFPI3WnhbsiNIiZ1oY
         Ks/9l0Z2l+DKb+dkXc6o1IY1ATcT09/cjR7DJjB4Jt2X1yDSQTHldeq/F2A9x4RfCnkt
         lYQ4+Qpg8++DiteFGFpQKUYVfy9u7+vTgwn0BONxAIgWNRATHM6aLuC58a2MKK5shhhL
         NhDxxCU6s5Z6gf/+lIgBsX8SqWdJSgqj2VhaguqYJdWHPYLulz/BzPqjVyuddMlqwU5S
         i3mA==
X-Forwarded-Encrypted: i=1; AKwUvBwIGWLh/APCGRVPwqtL7mn9NWZDFB7eLNdse7i91vgCbECE+CVbSbwMyTGy3vZwHLdnqda2XVLW0iIH@vger.kernel.org
X-Gm-Message-State: AFuF++lrRw2etl5xQvB5T9ZzKnh5xOEum+/GQdtXoVzbWgDaTjx6Zdbe
	qN+PVTveRX3MD2XQK7W6t/xxCgMBoHolVDRPAUXoDJu/dz+q2fD2/dPfw9iwEw1ZK8Q2oOYaZgR
	4o+GeH1N7pOsh+iXf3oi24PRXkJQ+J+RNEaY8mkPM5mVsO/GjYW+Eqduf7VquEZ1F
X-Gm-Gg: AYBFou2CcrLb4u0z7APwAarlW098qIS/JEZkaKhjOtkcXUlVlSNEewo80gWzUouTM7k
	KADLhjvQUnYW/RPpv0yzCSdlH816B4Ngimc+40Ati1LsIDRnqif/W0TJJtFSe3EegCSMnWbv/Zr
	Bjl6cofoGwvQvV9bZ0NT8i7eoq6sre0UR0WLA87U8kvdARyA61wj5gQmTuhCdPF3HuEtfpj0W2P
	XQudZscT4S/EgmEn7/sLCMJOCVB5ZzojYq5U0tT7HFC6damoL4gpGEOpIvZ/Ldfjj0GSrTGAB16
	zUOsG2SXdF6KtzY5jVK2dmtQBXg4JCoi+tGlo17i87etEQ7QDTkkxckKs97FRS8tiqVNPRklLXy
	5GAcHgXEfEs2OnYKoyzSl99A0cSG3/nuUQaDDGtKydI90nUzBYjMFf0lTwbIlZUft8m9xU7s9Lj
	jeBw40F/FOjTbv
X-Received: by 2002:a05:620a:3904:b0:939:ff85:8067 with SMTP id af79cd13be357-93e9b74d90cmr499756585a.30.1791388059210;
        Wed, 07 Oct 2026 08:47:39 -0700 (PDT)
X-Received: by 2002:a05:620a:3904:b0:939:ff85:8067 with SMTP id af79cd13be357-93e9b74d90cmr499748585a.30.1791388058556;
        Wed, 07 Oct 2026 08:47:38 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcd30a8466sm170150e87.83.2026.10.07.08.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 08:47:35 -0700 (PDT)
Date: Wed, 7 Oct 2026 18:47:33 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
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
        Taniya Das <taniya.das@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v3 5/5] phy: qcom-qmp-ufs: Add Glymur support
Message-ID: <unvey6hlz5ov4flgzza7f3i7nowxym5ik3dd7jkzx3yiqt5xqp@ci3z27we45e2>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-5-84cf4f861415@oss.qualcomm.com>
 <zovl7lrhlleflaewk32o4wofr4bzm2bmkdnakev47peijrnkfe@p3ixrxltdpcm>
 <f9c7bd4a-2e97-43e1-a9bf-295b841ef0a3@oss.qualcomm.com>
 <p76qp5bhijenec2ygj36dd47uxkeyk6kztccbuhblte5lqn22x@yikvkbipjbae>
 <7e8ea792-2336-4252-beed-7345815b0b90@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8ea792-2336-4252-beed-7345815b0b90@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA2MiBTYWx0ZWRfX7alXMUAQXprJ
 hQz/3gUe0u6ALYytqHR3FoZ5OPSJMUjKqV9tLlv1YuzJF9q2QSlxZhf5XtfmgceuiKxPchkstiI
 z6nBPSG76Ugt82lEIi93ZbcXo3DzAoA=
X-Proofpoint-ORIG-GUID: nKXkxkbbMWmlDC7-EnReCOhoimYk6RZm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA2MiBTYWx0ZWRfX11cEm2CcBDob
 /td5x3tQOulynuccfs/3NPEd6hQDy/ipsxkLsPZbuNaRAeyfaQxawaKgZoWffNdOoUcaJTLmVsl
 0hNuWOlzCGo3WwB2ieqOhnbTRhf8yHFXFClSjSyVCSDa6gAl0bApuKHWMGxX2fJrgN2xxQzbmuW
 x247RKyi65PJkTvBFMyFYYkXPPbaSwQ68hDu2jwSH03xJUu6y9Fm/Qr9JzNJpzo/SOWM1o1kxAE
 z0Q/dkJIS6St0uBpjQWLqlA7dlfaygNLQ6+UdB0F2yFr+TMKlqXl4aLUj8ktw+wu5XI2FruvfJV
 bgtvLvPy32srKjFQlVpM5iYHikt4gseMqh5NAX4uHTEHUdfK8IkSEPxzxN8AISP6LbXP8JsKy0+
 tmXQFxQQpVKRdZj0wC/THnmA5/LnL6jpQ3mMKIov9Q5yuC3mBO/lKl8tXxi0rlxIs7M7nfSVFdq
 KwjNJRG9dgAHlDRBSug==
X-Authority-Analysis: v=2.4 cv=OfcNnRTY c=1 sm=1 tr=0 ts=6ac6699c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=0f0GmaTcbrnyVoL-888A:9 a=CjuIK1q_8ugA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: nKXkxkbbMWmlDC7-EnReCOhoimYk6RZm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070062

On Wed, Oct 07, 2026 at 08:15:39PM +0530, Pradeep Pragallapati wrote:
> 
> 
> On 10/7/2026 7:13 PM, Dmitry Baryshkov wrote:
> > On Wed, Oct 07, 2026 at 05:03:02PM +0530, Pradeep Pragallapati wrote:
> >>
> >>
> >> On 10/7/2026 1:18 PM, Dmitry Baryshkov wrote:
> >>> On Wed, Oct 07, 2026 at 11:59:38AM +0530, Pradeep P V K wrote:
> >>>> Add the init sequence tables and config for the UFS QMP phy found in
> >>>> the Glymur SoC.
> >>>>
> >>>> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> >>>> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> >>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> >>>> ---
> >>>>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
> >>>>  1 file changed, 99 insertions(+)
> >>>>
> >>>> +	.offsets		= &qmp_ufs_offsets_v6,
> >>>
> >>> So, is it a PHY using v6 offsets, but v7 registers inside?
> >>>
> >> The QSERDES RX0 register offsets on Glymur SoC are aligned with the v7 register layout offsets.
> >> Therefore, the v7 QSERDES RX0 register offsets are used for Glymur (similar to SM8750).
> > 
> > Mention in the commit message, please.
> sure, i will mention it.> 
> >>
> >>>> +	.max_supported_gear	= UFS_HS_G5,
> >>>> +
> >>>> +	.vreg_list		= glymur_ufsphy_vreg_l,
> >>>> +	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
> >>>> +	.regs			= ufsphy_v6_regs_layout,
> >>>
> >>> v7
> > 
> > This still holds.
> >
> Do you mean changing ufsphy_v6_regs_layout to ufsphy_v7_regs_layout?
> If so, no. ufsphy_v6_regs_layout contains the PCS register offsets, and the 
> PCS register offsets on Glymur are aligned with ufsphy_v6_regs_layout, similar to SM8750.

=> commit message, please.

-- 
With best wishes
Dmitry
