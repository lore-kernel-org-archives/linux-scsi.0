Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896726;
	b=v2+cwxlJy7l33yVEJSk373fDrzHQdARZYx/QA65W2aof9sJFNCCZ0bTbD3vPOkzoMgrx
	 y/4aFmsh3MvaMRPFzGnXWtlBqlN/e+y0s7W2gkn7UO47lZMDWhS1IyciBKh/V4A7u2Ve1
	 HchgUwi9RPbq1CzjEYTUiODJltfiLodRSqtdlJZPd4vahp5I/bs6APR03L9MJmsgAl+H5
	 8cAvJNS3IT03gQ93HEUxt+eceJxOjZ8O62CpGJcXtODnNj1L7MW+z3aXZfl3k7xPgghG3
	 Mh9qTXkE/dVCMRDKcEKXoPF4SCj6sMs5M7b+YDUNHHsMLZwH0YzcoNtaPLjb35qKCvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896726;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5yD+WOgs/w0UEROtpGaM1H5zLUeHVWQoG0KCTRfw/gg=;
	b=ADvKZSE+8W6TKjLkBopuc6osxnoBBwMLrGctVzNNKE+caLBay5t0rCUoILkc13BOf1OV
	 3vZFed14/6q8ZH4UtOEm1NSigFikA/9f6O5VyJyrLvsgPi9plzJjtxc9N9zSNQA3fH+OS
	 Po+xm7rGKwXfrR3uvoldbnfFb6XZJDNO/q3Lt6BuCFIT0gQdnFIJffCBxpkVgj0/DkpVU
	 j+5UYhP1fNtSjLlViCuXBWtQuIyZtdXl0IzAdRJxecjlbXpvziC2eMiVrg65ou4U0hTCm
	 DzeP1Gc6y+tYeApQTOST/GHkVqc1RdKlOzkNO0vtYNMlhQ4LHbXgys6acgrVPWIldcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gbyetD6M;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="PlRPIE/B";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E4606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 06:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A51E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gbyetD6M;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PlRPIE/B
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AH2a6v82934224
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 06:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5yD+WOgs/w0UEROtpGaM1H5zLUeHVWQoG0KCTRfw/gg=; b=gbyetD6M55TyiFm3
	+stp9xNsuzewD6E8kFAsyawp5FF072tq6NjzsIltJ7irOevxHhCSj+ZmW9ZZzb1l
	zrPvgKQ5RXuPXSd/JDUiT0ys6YqqDTbR61RHq2zPEi9tiOu+i3OQqyi1JDbVLg9d
	5HrxoW+p+U/eH3fdc0kHyW6cwWTJ6mqhlmpqLhxFWchN3xebtE4XHvRzZ7+AY4s2
	W3S/ajc0vQbZMgK+IXbts6rotjdK482j8fv55Tj0lnwTwoFsrJbpCKnKODVcP6kD
	u2HkI0ZdLdSuCYrqs0+ePH3GlwZRx11H7b9glala1Np7gOkLzJn9UMqkv8FFmM/9
	Z/AixA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j09m09np1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 06:25:24 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b07b06027eso5458086a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 22:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794896724; x=1795501524; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5yD+WOgs/w0UEROtpGaM1H5zLUeHVWQoG0KCTRfw/gg=;
        b=PlRPIE/BlbSEjGRRF3p/sf5Gr75YyDeMBhFr7+iOMzhXqi8cpoVD8XJ3vFo2PInZLv
         rPyFt+mru5NGo4boxHxjr/oHKFXKr4YSROjz79eGjJAXc9AkTg456CHzAzROygmUT2mq
         JE9VCulQSn6afpm8P3BTUF3kMJZbyEWdNKVSK3l/c36uAj7ORHiS6UQODEwyhnlxzALR
         QdEbR0woB0ZMn79hgBRsUmjzDIX4h2tVlxx7XG7o227I6aaSfMajtOJaQ02KYWrsnLyb
         4eao2jFOzq4nH+q+jrTjtpPOAYuxdFFBz/9rp1d4sXW6muiF6eqiFcn0rRGcGmnxCXLJ
         ReKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794896724; x=1795501524;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5yD+WOgs/w0UEROtpGaM1H5zLUeHVWQoG0KCTRfw/gg=;
        b=n8HSybAxLPcA5pMPal49AwiN+7dedqxkAO9H78r89BPobz5C1vXwdEJV1PUdWJsBS7
         AI0NHHQi/PY8yCUk5YN+CEZYRopo/disjMsdw0ns6YJ0JVKrs6wEcEroIrR0yzozgXsa
         WFsJIie5TabzL/VuNMTGDYxsrcXntjNg6p6ZgJjggCz7Qb3wYzDRR09kEwnzXMUgTljA
         3WaAtVu1pKubnhKYNthRKKoXUYvx6VFIyB48myB5eMq0IQvYvDzkzmkDFIq4AgGYRzRF
         Zlxd0ljDad1SYQtEUxYCCPDgOCJ1ORCqMBM4Al4Pd8RZdNK4kL2aVYo6/dkh1r9iuMtm
         ayNg==
