Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F741249EB
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 06:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328993; cv=none; b=N0T7u07j9oUR4t5LYwpmcJG/15vbxNNuuMgUjj/eBCa1I22BYZFzyYqBNzXxnrBIPVQ2d8CsRzzK/dCeA5gITOVTl9VBWcw9xZNmSufEezp6H7R2pxBEUhG5f/dL81eVdl2lTPHp46Rzq7L+b+B8WxbWYm7v9dcpgs+WQprH4Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328993; c=relaxed/simple;
	bh=lbpHvV9nwxHUmABpWmOFrhwkTXsjfOSaP08IrwX0zyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feY5wdrefpRotrsmqboy6MTvmWiL3WW68i/nnyqBTiPke/oiYcXBF/EdlrXG9Bj5s9loRs1lNiIXEvuJbeu3wb4JBx6vQkCGOY+bEOcAw+vw6B0GUQACh3Jzip9NAz2GnFKuKYNs5jQ7cKB8TNDfjilaFSb7zLxhiqITTj1fx5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fZXk6xUH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KYonrtqb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fZXk6xUH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KYonrtqb"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6825YIhc832077
	for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2026 06:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EcSnLB6WKmAsBeRVJJ+St11n89Sukxc1aDDh+R8r5IQ=; b=fZXk6xUHRubKSz4v
	PWhkAY7U0kvr7kfm3f9+8ynciDF6bPIo655pYwp75e6CrJQJJSXuVoELWNyLQXKu
	8NbxmXHh9TWZ/6CUdoNfLK/3TcPzELEx2C1lr3zhU5LJLHKGVwEGqIeHC298ROwG
	Jq1+zES01/2Rj9c2aqlqx5LWp4sZf0WBJ3SLV1L4L3/pwYHF+uERoFGNRCn/y2dj
	RpMft9/++EtmMnUpM8LYJAl28inGtjTm0+E7iLKEq55Gk05aiQgUfIBuLwVOxOJq
	QQy8JuifLdoY8CpUpm922uwCMnFLLYCk5UhhatZbvpQ5NMmS1sjdohV7rxsQClfq
	omwfCw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge3n0tcjj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 06:03:05 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso875658a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 23:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788328984; x=1788933784; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EcSnLB6WKmAsBeRVJJ+St11n89Sukxc1aDDh+R8r5IQ=;
        b=KYonrtqbd7vL4151Rfih8vykYU0k/roN24sz+cq4yO91efPmrU3z4TIJW3vA0u+lF6
         y1YWpkJjn/DfE2fUAWGC+vqlXb3IAB8I5R0XrTZSChK97RRckYVfygyqcCxp9HeEKbkX
         VVEOugPTfdwy5CPQgaiBx8yEQSNUK09zBVQ04tWyQ0gTtb1XFudmHpLpota9duGmR+Am
         ub7n92/4qaH93VSMDc5jvIyWS+Duf5dVOspbC+BnIiGbpazZo/RgNTpwn7AhcR0a6VnY
         SosQUOBkymSFg9zFqNKUgwOi8Z38Gvu88cMK00R83x6WVXoNLb3CAdOtwlYTt2o5SalE
         cXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788328984; x=1788933784;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EcSnLB6WKmAsBeRVJJ+St11n89Sukxc1aDDh+R8r5IQ=;
        b=fN00rXV/cc9gURLXzEUvwOJVmqoZZ4BfynjTypTTf6gbrObQZJad7ePxAl4h5m7S6w
         /8fnOZXuSEX/1eU+LUdCDbFnH6gcf2/LL4UdeM0UAMm4WheV/Wx3RTzpV9QZDHC+HylD
         hMfivvtnX8I9hlti2afTOkbHVzvRhvgcbG5FVj3XNX3GUOvbPvVGPTu1SLD+augXAnW5
         U4Orf60DJIJliszSdFeuTKnPaqKu6fjssUQJdy1PfsdB6VyczP4PXJLzZ/FKU6C4wDc8
         qvoEYz3jItRVNkLM3yNEyWBRdwl3Qyc8u4wvS6D1RqCDoXV858bsH/esPyr9TgQjln35
         I7Ng==
X-Forwarded-Encrypted: i=1; AKwUvBzOqD+D96eCxf7Upzn/vdsLqdGu+TOv6Qdq7HJQjDtYynPQGeiIvYCDjscywgYEeIKo6vojrOfJujfu@vger.kernel.org
X-Gm-Message-State: AFuF++lLBgRaNm4gGkoUShTvxlDM965wGAF5kM2imWqpyj3gRvg866co
	qePuKRDiKInwdUqnArnOy6hX1SjFWFxUqYiNA8W7LfDyyuWq7SIDpE/Gs2oJOGmfHm9wrZKtAFu
	Ut7XAWKzHqrkU0c1btnWq35mMmzH5dazYY0EGt8ZSV7eZS5wlwEdZYdQDYnmG2rP8
X-Gm-Gg: AYBFou0SRsMvVlZ80XmKFyawSOromNOpxayOZj4vh800h2/iOpcxKuWx3OvXfVOm/PB
	lH7zCe9NQ2AJSYYbeLDsQVN1pdoFHI5yj9hbUfY9sYMcySl2r07nJPeLl/0qhIXGD2ev83iFa2h
	ma7DOP2q9aFydkAvxvpugU9/Q6P/YwjEFMW+6i5X74A3rHVEZheubWKykfnOXkJ3OJ+s1VejsKw
	fbZ1BW9BbbWseEa3gtLlqcZvK2Onsp2PznSvLL5S7J29cFY/MGmTn4KedNK9dFDW3sot6Rq7oPT
	fFay8H61ksNchXK60bMBTGZM6x/dw3bQbXjGFn5kYKx/Zhu12PD1tibdCT9wspMy0PaT7klc4W5
	8vzogQu2uQ0PInim0pmWa7s+QAvDdPpNyoYpF0RUkwd1u6WSWGeIKjnn/
