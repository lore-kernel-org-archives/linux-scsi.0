Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34B423EA97
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773485301; cv=none; b=X4klIHkBR/WPfviA/cRKj3xJuJbBr9WsPuFjp1ShinP0V7jaIO5OL1ToMIvwd2xvL/fJGVXpVxm3VPCJl4BwkU6847KtyoiYQdwQ4WFOIbW/Oj5PZi+Gw2M/FQNvhftbBYP4V/YZMvdQ8qYj9Eqrs2oePvUYD6tN6QpalHJFqHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773485301; c=relaxed/simple;
	bh=2N9X2blZC11o4gKnQlkQhny4FGpk4E5+hS02ZXPNKuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zo7N2n5ta1GHsSg0dKmMiCUsFy6ABnPsyi6PpdhqvsFhsSeDC7Vvao2f1+ylZzs68SeG4534hx6mUaZtbsg34ldL9+Hss01ngUSe07fIDgCEI94KhMl0W9Uu3EeiPyOtHVSnRX2R1Jp26SGk4YN4eExxzmYGMtS3TGu9lvtks0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HmDNMtal; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MsePc8AA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HmDNMtal";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MsePc8AA"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E4lXYQ2006961
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CTYv1dXFSAG7Ui2x4cGtMMWcIHDnGh1Nk4Vqdo4b774=; b=HmDNMtal7+Xg6p6k
	uI6jIcPugYo8EvDp9/Nz+HPBGOawsx2lL9ZdzTybUylv98x8MdP5sg1DHnQH7u9l
	+aIrZd/mJ5RGDBmJofX6FwhYJk3V9RshVqzU23apu9dYUScvsEOMF2IG6zDc3G7Z
	HKu7/k4H9Gf0wCY3ov++ju4pI5RYG2XEsPy5vD4/vfMrRRyBKzgB3qt8HtWPnAX5
	jtl1VP572UEpnaY+6Crkw0xpoDWmkq/HbCVSHIq+StbMj4BR/bc6vT9ZEjuvMtue
	s3T10qCz40aSA07n8Xt0F0gQ4Hr5jY4hEQ6jgvoBtiV16fUzontVPrWJ5W//zmGg
	5eCivQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw0y7rgku-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 10:48:19 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3598c05c806so3478490a91.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 03:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773485299; x=1774090099; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTYv1dXFSAG7Ui2x4cGtMMWcIHDnGh1Nk4Vqdo4b774=;
        b=MsePc8AAYIPpIeaFK0duWzNBlJcDMVsTfh2IB3RMJ9gg6FPeoFQuJykXyO75VZit/t
         dtOIVNRE3KkI0JvAnwSfTk4GJh8HvtQZT0ulbEx2/dPr+uF8G9GutOVLL2+Fv3wXkNUy
         YD94VzYAbGnDLIZg7kB9efMJFKYbgPVjUTmdm5ZTyrstbabvGdCbwL+BZ04JikU4vJmM
         6ARUFKuLGoRZwitI/BEbOrSWoEMowlZRxemBCtnY8JWANYS6iL3XijIDYmkf7Za3lrff
         a2XKbv7ydZlJ0fkXmG5Fi7id5T+1ffjfdC7v+JTeEuZQeG7vqhm+brw6tL3XxrLXvEpJ
         W+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773485299; x=1774090099;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTYv1dXFSAG7Ui2x4cGtMMWcIHDnGh1Nk4Vqdo4b774=;
        b=EdJOarYgQQahdRel5fkiab9TsGFouxT3gSUTW0p2hl5z0QHkf/2zKdrdR+u9xNCST1
         XP7aKS9bDd7TG66LhVLn1GdmHw2/caNp6z+weiUibZ/7zIkxZ4d8r451gTAqSeYeMOLc
         ARMqltXTKeZdQCDTsVZjlQ37gZhAcSxDnL71VCgAccGGJbojVNOGDJeb/UkKW3jYg8Wu
         5j9u1PZHf1L1TNnUKFR9OY/IIlRXAsVbwmxwYKciTl2ecq+NIAfCoICyUzDAb6duz8tN
         T17JS6cdCzeb5FzV+QXT3HNhNOzNDseuV5Tci5Zbxe3H2j61td47Srj5lmQ2J3JZaE1O
         WL7g==
X-Gm-Message-State: AOJu0YyiezOqilEMwT7alFTbOn+TC8eNwTOczys/JMUg4H54+xvGd7w7
	hghRtUIYX3MqM6eoDyXivfDqDuxcoRwU4kkoJdAeV5SrnxTUrhQbqpPcuEG7Xk/1P3G/10R73k4
	NCu3V4BlMKqLuecvdwHDEdJexXkF7g/2CanrqcwhCN7+3xeAWzUZULsrA90Lyf3yJ
