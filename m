Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE5A26561E
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760359074; cv=none; b=siY4Pui6wn0W2eya2s+woyc+MN3J96ptj9cK6A2Mz6G5Zva+3wRLXKz/X6CbEi7ZZS3oa2zjXuvgwM3OQU0xrqYfVpWvv9cTs7zPBG6IDGwhg3uBwrWC+MXrcGlu7VmZA8SiS+hKJeqnLSKYuyh+A9QDE/Sj3Y0sxY/fqKEUn14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760359074; c=relaxed/simple;
	bh=aZGRCaEQAskD8nIjNVaot/fSIqSTel0rYFtYU6crRRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLMozoZBIzivxyhZQw05cP7vny9KldxKEkZGPWF7J1H1VIZqiAz5HvqHeAO7Kwdv6VUd6gdAqMJcxtNcjejnPxSJ5RTG1gURNPJl/A5NeuiI+w38lt8156UdK9TQhoMMIF2ljw6NPDocqpx7MNEEbn6McoAbuSUa4rOV3k86NyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Palj9H/Z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Palj9H/Z"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DAk9sT022192
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=UTXiDHZxjE5lYanBLZzc3WtP
	FhwD6zEyaiJPl3VCc+c=; b=Palj9H/ZHdSeQ9v8BmEGpcpToPtdkFkW8L9foVqF
	ma0Q1ih6Vl4BSwmHNHJip8SFxWjaPUnPkijbB4VH1suCrIPjty4Yc84bssgGeMkz
	YlcM7rGi7pTcoviN/WtNMDuncdFFQxwPk2wXEBMC2ddryPuWkzM/LoaqKh1gZds+
	Txq97tHGJjSZ4ihmFmyr+fYQUucuLypOmod2sd4WiKuelVCEp5Iyje9EZmhFaDsJ
	kREEkvjwGMCOFsY0eqoBnH0uZ3NvHxfrtABxbZozsX7wIGrFq8zrtlZet1NUdQWF
	3WoD985IMAHdfy6W+Br7NDrmgdCYGfBoBF8QKOC2Gwighg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49qgh64f2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:37:51 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-792f273fd58so187457806d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 05:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760359070; x=1760963870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTXiDHZxjE5lYanBLZzc3WtPFhwD6zEyaiJPl3VCc+c=;
        b=Y45LwyvSVejVaUoYF9JTSDcQqk4YPFHFy+MtEiyBMRobW/U/ZtVDQywwYChuF7hEcq
         nmK/2R0BpMSd9xXgzhhrrnYP8YHxZM7I/85ucY4ZNfVJEYWPT1OIP5lxqP304Fnyk4hq
         GAcg3JB+dHuVRTCW5vxCifunQsYRC5g/tC4j5Kd3Y9cOmcjyWdpOtJT22eL41xhkEMvN
         wJWDnKmfDXk0FdCoh9LC13FkuQxM7Kd2RKNMYwBZklPA8GkxlXF3MtfVM0/+YZOaEDbs
         GfLz8zmwOMwwlAxjASLrch082IBpXJCMH4XahxT5zsw06hqua1kDAjOowvzC97MegKq5
         pllQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAyA1TXXgiz/hY+WnGpHQfDtwMtjq/Ini2zGDHsw2mqmxJJKDTomfTfJQO5EuB0vsiyCRPqW21Usq+@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4GOn+dxtzymp1uoM+TZ7G9QkUOgDyGb/Bhm/7XPr/GrQMNYHC
	JD55X7lzj7GLhb+5+DkFnD8MVXa4Rx7K5h5HFCD+rbcLSM4VVIFjohTgicD3IodiR7ZtGG3XVHt
	IIUeTwlmt66jijMH77FuK/8BX8Yqio/taaKFuhimInJ9u7Q3jKedPz4Vr1EB5uxPt
X-Gm-Gg: ASbGncv4jTrawFUkc74Hvwcy+7T29ZFO5d68EOFt5SjUtwGzRBuSnMEINbjIZvqkkSt
	w+sVLCiKOuK5lzsQuG06nOc35m2OlEhC3dsYuZ3kDuLrTfpfJrojzhu94CHRy0uZwPdrSDiKbHS
	9IrweSGGVTE3KgCfWxN1y/kCio5lnvDeGN4U8uTcnRJ7W6s6TyzezK/cuOsFUYqXw0sj08EQJFl
	EV7qCd7SP4AqBdaELTvzPeCUBfQIRicCZ96sdQuyXMCLMMFkpvgRvrMqrTIpEiXFsEIIX7TGB3u
	t1WMG+6wryHpPkXz8d1Y12li2klksVrDccmK+AxibWFtIEwwB5CbVWduUw0l9OGlYjdyVkXq6ty
	ykBlohbS6SeYsj1JKj8RCVGeWikz67dz6+CuPxneQE1Os5XQR80WO
