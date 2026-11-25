Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795608113;
	b=MQnpZ0aH+kBcgFyhCIzPA0FagNWaNeCevXZ+3KLuktMOWZymXEx8r6DJIdRHa7GNt9e0
	 1Y2kjhvEW5aWf3a2NxZJ0byRnzV4vu1O0/JqK9SAk4cUaEmLJUKlHkiQCQGvLd936LhnG
	 iTolZ0WTd27vdDTK/S/vUaFUyaSiZO1P2PnT9bqAu/0yEZ4fvRBAvc0lGMfdU2TOPNg1v
	 DesR8NzxgRxE9gMtQyuxyljcxNghGVNiAmPFmaubKlyd2VngZE2NTDNBs+3ycjjs6fbeU
	 YjhrWbyaqDGt9SqWaISahRBYuydsjY6e8EJdgZPuGUntO+ApwhJazh5BgyvSqwuFMBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795608113;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=JH0+oBZQMbhzUlbiC8dnWCz5sXtMHNDZ49YbsVl19LY=;
	b=kdNz9nB/KZyN2v9z/mOoFJkeNEkKobFvOwJOPbXLrMpsn+QlVh2x627mpWNKCMwwGA6u
	 IOEk0i52Nt8dGKFJb8l1fNtqGuiqb8aeKRXRr25AhHaRkfdm/s6AKmmUrmLKuQyObBB72
	 Nu9IVoMumvefnHlPWGq0NbT0v/I+HoCD3b5D1FT+amapmmrCZIc2iPbzlBicZ1ZRRza7Y
	 KoRHojyoMK8NTZzVQrvY69mFE2kMn6obYui+FkrwznPxwEqvdRZCmgWvxlBf+PsY3/uZW
	 dl58z/4ZxWGoGeLRNb4Htt8heaB1mIkUOts5GxL90NYp6Gtik7ybKuXXX+hpTCJBfMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FcCKHBfO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bkHEKFaG;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C0606A321
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 12:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B47C0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FcCKHBfO;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bkHEKFaG
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP9mTBq2121308
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 12:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JH0+oBZQMbh
	zUlbiC8dnWCz5sXtMHNDZ49YbsVl19LY=; b=FcCKHBfO6oIC01Z1971CkqMK19f
	b6IwpdYxK7hts14LM5Tu5dXXC2NVJ51/nQGpRwbIppx92GgLV70t/KNHAPxBxkqz
	XvKLto4njmstadffJDtTosoHjPRaQpaXtNBebMb2u7680gPo0KlHtKwbd+oEYR23
	+kKxrqMxChitoG9lbTRbKpu5ws/pij2vd/cGzcwWWFGFYgamxCsYtugjSmXfzW8L
	9AvlnbkZumDPo+m31KsO5KzUAqR9F6KShCZf+R769WdClM1jIAmBXECEWncGRJ8d
	KFJaqRIoUXn2fbXkKKEIdgJCVojR4ScF+1dyaVP/RyY7JUsRkyw7kAiSDdw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j5vukrq4d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 12:01:51 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2f03a137f6aso50207995ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 04:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795608111; x=1796212911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JH0+oBZQMbhzUlbiC8dnWCz5sXtMHNDZ49YbsVl19LY=;
        b=bkHEKFaG0ykIpUvTORCKyOWsGdXaMljYg8yfuvaOjiL4hRIr0mp+RN934I+2cSBwUC
         PDM404kvjLEw4kEsCH9kFLNEotlwexNVSl5zuSDK1HCaJnq3eYrGJs0XpiYtaJGhaPuT
         BB4Q/ed5dUqkvdeDShXBlpKAISbOXOVRND+w+xKuRvMOR6AogPir3BhnUpsrhceZENHT
         BO2oE3wJ+Wj1R27auWQnvHHL5xYMNBCeEif42/B4WVSiM8nCw9sq1BhQ2bTRz5nv+pv1
         OcFamE2GU4H6ZgvzYcVPLB+oQSzeztqeJtH/wwX5NIAMAly4W7XpYQf5y1oFnuiyb5vg
         Qn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795608111; x=1796212911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JH0+oBZQMbhzUlbiC8dnWCz5sXtMHNDZ49YbsVl19LY=;
        b=iREYcdiGZaxund6N4mgBWxur1aBvm0B8d7Fov/4sS9Qufx/vNDL/+lTELxj40HZr5G
         a3rGieIXwqZgpte3QUMoLKeHtDNVunWzv8j+u+UIrOOUdcJ9yFcx68PI06hvA9aa2RzN
         MP2p28QRlPmdLtxikuTr/8oUo73kN1y/K9uTib9Pe/t5SdYHcutqVtc4AckJVtGokl5G
         FQBRAiSiX2NeZEPshYMc4mi0qHh1xniGhuMxnbnkBmF4Tm8Dl6PVv75CF+8OB2onST5f
         0c0aK7UnoUIBKvKq0yJxhb4iviLqqwn1MF7tyIsxNQeE8mDSvq8Er+R7fafLil5yYcXs
         UBrA==
