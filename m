Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AAD39BFE1
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 08:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250965; cv=none; b=FzF+G9yYdQQTavk5keFwTD+bFco/pooOGDXJu7crya62JBcOOYsaoDT2kGqCniWW/+9Ht3atv9Pki7Dq/un61F0ZpBO/xdSs94n1gjXucBP3B2BExZ0yrhcXV3r+NTMw5rJSdNudIl4t/Dt2rKNxlglh2W4/pSGr4ZhwX445alw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250965; c=relaxed/simple;
	bh=BXTkNpotV6+/VKSWvgju9tqFpl9x1Q1iegvZv0jqNiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TbAtWnMGuLslHFjDWPclKQ7QLdanPTZfPQlvVpfISTlHvjvgiK4z1QnuYlTZ9Jj3kHCy1jmSDNns9PJ4JXmiaEPk8qbrnDj99LULsWYQhl0kj/Zn1kQ7YfSu4oArUFRswcYpd02dLkCQfqV1g0fqliNu+WNnckyhMlGjebzee30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=URygmAr7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pcgmehwq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="URygmAr7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pcgmehwq"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68178r9B2974280
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2026 08:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	meDH//M4fwWFLyQcHxzc/yohRr+DPejzh87T/qXhH2M=; b=URygmAr7Msc4qtmd
	5tMAXim1HH9OcSmbpUK6/qA30j64y/bQ32fwzGWXud1HEy5IYBoconBger2kvYmd
	+N+izF0IUKhc0pS3Zz9ya7Jbh7PdcoRZFWiWliIuMnDfSVu2U9rVqOBb5TtlnKaf
	6ft+iaCeCXQTCGSiQKjlOhYJ9nbW+/8ywTex/rtj7hl7yTsZhIPRYFWNThehZVHy
	PLAKcjN2wDgbqDXAmegxBsgiNCxKkKTQpKF7oOi+NrElSJVD5elWxw0P1v0zGtXx
	abh2uwVnJ4pU/aXn8ZT0R463YaCyWlGauznErEWynnUnMuKVQVsuqV3p0FkDvhbN
	QvGsCA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdsnu0dsu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 08:22:42 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso6890843a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 01:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788250962; x=1788855762; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=meDH//M4fwWFLyQcHxzc/yohRr+DPejzh87T/qXhH2M=;
        b=Pcgmehwqa/LY/uNJ54UYOGQCFLpOSVUvudk1w1s7wpOJj0FecvYcpqvoWX9FvbYuco
         cg1dcC68HoN512tBX9BWplrWo8OXkdeb3IfGxgCwQ8I8azn1bwY6jb2vp715IsP/DPoy
         VRDQHCiSqlmuH2eIrf60aGZ7oGa4vNRaoatgpKViZHFKAAXOndN/1vcT6LTbxwZvnCp+
         KzKxUUjvaRcb9XxExf976rdTY1eL4Kx7gfKHdkMMfjKnx5QCIuiIwGIVRLTGzR/QrYBn
         TZR8qqjH5cADghung1Mi0xr1sThl+gMOagNpsFea+3ZUscofU+FDd2oOB+0VTbjmW5K5
         FL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250962; x=1788855762;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=meDH//M4fwWFLyQcHxzc/yohRr+DPejzh87T/qXhH2M=;
        b=h7G9+FQDpJ5mKs5J2l+/COtz3q3N/QNHjvtHXfCr3JgHJDt7uXRNEZY3mwoLIVABA+
         tAxzqyTeJIZiACUYLd1wBIadm8jE4mHGm2yZIy5BohfAyNJlgeHDtZzICoqQhY9sjKj1
         tO0XAG60w81SxbQQ8YH/2qHuodCqyHZlulhVNytUH3Gf/PJVDkjJTzG+qt9MRyMpwVpV
         pDV4oQDYxRRy+j6KjGCUWw0VnipvQL8+OrOHWmviP4qoG8F42VeQ7pUviTOjCSiVmylg
         nsHVRCCkSR8RQ3PfYU3fsCC2o6srSl1/PpNu/t546LeiKR+INmQIua80zbToXKIo0SFg
         Npzg==
