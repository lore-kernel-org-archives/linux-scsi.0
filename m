Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C944C2DC79D
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762929350; cv=none; b=kokMGkGlWEeQmX7Um3rRsUnpH4y5wn7bFTRW2WKMAxZxYot+L/fEcEdBydF6rmQ48pjFickZzNHYwV/UlbWpl45ntbQcQVtS0WT6e8lrPjl6/gzTTktgBr93KV6LKXL5DAnKDc7gfSb7fIq+pxMdPipETXxw17rL97fvtjWk8/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762929350; c=relaxed/simple;
	bh=iHNbur1CgPu9EMbbpr1oIxjrkDUOkh1go5m1xX4q/8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsihJIcfww1cw3JQDx0bTF5RVwC8BmuoEVXz+POL0ze04Vp0m+S8vTfB8oCSKGEeGc5j38p9r+MHkgGzfAGnf9nCFVaGoOQalePZFU+125YSEYufImfPrYnpYd/iLT7oRm7chhzm7eYXQqy3vv4uBETAfbHqh4N0KmiaqQtYs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PjUveni1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E7znkbji; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PjUveni1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E7znkbji"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AC6HuQ1317193
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iEFXFi5trTxomRGsS7gEFHXX8gbfIDxo43cEy1pNfI0=; b=PjUveni14tOQgjUq
	TdUk7WXuyNPIVnRtvQcMvOoYLtM05b+VwEjKuJFP4b3KdXKXEl9tXgKanhjXbIbE
	0uyJVyTqkGgWqRPJzOIwY5aVtjM2U0jsDXMxv/KTZAcsI5IdYLJegrFZUvJZACtp
	fOIsYaeSBvfjy6G3hWRaHXwhzxvTeCRNNuhxdLghui/fsHFSiSSswt/Q71GbaH4L
	kjV4PvWP4Y7s0EuUNbFIPl+WYqOUeg2u24spHDxRDddhZ/ygcr0fDjC/O9KmFyVe
	Z6Mgr6N0r/xaX9KIxg0M9wXirapBhIQBuFugevnWnV52kmijmbw22f4xGo79lNXw
	sbJHXA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4acmumg1nk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:35:48 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297e5a18652so6321365ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 22:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1762929347; x=1763534147; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iEFXFi5trTxomRGsS7gEFHXX8gbfIDxo43cEy1pNfI0=;
        b=E7znkbji9uQvyZBasrBQvXo8dnxoyYW4F+j0fS4m3y4zWL3xL1qVCswirGCx19LK1e
         N3VlIYih9uXqE9kMoLRK3IwnqbHGvhNgjSdUnDMD0w+4eXxPDkUbm0jskO7nN7AGfQUv
         i+c3tjiUlfGrHakXXvFRxTFnl75NUh+NQVbKgMUzVfB25Rx2sdXPRJ9rgv7oRdhpRIKV
         aj02cHXfoXXdoP2dJHLNYynOqiNl5ZZzomtweJEfsrPQCzW5w4TX9hEa/oU9fA93ONI5
         TVtvtFG+1Q/TG/z/qwjLFa7uoKU3/7HJhl1501N9iqFNHZaZMkE9jd2wFQY+WV4ry0du
         Zp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762929347; x=1763534147;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iEFXFi5trTxomRGsS7gEFHXX8gbfIDxo43cEy1pNfI0=;
        b=SjBbuYPwXFifEvTLWIzH0MNDGqVIJuVM5XrcPcHrowKEwsM3oz2bjYT4QMApUrp8kV
         PqwwBcHVetTeKuYgKojH332yG4QsrtFhY4xNaw1GgCyyyCty6qRtXMI/3zDVy5vP5BYv
         iYOhMNJ4xDFlu70ixaogKaoCOvLVWlRiXmmyu5ih4Vd60Wk8OC5jUrJYGefWuxvgI+qU
         0MalKSHZqYvc2wEW6XPD2mi4D7kzg96DeRSD9rFPVGzBJsazgpsiWgUk12jAUJVODAVe
         xxekBr9gMv1ItKgr6BZGZHrCgJ5GkCE790+pFPveMj/qh2u8J/7ZsOd+FNEPrMpUYHGh
         vjWw==
X-Forwarded-Encrypted: i=1; AJvYcCUhZx0CioiWfT8PRUPi6nDbG+JPXBBNnpKl8YcMHFojAYXe9dHtW/e6FQ5MgvuPEAY/kmk8F/se/esb@vger.kernel.org
X-Gm-Message-State: AOJu0YxylrFQZvhwRrG32aE+MEM0ywGzXX6cHDp0hHigOXJigmKQ9h/w
	dg4Bd4KUwhRXgobxWBVbI+k3BcjPrgM85NSPwZxizQ14NTQcdbxRbeTw6AzEMRnbKU4uIOaG2d4
	rRSwOhQe7mHgXU/JibIMYBXjRjMoLlvGvi6GqbbCSgcvmXK7WvLbfn2GoqjovQH3h
