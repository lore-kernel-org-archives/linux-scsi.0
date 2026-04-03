Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4753B7746
	for <linux-scsi@vger.kernel.org>; Fri,  3 Apr 2026 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775217573; cv=none; b=IgmMv1AYg8v/tj8NmL+bpWsqBi34JnMoVucP+zD0gsfVgzLyI05KXG6K2bemJFb5Y7Eq76yBTmSBtGs9E9QaU21IHnr3l7sVoHuqjMb1DRbvD0sdogix7BejYTeROl0zifDuGO06+uPXx1oLcbPmvgPCfn4QLEYUYU8h71MQ9fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775217573; c=relaxed/simple;
	bh=DkiKVfGKmwuAwr2izbdAbcwMKG7G5cWwKW7/OtXtPjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPAwC0WpyFZPOaBt97UA2Iv72/LRZGZsZS8e6nB3dObc05mPDEd7R7vGDE2ypKsaBYdBb+q7iX84dEUlRlIIjjG5FPLyPVNOdQngJPkJis96dKQOTaqPcmEc+brV9ZNRQGd6GvMmqS2WZvArt+6cgzdvPEs8+kC4tzVpqgiSDzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zu6050+v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JmA//ptx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zu6050+v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JmA//ptx"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 633BKru63804976
	for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2026 11:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rIB07DV1tdm7k7+UufYs3koTVO8ALZL6SbpGjd2EXmw=; b=Zu6050+v33fSurYb
	B79waiPVN101Mz2YzL1sxEtcUB/b5HUnle+CaoW9IGjl6l8jxkDSHJeoGi1126W+
	p0AuZFDvN2jjcjrmlOipi+oejSILpSvp8AXk+GDxj0txNLK4C89uLo/idK/A9DPF
	NUZmM/4HHf4iUoGgtoNmGheeZhrZeYOTV4xwZyHuhW36/nlqiJjboj/H7Y1EryEZ
	VzO8BFW0a/ILZ5ICGP/G569lIIuPt7xZiKA2QRg0FPavOq+O9YZQi4mTGHaIoWLT
	RGRNg2DofWZPINLIuqSrD/7/POo4h+MjTZK28ecvvfUSorNoMDh+3xeAv9LSAuZ9
	bphxhQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d9r0u4902-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 11:59:31 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35d99c2908cso1834560a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2026 04:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775217571; x=1775822371; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rIB07DV1tdm7k7+UufYs3koTVO8ALZL6SbpGjd2EXmw=;
        b=JmA//ptxkNzX5hnrzzZIXp1YG8oDm9ql/HrtDR8JzCwP4UtmmhY3upg3yF7jRBkzXk
         0iSaZbmRGvy8NaSJfE0kGMyjMAyuCHEUmvqIv2fb4EEyzT4ilXm1ER6pp3BS6GOYtV3m
         j3Ocf3gZv6YBagNbSfgx9PAI6+MBOzKdhjL6cjMNQtlqTreBI40vIIULyG2jM8HWhkWu
         gpEeh4Ix7hfZHRnzK50u7hLMM1bUYTWaUVLQ7ruTwIBLyDlcuYL+UIcXjxKypq4Osg/h
         ezyfZrSWSltIk+PY5FpVirPzlFx0++ozeAPe+hrzSgJ8A4H00tZI4O1Itz8SOYl+d+7A
         kfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775217571; x=1775822371;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rIB07DV1tdm7k7+UufYs3koTVO8ALZL6SbpGjd2EXmw=;
        b=AfeFvrE9rDo33NUiW0U17lq+2Gj1ZNBNk2J78Mu/8kh3DRUMv1UQWlRlMMh2R4RjkX
         r7zOXUFZUe00NYykQaSDYrDOnkMYWt4jd/H18r/yTT+aBU0oLpkOvO/QQ53Ko42GnqW1
         DgNsEJ+4wAYwQLjVlgio2uSvEY7PC7D0sNbfMbDBP6umfzPFZQGbzr5qhRXCC7ToFsYE
         m4Og+n7q8VdLLSby03P/HldkchLN4IEdfkiprwTiuZJu6Z7CrY6FF9NUQkG9nzroHCai
         GoZKpCgstL8CJh6yragjYcF5A+ANFUR2auTlS+OeP/mc2K3EKLkxb/uMzO5q55eTFth6
         E9EA==
X-Forwarded-Encrypted: i=1; AJvYcCUnxzqRkkEv74f5wgUvx7IRYUXUsEgPlve4b2uBpaRsw730LYmfTYbS2u+WPRsc2WFB0ArVUCuiyucJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4AFbEz8OkxDmRV/RXLda7ITr7BJ4yEsaIsO3I3Vfr2JBLu9Yk
	sBkVwxuzLFSksbs1/7dUo0aV7KhW8GG2Eey8l7uzRmigQOqdnbCfYwXdOpB/1E4K/0oRrJMCTEV
	Iz3NqTsozlFgRIuaGgK+LaDqkj1uubtb+O47G71tq5OYlLcHCzMUGdxvZgOKa1OUW