X-Forwarded-Encrypted: i=1; AKwUvBzd1uxlJprYCYfJo37sbYtawgTgnWXinPhZeLZ5gNEthAOCWpuNNj7grcNafF3NyBgX+1U5eGOUZQBr@vger.kernel.org
X-Gm-Message-State: AFuF++mKe6A0uDbVDG4FffydC7En4ap9z287pXcgUmWbgAp8HWoUdSqq
	4BYogPp339txt3SjNllgxPGry13PFyp/ZoN3lcEv9MXlZoyMW4bX+C/2DHmZ9r2LI0lw1bxAWQZ
	OIFFvWrD/hxlL6DJdcTVn7xaHZUOlXApiiwSK2ErFyyGO+374n7RAqt4z2VlmvdJZ
X-Gm-Gg: AYBFou3AszpUz1e5rdQL6GKfNT4XEIUmRSSfYicOMOEFQ5eZLFxAMjvMqbEUF2KRJS1
	rsPeZYHbIP+WfcJK/bxqdrcAei54bBuEs6tl00oF6U14uiLgkxcoGxmkBrBRIEpigO82I8/GZz2
	PTU1EFIrAlhPttIRTH+AlPHdf1Y3H7HJMEqQAKfOzuYT4aClraNv/3F8PjCBIUPFjSp39BKI4rb
	aUtHJr4OkeCk9L2HWILXlqhZRfx5nixxBuipi1WulYgOVEbqOKO6mYKr0QFZtw7JW1N06pRkrJ0
	WJL5Vcj4LHt4V6j6S6Jn7Fw0qE4JQLXe1+DjsgcWEf3iaxLCRALp4e3aKHrD+s3+YpLVVqfEjiY
	0eqPgDrzIKq3o4yayXQDu5EexhEunBQstRuMuvufhCXP6dOZCJ6Fpks9Q
X-Received: by 2002:a17:90b:538c:b0:398:d6e6:4671 with SMTP id 98e67ed59e1d1-398d6e68870mr23470137a91.25.1788250962081;
        Tue, 01 Sep 2026 01:22:42 -0700 (PDT)
X-Received: by 2002:a17:90b:538c:b0:398:d6e6:4671 with SMTP id 98e67ed59e1d1-398d6e68870mr23470071a91.25.1788250961597;
        Tue, 01 Sep 2026 01:22:41 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d2e465sm55409570c88.4.2026.09.01.01.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:22:41 -0700 (PDT)
Message-ID: <ca838905-f0f8-4f0a-96aa-2bc05ab6c0a7@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 16:22:33 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] FBE virtualization: inline encryption for
 virtio-blk guests
To: Eric Biggers <ebiggers@kernel.org>
Cc: axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827184219.GB2137493@google.com>
 <d81e347e-8ca7-40a1-a428-5bce6f0d4b02@oss.qualcomm.com>
 <20260831210759.GE86114@quark>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260831210759.GE86114@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3MyBTYWx0ZWRfXzzulCMZT2s/z
 822Lo3YuwCLUGRphf+57SbtItnxYR7hVbWafSjTO9ELzLUrDM+2fsb0WYdQ9M3HCfivOPljEyze
 FdyM9VlE6ziKVcFmsos51U89OUhXwyvHf3lxQKnR4qQKypSvBAdBrHWQg6zLMMni+eDI5VaKMzx
 4MBazePVTehsJ8Mhq/nYGen6y745YFJZrLPtZjTMmq+pgjSXfCtAE+8NcksXaFOX+IqDEHYvVdt
 TspF5k+Mh7uqSNmJGuhE0H3vHkv0P5UXf59/NYbZpSE5AKqS90Wjzv57uP0JBYC2xyvnm7TCbsK
 DcYjrFLoOkqIV1dwLRXZwoNo6c1cbrSl7ZH5JsIxWvEAGyLzWLjTZXrHMZ9299ciQzsQamENR4P
 rKkls0bov3NCZHtKmf7/ZV7jpn4Nm84/UVPpq/Tpby1I+ugBMK262wEv2nsFXp9psZX5G5wCOqQ
 tXBpW1aZC3ghN0//40Q==