X-Received: by 2002:a05:622a:189f:b0:4e7:28c4:3367 with SMTP id d75a77b69052e-4e728c43476mr38351821cf.82.1760359070269;
        Mon, 13 Oct 2025 05:37:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWOjldqO3QYpUkgEWR+chHtoaSrhdJCEvdufVafxS4s9vy3NHcZihffXxkbgVUGrgtKFOT7Q==
X-Received: by 2002:a05:622a:189f:b0:4e7:28c4:3367 with SMTP id d75a77b69052e-4e728c43476mr38351181cf.82.1760359069747;
        Mon, 13 Oct 2025 05:37:49 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5908857792dsm4079248e87.105.2025.10.13.05.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 05:37:48 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:37:47 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ritesh Kumar <quic_riteshk@quicinc.com>
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jessica.zhang@oss.qualcomm.com, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, andersson@kernel.org,
        konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org, linux-phy@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        quic_vproddut@quicinc.com
Subject: Re: [PATCH v2 1/3] dt-bindings: phy: qcom-edp: Add edp ref clk for
 sa8775p
Message-ID: <xofvrsdi2s37qefp2fr6av67c5nokvlw3jm6w3nznphm3x223f@yyatwo5cur6u>
References: <20251013104806.6599-1-quic_riteshk@quicinc.com>
 <20251013104806.6599-2-quic_riteshk@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013104806.6599-2-quic_riteshk@quicinc.com>
X-Authority-Analysis: v=2.4 cv=H/zWAuYi c=1 sm=1 tr=0 ts=68ecf29f cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=COk6AnOGAAAA:8 a=1RwfRIOwSLSNpsoXFEwA:9 a=CjuIK1q_8ugA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyNiBTYWx0ZWRfX2zEIOs9VS6of
 xu8hn8Jya0cS1xqmHPlom3HvgPyW8IPN1QWqRfqniASbtLJK09q8ZqLNTnmVhmXyzoUhBgKqyXb
 3ohN0OkVJPu5goahn1cjUcInHZV1h/OeR1vMh+pDSEK+XRXGbuFumBpkD1iFE7RXe7MGTWuW678
 WWhI69LjpY32omEUre31NLB5y1JnQCmCFuANB2CL7IdiRp8ngsXKAxnunj0Gj4mBFDS3fDyjnP0
 0b2TjmL42GMNNYMoyx39wfLDfSbPpMrGsvJRdTLxNmj+c7VL++JLYSA0eaBwECtZWZcxjMek4F/
 ROW+3ogX1NOKNibjxqsxkBdkvyeIaVMA2I8EZECsmIm42mQKGx9C2Ys78Nn7ermYd1Il+plQ0x6
 F5mKcPwHJ6E7iqRd6Mky9iuhAVbjNw==
X-Proofpoint-ORIG-GUID: mOoK_4qcAGYVwHRg8nxDsqsMC8YKDU81
X-Proofpoint-GUID: mOoK_4qcAGYVwHRg8nxDsqsMC8YKDU81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110026

On Mon, Oct 13, 2025 at 04:18:04PM +0530, Ritesh Kumar wrote:
> Add edp reference clock for sa8775p edp phy.

eDP, PHY.

I'd probably ask to squash both DT binding patches together, but this
might cause cross-subsystem merge issues. I'll leave this to DT
maintainers discretion, whether to require a non-warning-adding patch or
two patches with warnings in the middle of the series.

> Signed-off-by: Ritesh Kumar <quic_riteshk@quicinc.com>
> ---
>  Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml
> index bfc4d75f50ff..b0e4015596de 100644
> --- a/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/qcom,edp-phy.yaml
> @@ -73,6 +73,7 @@ allOf:
>          compatible:
>            enum:
>              - qcom,x1e80100-dp-phy
> +            - qcom,sa8775p-edp-phy
>      then:
>        properties:
>          clocks:
> -- 
> 2.17.1
> 

-- 
With best wishes
Dmitry
