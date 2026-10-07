Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2111F4AA564
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380628; cv=none; b=m7IodT6RuV2sEaWSepBSdwuCZzI61dJpUuk4f5hA9T/E0R5+3eKS1ygGonBe/Ispt3J/TRogjrmNeyj3KEP9YT6wC0qh8JhdNLv6aaMVNe2RRSddtxXFb4hPIAFbTDa1EjNACHW0h57rznNpQ80yAE0cKHdr+XAKheas8QOmj5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380628; c=relaxed/simple;
	bh=Mo5vMW6Zkz5H2CFeTFubPNvIJVxYHl23UrqUeg56qRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVOHxPPNer4VAaOjOuV6xa/JqzLryNwT73qkkLfxOSLTFtl9zpsvRIK5ywcJ5U6oUd9UUtS6mPl5WcydzwHK3SPh+a5i9s4juIDk9l1R2IkcqEiZNW48p4leqWaods/X6UofmY0ikPYS/VyUa9qqlzPMPrNB1EBPy7wkFNwmtx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PuVW/ih/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D/Z8MhEZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PuVW/ih/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D/Z8MhEZ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BVMB12364095
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 13:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=U/liQNsAQUWHpc9Ht9TcT3uf
	glSLG7X10a7oV7oShF8=; b=PuVW/ih/A+mwX/6USRRApZMn83CjIk1rYKuzvzbU
	krqpC98aa0i2aNqjMK3xdpQ4Br9qbwZiSyVbZL+oXVJqHdMNE11j95dT74R9qUJd
	umMnFL6E7g3hh1UNW7o/2/a1Wx+zbNR9rzVpZ1Ow+qkDaZK9oksLnEe82lTsKJeF
	bkubDgi+0XFHaj7sQK9rMuK4+ib91+3Xr7R+9HaM2tTfbMjZ6L1ioEoyet+N9kR7
	6LUSOxdgbJDR0ot9+DgA4CmN+Y0OZE+NCMWog+IoLtQKONWtQszFsmpsCTkpqC0C
	ila0Hd6XnmvvoBlqU9FqFAA9lhZlNvVPQXZ6A4fEdMpHIg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5fw8snea-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 13:43:37 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91961374299so114958146d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791380616; x=1791985416; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U/liQNsAQUWHpc9Ht9TcT3ufglSLG7X10a7oV7oShF8=;
        b=D/Z8MhEZ7eAuIuE+16dY0jS5/yU/jZkIfu/D4JMLzMF5ry++Pw4wncparCVPDd7BrR
         +ezoio3ulHzMs1f/zkIZIftMv6Si4PiGt9jmsjLEexEyDw+LowvIeuRjixh8vI/DcAzN
         dZ1vEEIu/UNUpRIKGQ9n4wEGwYBIWAk7kVuVRJbffD75AHBxg668DI2cLTWOGy+6qEdf
         E44nm6lwebN7F8N9Deb2J/aGfl2z5F3SrPSmmxh1fSvljRWntAY+iIiYLyw7h6XqsWGw
         fBPhElPToe910GCfcQraBzJ3VgfyPcfYF5t2rVdkLDQhtq9feJsLafbJYm9ur9EX4nk9
         c46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791380616; x=1791985416;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U/liQNsAQUWHpc9Ht9TcT3ufglSLG7X10a7oV7oShF8=;
        b=vlu2ndemTnrfyXd62R1xo9VNXKMINRwbtzPx8/cF/r7b/U6QszORESptKgvFVuy1nQ
         a49PnLQCP8fw1QhrgeapgVSIcDFnC2UBC0V4CKNIU45yClCrZFeYAnHG5hrgAUlOGeeW
         txoJe7AsGNvN7vkG6wfF+8E5MKlzTgUI/yfcbHoxWeibXorE7y1piBbTDv13TzVImzrY
         kT1M73sTmG2hSh0j8Dlw3yOMrOhZMmrWK5Ahq5rLx3fA6vs+Ad0hT4RhcWisOfL+1jty
         CVWDaW9qOGExyol1lUwIzTXgleWxLGR0Ue5sc/TV9H+CTkOvRGWLmim6r/WdZvxcbo52
         bDnQ==
X-Forwarded-Encrypted: i=1; AKwUvByYFCkatJVwGJlr0xcHeL/MmuQuIWxIw1Vt9mSDMJvG0nDldgiZEKgGkQm44IVMnV2xTKNt59UvH9WY@vger.kernel.org
X-Gm-Message-State: AFuF++lQazDb3RgTGlMuE9dB1Y/9u0j+XbCyFME/tIS4CwkwGreCmeuA
	qhPVG9iqc5F4OpQuZpZfambwtMXGn9A7rRz5+U45QJk6ZH4py8zLaW3ULCy2MNQT8aadmAMb/DR
	3kv/BmnKPBNr3IaX3k3rXcNt6H262AbInWEei8yNtB8O0pGjJPyGWfnTNu108rIjD
