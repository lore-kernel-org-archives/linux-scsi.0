Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8563F28B40E
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633548; cv=none; b=kI0m9Fdy8GQuFVXvaSY11OVpW2cmJZPX/LvVNlds8qnq/n6WLUa07BOOk2LPT7oykH7T7007T1bN8361sl1g1yI+teGYJ0rDs9MgQVnP2LVVg3p51OnqLP1ugiJOTSzQChrqAbD/N50vdcA3o3E0q5mGfAhuLSZWdnYqDpDNLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633548; c=relaxed/simple;
	bh=uJiTss216tj35hO21nzm2DdORL7T0scejeEGhLf33tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIQ86Z2spbR7H+HnJrg0al9gnm+p+ngHHEW8GdIwjtnfYPZ5eD91/GnBYjxtHkfwQEQFwVFNNSabwxj6IxF1xHIXArfjPZJFcpJzrN9MDI2aJdM7SZoo5R2liNxTioG8Uav/qELdX7EfDa3pmRPHbAUuRAkZTgdrCpxMfw9RAN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nkNbB2vp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cCOgTnl1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nkNbB2vp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cCOgTnl1"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AK4pmHw3844005
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=5h56Xl7jBbfNLpxMcj+k1KtA
	eCsdY4WCnSjsoFyS1dY=; b=nkNbB2vp/Kc2fh5zE6HrmicvDZAS7G9O903so7vx
	Ij1YhriM0lyy1ArWILyXNMSsByenzNRT3fTeKwpfvynI2LSVcqiXN9MSRlBNfs98
	41SsuZuy2p1s9sIJUSQ7l8ERMt0BtjXr/MykFLrzNH3XciiXqcTNEVGIaPOsjkbG
	VxzprJZ+8YjuUNC55gGnNoIEoNDJVONF33Av+T0foiCQRQC+iJaXs/ljAj9mo0Pb
	lmmn5e6RyPFTJq8HqndgL1HLaR10MSmxv6SIHq0vzglP66BPw4NjoPCes507mZmH
	x5VCKLp2TSiIn3y7VdLYzZ8juQic67tOj4kuUiFgw3qx4w==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ahdpr3nyg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 10:12:25 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-297e66542afso29858845ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 02:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763633545; x=1764238345; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5h56Xl7jBbfNLpxMcj+k1KtAeCsdY4WCnSjsoFyS1dY=;
        b=cCOgTnl14lAQXfvtdVIkX052Ggc6BQ0E2lxVGHWzCoYZ34PFXW/koFc18RgvvWZtYO
         17c6rXORWJITOHM0XkAjkWUO2pKFWyzhda9NGW0i+HiMPbgkDthFbNB9ht64usEyu0Qk
         UecV4AxccXnlXlGtoTzmxDhn1Nh8lBZjdx7jrGjFh2ma3lqY70CfriRsIcn9lMAv94cV
         S30wPqUuADH0Ho9NojI0HoB8U6u8RVZQJ9UovCGg4e5U+BJew/yrCEo244DYAcG6M+kv
         /G9vnqKWjFd68NjB9ncVmnx1XkqpNYscH8h8qA1llMUuQ72fzVoFl+LCGPlKd4zOWdzy
         e/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633545; x=1764238345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5h56Xl7jBbfNLpxMcj+k1KtAeCsdY4WCnSjsoFyS1dY=;
        b=oPT92PPUDoOdekCUxD3iLVHgwIWPxoY3ECdkmxhT1GutQrHoL1dZDhG7rG6o6keeld
         GOlF8K6nidKi7bXCia4Wjez90HYbtBjO6ZDk7kj6Tuj+SccCer5jvG+4qXSd02mv//Bx
         GPPg5cSwr2F6AdRKCkLw63wEEyWUepIx1E8/FES235G+ISiKB6JxKMYqLoQAzGMbikal
         kZYt+D01Nvf5BpN+XjXszXqzCCT4AmCQP/sKhTUYowGk+sBo6qfOurNqmssNplsj3ug3
         77I/MNVsFq7aRYkAKtII0OqmHBCzEALXg4HNoleA254+lmV7fDvg9rfvsAI66iVG3OPB
         rBOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuB6ZmWYfc7+tNPsU1+IZY0pwGgGY38Lr0f/yqdvc8JfpBwEGSyzipmJSGFuk+3/J9A5pUqiLSWhqP@vger.kernel.org
X-Gm-Message-State: AOJu0YxuGkyNjfoi0nQCQOCPrMemuWe2L/DUR+xxQh+Nhju2pEX5Ynay
	1NtWJjDxkVs9Wk0c3WTj9DHO6mtbXRA3rTVR5u2Du7VlmSe8NFWNsusK3HcEjJO6jtktFzTAxe2
	qojpGrjp7axfjeo43ZHQEMAHOa7Q7gs6W38qUlrMuoF23yguBDPntkajk+ynDlU6e