X-Received: by 2002:a17:90b:55ce:b0:395:4de5:1054 with SMTP id 98e67ed59e1d1-39aee066e9fmr3902073a91.16.1788328984244;
        Tue, 01 Sep 2026 23:03:04 -0700 (PDT)
X-Received: by 2002:a17:90b:55ce:b0:395:4de5:1054 with SMTP id 98e67ed59e1d1-39aee066e9fmr3901979a91.16.1788328983698;
        Tue, 01 Sep 2026 23:03:03 -0700 (PDT)
Received: from [10.110.50.50] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430e9eb4dasm5534267c88.2.2026.09.01.23.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 23:03:03 -0700 (PDT)
Message-ID: <9352d44e-ef61-43f5-85c9-eae267762e84@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 14:02:56 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/11] blk-crypto: move bio_crypt_dun_increment() to
 the public header
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        pbonzini@redhat.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
        linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
 <20260901191342.GC729142@fedora>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260901191342.GC729142@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfXz4OejA36cunJ
 RTCWujkpLs9XZ9wfjENa4DKvvujTN181qxNBJg2vk24AQ3mvrDfDhtvvBHpdB3i/l59FJ41y9DD
 ISnpiAHt6XSh0qnWBSjpHKQU2547xuhQpdBSWmIoAifAnoDWyo9QgCRMBKDMV/fBQ3g99rLcJ1N
 ZtFc04XABOXCYcYmL8sMPe2NPNNpaiPK1r76m40hf/6bbeQ/IuW9fo08HVT3oofUZyMalVvUPRA
 f/6azazBuF8wPK9LquyE4/SHyWdy0vjGisS2+6il4WYQ4OCUuznGx8dMHlhA/60xqcmV7V49s9i
 +ujgZciEtzMFp0yGUztbPgNI+f6D7DN8p2tXXjvyBOSsIB6XaaP5kMITZNud+SMtgmmTmTqwVjF
 cmGzoKDJ5uSTe7220j8cEGimVTvXqnUgsAoslFvIx61cX8F8Tkc/rRvZOO4ICY5V1q+mIU4g9xF
 gmfgpgi6QcgAImiFSUA==
X-Proofpoint-GUID: tzp92wP9WiYDMFY9it9HamkYijCTrhXi
X-Proofpoint-ORIG-GUID: tzp92wP9WiYDMFY9it9HamkYijCTrhXi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX1KMzHyw53xky
 F0tvAH3UYNb/Vbk3ewCAHQMV+KofBIAZOqq92oxY281YPHtF8h/9PeVKc4ldUBwyKFu/+Q6psbQ
 R9DjnRIzLQ2ZevSBvsvdENkWkMMbvsQ=
X-Authority-Analysis: v=2.4 cv=R9oz39RX c=1 sm=1 tr=0 ts=6a97bc19 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=-2wExInEUDM6fBQoz8IA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020051



On 9/2/2026 3:13 AM, Stefan Hajnoczi wrote:
> On Thu, Aug 27, 2026 at 09:07:16AM -0700, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> bio_crypt_dun_increment() is currently declared only in
>> block/blk-crypto-internal.h, which is not accessible to code
>> outside of block/.  Drivers that manage inline-encrypted I/O
>> directly need to advance the DUN across bio_vecs within a bio,
>> or across multiple bios in a request, and have no other way
>> to call this function.
>>
>> Move the declaration from block/blk-crypto-internal.h to
>> include/linux/blk-crypto.h alongside the existing
>> bio_crypt_dun_is_contiguous() and blk_crypto_init_key()
>> declarations. The implementation in block/blk-crypto.c is
>> unchanged.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  block/blk-crypto-internal.h | 3 ---
>>  include/linux/blk-crypto.h  | 3 +++
>>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Other include/linux/blk-crypto.h functions export their symbols. Does
> bio_crypt_dun_increment() need EXPORT_SYMBOL_GPL() like
> bio_crypt_set_ctx() and friends?
> 

ACK

your're right. EXPORT_SYMBOL_GPL is needed. 
It will be added in next patch.

>>
>> diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
>> index 04035d237f03..32c720aabba7 100644
>> --- a/block/blk-crypto-internal.h
>> +++ b/block/blk-crypto-internal.h
>> @@ -26,9 +26,6 @@ int blk_crypto_sysfs_register(struct gendisk *disk);
>>  
>>  void blk_crypto_sysfs_unregister(struct gendisk *disk);
>>  
>> -void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>> -			     unsigned int inc);
>> -
>>  bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio);
>>  
>>  bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1_bytes,
>> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
>> index 33ae52b77522..c9f436b6b2ef 100644
>> --- a/include/linux/blk-crypto.h
>> +++ b/include/linux/blk-crypto.h
>> @@ -181,6 +181,9 @@ bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
>>  				 unsigned int bytes,
>>  				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
>>  
>> +void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>> +			     unsigned int inc);
>> +
>>  int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>>  			const u8 *key_bytes, size_t key_size,
>>  			enum blk_crypto_key_type key_type,
>> -- 
>> 2.34.1
>>

