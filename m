Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D26470EBC
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393802; cv=none; b=XGcjDxLZkPKyh2xKTFq/k0/s0u518FQ7G50GbDOMzg0IdoOlDlms3MYsSi0BCTyppwvH2QOVZTzHHmsBjk5o1glA32dZt/XH2H7ODsm4ZArK1VB2RpFJQpKTGxMq0AxrUxb1S3wfMVUpwWSaO1eTuVWoDu8sMuuGlmriCrDMBYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393802; c=relaxed/simple;
	bh=UT06poTznfl8ZTAhUcuyx70LEC/HCesL6yPpBlRCnyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JDu5A5hPXlt6horXaRNW/St3brmDsuAtUgxo2ERrbD2IlaKcuA/6jfYacagXS13cVpQ2lk0N9PQ2Lpd3UBMizurmSwpPF8Fl6lV4S989c8nucaiLmEKqd8YiEdWfCRCenKcfrD00iVgIQ4xjChKaP5bkgVMmT3NVA2LIdVafwPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SF1vugy6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=clyTa6G4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SF1vugy6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="clyTa6G4"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED0Q1u674431
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 13:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p0xQVh0vFCjxQwxfnwMIlrQY8/y+VhxDPksoF/C8V6E=; b=SF1vugy6tmxJ9Hb3
	/FBZDLS+4cz7nDXWp1+crGENkhyjij95AdcMLf/rFo8zeXbBVavHGJvBWO6ZlRGa
	sTxJIBwuvKbhzK8Fai+hdLeQpX36RNOdlBbmP9Iwaw71Pe82kEZjyuex9SDZYo7h
	YE62YjGxmLa/kUEaTU8Rqf+dOtXobfFfL2qCniywySt4ktcgriRDKTNEoooHHdbF
	mXwQWtWU+MFmQBj7NeK1DXGEh+fYXbtk6yGMNmollv9EXrgC2Eq582ZpmX6/BLjB
	D0U7eqyZVEvBPfWqFlUhX/CelJT3zX/ys8qTycl4noDf1sA9hf7Z+Uqnugw1C2Dq
	q1Zi6Q==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpecs8yh3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 13:50:00 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c82b318a06so42717e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 06:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789393799; x=1789998599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p0xQVh0vFCjxQwxfnwMIlrQY8/y+VhxDPksoF/C8V6E=;
        b=clyTa6G41OmcgVz+BoTYkkRar1ffIRCGqepWY1Uxc+jLauYZ7cGTHER7eetIUrpP+c
         CJ+St2Zu8VbvU4Jsww6rcOlsnzuGI7qVyZFMkxlbDMYqjWIqn77IqH4RgJbfqMt8J37o
         3sejXNeoPsaRjjz/Zkme9YnVbMevWayWwnJpVfSpgn+XNFr5xXDudsUcydOdRV2uw9kY
         7NQVI22MmZohz48B6BUbRyH/42DVGLnhFT4T/FpWKlBDhKktDvLjHzJhWyfUCKT5z9F4
         LPhIA9qxhtEyfgL8BQhLatJXSazcUzfwFTF5wRxcjzS48fFFR1VWaeepmOx2NWxbhzMs
         Qbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789393799; x=1789998599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p0xQVh0vFCjxQwxfnwMIlrQY8/y+VhxDPksoF/C8V6E=;
        b=aLRmCzZSM0BIegYnZqsBYSfPiD1QzIoudF0OIr72W6mWYGoZvhKPWS6QmTCs3x0OCt
         IE325SLh8FOis7Qktls/QziUvy3gp2TDo6wpcqe+t6w5a74JbD/WXwH6R8ju9umYxFxu
         UVPdhXfrRYjHItAozt4/8IjHM4Eys8Jl26ZX6fl5FdFSq5ap7SOf/U0zOp3QvuYa6yV0
         ec0O3xVnSiS1pekmxq8ZOejTVfohO8CJ5Zo4iyWDKTqbEiBydP6/zHo/LkYC3e4HOpdO
         B+5y63hSv30HG/bBLv/jhWEMcNs+3Id6qwLn9ri3V8nq9YBWKO3u29jFYNIhnPRjk8s5
         6Hnw==