X-Gm-Gg: ATEYQzwTnLw/Gj6V+vbhPutnwx2o6AABLlgOAfevGvb9upzez7MSzDo1kTpOzEIpiMR
	qGKlTbKlbKinUvRzJ0IVu0/MnIl921uw8wX7Uo/u+/XR4LAcrkiWSGKh3o6kYz4oxjl2oOMvirw
	Junom/ePoVbGzmvYJ0jYWdGixFFOQoDeOLt9hJkgveU4JpeYSMskLS2OXa622y/XO01BoNqn4dn
	gJ5iOVzxpI4Fr0xLEl1+oybKwYgVA9ve6cBlTVFM3MuWB/PMf5IsfHVIRMqZVLmlsjY1orqnrSO
	ozp3mfzrMV1XyGloJ/PTpGMk+tWXHeqeaB78LSCNS5KUmnw/qA7bmWuLv4vTv6V59QUgvUfPjx0
	fiSw3/qvq9pEbR/y77LuxR3czwoQu2Jbinl2O7Kx4rEu2yj26bizAh5UFiW/roB3iCclMeN5p9r
	wg5c/mKexBSw==
X-Received: by 2002:a17:90b:4b05:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-35a21efd272mr5787946a91.1.1773485299225;
        Sat, 14 Mar 2026 03:48:19 -0700 (PDT)
X-Received: by 2002:a17:90b:4b05:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-35a21efd272mr5787938a91.1.1773485298771;
        Sat, 14 Mar 2026 03:48:18 -0700 (PDT)
Received: from [10.133.33.24] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a1ac3baf8sm7099399a91.12.2026.03.14.03.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 03:48:18 -0700 (PDT)
Message-ID: <71986394-0ed4-4ae5-afb1-7da4710856e7@oss.qualcomm.com>
Date: Sat, 14 Mar 2026 18:48:15 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] scsi: ufs: Add TX Equalization support for UFS
 5.0
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <d4b09db7-db5c-4d99-afb2-47deffc0cd17@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <d4b09db7-db5c-4d99-afb2-47deffc0cd17@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: W4PAe3am5-YaaJ5CkVsmhznSvsHqp6-S
X-Proofpoint-ORIG-GUID: W4PAe3am5-YaaJ5CkVsmhznSvsHqp6-S
X-Authority-Analysis: v=2.4 cv=D9xK6/Rj c=1 sm=1 tr=0 ts=69b53cf3 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=BTOOqkP4DqQlibgNVLAA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDA4MyBTYWx0ZWRfXzeRYoHQPK6Vq
 pIIBOL9T1ru5eli2/fkuMKDt6kn2vucRKiYtWlOR5Rf7H1W+6viAu5tC2LyZL5wbEMsmXF3dTp9
 bF4OTwjXLoKF6lZK3PaZ98Qtw0t9oZdMsCqP2CZwnfF6xEF7z78MyfXIqaapCPFKDRSuv5eqJ06
 1fyfJGG/jpN0amgdRIxJK/5juPTk805VtYGQNbPeSndF6YL5oSi+Y7Jq7ttv2uJGHGNBJ7YYXeu
 3CkZGS+i7Pm3K7IIeEsk7zvDxH279I1dT0Wql+ZoTl7AHcagHvtKiBMN55PUp1c+VWelzqCRu+C
 MwDeP3ohYWX6Ctw5IoHyqNcPDhiXz8VwBb64vIuQk+5YEBIibKWpqChcp9QtFHNdFWgxtZvOYBc
 p0iHWclcp9Z+ZDv0vTc+YM575AXlzEDqa7bfEYmiTngohPlTxwYVI3UkAbbLaULlquX7yZEuKQa
 Eeh6cfe/E/DU5wrKkug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-14_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603140083

Hi Bart,

On 3/14/2026 5:56 AM, Bart Van Assche wrote:
> On 3/8/26 8:13 AM, Can Guo wrote:
>> The UFS v5.0 and UFSHCI v5.0 standards have published, introducing 
>> support
>
> have -> have been?
>
>> for HS-G6 (23.2 Gbps per lane)
>
> Hmm ... my version of the M-PHY version 6 standard says 46.6 Gbps for
> rate B or about the double of the rate mentioned above (table 11 /
> page 45).
Aha, good catch! I will challenge the same to Claude who helped me draft 
the cover letter.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

