Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B26F305667
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 10:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258677; cv=none; b=ZdzU+TdyWfFqbk8VEfXfcXv9Q/prbepYocG4QpgLESwFtm7KOdRSuDqYsDzIfCU7QfdJ8Pc8C6Ylga2qpgwbtUq+NDoqhoCNCzkHNOMDy2N3Vkq5GWVufTaBluJf4xo16WO5JXN5WgWonOwpBSndOc2OzF2GBNpTfTRa5kRVnGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258677; c=relaxed/simple;
	bh=kNwdYXQxhSnCBMo14LjoO5s99k2b7eHUDeXaniwjW0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDlPYqu25cGNK4i1zKPktnLfc3SjmB9hR4PNwPmJbL6RTpWuyQTUxAjBUBv28ygW9edn6mhSxPkp4JVOrZWNQGc1NyS/Z0gwjWlzP/5IWxUjt9h/LCMQWmczZHxDjuLK0jNL0dahChweqjPfLQqhGF2GzlNaPBZO6cDngWVkCOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Udpn1XyE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PTY5Z+OA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Udpn1XyE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PTY5Z+OA"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJDjr3406531
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2026 10:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WNBYVEL4VD2Rb1PjIgbFv4Nat0n5GM6fK73Kzf1E+Do=; b=Udpn1XyE8KMUv4dy
	ua7EUwZ7of4nqHKtJLWxgXXho3GiVuCPw6JUwr4R6BF7VCyyyZyfVc+ZChbBGYZP
	9B6NnIycJaXUHWXgEFdZGcOGLU5+t1DrE6QYsT2UeeagN/WctBsDCV/OyDfKlfV7
	qg3OdCmFzTzxC7YUTs/gz3MDnAzqyQuRtoNdyE2fe/+24kXaQRaN3wlHOK6L7m6R
	6lcy6EQBqrtsWqSc1wf8i/bxakgynqKJWqfHHpvkS5QCg7L0RjTHuZdfeidLhOVv
	VtRIQD60r92PP9CkdqFC8mzUwyHkBLSOEIZVr9NbIkfq0ySOsDrsxwqY3v9a7L+s
	655Lvg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdsnu100v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 10:31:15 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so2089687a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 03:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788258675; x=1788863475; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WNBYVEL4VD2Rb1PjIgbFv4Nat0n5GM6fK73Kzf1E+Do=;
        b=PTY5Z+OAcwVuf3o6nugZniuDC9kHeVs7225/VBJLY8H5bfGwvlCtlEoVUtZFwsmylo
         fMBuhDJC0nYnEBXP8aQly026Py+QbGoUxYo51du6MxyX1JlUbX6wZjVYq92AaW/RDie2
         HoYyM78FwUSSLacengLe5o2VEMGmUTUnv3ACwfR8EusR3iUVA5D7dpGuqcuu6zY+oeBQ
         0N0CuxMRTuClA+0bR9SdeXmnF+MGkOID2SoYayrfajasTzP8rNW4Cumq5o3Qc1AmeDWg
         3oroKO4SK55Hkm0r5WZE3Wg8NVL9OoxmaloJA7SkD4W4l7Mi4pbxw1WEPnlGnwQDrm1X
         qZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788258675; x=1788863475;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNBYVEL4VD2Rb1PjIgbFv4Nat0n5GM6fK73Kzf1E+Do=;
        b=S0rRLKGaXTcyaIhWrEEQMVOMmCktX7skP1mgehjguvmzX7rIgcRUIxESqlVxLiyHRP
         Kx+NabUJsbckDyd1U7Lr2ZD+NqaDHY/kx1yVkSn/4mlvPM/+ZEKj3523lhFUCcnjo4rx
         CRcys4VIXZk/nwRpc6EmV31NN2oVueDKArc7s3KchnyqGt1S+HnrH8gfkNXrICiZfTjS
         oYyBbFyVyAUW6jQ5rv1r13/xlPJUmrPmZNU2FC2JFweuRqMedb+uFSXEroER5UnFBfe9
         y9q6CIsecVKhQtaFvU1MWP7dmfGpSZQev1RLBWtks/NHQk8ywf4x9Ga2UC+7SJXwRDcQ
         zG4Q==