X-Forwarded-Encrypted: i=1; AKwUvBy6ndiUe2denilQjFlUIWZzdUQSCt2uudpRoHmySWMuSRkHbw2jCZez5MBjpnFKmyCdI9wSaAT+sjim@vger.kernel.org
X-Gm-Message-State: AFuF++kuIdpKRxdMIXauAsWDrsF5qnSuXbmdArYBod7P4VDRPOHw56D1
	3BgrnervxTO5aUsFlPxsZHSZa2Cr9K5HwqHMn8yMcPi5bbNPLxPytKzPlbKaRfIUI6E4jsYsf+W
	YV6F6V3zilcW1FFUeyP8iJ0Et1h01iFiFJ3Ns2+pYfZk1p6vch1SgO/LKfwG29GNv
X-Gm-Gg: AYBFou3o84iJAqeakc/FeuPSkp/EMEUeASEDXWsBsxU/+v52cBMsTEK9s2JE/V5mGb3
	BFnpsUoCIBkWFkOp4luczerprVvsZFS+/DugXgS5TePGYap51eFIhNrwmjHfxxLc+3wBugaGC10
	sfU6RpIacS268iSOXs442PooIis6Az1UZl6anIo+WKdM1/+OMPufF1fuTmlz/1SuKbCrWUuqvyl
	8fzhBrrQh8XzY1zhrv1nM48uLA8lgQluaAAoiFwr9FHT6b5nTq3NLgXsirjToErtZD0vwLp+17l
	WHk0ByR4EXz4oDb+dlXdgJf0Fgx9xAF/QQycKUl4bG859FGrb+vVcAwFQDR5Fc/wTEdf+Xa8ys4
	a4joF/Z0=
X-Received: by 2002:a05:6102:149a:b0:797:576b:a9f with SMTP id ada2fe7eead31-79b5be3a274mr594976137.2.1789393799288;
        Mon, 14 Sep 2026 06:49:59 -0700 (PDT)
X-Received: by 2002:a05:6102:149a:b0:797:576b:a9f with SMTP id ada2fe7eead31-79b5be3a274mr594950137.2.1789393798841;
        Mon, 14 Sep 2026 06:49:58 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660ead51sm440791566b.49.2026.09.14.06.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 06:49:58 -0700 (PDT)
Message-ID: <732f6e8c-d7b9-408b-9bde-7034f73667ce@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 15:49:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] phy: qcom-qmp-ufs: Add Glymur support
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-5-b9fc5e2ee99a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-5-b9fc5e2ee99a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDE5OCBTYWx0ZWRfX5vcB7chCFn+p
 mWKU0xnqsZRlmSTAIucm2TAmNaR6TevCInJ+GUE4E47J+eUoPCrysWgAFeYwcyQn36I5sGWCIjy
 Inu5iJCoP/xk5ZwWhSJg6OFdBKCcAb0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDE5OCBTYWx0ZWRfX3nlyUMoPThjD
 +ue0xhLE69OZMohjhlxq7WtAmISzOzj9eHtzkfMJeJ/QpErj5k/98Lak/DWuGpbAK4tpbUwIx8L
 yKGstSPEorHfUNa4khebdEUFn4oJIQgI9MssKE3h3XZ3Vbc8gs0XCbHzjZJ93C7kNBFtWLxlHEB
 uVSjfgYavNpnz6s6yENNyyimhytq0M7SiPLbkDQ9gd3RliaLSyBu4QsBkkmzdIViw6XmqbWbj1K
 k1SCwugA2ByJfbGuerzsACSbWJC+hsCC4uaahknmcDHA2R/RmIYcjwM7Ov73OGADU373dQYHjcc
 kvTgqCHA0zxisSGlU8A+g7lj2S+kDsS+1ZpRxO0WDGI4V8et9Qx+LFvhxujjPZa+0dd57QW6hnj
 vrmPKpuukuhAg0ju/6nsqv2sjQEj/hlqvVZpBdjinNp2QMQr0Oizg8tHXgJcJi/Bc8tBEcC0+bY
 btDtNiH+TbviaDHjfBw==
X-Proofpoint-GUID: fS3JsU5vpqhMDz_hgtK9QdPUNgBqE2r1
X-Authority-Analysis: v=2.4 cv=b/cncdGx c=1 sm=1 tr=0 ts=6aa7fb88 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=e1BaVoEGz4s6-YW_u0UA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-ORIG-GUID: fS3JsU5vpqhMDz_hgtK9QdPUNgBqE2r1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140198

On 9/11/26 6:47 PM, Pradeep P V K wrote:
> Add the init sequence tables and config for the UFS QMP phy found in
> the Glymur SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---

GPT confirms the sequences are OK and I can see that the 217 mA
load on the regulator also has some confirmation in docs. Not sure
about the other one.

in general:

Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
