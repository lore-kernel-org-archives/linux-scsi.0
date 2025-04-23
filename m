Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7B19D892
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415303; cv=none; b=fy/+OWZfOjya8xJVYDvk0J7X2Et84pW4BY8TMqbb/y3Cmes87F0ViEUHUg2P0fFrNnXV1GAfi+PskenzA8h/rY/jSROpTKeOLb1AxdeZhGGC2KQid7khgzTKg6aD16KpGVI24kESxNzD7/2AYMtx5w9CfnZzgLdpiI3dE8z+fz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415303; c=relaxed/simple;
	bh=x1xM099k58e962H/jec7C2ksEWH7T+h7cL/fb7TmtjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQHuQhykGnE7JRkjA9nTSM5YXLZWawwAbe9ciuJnCfLGsf6Y9//Omp+vB/8N/TjghkSAudwZrAFw2R8VKXfXhqEfKv4gmk08Nr/l6690QzN0jqguIdWFz9h/duiOBfdDfkdz+1d7Z6gGKVLoDBze41UlIvwvQtqozj287BxuACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mbwdTD0g; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mbwdTD0g"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NB6NO2024369
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=gesSST3I2MpEnFmeJa5ypS5I
	NGFvjsE/z3/d2bgX7FA=; b=mbwdTD0gUiHIlzwNnGcBQa9jIH7BinPCACO9hTfS
	z8O+fZDwmsUffir2JzHl2CLmdqpMbDLmWun6cj9bVdLc33PFLLFds7Ys8OG1BkmL
	IoFmNBLeRmHs2NZqKVEwyGj1lauclEzAuPHcRPm9NtwQKYWF9XQWIE/1pdqM/NTk
	Qh9aYR+Wwge19cj31Sr4y/G9KQtEUg7uos3yyWwdH1SDn/46xwVcFhuGsBiQaR6+
	r0BhQ3Fn6xJvHufcvKJNiIQXAtCq5GdO7O1wu6Tnvlyo+r3G6OsjLQE78N2N+36L
	rHwpcejcoQLoV2X895FprXVLJfB6Zglm9dvA2yv+B89gxQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh3a8w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 13:35:00 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c549ea7166so936509785a.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 06:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745415300; x=1746020100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gesSST3I2MpEnFmeJa5ypS5INGFvjsE/z3/d2bgX7FA=;
        b=N9rCRLuIl5zLs9k1vw0fTG/RnsvtUMfWAnDg0KLGpk8OeTNFow4o6t9p2cahisgqUj
         bzMvSnlKRGK1aKw6muasalgww5ItTvyeT5SHC8q1sopvligWcxaTJCfQDXekBtwXFyRo
         42RORowL3+Qeo+qqKXxj6VS1QSupz4FJ6fXyrSCspQQdeUCmw+ZujmaySMqHlg8b59yX
         UA0yHxP9veNJuva6YGo0YPP5VOPTT0qrMjcMVO7bylHjydj6cUDksaABIwgC+7m3yRnf
         yU+sB3Z4z6dP6rcXR+giorj2S/BEvrw8fYOtqiWvYEbQPzz67RMTfeMNWGKv+UDOO4/V
         YUuw==
X-Forwarded-Encrypted: i=1; AJvYcCU2tPk4lm1HNBenHi478wTlAqPkYLw0YVo5SNlsmvf4hR29rC/dOFrM4HXvywWaAtf32c9pCxRKcK1i@vger.kernel.org
X-Gm-Message-State: AOJu0YxilAgJiesG9Erq7rc93YIGhpFOLEirfyxM7AESkuca+J6tavai
	3B7Mbut74jgWpLs9bbpbN/oRc8YUN9gupQ5JwRIqe9n4ErHqAC7vn7FUx2BIWydgnTYz8xHFgYt
	pstXIpTAbTif6Q38uk1MLEIcRcvfu1Qx92N+iT8cJbc2aGQOsDlT3EaK5jQSF
X-Gm-Gg: ASbGncumAnIhCxq7pkqm7+HrjEIfP2xgbfakOEG2MFF6NeUH6XLRu47RTXjranBoHn4
	nIvNWS0C5P5BGZx9ymOVkq6j6uayTGcWmsdL8CEdA4x/Ah7/9BeLDaYwCkiGwuw9Gee2mJLVWs1
	z7MvCS06vniHqqEdwhKXbZZOnNlzKwM0ajhGD7Vxc5eOL5r3m6jAc9Yi8tQc2ffm5UKg2ZtTFuw
	Unnyg+hWCLltv+d9gVardIYS7KenHg0vg57j2ZSoNv9trFwXYKOWELAFzyPI3WjjzeJcRnIKVxN
	ZkKftJ2VjbzSUSd0IzeUVC64Q+ohJbrRjtsBML6L+h0PXDCWg9LhncOXA89G0710E/ina0C2m5M
	=
X-Received: by 2002:a05:620a:3908:b0:7c7:b4ba:ebf9 with SMTP id af79cd13be357-7c927f98e4dmr3123333785a.22.1745415299647;
        Wed, 23 Apr 2025 06:34:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSwjmlcZib7gDeiGUVw/szN/iy8E/BLJscu+dW5fLmscxF+J7iPAozkJczfQ5JeB0jI4FQ8A==
X-Received: by 2002:a05:620a:3908:b0:7c7:b4ba:ebf9 with SMTP id af79cd13be357-7c927f98e4dmr3123327885a.22.1745415299093;
        Wed, 23 Apr 2025 06:34:59 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d6e5f61a1sm1563103e87.241.2025.04.23.06.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 06:34:58 -0700 (PDT)
