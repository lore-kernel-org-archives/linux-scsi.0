Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BF331578E
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767182145; cv=none; b=JbFvpGGJbLNnfb7NHjKdpxCVFPdmGiBwj9tmQhZ+iNJyqraSVqdAMQE8nwzP0/WfRv5T8imvovY/yfnLffjFhJDXApQDBj+gt0W8HezEG6ZNIyFFts4/gjDxD+Y8vGasxqKtFVD9Ha5gfwkS4QvjgmDyBID5i45Xok2paQzA05A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767182145; c=relaxed/simple;
	bh=26ZCebUf1Nu15xC7Mxv8B9cg4rTzsV8UwyCpMlmipM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGxLymOV0iin3kIuMtneZI1sAoYU0ZIrhWz8KCzIze4pb163eJ3tBMK/BGBrYfmTO3mWDC2j2D77EopmXKzXk406JitZQXpOwmpJJYUpZvjV5EHNUqYLLZJyqRFOKJczYUB/2Ovcj571iIQCcAWuyVJf1PPYMAOQU4WFz88kq50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dqDw7voi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WYnUqkVU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dqDw7voi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WYnUqkVU"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV3dPQ71830431
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mZtHDvv9a/Lx6wm1a7+DDrNkrtZyN0d2dr5ef8ynUaE=; b=dqDw7voieUyWUY1K
	cP+l7X811toMTHk3NGsD/p4B3Sj6KO03LpOFP3A+VE2n22PftpRUOM6Q6hBPTR3F
	VNI1k1oWs91qS+y5Tdmd0Q8ME55U2sHLKDYvOAWyvUVmvYpyPHo/fR+F5QT/Dx3n
	PTjbMv7q6d4jv4ndgNod3MdybK6aaTSYOjW8kgfHOhrafm2FSJFz1nJKhSjAfQBh
	GIsP+CWFMTGHm7gOibObuFV+Q9T9RgBucTm3EVcGG1X1d3hbcHl5kOuYizRbg1Bb
	E87miiS2F3nVYLFaLaFanwJv2p0NeeoTlxEVIG3ABRk7+1fHO/UBU7jBVA4V1aAu
	n5WK2A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcv4agt57-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 11:55:43 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ee05927208so47678351cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 03:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767182143; x=1767786943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZtHDvv9a/Lx6wm1a7+DDrNkrtZyN0d2dr5ef8ynUaE=;
        b=WYnUqkVUlIlqo39OD3ghwnrvbT2BJJqyL8d16HGTEbEY79PxB8HHeqA0wU0N/pKOj+
         N5G68rV1tc7uyi1yacM4N0c40kzRLPFXTwooTSO/pH8hnuCMmmtgXjuN3jkh/Z81nJgy
         Ts8JmiWzRXxJIC9XWaFcY2b1NvXwalxHR/H/8oRbPxsuwERlZ+NmgCJefGmywAoS94wF
         dJYmDQhah6Jb7NnGdjKJkbQCcg2+MqWvdngf75Z4lNQYG+qFchUZ08D4Pv866o+Fa46d
         Yhj/VhDI9lNdgIRWPNeKw0Ivx6S95rSSmcOICw2tsgoZ4W/mS9cqcyS+wd97aS+jS1Qc
         +A5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767182143; x=1767786943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZtHDvv9a/Lx6wm1a7+DDrNkrtZyN0d2dr5ef8ynUaE=;
        b=I0m5gD/L+qb+BkR7EMjDwP4kHXcyGmSiueDYTYHNC8wk4QZog4Li54/1O4+Q+fXT5w
         JynXG5cC3GW60WagTpwl6L/5LaVsrwbxwOjFdPlf6eIlqEhM9bakm/+0cJHD/nfMVfZq
         Rs1BmMTG+lvJErS030jcxBTkhVHGqDzsYFC3ZpeC2vgoryUMDenGF9sQq++Uzb5ExFVQ
         T8pybTdNrQmxwFY36MSOj4Vo6boyIhyKOy+TSdu23gugp3NDLALhjYrwBNNy9wuEzzcM
         hHhple6cN3Hh1jHebKORbS19cZakuP07OSlgLOQb1xkhkZGkz2Y/4fV9LQReqH79weIW
         2atg==