X-Forwarded-Encrypted: i=1; AL+hErEBKFBfGtdZzlrSqgrJf8EAq0X2qmRBSSt4/2QdE9apIqWvdcw3kwI1F6A2LtkuHuyQMIgMyvc86S40@vger.kernel.org
X-Gm-Message-State: APuU4Z/PdqNQLFVF1lNRvJrwHyrzC1CbD03/x2TkqkLie0QjpOUA0cSW
	yoBUr1RelTxXXkDQe+GrktxEen+bP05UFcdu0u/tO6OoavtngksohU/e03GMsE0ELuOdtWckJ7x
	Z0S1p6dxjiqTpXnAaJZo/w2raH2FMe+jAjbBB4XgihCVSFWQVxuaqgHh9+6IJ2XBs
X-Gm-Gg: AZFdTZcmw8+Bd3WdPhP1UOBQZzZgp9Xg5kIRA0X5LIFyV5z1UReLdZ7TP8ne3jVbWzj
	2FlAkHx6/qwD2BPMbN1d4l9aV89968y9JSVhN9yv3eAfqkjK1rRiK7dcjSiC0hYcdJmvd03gF62
	4LPRqEqvdCPs/juuCaVdMC+cGNgM02xm49DaWSvTYrM8mP3VnkF75yNMbDs8FeEbBRqUK5DExI1
	b3QvQEIoFcJYVYloEqQS94MqHj6/qARl6anPf9gBP4mFSHcSJmcZkQAhatU4kH/Wsm+Yqdp6iHz
	Jz8znWk08/kKrkfXiSRR1X5+pF/Vf2/Y7Pv05RpBMrobL4XdUQxhteFN43+tsO5ObjXKjW4igM4
	p1HkgY6oHIXOZK3tq206IJC2t4ZPjvljR7IIZ4GxArvweguphuT2/rgpYPn68V1nVzXu9DSls56
	nRfGE=
X-Received: by 2002:a17:90b:3f8e:b0:3ac:945c:7f69 with SMTP id 98e67ed59e1d1-3b1b0b5f193mr11585556a91.66.1794896723993;
        Mon, 16 Nov 2026 22:25:23 -0800 (PST)
X-Received: by 2002:a17:90b:3f8e:b0:3ac:945c:7f69 with SMTP id 98e67ed59e1d1-3b1b0b5f193mr11585546a91.66.1794896723403;
        Mon, 16 Nov 2026 22:25:23 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abebf1aesm2512101a91.16.2026.11.16.22.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 22:25:22 -0800 (PST)
Message-ID: <2a4f99e9-4b51-42c5-9852-8747bf8f1a14@oss.qualcomm.com>
Date: Tue, 17 Nov 2026 11:55:17 +0530
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ufs: ufs-qcom: Enable ICE before enabling crypto
 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
 <20261112-qcom_ice_pm_enable-v2-2-177e454d6f22@oss.qualcomm.com>
 <20261113040820.GE1742@sol>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261113040820.GE1742@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDAyNSBTYWx0ZWRfXwKdc0NjTs31D
 UAOWc14m9u67Az+iq4zcBHEYxDiegpSklJmxZ0dgjMEbyh6iuRiXhKmQMy7puUM6Gwkse3LsGPb
 Yvk3bRmPig+52VeHiGM/MGbEz5vsjwE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDAyNSBTYWx0ZWRfX9v/qndh/JEaD
 rilhTEjJnqEpKGhbeSNiO68YtCkXTXu5WL+7jg45eEZflfAJ5TaWvOjqyP750G8TEOLEHM2VW7M
 T6BH8Qgic6Iax3W6oVfzrXEUz4E+A/lNI9JZ0HhO/TaVW5Z10Vy9FPHXIvUNGekRy9zIJBcOj4r
 uNk+EMqduDCwBCnJk04tPR2OyJycgBDR1zP98oYuxP2eKXLhWTc6dkgidGpyN4JmRXi+MYnTSLG
 CO9IJvCes1Bn+qDsHQ9sHv4/Ufm/qSXu4XdFtK+Zn5QSjp+jdn2Q1wc0F+Jd4vkCVjhbE4/nAhS
 PQSl+CVG8c09l+8Ijvm5TctY0FLqd81EFepK2Y+dURCmNODCxse90OkQQiW71FxhnZcHwWCHd08
 4hhmZnYt7InjilILBxrMBGj1x6B5rpWGgYk/U4sCJetF7pVHIbsz6fBxC54qCXjJIV/cqUNQcZ2
 OvxW5+u2JJvQBCeZvMg==