X-Forwarded-Encrypted: i=1; AKwUvByz6rWAV2bdpAScDYdGMcJia8HmTliz8E6tj3Pb4lJQaK29SNNbI8YST5cOQCBldZVh6B/edBzVudCH@vger.kernel.org
X-Gm-Message-State: AFuF++kakAFF//vHrQk0RAdeQZZa4Pw8omNQ9ZbP4Iw2YphkiV3A3+Px
	fOSKnPqkxUhH4Z/hv8sFd+HuyeycDlHRp9J3Ou+Vku1hwQ9GkuszteX8Nk2phCY9e91/DuxTK3l
	h4C+h17lIFRoSireoQdOrpdUWyJltdTb1wSATKFpwYo1xtR3xtr6vhKw0EorFbzJs
X-Gm-Gg: AYBFou0ar8GDudyrHyg0wErN8Dgd85rP/Yjyux1g4SFeUbdlzdzhTIDJ4CbubDO1qVu
	8wTBu/llY0ckVXejRkNjl270dOKR827Wyd4CeK9mbnC+ZuJ5yi4rPZWhgelkUAxd6Q7YKEt5NM9
	kHXDxIRJtxg5JBDhwDIGb0Tz1PLHKRNG/9b+zylaMvczG7n2T4E7Kg0jKZ5Ldwznbv0ljr91kuJ
	yBZv/jnlS2CtbTZOfVJM/CbtnajURl2Ax8PiSlJtI3wdcw7EKzf7xyiarsIfenUtXubFB5fnSAF
	kbHPSvQr8fWNUQUy4VKuk0+ui+LRvNFGfAcHgX0l9z6FREdHAHilGzlUDgYD3/orD6X4ySy+vld
	YxloY0e8DdnxvlQHiF//siiO4XIUHhkPY4d5VP5Hsi1AU5MBv8LFB96CO
X-Received: by 2002:a17:90a:4cc2:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-396d27bb20fmr26125885a91.10.1788258674554;
        Tue, 01 Sep 2026 03:31:14 -0700 (PDT)
X-Received: by 2002:a17:90a:4cc2:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-396d27bb20fmr26125813a91.10.1788258674024;
        Tue, 01 Sep 2026 03:31:14 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm40964900eec.29.2026.09.01.03.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 03:31:13 -0700 (PDT)
Message-ID: <40156974-6637-49b7-8629-11e7d0d4e55d@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 18:31:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] soc: qcom: crypto_virt: add support for create,
 prepare and import keys
To: Krzysztof Kozlowski <krzk@kernel.org>, ebiggers@kernel.org,
        axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-4-linlin.zhang@oss.qualcomm.com>
 <4594e3db-a8e3-4f8d-95c2-a4edcbc8ca7c@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <4594e3db-a8e3-4f8d-95c2-a4edcbc8ca7c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5MSBTYWx0ZWRfX5em0DAQ41XzM
 9Mhyk4zJ8MHfrKccMDk7OaUwHiTEUP6XqXToUkww9ILBFR6DBbn01Y2chol+iDbjCNHDHQ4w3Ep
 lgPNBSjhNTA5NH//rqvr4X7u3mJ54S8QKRHm5xZCq/wIjPmshmrVTz0aiKo/ZJakVmmsxfEveqm
 HNIwhn6CbzDnLCusU3YP6XUI+NLjM5WHwcXDO3QMbJDrhXqwlfghPX12XPZN2aophIJj7Z1SGvx
 Ic+ugxpej6LTqPn8bR2HQb5G+wjXeCZW4rTOt09XALddgMIGSTVe99U6hxAorJcgP4ADACokltc
 KfwOiFyQH9F8clltn1F/X2viTAWSKoYs7K8he4PBnlkIxzxmkRKSbym/udqsujOG/V+TGX2i1bT
 y9BHfJoxi1VDJU+jsquwfnKUIAdoDVOF+peyVeSoYTyVhR6e9cvaa4+6dJVmReedPQ6rdGaYQjr
 qdNL2Jo5d7e6qjpI3vQ==
