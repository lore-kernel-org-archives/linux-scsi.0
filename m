Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD723AE6FB
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 12:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024314; cv=none; b=dcGBn8qv6bh3kxAb9xaAuyE26WXtQp3w1Hi5SSxudVjqb9wUhfKCP0A/PMKTDwB/ckgdJjnNsLIemzmLk0xDM26PXsBaoIhCVy6NrlBr+rBKn9F2xlSUkbIL5Uu26144KPQ4/tOKPhEPRYLb3XCBreNaSGS13i/LwGOAlhxU1KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024314; c=relaxed/simple;
	bh=rsrJV9JSs10oZW/p2B67CK/bbFR/ySGiAGre+fdGkZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNU2a/4IUvEWJpMIKZx+1rfAr+GUgIIU7ZqnygaZjp5NExDmpE8WQyJCUijoHtnBS5ordEVCJAk0Js3GksPSDELSs29TWP+lBVspObYHw9VX9t0lUg0MTyXds9z1GcINQR2CV4CZh1wRBKUZbhQ0iwKIWwCxMBlghFORj5x/79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S6rBZTr8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kbRyvgBI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S6rBZTr8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kbRyvgBI"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PB3kq51512818
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 12:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=; b=S6rBZTr8Zjxs9Gtn
	UdNivAqShe3BsUS2ZGthhRKo6Jo51V1PnP1JCAk7d4saqZK5WlI39w9QH9rPkMo3
	W0Q4G5NPRIfZqJlLZq+p0SVhIB5sHnJ4Yo1LRLV/3cD0JFrnW/WIKuJcjumN60hN
	PZgaLgDu8eL3CTn7TyFTDb5/5ysOQGpLynTC95ytm8xUEop7ruhoR5xS3SCvMkBC
	myHqwnNMsiIVzjB/+EiXwTDcwoeSzuiBuCSelHaIP/BcDD4eoHpcayV+j9WWCmSU
	xYH5Nym8xhsX/RxK3vLkCicTc9NCplK4yZv9xCRud4osH8uMRXJVdOuyP9fS4A9w
	TEchKQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chyvf099a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 12:58:31 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-824bbce0a44so27627419b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 04:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772024311; x=1772629111; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=;
        b=kbRyvgBIQzWEO+RDMMrPdI/NRQTeWWDTsjyUTU89zl6JCISawB2Shv3W34J7jjJeRs
         WA/biO1gJ4vFSUF44cEOsZO2WTNJc9WRwYdhw8RKIJ6w6AYns9fAAQlQhkuQ9pIWLEuw
         70fSap9EsbKTIRRtlsViVFXHDu4r/C5476btEJcRiIUJqlzxf6AiwNT7jYjM5leGn/sN
         tVXvAXdck2p1QIJhXMNIlWtuStnUPrACjXEYoERX7mi2suu2lXZKifFY2yhpTy2uJkof
         8RgnW6Afmi90QzcXVXcripyPbyFR5qejCxQRIsk5P9mtIofdFiVDIuubuacYyGb2yLYW
         HO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772024311; x=1772629111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=;
        b=Zm86yDj0CBQfO9MFMoD3YdiM0Pmg5Bf7qlo0pwaLwNBQNFcqIyTp63JblvJIPTktfV
         uVZC/wLysT3F2BQhvSjbwuiLsvade/pl8U88Uvmistx14pPIPBf1Z5kCX5RtXPXQBkZa
         FNuY/ErrZNMqaHH1S84EJXYmCGBGOzAocxlYZcu+BI7Md4MJsLP0OR8flHiDiBOxhmhK
         FmegX0OMQo13ILMFHgJAk3lDmlqQlgJrMJlf40GVIgJeqDmvk9g93ouftsX+bD9sQpvM
         5RMNXiMOhEdL/bPF/ElLnT8cC9LTEbGr57FZy18ptUnwS1K46mGYgCd0c8FlaQIepo4W
         lJtw==
X-Forwarded-Encrypted: i=1; AJvYcCWoMQ3JYqZo1VDZT4OgtCvC63Cdd/se8ZFZzfORUbA2TzdPf4SI5L8q1bNNLsESDAGI6rT/zMolWNpr@vger.kernel.org
X-Gm-Message-State: AOJu0YyxePmvTRsmaEIJB3AQMhkKWA7ACHykbI4bWzrBQJYZzerRRWqI
	Zb3OIleltvnbzFo0/H0C+LOHTJ3KMaI9nNQIAMiJ7VQNWHE4utfhe3nso2SxbOhoGmdgbSUAv4U
	2ZBwFbNwRqnjRP8c824OM9pL9bm9HG3nJnQVMpXY9rngN78okRVTeuQVvFF+3kB3U