X-Gm-Gg: ASbGnctO4DuLSw9YgEPhZU8ONSxXIlD63vQWEtC/B3Oa86gJymvfLlW50veg2EwiDSh
	JhziMGdJlw7o+/I5gI0Uxaj1vKL5P3WVjCbOnESDYE3Gp00zEYH+GXYKatgsfhLMe7e9KMumHvW
	BuS3TmnCUTQiQplxb0SEVn+0Nvh629+wbnlYxAzwgZ1DZL2vhwiW9P9/5MMD2nRBrD82AZDQ8DP
	GRHHZQaJl9SRAtHmaFTSxQcjfNhPyFF+uRjX9SSHgGmx0XiFLlL24eiM1oaYZgWSozjdSJVZufV
	DhESeerBan4+I7GPXV0fji21ejxiLXJo4e6OvfOb7iLzSljlxNQgZ/jC/VRFlId6kVFlZb2eUix
	oDbe9ko4IVaKiALG4Dnog8YSj5D7Ejo3WYT8edkm2/ojsKcw=
X-Received: by 2002:a17:902:e946:b0:295:557e:7465 with SMTP id d9443c01a7336-29b5b03b266mr35827585ad.11.1763633545118;
        Thu, 20 Nov 2025 02:12:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUmayQ2Ds6XylcNVxol1fw6gXfR7p++D9gSz9gVy8RGIfcHt3ITm1Ym1V/MQdIj7+2Qy65Jg==
X-Received: by 2002:a17:902:e946:b0:295:557e:7465 with SMTP id d9443c01a7336-29b5b03b266mr35827205ad.11.1763633544690;
        Thu, 20 Nov 2025 02:12:24 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b2af124sm21627695ad.96.2025.11.20.02.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 02:12:24 -0800 (PST)
Date: Thu, 20 Nov 2025 15:42:19 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] soc: qcom: ice: enable ICE clock scaling API
Message-ID: <aR7pg7shC32YD2n7@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-1-ec956160b696@oss.qualcomm.com>
 <a2c3eeec-b3ae-466e-b289-991b8658aaf1@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2c3eeec-b3ae-466e-b289-991b8658aaf1@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=Uq5u9uwB c=1 sm=1 tr=0 ts=691ee989 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=RuRDBZkFBo0teaAQglwA:9
 a=CjuIK1q_8ugA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIwMDA2MSBTYWx0ZWRfX75c/tx4XPpqB
 dvCGM2jYPVA2Pq4q04uPrQl6GPTJCfqVy25UB62MKfeA5FspLSzVZ+ZZTA/zuBDTsoCoq6+OoRg
 gOQpRwi1Bdht/CLREsBBlxxHkiNcp1XR33UfXaBkDZVtWwavPdVeiGN4t2hyi0GfL2aDOMrtINJ
 43DQ7bl5ein9Vnilc9y7pimBfkItkj5VvVOO9btd2hFOydy6Ib9N2BrE2DdTCkpf/C5S5EBZ88T
 nn7hs68YM7rGAuM5pYJniO65WLGOJvAhKVExOqh+fE15r5RjOkSvKY0Hb2K8z9zIGCu9h8xExvf
 EjJJbMvkzOCYgizCfP2h1owsog7lLZDEKSrPldKgLaU+qW8u+itPYbWIPxVR7/GBoRCbNgBAV0r
 VeiBBmBk9pvGzONoy0kNeYcfTcjqJw==
X-Proofpoint-ORIG-GUID: 9Y6Vf8v4tu2Um-5Fso6uCIW0Uc_JHyRp
X-Proofpoint-GUID: 9Y6Vf8v4tu2Um-5Fso6uCIW0Uc_JHyRp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511200061

On Mon, Oct 06, 2025 at 12:14:57PM +0200, Konrad Dybcio wrote:
> On 10/1/25 1:38 PM, Abhinaba Rakshit wrote:
> > Add ICE clock scaling API based on the parsed clk supported
> > frequencies from dt entry.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> 
> [...]
> 
> > +	prop = of_get_property(dev->of_node, "freq-table-hz", &len);
> > +	if (!prop || len < 2 * sizeof(uint32_t)) {
> > +		dev_err(dev, "Freq-hz property not found or invalid length\n");
> > +	} else {
> > +		engine->min_freq = be32_to_cpu(prop[0]);
> > +		engine->max_freq = be32_to_cpu(prop[1]);
> > +	}
> 
> As I suggested in <fca8355e-9b34-4df1-a7e6-459bdad8b1ff@oss.qualcomm.com>,
> you should really use an OPP table if you want to do any sort of clock
> scaling here.
> 
> There are then nice APIs associated with that construct that won't make
> you pull your hair out..

Sure, will move the solution to patchset v2.

> 
> Konrad