X-Forwarded-Encrypted: i=1; AL+hErG/4u4FatQG6Yiu2tXgJbnDPmZuL6ie21AIG1IcnAGiZl02X9jVY8j+NeGr6iesSU0I7KAzeHWSneHO@vger.kernel.org
X-Gm-Message-State: APuU4Z/5aXekhE/2yKkgKKs7NnLXSmYHThuaLRHwO9DqdV0KJ553sTlN
	8k1ApOVCVQp6+iXM0TIiXLyTgRlNPR5drjFUKH5q9aCtBo8zfV1kD1n5TTVedPQV09ZUd0GnqBQ
	+n9TiLJdcbHSwE3CSAzSIxRpg6dd70r4djCozcNiXTAcq6ZTILV1llJk7DFSdBgxl
X-Gm-Gg: AZFdTZcaO6mqrJtbjG00O1ZhcRrC5/63ODEA5eC/CVKyRa6ncDFAApl+rrPZ5Yc5cN/
	M0gKEwUhzN+OwjO/D4VqHl+5820WyIuZ6PwVDuOkEBXuRirkV9kXw7o43qavhPh4UQMYsKqPHwU
	w6mJbrN0xxe+fubzsdj7O1LE/6xUxRGEyvm47V3TdZCHJCBzmFO7v1X7LFw+SWZxLWcwFADW8U/
	9HJasukAiwla83/9oIgEamVdniw1b3HXlm7FgUCQ2GQeZyfd6pMuenEgCnSNwOlGDwsfiovF6Y4
	1dGDwuHG3455GVjaR1eZ2Vv73kNo0cbXUNyTuz1KusybWzkvB19ful1a46zGn8d+/WnOQ02DPcT
	+zb2BWMKNN0aTCiEeYGsynZGTRhu0m8ynSoLKmx+k4khO1uNvCupU83HcJHhaf8TFa/pfpOBuyr
	1AA8JOD/B+nPwurxmSE2qGEJc5Sq2LlFlQRUtqCBbT5Ef98To1FXdlJTI=
X-Received: by 2002:a17:903:4586:b0:2ef:de2a:3bae with SMTP id d9443c01a7336-2f03f170047mr176859685ad.30.1795608110686;
        Wed, 25 Nov 2026 04:01:50 -0800 (PST)
X-Received: by 2002:a17:903:4586:b0:2ef:de2a:3bae with SMTP id d9443c01a7336-2f03f170047mr176859435ad.30.1795608110199;
        Wed, 25 Nov 2026 04:01:50 -0800 (PST)
Received: from hu-ymg-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1a8asm84700455ad.24.2026.11.25.04.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:01:49 -0800 (PST)
From: Yadu M G <yadu.mg@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: dt-bindings: Add compatible for Seca UFS Host Controller
Date: Wed, 25 Nov 2026 17:31:41 +0530
Message-ID: <20261125120141.348306-1-yadu.mg@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7401e343-71f9-476c-9143-26d068c28aa7@kernel.org>
References: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com> <7401e343-71f9-476c-9143-26d068c28aa7@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=KfVHIgYD c=1 sm=1 tr=0 ts=6b06ce2f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=zTK7sikzi49oAEfBURIA:9
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: 42IA11Q-LqncKyZyYgIsYlGnLKYZKmUJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDA0NyBTYWx0ZWRfXzuE0urO28KmO
 bUKroHpRzBMoyl9X7xeGBALrGLrlc9ALNWuEJad7bGyqAb2I5gkf9/mIU0wIIDRq4X2daNWj9o9
 nNYktUM4Ouv88ChyXFbNmlXtjpI59AA=
X-Proofpoint-GUID: 42IA11Q-LqncKyZyYgIsYlGnLKYZKmUJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDA0NyBTYWx0ZWRfXxfSvK+E+Fmzy
 /4oW6qAwzcdwpBxsQd+bOvbhQDqEJ+ILm+fzoF1MdhZ3lJVYDzkH40aktxARQHVOPXOkEnO4gOE
 4A9+wn3pzTdXPMj/hV2z29eIpVefV2YXaoSnEJQZcSSm3gfQRRq0YG8EbBbbdZHRD+fgEfB+I6K
 PGUz4x5E4l30EzZkRpBpSWffhFWQKS5evTx9i426xnuNSkyPEltM3wx9eA6ipfFJ1iMocJOEjD2
 diMj/pIb3Ukv7kWnjHfLtMUdJnWGS+KZBCF+C7SXAnOejgDlAKeRtFetVEy/FWSen0IlfJf9KH/
 9Drix/UcKAs1KThwcgvR5SMMbRu2s8XTkJy7OZW8uBs5zn7sQ+eScmMxkp9QUkB0mInNwE0K4Tk
 BobHdocO9FC/MXnQDOGa/z/c4CuITPdQNtkuMLHQcMWQ1eyob7qaUsRmjT4NCGNF9dHGnCu/YmM
 RsRI+AVm6n72GZOPSlQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_03,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250047

On 24/11/2026 16:49, Krzysztof Kozlowski wrote:
>> +      - items:
>> +          - const: qcom,secaau-ufshc
>> +          - const: qcom,sa8255p-ufshc
>
> And Claude did not tell you how this is organized? That's one enum.

Ack. It was missed. v2 uses a single enum with the SA8797P entry, and
will recheck the other bindings in the series for the same pattern
before resending.

Yadu