X-Forwarded-Encrypted: i=1; AJvYcCU8iPOI5EbCQhnwTpv5apDLQ/s29DqCJvwuPKA2NPO3u4lvQOIcVVme7hH/bi+bvJZtoJEtKddFAcz7@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh8e00e5OIy80M4vLg8Oor5ZrwziluebYIenmsU2oN28CF9RBK
	9RAvhtjVuH0TPzw5clLSNTwP1Oa2krQVLkEz85v/hm+9mT41tSPEkOZEnPW5JAT3Hs3srhJUetr
	tpdFZCTtasBoE65UMXFgD2hD2S9IhBc3T6XRBIy5lhe5hhL3mgKwPcxQSkKO7KwYZ
X-Gm-Gg: AY/fxX5YxbB8mwIEqwxdu0tltx0KiDjKq97baM8vREwJtcWCRImmd0+UJbfAfeo40Cc
	3JjW01nf00IipTyusj5LXa+pspTBezAQdMJYueAkS6mOKaT/+DCMgQwwkBiVvdWLytyq7r6C4M+
	eTJbNdLkLmS1mmytJ05u+A678pknQAHH30aEUdRVD7lU0tMqqTEc9rIl8cULoUHHvefq1SXrs9D
	UuMOpba4ncOmBaLksjQk9y1sqCENAEpxraslXIjiNIVPQbY5BJASNt1sr1gI9TrLvjUnkyC3U7M
	WUH267Op3nYc4siIryd8v6oUU9ciCiVjwZ8brE/4NKaiwFAOKNciP5ISYLwHx6YR740Hx8EDe95
	qkZGgaMSCe5UWNY/hnvTQBrTGsUUYZEJtsRPgz0VCtdlePttiLYvFcmM9pPsXJ4XQWQ==
X-Received: by 2002:ac8:66c7:0:b0:4f4:b373:ebf with SMTP id d75a77b69052e-4f4b3730f72mr283982221cf.8.1767182142885;
        Wed, 31 Dec 2025 03:55:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOvZSDvJ5tWhebJaz+nD2zV9fr+3lvFxOjJPyUKgMXYAXQDj6ZhM1nsqD5NZ3p75eeUOyj/w==
X-Received: by 2002:ac8:66c7:0:b0:4f4:b373:ebf with SMTP id d75a77b69052e-4f4b3730f72mr283982021cf.8.1767182142516;
        Wed, 31 Dec 2025 03:55:42 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9105a9c4sm37947767a12.12.2025.12.31.03.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 03:55:41 -0800 (PST)
Message-ID: <4e480e00-c112-4425-a5c3-bcae444846db@oss.qualcomm.com>
Date: Wed, 31 Dec 2025 12:55:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: O7_EqVIMCsY9SnKpWmwQqgbRUrAde2Zf
X-Authority-Analysis: v=2.4 cv=Ps6ergM3 c=1 sm=1 tr=0 ts=69550f3f cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=ZKaqVTGohnnJfaf7M5wA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDEwNSBTYWx0ZWRfXxCIxYsMxd9Ez
 MDc50VrdDgzn1sMXk9htju13kaAp4JF3W38IYOxlQxgiVObopWHPDyj6jkQ3EAkM830+YuTUgU7
 6lujPd/r0f7uXLcqLPyq63PMemDuAax3Zqc8DGY8PXHSsUs/bxf8zm8KQ6fKM7Uu9CfMkENWZ/9
 fsW8jvQ1tqHvGa6TUTmuF2P+TYoJ6TOUbkrI86ppSkFz88PTn6PbKqcdrR19FsjoKuSqf+AhHLa
 3EIXnVZYFrF+yva6PpesVFRh9w+iixEWDOyvsUP/jNbNtk7fue3NkFOnE8kyf7eiAGNr8MymSUQ
 d/mvZatDuzH/sVWMFyNlNdFx33ZxN50wERdQ31vrTF6lMZacCK8LQPKy5faMW0uhnKW9THpFY9O
 XPPS8KY8ozUUtwrRe2yXbCq04fQI4gAtIw1QqIyk+5qGNH5lznhaYigcpVhobAPK8PZ2GlEhAP0
 iYHaYzseNzciH2kDz0w==
X-Proofpoint-GUID: O7_EqVIMCsY9SnKpWmwQqgbRUrAde2Zf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310105

On 12/31/25 11:19 AM, Pradeep P V K wrote:
> Add UFS host controller and PHY nodes for x1e80100 SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
