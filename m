Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24653F6C32
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787823; cv=none; b=Ap7oAgvfYiHxzrwXggECusStiF0vGlHvSvcPcaTOikb9iw6UdrDGG8rkVhkfAjJSBqq8AvvZaoyLTTlD2ivRU4RUO5XJpmkHVjurb+MVK83l8wG4MadztP8VaLGfEv1I/SCRJx76SeRNpNsVoxgXIzIU1uj1I3XvvTN5dhncIXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787823; c=relaxed/simple;
	bh=PSCZlzz5fjxTGq9uKR6wX0C/ymeqII0/PUc/wexBbHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsBEvAb2gr0HvIZtCdOpqtRip/fYFCIOXnxHb7gmWvLq0BE3YMwqaU6YaR8WChQYF5MtnnZxVJ7fFVOxghseECmGVdbYIUSKQ/Kc4UJ6yuIgg/NrHAO2PPogbdSsBJaxzez5lvO/lRrGSD3kNR6plMRduBBremxNxPxuWXD6VEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AsXDiPjm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dfXWJ7bM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AsXDiPjm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dfXWJ7bM"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ICtxg81600071
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B7JX5X2XTD4Cde3MxSmPYTnPXo33idXZtjiWq+3lvLA=; b=AsXDiPjm/cJN4pZl
	RdSpC7JwGwSCoWCLzG/B6XJfdw0jsEwluMJtdPBCO7BR1CeHBLRRcJoOawvbkGtA
	PTlQQBA4OQ+s+Oe8uA8cu8Is57MrIYpst1KglQE8+j115BcqhHO9cxU9TtBCyTSg
	nN1qmb3ySMkYFpWPi5wd4yi/GdM7vRtbM4caAbqz4WsFuuDDiG4nafF+xTUdIwU5
	mrsrplcD53iSG49rxOW839guDzA1/hwZbNqtSJF115qQKjaNlVJeiuKP2MFd3dki
	SaxgB0FujY/xEYTQEuEQFkY2aUIT++WiiMREwRO/CwYAT+UKehbchoZ1F9Hefl1u
	jn8ASg==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev1wc37a1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:03:40 +0000 (GMT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e70041c746so108982a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781787820; x=1782392620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7JX5X2XTD4Cde3MxSmPYTnPXo33idXZtjiWq+3lvLA=;
        b=dfXWJ7bMgUbJcldIz3vq07I74EpPN2vmTdmK7m/GTtcLvhsPQJ+TLE0C/FTxG78pC6
         9sTmQAh9pUctk2vxWuomYl5g0RuhZQ1nGdg57rkN12TUxrdCGWv/FU+v2V50nGHup7Sl
         bTcylULNu+O/EvjwvCwtvwHjJcWxG0RtD7UQXaEYkFI9gnZ4ppr2Oe9JMLvO13fodhP+
         t3ffNfcJsOwen9ChyB/EEt9TdwwT5kMZofv9Walc5iInxUPblLrsWYBXe3z1kBePSeaE
         3LH5sGAqxem5znxQJ/xpFotdZ7Wid1SzR0ordH8dnzR8Y4WW++SqoHOkKD7M1oQcBtPj
         Rx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787820; x=1782392620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B7JX5X2XTD4Cde3MxSmPYTnPXo33idXZtjiWq+3lvLA=;
        b=h74e7q5Bpj3/JBeJtlkbiXXFzVbDtlZbt873ArqPTvyVRh9RlG6371Nh2j9JIPgZ/o
         VYIYiDifZfZKseyTw3zj0OO8GBeQhlLsrPVYmcFAjyDZhwyuDoH7933ftyM7kL5OcYy3
         vW8EoWGq6V4/mBlmTqu5w062iWKePOkilBQ874Db9rJv6rltJ0t62Qxd7404JlpQMAq/
         LrT6GdwjXfVruybCn2j82G+C5srJ4xQnD9RfMqxf5x+tc/C1v/uKXGoG4dM77pR7n1QZ
         f9XsSXUtEYYgN0GI1XgQ0gVPAko8V31i7hs+OfhblTKV0LbAWY5I/UYrKQ7uuvNlUT4w
         yqMQ==
X-Forwarded-Encrypted: i=1; AFNElJ91qN9h8dzQa5VYobfjeUAG987fo6N1pE/H3oWbn7ilxWUJO3q8+oWz0UNFf50FM+XkEs23guEeu0YE@vger.kernel.org
X-Gm-Message-State: AOJu0YzIZl35u0AJ8kpJTva6e93Jp8Abw81o/z6IOrpxHQuwvbVDOX9r
	RBKGU3Q+BNLgwlZ0XyFVErtEPlWoxamLHzZqo0cBp1V9Gfuz3Cmk6jiTCyS3aq1VZ2s3nFykv+x
	qRDN5aMencRmA6BjT1Vm1iim74DiPHmIy+uGb4aJHGmSZRVIxznKZJL1hZ5DV0WcW
X-Gm-Gg: AfdE7cmwC6XlDGX0JBklRGz/OnqJsWnOcXT9rPgvUicIS9wk9ZuDKf+49A6BuvGNDrG
	19ZeFuGz2qilhnEfRZoqhGg2Ui4Yq3BuAC5eYLrNdEpPGRO6cihTPWp1KHz85sbw7lhBT7HYoL1
	a4NGMknUbO9TyyaKwUyOHvQ2/FNZ672U4b3v8sG9PZQzZY4q9gvpoGueFRtfG130YOEkdQYfE6O
	qRYzW/BSyP3Q2CuJb6IOOCpIxUDyqA65QxTSOYbwZiDQZcSjSKKD/Fz4vIDqMGG+guyCrFx0POE
	QgekgY9+6jf/w5pO5Gnn8F3vSi8pwA/E2Y4yGyktrNRaKPdKjBBU36TJmDpit6KK1A1pOff0vwH
	o+/tU1WOcFQYLeflvf4Vl9D20Ap8BCwpU5+A=
X-Received: by 2002:a05:6830:43a7:b0:7e6:6f9f:7445 with SMTP id 46e09a7af769-7e90c7497d2mr4384700a34.3.1781787820204;
        Thu, 18 Jun 2026 06:03:40 -0700 (PDT)
X-Received: by 2002:a05:6830:43a7:b0:7e6:6f9f:7445 with SMTP id 46e09a7af769-7e90c7497d2mr4384650a34.3.1781787819765;
        Thu, 18 Jun 2026 06:03:39 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-695836d7e78sm1997961a12.18.2026.06.18.06.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:03:38 -0700 (PDT)
Message-ID: <c008fa1f-55e9-41bb-8ef0-8a9d85f2614d@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 15:03:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-4-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=TMt1jVla c=1 sm=1 tr=0 ts=6a33ecac cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=-W0wxAWcNmATYll7EfoA:9 a=QEXdDO2ut3YA:10
 a=EyFUmsFV_t8cxB2kMr4A:22
X-Proofpoint-GUID: 130OPhB2u3-NpZMvscCD5zyTcHVE4p5d
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX9Dqj2LSLVXWH
 UaYR8OnioJp33dN7iEo/l3gfxK1jhOBDcYYyTkbo//fM9E1svteUxinOzQVUQC+ZM2LVNlCqhd4
 EBacuC+U9AmFfOpYwbqdZX68Azbh2vs=
X-Proofpoint-ORIG-GUID: 130OPhB2u3-NpZMvscCD5zyTcHVE4p5d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfXx+qno80OjPyu
 ZqMoIBP5XMC8Vxqs+x3PhF5wRyxrYVqV0xAE6KkUEB9/P3XTQlGxMOOwJeE5aBkrlvji6S8ncuE
 I9QbeM0xx5o4sTyMOrQQ9F9aazb2vIpm3kSPmKFBrAr5OjRR87uNLMb1ss62eNcjUCp0gDorMpd
 1HDeA8h30i5MfQBZROG/B6WzR6Da7VtkbRYdhQQ/K7hXKUuMZ8N80phnzRydClhtQA7rdq9yr5H
 PmUieBVDWJiaCJiSsY6OhDXjt3OcUsCagLIDTnoutmenDz9hXRUpATSmMG+RiYQyjk9H/ehzWR0
 N0XvK5OO+kpwXyL8GMUNomNX4z68cuBoVCddgIPnDBWNz6xUIdV28A5sOZsRhAMLfACyJilk6Km
 zxHF53aqrPD21H5PhI/9uwmWaaop7SZFXmUbMR4cCT1fpubsDV2bm/jLMeo6uUpi7/DXmHdIfCu
 bB/Qo19OpraQTIXFg1w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180121

On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