X-Authority-Analysis: v=2.4 cv=L6ItheT8 c=1 sm=1 tr=0 ts=6a968b52 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=t1y89GQJVBw50UXK7BcA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3MyBTYWx0ZWRfXwxpVIDMRdDX6
 iF9GrdhsenM1M/CTxvyXoFV0Anyd+hCuhEybAtPUBLr5xnu7Vj7U8hgjr5lyfZ1F1YO+8bjjfqf
 Iva6MUTbvw6t1vHplCHfcTC4llF41hg=
X-Proofpoint-ORIG-GUID: YBn1f5_MDzeXvaO9GmqeU8JPwYPYdFzh
X-Proofpoint-GUID: YBn1f5_MDzeXvaO9GmqeU8JPwYPYdFzh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010073



On 9/1/2026 5:07 AM, Eric Biggers wrote:
> On Fri, Aug 28, 2026 at 11:37:57PM +0800, Linlin Zhang wrote:
>> Thanks for your comments!
>>
>> Not making virtio-blk itself support key programming and eviction is
>> something done deliberately. Based on that HW-wrapped key management
>> operations are also handled in the out-of-band path.
>>
>> There are bellow 2 approaches I investigated to let virtio-blk programming
>> the key.
>>
>>   1. virtio_blk implements blk_crypto_ll_ops interfaces, including program
>>      key and evict key interfaces.(Same to 'the virtio-blk interface standardized
>>      blk_crypto_ll_ops requests' mentioned by Stefan in the virtio SPEC thread)
>>
>>      The guest's block crypto profile manages the keyslot in virtual slot
>>      format in this scenario.
>>
>>       - block crypto key and virt_slot index it passed to the hypervisor's
>>        (EL2) device emulation (QEMU, using QEMU in the following) which
>>        runs in userspace of the host. Besides of transferring the virtual
>>        slot to the physical slot, a programming block crypto key UAPI need
>>        be added. Follow current blk-crypto design, it may be like
>>        BLKCRYPTOGENERATEKEY. I thought this results in a security risk that
>>        allows userspace process a key into a key slot.
>>
>>      - For key eviction, it's similar to above key programming handling, also
>>        need a key eviction in blk IOCTLs, but leads to the security risk
>>        that allow userspace client to evict a key in a key slot.
>>
>>     virt_slot, DUN and DUSize is appended to virtblk request during crypto
>>     I/O.
>>
>>   2. virtio_blk implements blk_crypto_ll_ops interfaces, excluding program
>>      key and evict key interfaces.
>>
>>      The guest's block crypto profile doesn't manage keyslot for the guest,
>>      the host's block crypto profile manages keyslot for both the guest and
>>      the host. The trigger of key programming operation is moved from the
>>      guest to the host.
>>
>>        - The whole block crypto key (key size, key bytes, blk_crypto_config)
>>          and DUN are appended to the virtblk request during IO, a little
>>          high payload.
>>
>>          The backend parses the crypto message in the virtio queue and
>>          construct a block crypto key and DUN for the bio_crypto_ctx
>>          set to the BIO. So that the IO flow in the host can program
>>          the key. 
>>
>>          The question is that the blk-crypto-profile distinguishs the
>>          block crypto key via the key's address. But the host has
>>          different key addresses for the programming and eviction key
>>          operations of the same block crypto key from GVM, because the
>>          key is re-constructed in the host for the key program and
>>          eviction operations. 
>>
>>          To fix it, the approach I thought is maintaining a new key
>>          hash table in the backend, and comparing the block crypto key
>>          content and DUN parsed from virtio queue with that in the key
>>          hash table. 
>>          My major concern is that this need keep the keys synchronization
>>          b/w this new hash table and the blk-crypto-profile's hash table
>>          carefully, avoiding that key is still present in the
>>          blk-crypto-profile's hash table, but removed in backend hash
>>          table. Another point is that the whole block crypto key and
>>          DUN are appended into virtio block request per crypto I/O.
>>
>>        - For key eviction, adding a key eviction in blk IOCTLs allows
>>          userspace client to evict a key in a key slot. I thought this
>>          is a security concern.
>>
>>
>>      This option doesn't need map virt_slot to physical one.
>>
>>
>> Taking all the above into account, I made a compromise to implement
>> blk_crypto_ll_ops interfaces in a out-of-band path, which lets the virtio
>> blk only need focus on the data path. I agree that it is complex than
>> the second option mentioned in the above, but small payload (only
>> virt_slot, DUN, DUSize) in the virtio block request and no security
>> risk of key eviction from userspace.
>>
>>
>> I would like to hear your thoughts about the above and am appreciated
>> if you could share your insights about the design of inline
>> encryption in virtio block.
> 
> Well, the way it should work is that each virtio-blk device should have
> its own set of *virtual* keyslots on the host side.  From the guest's
> perspective it would act very similarly to UFS / eMMC inline encryption,
> and it would be easy to integrate into the existing stack.
> 
> Then to process encrypted I/O, the host would use the keyslot number in
> the I/O to look up the blk_crypto_key it previously saved, and issue I/O
> using that key (using bio_crypt_set_ctx()).  The existing keyslot
> management logic in the block layer would allocate or wait for a
> physical keyslot as needed, so it should just work.
> 
> Eviction would similarly be passed through to blk_crypto_evict_key().
> 
> Note that with this design, there would be no static partitioning of the
> physical keyslots.  The host would just allocate and release them as
> needed, similar to memory allocation.  The total number of virtual
> keyslots could be greater than the number of physical keyslots.
> 
> This design would also work with hardware-wrapped keys.
> 
> The hardest part is still the UAPIs for the VMM to do what it needs to
> do (assuming that it even needs to support physical inline encryption
> hardware at all, and not simply use the AES acceleration on the CPU),
> but that is the case with any of the proposals.
> 
> - Eric

Thanks for your insights and clarification.

This is a very clear architecture for virtio-blk inline encryption support
and is quite similar to what I referred to as approach 1, with a few notable
differences:

  - The host maintains a set of virtual keyslots per virtio-blk device.
  - Physical keyslots are not statically partitioned.
  - The virtual-to-physical slot mapping is managed as part of the virtio-blk
    device implementation rather than being tied to a VM-wide slot table.

With this design, I believe there would be two VM exits associated with
encrypted I/O:
  1. Key programming
     Before encrypted I/O can be submitted, the guest needs to program a key
     into a virtual keyslot:
     
     Guest virtio-blk driver
         -> VM exit
         -> virtio-blk backend (e.g. QEMU)
         -> ioctl
         -> host virtio-blk proxy driver
            (stores the blk_crypto_key in a virtual keyslot)

  2. Encrypted I/O submission
     The I/O request carries the virtual keyslot number and DUN:

     Guest virtio-blk driver
        -> VM exit
        -> virtio-blk backend (e.g. QEMU)
        -> ioctl
        -> host virtio-blk proxy driver
           (looks up the blk_crypto_key associated with the virtual keyslot
            and submits I/O using bio_crypt_set_ctx())

I have been wondering whether a model similar to the passthrough
blk-crypto-profile used by certain dm targets could be applicable here.

In such a design, ownership of keyslot management would effectively and totally
move to the host. The guest would no longer manage virtual keyslots, and the
host block layer would continue using its existing keyslot manager to allocate,
reuse, and evict physical keyslots as needed.

This corresponds to what I previously described as approach 2.
With this approach, encrypted I/O would require only a single VM exit:
  1. Encrypted I/O submission
     The I/O request carries the blk_crypto_key and DUN:

     Guest virtio-blk driver
        -> VM exit
        -> virtio-blk backend (e.g. QEMU)
        -> ioctl
        -> host virtio-blk proxy driver
           (receives the blk_crypto_key and DUN, then submits I/O using
            bio_crypt_set_ctx())

Regardless of which approach is used, the host would still need to maintain a
key lookup table so that the host blk-crypto layer consistently sees the same
blk_crypto_key object for a guest key until that key is evicted.

Note that, the key table format is
  - approach 1: <virtual_slot, blk_crypto_key>
  - approach 2: <hash_id of blk_crypto_key, blk_crypto_key>

Therefore, if transferring blk_crypto_key material from the guest to the host
(and from userspace to kernel space) is considered acceptable, I wonder whether
approach 2 might be preferable because it avoids virtual keyslots entirely and
reduces the encrypted I/O path to a single VM exit.

Do you see any major drawbacks with such an approach? In particular, do you
think reducing the number of VM exits by eliminating virtual keyslots is a
worthwhile direction for virtio-blk inline encryption support?

- Linlin