X-Gm-Gg: AeBDietopXNdafP391AN+9RuYQerhTsedIygMuQxZOS1ll3WrtMoq83sO5ye82QSCTa
	I6TSt8WVTeh3BGHMXbp10mNqa69QR+OxgMJlvpLaeyQtKtiAq5jIwjdXN/r/YP/bC8y0oL5yYn/
	QC2rXB5Taik1GZogywsu/Hr6NG4LIKH+tLa3LRSFSSAMrgdTewV3Lmhoo0Xh5GpkBvfECA0Q+Kh
	tN2ce6853DOFt978RaYL1854tFVn8bJjmPF4SiLe5XBTPbHkfrwAslgB9bmUJInSUWLs4/EB441
	oQ01N8ktRNa+4VDHCfpR/l2q4C7rbKudwVp/9xRVriuQPWdXcU469kpDb9ML/i5XsZjyOYuGLZb
	Lh+yYcwyeuSKOYzvuIzT1VRaAZUXjhhhK/drh5ZvaAixFL9elV9Y=
X-Received: by 2002:a17:90b:3c0c:b0:336:b60f:3936 with SMTP id 98e67ed59e1d1-35de680b3efmr2179736a91.12.1775217570577;
        Fri, 03 Apr 2026 04:59:30 -0700 (PDT)
X-Received: by 2002:a17:90b:3c0c:b0:336:b60f:3936 with SMTP id 98e67ed59e1d1-35de680b3efmr2179717a91.12.1775217570111;
        Fri, 03 Apr 2026 04:59:30 -0700 (PDT)
Received: from [10.92.178.97] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe9709b8sm10103955a91.16.2026.04.03.04.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 04:59:29 -0700 (PDT)
Message-ID: <57aa580b-c7a5-4cba-af5c-bce3d692310d@oss.qualcomm.com>
Date: Fri, 3 Apr 2026 17:29:25 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request
 support
To: Bart Van Assche <bvanassche@acm.org>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.lin@rock-chips.com,
        nitin.rawat@oss.qualcomm.com
References: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
 <20260327090346.656324-3-palash.kambar@oss.qualcomm.com>
 <97050b9c-7174-4402-a1ee-66269f8d8b6a@acm.org>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <97050b9c-7174-4402-a1ee-66269f8d8b6a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDEwNSBTYWx0ZWRfXzqx0sw2Rw6iQ
 iBP7rXJnOYD8OWGK+IzPS46ulAulFopLWZ1GvztzR0rSIiRZtxVQtl5FVTGn2rp4rWfz20wfu5R
 7b/5hthl1OFfmyEn5WGEnKJZI+Ka1gSP8mJbeZGDs7wFPzmwFUOZW2kwxDd5lKiC9aHf41KyGHB
 X2ieiLUXJCUJf81YmM+vCvpzWRcdNW2vKrcFV01achWhW3lGmCW8LTW39DEEKGvEcijTCleUK2S
 gQKxu7McoKNMbmKPLxBKXRsAuZsPa8ZTJcm0d/2BDC9uXnajLxuuOHpEGVMLygBT/Up//GAMvJC
 mZ6b06Ln0mMqmw1YVigT6tm7LknZH4jb8EST0FOgH45l8xVT1631H6tqKe+kiHIilx0BWbiyxGJ
 uFUmP8H5G+acf0ULjBYjsnx1NAsdZSEto1TEwS1Xc2ntOmEKazoNZa4fs/qo8CEW4bseDCZPS1Y
 l/xA7w702ig9Zn3/yPQ==
X-Authority-Analysis: v=2.4 cv=D5xK6/Rj c=1 sm=1 tr=0 ts=69cfaba3 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=3zKRCnpXH6Dit4Bn3WgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: kaBoyfR9KtH1Qv2X6sUkhxPvOuBzmSwM
X-Proofpoint-ORIG-GUID: kaBoyfR9KtH1Qv2X6sUkhxPvOuBzmSwM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-03_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604030105



On 3/28/2026 2:52 AM, Bart Van Assche wrote:
> On 3/27/26 2:03 AM, palash.kambar@oss.qualcomm.com wrote:
>> On platforms that support Auto Hibern8 (AH8), the UFS controller can
>> autonomously de-assert clk_req signals to the GCC when entering the
>> Hibern8 state. This allows GCC to gate unused clocks, improving
>> power efficiency.
> 
> What is the "GCC"? Please expand acronyms that are neither defined in
> the UFSHCI standard nor in the UFS standard.
> 
>> +static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
>> +{
>> +    if (ufshcd_is_auto_hibern8_supported(hba)) {
>> +        ufshcd_rmwl(hba, UFS_HW_CLK_CTRL_EN, UFS_HW_CLK_CTRL_EN,
>> +                UFS_AH8_CFG);
>> +    }
>> +}
> 
> From the Linux kernel coding style "Do not unnecessarily use braces where a single statement will do." Please follow that rule.
> 
> Thanks,
> 
> Bart.


Sure Bart, will address these comments.