X-Gm-Gg: AYBFou0cRbC1PmLMbhQqI6It0JN/6ub6drnS8T5hYjwj72QCL8CVsGEfzeOAcUPMk3J
	OcS69HF6BzuQpBtZkzkGnKVwyzWcSfOUDJfVTRUABsO7uPTpYEWVMgvwZOjZ/ypCACnvvk1xdit
	sAjs4aQhIY8tO6CcI/B4/mIZ+QgRtYpCy3UvY3Phu1YB2hL/SHK6LMq+mkX//JqXcZqyjdvY6gK
	I+m7ribXD2cgAfK08a/TcHltvOOjM/iDnxS9iQwxrSJFW2ZNkMYA6x/GeFl3z+JbJEOWo8oNuVA
	zDJpCnof/aaJGzcXal2tny1Q00rxmKEdZb9vKTUsK5FUezTebWXuHhjhoIMQZybwxV/I6+gafPL
	sgpdiaPVhozZsOMgdYdmE1S4SsF9QErXIH7C/H+EroZBpwTVsV8qOTwZ/2odGMMyZeN8aceUhb4
	glQR8gdxfnY+iS
X-Received: by 2002:a05:620a:2711:b0:93e:74b4:3115 with SMTP id af79cd13be357-93e9b795c5cmr398243785a.38.1791380616114;
        Wed, 07 Oct 2026 06:43:36 -0700 (PDT)
X-Received: by 2002:a05:620a:2711:b0:93e:74b4:3115 with SMTP id af79cd13be357-93e9b795c5cmr398234185a.38.1791380615473;
        Wed, 07 Oct 2026 06:43:35 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bcd309c713sm54780e87.68.2026.10.07.06.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 06:43:33 -0700 (PDT)
Date: Wed, 7 Oct 2026 16:43:32 +0300
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
Message-ID: <p76qp5bhijenec2ygj36dd47uxkeyk6kztccbuhblte5lqn22x@yikvkbipjbae>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-5-84cf4f861415@oss.qualcomm.com>
 <zovl7lrhlleflaewk32o4wofr4bzm2bmkdnakev47peijrnkfe@p3ixrxltdpcm>
 <f9c7bd4a-2e97-43e1-a9bf-295b841ef0a3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9c7bd4a-2e97-43e1-a9bf-295b841ef0a3@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA1NCBTYWx0ZWRfXyvIgzcyyQw6n
 EsJ8kTSNgUwaus3sxylZpgyGNS48ZTL3PSg65i9NWHKf3ssuwhAFlLmdyAUrmNfZJrp6LEj+nTg
 HKcjBlo8Ua8NhWp12vCQk5VgCWHICLg=
X-Proofpoint-ORIG-GUID: kyf4wMccwRQbVEnkmBAedtkVwORz-Rh_
X-Proofpoint-GUID: kyf4wMccwRQbVEnkmBAedtkVwORz-Rh_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA1NCBTYWx0ZWRfXxmnvvUV6bpv4
 zh2Pt9GLIh8jZFr3IwyKWmfyFlYWMq3SbN82EyApemceS0zbb1XCqAHuDhemFU2rneH5IZfeZGE
 SqJjYNzVv7OQhWmt1p5sgRAnyFdfxZaN1GcShXFLgAujMums+JlmZlLgi55F8P/e3Q0enN6QVRy
 epO+vJtxTHnpC9l7hAiEoI2yKc6WMl9EvHybHhb5hUDzRY7eTBsa2PqNpieCZlISULgXrVyNtgQ
 ZkfOGzmfmU6mRR1KoxZJjapbFMEVIrzf/YQ/mYCGgUP/uk1tuBLfFrHdFFIzYRXK+Ks8QOQjivn
 SnSQOWmAVm83ebT4yM3FFluf+n0Bb4RRWzruLo4pYpk+mvSH+4g9ouYNGUEsBI7q3dtmQrQ9c+J
 igKWTRSgOFrtYGUNxgzITnCEqDv0II4G4WAZNPgLCPNGD6mNmdplRlfOGxFXl74vKlu2CNU1GZ4
 oTVdpQmzYM242uOReAw==
X-Authority-Analysis: v=2.4 cv=Af0kjHXG c=1 sm=1 tr=0 ts=6ac64c89 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=JfrnYn6hAAAA:8
 a=EUspDBNiAAAA:8 a=g3YXqlWUHmiHVpce9XYA:9 a=CjuIK1q_8ugA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070054

On Wed, Oct 07, 2026 at 05:03:02PM +0530, Pradeep Pragallapati wrote:
> 
> 
> On 10/7/2026 1:18 PM, Dmitry Baryshkov wrote:
> > On Wed, Oct 07, 2026 at 11:59:38AM +0530, Pradeep P V K wrote:
> >> Add the init sequence tables and config for the UFS QMP phy found in
> >> the Glymur SoC.
> >>
> >> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> >> Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> >> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> >> ---
> >>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
> >>  1 file changed, 99 insertions(+)
> >>
> >> +	.offsets		= &qmp_ufs_offsets_v6,
> > 
> > So, is it a PHY using v6 offsets, but v7 registers inside?
> > 
> The QSERDES RX0 register offsets on Glymur SoC are aligned with the v7 register layout offsets.
> Therefore, the v7 QSERDES RX0 register offsets are used for Glymur (similar to SM8750).

Mention in the commit message, please.

> 
> >> +	.max_supported_gear	= UFS_HS_G5,
> >> +
> >> +	.vreg_list		= glymur_ufsphy_vreg_l,
> >> +	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
> >> +	.regs			= ufsphy_v6_regs_layout,
> > 
> > v7

This still holds.

> > 
> >> +};
> >> +
> >>  static const struct qmp_phy_cfg milos_ufsphy_cfg = {
> >>  	.lanes			= 2,
> >>  
> > 
> 
> 
> -- 
> linux-phy mailing list
> linux-phy@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/linux-phy

-- 
With best wishes
Dmitry