X-Gm-Gg: ATEYQzy8QgfzBpnpvKGQJklFMLVEu/SjbGnd6GJtbNuc1nT/ACrlD4n2pUQ5KO3PZtU
	h9K9PabvBiZW6XHJd+V6MJAJcBlb9c+vrQpN1CgkkMWoZsbetEBvY3i2UCm6XeWho2ONDSYhZae
	fE59sWn/PLcBHC2/X1rGjfQNO2kvNiUsstxu3hGustGKRWm0BJfKhGrwcmCxk5vTMf1ZAcpRzGy
	f0ujlz5N5nVAqeolZ4Fb0plr/BhHkvVoe/CGi6rUXJmnoCxldrE9LmG8ql7Wcno0C9I014zwtkD
	qngU0AH5+N0ZPak6HhIff7SJr490G/3m3PD1TUt5FjbpXhETtZ2EhzQAj1tV/DUbXcPt+lzIHUl
	576eV/8Wwc7fvjnQetJNldiEmz6Z3wJ+Fy16lGMLGfnQv3+exymizeTiG3d8=
X-Received: by 2002:a05:6a00:4b11:b0:81e:8e66:38d9 with SMTP id d2e1a72fcca58-826da8ee310mr14805875b3a.17.1772024310902;
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
X-Received: by 2002:a05:6a00:4b11:b0:81e:8e66:38d9 with SMTP id d2e1a72fcca58-826da8ee310mr14805844b3a.17.1772024310447;
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8a55d7sm13750737b3a.46.2026.02.25.04.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
Date: Wed, 25 Feb 2026 18:28:22 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Message-ID: <aZ7x7gG0OZEQSKVy@hu-arakshit-hyd.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
 <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
X-Proofpoint-ORIG-GUID: cqKKomZO8DTPNz29E2AqQPPgSai7Xkqk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDEyNSBTYWx0ZWRfXx7dVs7mzCYLA
 9CM/uNByz2kpttwVvU6rfUaiGIzv1+rRJrOVrZQrlzoV1sSeN3hb2SC3eTjHcQXHBktztGWeYWI
 cLYiy5DLR5n9b15ha6KbHJDy4BCHrDp5Hmhgu9alkx7DYpDoRRxhhM1awwHCgg7NqgJIR9uVtRL
 pDIjMGJHWyOQOsTrLVZxlAw8L3jv/rfwsv5kTi9KABsYTwC6ImKz2/oqLvyOue8PXjVRLrxF5c9
 zjiB4n7xgCTvHEqagePKGfjQZVa49RvXiKcYLJjMDvf2fUZFHtjXuoaJdN2tu3bKiEhYRGnZy4C
 e2q4Eun8LgaH4bNTElNjHZdpGujvSLPdnE1mrfIIRVMa3hnpkhgi7c+khQrgntWN8+f5jXy5Nkz
 BcUGx3Gt+Z3vl6uPDefsyXrM1A9QDGikm5NxeXi+F7JX8nji40znYOHaFRZgMLFl/xfoUP4Y24Y
 Gk/kyZgPQupSLoIxDoA==
X-Proofpoint-GUID: cqKKomZO8DTPNz29E2AqQPPgSai7Xkqk
X-Authority-Analysis: v=2.4 cv=dZWNHHXe c=1 sm=1 tr=0 ts=699ef1f8 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=p40s0NTFcljArWS5TpEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602250125

On Wed, Feb 25, 2026 at 10:00:12AM +0100, Krzysztof Kozlowski wrote:
> On 19/02/2026 10:39, Abhinaba Rakshit wrote:
> > Implement ICE (Inline Crypto Engine) clock scaling in sync with
> > UFS controller clock scaling. This ensures that the ICE operates at
> > an appropriate frequency when the UFS clocks are scaled up or down,
> > improving performance and maintaining stability for crypto operations.
> > 
> > Incase of OPP scaling is not supported by ICE, ensure to not prevent
> > devfreq for UFS, as ICE OPP-table is optional.
> > 
> > Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
> 
> 
> SCSI/UFS is not respecting subsystem boundaries, thus you must not
> combine multiple subsystem when targeting UFS.
> 
> Please split your patches.

Sorry, if I fail to understand the context here.
This patch-series is already split into 4 patches based on the subsystem.

If the concern is the UFS patch mixing subsystem explanations,
I can refine the commit message.

Otherwise, if you expect the UFS patch to be sent as a separate patch-series,
please let me know — though I feel these patches are more appropriate to
land together as they are quite related.

Abhinaba Rakshit