Date: Wed, 23 Apr 2025 16:34:55 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3 5/9] phy: qcom-qmp-ufs: Remove qmp_ufs_com_init()
Message-ID: <w2fuv2xnvszlbwdlxvakkex6sce2mm32uslft5ma2zvz2gscvd@chgzsflkgxvs>
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-6-quic_nitirawa@quicinc.com>
 <zvc3gf7mek7u46wlcrjak3j2hihj4vfgdwpdzjhvnxxowuyvsr@hlra5bmz5ign>
 <4557abf9-bcd2-4a06-8161-43ad5047b277@quicinc.com>
 <CAO9ioeXyDWOhe1cbGO_tR=ppZd1aC0GSdeMzQjir4XmDRMQ3Jg@mail.gmail.com>
 <64216a90-e2e0-435c-87bc-388c72a702c0@quicinc.com>
 <sajcoh34gyfcvhik3yairil65guvp2rt2xdmbmlpmlcjvst5ci@qojbxhmrnrxj>
 <0d763853-5b1a-433e-9fa1-23ea0184b9bb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d763853-5b1a-433e-9fa1-23ea0184b9bb@quicinc.com>
X-Proofpoint-ORIG-GUID: fEMLLZrtJl5UAxHoiqcKGUurV2Sf7qJe
X-Proofpoint-GUID: fEMLLZrtJl5UAxHoiqcKGUurV2Sf7qJe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5NSBTYWx0ZWRfX6AeQmxE6bnet yT+84USWF6Eqrh3BvUac/iQqMkI3RuIe0GCDI7HcOHDEB3DvbUDFFuTcpPbuJkiLwrHDR4O4amt tWWlJeKzG60wE8P5/IhxpKpXa1LW/fzlsujU3FrDSIxtAK6UXgxf8DpIAe5J6BjZ3A+MkVDqiuZ
 7a8S7m8LfPPpKEHPnM+mSe9nVYPa475tREMWISL/AOJodQ3jBnZ4mUrhGgZWoM1ZkdwXBz4x8mR GXyKe2LbzwUeawZs3Wtj4iGHk9L+dZ+zTFeM/umXXRIvXsNvwplX6Ik4g48OMWwZWxiMwmIMEhD rZAqJv8sH78P+40mGRjMQsWbVxpH3z8f/LvUpCvv1vdVN0NFeFRA9//ZsOgJ8OYhCLJ6V8Nq6lH
 D5XCfpCa2gf+kEUZbc+Q0sKFxtJj4YHFDKGWd2Z41iA5qsh1UPTXoR92Vy9caBGGUXcpctSS
X-Authority-Analysis: v=2.4 cv=Mepsu4/f c=1 sm=1 tr=0 ts=6808ec85 cx=c_pps a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=aCPLThnsKnsU9gi7CwAA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230095

On Sun, Apr 20, 2025 at 01:38:40AM +0530, Nitin Rawat wrote:
> 
> 
> On 4/14/2025 1:13 PM, Dmitry Baryshkov wrote:
> > On Mon, Apr 14, 2025 at 12:58:48PM +0530, Nitin Rawat wrote:
> > > 
> > > 
> > > On 4/11/2025 4:26 PM, Dmitry Baryshkov wrote:
> > > > On Fri, 11 Apr 2025 at 13:42, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
> > > > > 
> > > > > 
> > > > > 
> > > > > On 4/11/2025 1:39 AM, Dmitry Baryshkov wrote:
> > > > > > On Thu, Apr 10, 2025 at 02:30:58PM +0530, Nitin Rawat wrote:
> > > > > > > Simplify the qcom ufs phy driver by inlining qmp_ufs_com_init() into
> > > > > > > qmp_ufs_power_on(). This change removes unnecessary function calls and
> > > > > > > ensures that the initialization logic is directly within the power-on
> > > > > > > routine, maintaining the same functionality.
> > > > > > 
> > > > > > Which problem is this patch trying to solve?
> > > > > 
> > > > > Hi Dmitry,
> > > > > 
> > > > > As part of the patch, I simplified the code by moving qmp_ufs_com_init
> > > > > inline to qmp_ufs_power_on, since qmp_ufs_power_on was merely calling
> > > > > qmp_ufs_com_init. This change eliminates unnecessary function call.
> > > > 
> > > > You again are describing what you did. Please start by stating the
> > > > problem or the issue.
> > > > 
> > > > > 
> > > Hi Dmitry,
> > > 
> > > Sure, will update the commit with "problem" first in the next patchset when
> > > I post.
> > 
> > Before posting the next iteration, maybe you can respond inline? It well
> > might be that there is no problem to solve.a
> 
> Hi Dmitry,
> 
> Apologies for late reply , I just realized I missed responding to your
> comment on this patch.
> 
> 
> There is no functional "problem" here.
> ===================================================================
> The qmp_ufs_power_on() function acts as a wrapper, solely invoking
> qmp_ufs_com_init(). Additionally, the code within qmp_ufs_com_init() does
> not correspond well with its name.
> 
> Therefore, to enhance the readability and eliminate unnecessary function
> call inline qmp_ufs_com_init() into qmp_ufs_power_on().
> 
> There is no change to the functionality.
> ==================================================================
> 
> 
> I agree with you that there isn't a significant issue here. If you insist,
> I'm okay with skipping this patch. Let me know your thoughts.


Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>



-- 
With best wishes
Dmitry