X-Proofpoint-GUID: mb8NmS8-C1NGtx_9QWR9og2erWbIFrvt
X-Proofpoint-ORIG-GUID: mb8NmS8-C1NGtx_9QWR9og2erWbIFrvt
X-Authority-Analysis: v=2.4 cv=F7rC5ahN c=1 sm=1 tr=0 ts=6afbf354 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=x_L3ctan3gn5YDiFMPYA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611170025

On 13-11-2026 09:38, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 06:48:18PM +0530, Kuldeep Singh wrote:
>> ufs-qcom currently exposes UFS crypto profile and sets UFSHCD_CAP_CRYPTO
>> before enabling ICE. This leaves a window where blk-crypto can issue
>> keyslot programming calls before ufs-qcom has explicitly enabled ICE.
> 
> Please be more specific about what actually goes wrong, and why.  During
> probe, the crypto profile hasn't actually been registered with the block
> layer yet.  So the above seems inaccurate.  Likewise in the MMC patch.

Seems i explained problem in cover letter and didn't mention here.
Please refer here:
https://lore.kernel.org/linux-arm-msm/20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com/

Actual bug got reported in storage drivers after introducing runtime PM
in ice.

In UFS probe, setting UFSHCD_CAP_CRYPTO enables the crypto profile and
let blk-crypto layer send key programming calls(i.e
qcom_ice_program_key() in ice.c) even before UFS get ice handle (i.e
qcom_ice_enable).

OTOH, with no runtime PM in ice, clocks are remain voted after probe
too. When key program call comes from blk-crypto(qcom_ice_program_key),
it calls qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot)); and
works fine as it's clocked register access.

With runtime PM in ice, clocks are voted off after probe and now same
sequence(ufs-probe -> key program call -> qcom_ice_enable) introduces
kernel panic as it's *unclocked* register access in ICE. That's why it's
important to enable ice instance in UFS before blk-crypto trigger any
key program call and hence moved qcom_ice_enable in probe.

Same sequence applies to MMC.

Though the issue reported once runtime PM in ICE got enabled, it's
actually persistent always and ideally UFS should not assume ice clock
cycle and get the instance early.

> 
>>  static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>>  {
>> @@ -188,6 +190,12 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>>  
>>  	host->ice = ice;
>>  
>> +	err = qcom_ice_enable(host->ice);
> 
> Use the 'ice' local variable.

Ack.

> 
>> @@ -636,12 +645,15 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>>  		 * is initialized.
>>  		 */
>>  		err = ufs_qcom_enable_lane_clks(host);
>> +		if (err)
>> +			return err;
>> +
>> +		err = ufs_qcom_ice_enable(host);
>>  		break;
>>  	case POST_CHANGE:
>>  		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>>  		err = ufs_qcom_check_hibern8(hba);
>>  		ufs_qcom_enable_hw_clk_gating(hba);
>> -		ufs_qcom_ice_enable(host);
>>  		ufs_qcom_config_ice_allocator(host);
>>  		break;
> 
> Needs an explanation for why ufs_qcom_config_ice_allocator() and
> ufs_qcom_ice_enable() need to be called at different times.
I didn't get any issue if we enable ice in POST_CHANGE, I added as good
to have change so as to make ice available at earliest.
As no issue observed, I am planning to drop the change.

-- 
Regards
Kuldeep