X-Authority-Analysis: v=2.4 cv=L6ItheT8 c=1 sm=1 tr=0 ts=6a96a973 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=2tBp2Vdcr-mqUi0jtlkA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5MSBTYWx0ZWRfX6n5YhnlIwIr1
 MAM9nB6syMxIok8yBVcl0hF9VpId/HaOQKb3cnPewVCBRz4lBrw0DzpCTeO/Fm8dUS/eIc8AwS+
 Kv7m7P3uWQONZZCVd5zMUudHOFnKpQc=
X-Proofpoint-ORIG-GUID: wO63u4IlrXgbVKrUj8VtmUgR_XDonW9P
X-Proofpoint-GUID: wO63u4IlrXgbVKrUj8VtmUgR_XDonW9P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010091



On 8/31/2026 2:58 PM, Krzysztof Kozlowski wrote:
> On 27/08/2026 18:07, Linlin Zhang wrote:
>> +static void crypto_virt_remove(struct platform_device *pdev)
>> +{
>> +	virtblk_set_crypto_ops(NULL);
>> +}
>> +
>> +static const struct of_device_id crypto_virt_of_match[] = {
>> +	{ .compatible = "qcom,crypto-virt" },
> 
> Undocumented ABI, also not really allowed. We don't take bindings for
> drivers.
> 

The dt-binding document is included in another patch in this series.
The concern about introducing a DT binding for a software-only driver.
The underlying problem I am trying to solve is how to communicate the
wrapped-key size to the guest.

Because the guest has no access to the ICE hardware, it cannot get
the key size by reading the ICE hardware directly. In the other hand,
the wrapped key size may vary across ICE versions, it's infeasible
to have a fixed wrapped key size in the code. Additionally, wrapped
key size is vendor-specific, it's nor proper to pass it via virtio.

As an experiment, I used a DT property to set this wrapped key and
wanted to get feedback on whether this is a reasonable approach.

Is there a preferred mechanism for handling this kind of vendor-specific
configuration, or are there similar examples elsewhere in the kernel
that I should follow?

>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, crypto_virt_of_match);
>> +
>> +static struct platform_driver crypto_virt_driver = {
>> +	.probe = crypto_virt_probe,
>> +	.remove = crypto_virt_remove,
>> +	.driver = {
>> +		.name = "crypto_virt",
>> +		.of_match_table = crypto_virt_of_match,
>> +	},
>> +};
>> +
>> +static int __init crypto_virt_init(void)
>> +{
>> +	return platform_driver_register(&crypto_virt_driver);
>> +}
>>  module_init(crypto_virt_init);
>>  
>>  #if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
>>  static void __exit crypto_virt_exit(void)
>>  {
>> -	virtblk_set_crypto_ops(NULL);
>> +	platform_driver_unregister(&crypto_virt_driver);
> 
> You just added this line, so previous code was simply wrong?
No. In previous patch, virtblk_set_crypto_ops is called in
crypto_virt_init and crypto_virt_exit. This patch moves the caller
to the driver probe and remove APIs.

> 
> Please read submitting patches doc - you need to organize your work in
> proper commits.

The series adds inline encryption support to virtio-blk as a whole. This
patch implements the wrapped-key handling portion of that support
(generation, preparation, and import), so I included it in the same series.

However, I understand your concern about commit organization. If you think
the DT-based instantiation mechanism should be handled separately, I can
restructure the series accordingly.

In addition, Eric suggested implementing blk_crypto_ll_ops directly in
virtio-blk. If that proposal is accepted upstream, this driver would
likely become unnecessary, as key generation, preparation, import,
programming, and eviction could all be implemented as part of the
virtio-blk blk_crypto_ll_ops backend.

> 
> Best regards,
> Krzysztof