X-Gm-Gg: ASbGncv/EDrmxBLNMcpzgy4f3XANr27jPeC8ZZt5bI6jQkdK4G9VRwXnYxu508yoKc9
	E8h70hK7HCvUqiAhuHm72Z29JswCjiX2V5PxT86MXbkQI3IikdEKysxJHTQPwQqXfPlBz+Zd2s8
	JjnR1pWmXD7qJD3y5SwYFLoPrnq3ixD/EyinsIij0zFGpMzcVkKeYsiyMfOauQ0wX4Fu2GR9HbS
	6Yla7FqBYl8lgfKjTXRbwnfKt5a8PwUFNEYSCYv8B2DzSD+N3Awghzt9pmixrOzkcRbLUDeHjXy
	uaColi98SO8EK1JUYZsj+OyfodXzC6l6oP1Qmnfw81VlLugTsnFWLbMi21uFSnHb76putYvWOHJ
	rlV49N58H7jdfv0AaFRNs0Yxb8qwRgqVC4lP9
X-Received: by 2002:a17:903:2f88:b0:295:557e:746a with SMTP id d9443c01a7336-2984ed34126mr22611405ad.13.1762929347279;
        Tue, 11 Nov 2025 22:35:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBwTkfpC11yPeikWLPdn9cJivKbZakW5wxhoCWISx28xcRHZjpVs5bJWxOlZmoKbf+AA/WdQ==
X-Received: by 2002:a17:903:2f88:b0:295:557e:746a with SMTP id d9443c01a7336-2984ed34126mr22611105ad.13.1762929346761;
        Tue, 11 Nov 2025 22:35:46 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dbd8ed3sm18403175ad.15.2025.11.11.22.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:35:46 -0800 (PST)
Date: Wed, 12 Nov 2025 12:05:41 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Enable UFS ICE clock scaling
Message-ID: <aRQqvbn6cuTBde5u@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <iy6ls7c2bjnzpfcuact4vd5fba7phmng2vlhzaxxix6hlevjbz@gnva4h2d4vsm>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <iy6ls7c2bjnzpfcuact4vd5fba7phmng2vlhzaxxix6hlevjbz@gnva4h2d4vsm>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA1MCBTYWx0ZWRfX6AOdUypytDnr
 H0kis0ljG65vqvG98KTYrlU6uw818bl+gndnd2XFkm+Bj7nc9yd1nl9DaZMuCW/2cwhcXKOzQ6i
 /U0f1qXOj3K8QQqiTp6dC8Y6e5WQf6/xeIvHOl5NYKeboPyfMacz8m3Rgn+NdcT/k8bgryYunC3
 A629aUtO+RcmabScGnMvmMpmEX21Q8sWbpvXj6OQF4LEZKMxNtDPz5J3ZSwdWyoaFqT7kfomj1o
 TNcy42tzCntJ9CCStb6AA/yqYenIgtdmpk560BjmrwyvnsTeIE7BepKOIHs7TFWGfnPdYTSbUa8
 1Wdui7mutBE2l0tQtUuh5ZUdoYtF7kkvXBdUJVp60LViKPJwXUfRy3rrFET6+DNfcx8ACmh/qD8
 qf3G2glWD92Y5t0A7EJv9u6OdYNrvQ==
X-Proofpoint-ORIG-GUID: hZ5563vKDI7PhHYxWoferX6kpsG8la0Q
X-Authority-Analysis: v=2.4 cv=dZONHHXe c=1 sm=1 tr=0 ts=69142ac4 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=gthY3zcKJWpGDLxpuiMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: hZ5563vKDI7PhHYxWoferX6kpsG8la0Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_02,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511120050

On Fri, Oct 03, 2025 at 10:18:15PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Oct 01, 2025 at 05:08:18PM +0530, Abhinaba Rakshit wrote:
> > This API enables dynamic scaling of the ICE (Inline Crypto Engine) clock,
> 
> Which API?

Will keep it more specific and update in patchset v2.

> 
> > which is tightly integrated with the host controller. It is invoked by the UFS 
> > host controller driver in response to clock scaling requests, ensuring
> > coordination between ICE and the host controller.
> > 
> > This API helps prevent degradation in storage read/write KPIs,
> > maintaining consistent I/O throughput performance.
> 
> I'd expect clock scaling to save some power, than 'preventing degradation in
> performance'.

The solution should achieve both objectives: maintaining functionality while
dynamically downscaling the clock during periods of low read/write activity to
reduce power consumption.
Will update with more details in patchset v2.

> 
> > 
> > The implementation has been tested using tiotest to verify that enabling ICE
> > does not negatively impact host controller I/O performance during
> > read/write operations.
> > 
> 
> On which platform?

Currently we have tested on Kodiak and Talos, with additional device-tree changes.
Will also update the tests details better in patchset v2.

> 
> - Mani
> 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> > Abhinaba Rakshit (2):
> >       soc: qcom: ice: enable ICE clock scaling API
> >       ufs: host: scale ICE clock
> > 
> >  drivers/soc/qcom/ice.c      | 25 +++++++++++++++++++++++++
> >  drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
> >  include/soc/qcom/ice.h      |  1 +
> >  3 files changed, 40 insertions(+)
> > ---
> > base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
> > change-id: 20251001-enable-ufs-ice-clock-scaling-9c55598295f6
> > 
> > Best regards,
> > -- 
> > Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > 
> 
> -- 
> மணிவண்ணன் சதாசிவம்
