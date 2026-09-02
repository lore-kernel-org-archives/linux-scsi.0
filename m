Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE3485505
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354896; cv=none; b=RQXCuXypakM9bnj0+QQFOc4iVh3b3d/wmnVQn7fiODY3ij1GJc5gewIiwKQ0x1Fw8LQ7cTbzzyCfefCIe9+UhfSp8eXfEvXIGYflUIrHu1Ah8yUNYj23lWiT2Cus/hxTcCDra5l/tfJw6r3dnICY1mr/qSN9FVTc0UFSF0dhQjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354896; c=relaxed/simple;
	bh=Pk2yp6y+yhoR3JRRgcWSrOKmYtMO175N2G6OPRTrZYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sYcenrCFO1aJ+YbeuCz2TEn63BoKOIfU87MhWfB1Ocbid6Rk27hU3ywyxsNfmDC+sEEzBUg6MmmIgIEUPB9capHZTxvpjHqAGL+vigpss/07/UF8fM4m1ha1k+SAJLIWJGfaL3PcdKAIcEyBRNpA90DifhrV2xb7SKIjOWJP68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZppqEJLt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QvxiH4K6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZppqEJLt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QvxiH4K6"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682CRA3J1385890
	for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2026 13:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nPE/I/EUJ/xs6Jv7xRjQGcyvZ2qSGFsLM9nxhqY7l9Q=; b=ZppqEJLtb2qCRIar
	m4ovo69cqiRfo2VzMNc1JP27UejCsDBhecv9EBBCe6qJ4sOjZryYx+f23qgV2VH7
	vr3sdKKV8DNz6HUt3n9zQM0AeoK49IDFYY2Y7lFijrTz6/zOfUSed17mUVxttBcv
	/nQA90T7dszKnl20ZLf3sYZ0xwdBn2jxHHHqBDu0z5f4SYDWSpyIRJLmCKbdM/qR
	hoIMpsMSJRSxKZWp3r2c94SMKOBIW3Due46rfvFSr8Oq50tS5Putxkp0yKZ44S9u
	LjjGOHxmzFgUHnA8Ky/GHAbflByGCn70p9FHfwYHgmJebNTUna6L0MLio0uAQTgE
	jMW/qQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge435usbs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 13:14:52 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so1411519a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 06:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788354891; x=1788959691; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nPE/I/EUJ/xs6Jv7xRjQGcyvZ2qSGFsLM9nxhqY7l9Q=;
        b=QvxiH4K6gdlzF1DYXn1ia48SJcDlx+1PuF6u3YxvFuKZxBA8Yq71JlvfZWst8W+0ST
         PmLqHgnHvvkeCZiTlZitZ1VslKVFsyd5mDIGBuLmMlOfP0fmh52S5mbh9+SUPq9yqMYl
         4PqdvDF6r8ekRfWlWk6axFmzaTfIPpgy6eqrqCE0q0ttYNxVXDbQTn88mJgtsbciNuVl
         TpeLarF3Uol8qERol9Z9o5VOA1PK0GDUzzbnbZlZ5c4ApLqD8p/bGVjrXzGSuTw10f7Y
         MnMJA6oAgX+1ciSwHUzXzJBcOKzNDq+KF5SWU08745IDGYANuOmmvR7WFnpvP8gBsVdF
         v/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788354891; x=1788959691;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nPE/I/EUJ/xs6Jv7xRjQGcyvZ2qSGFsLM9nxhqY7l9Q=;
        b=CISKRSl6KEEjBbFOzA8EMsJb9UMG8eE8Lw6Ot/zc19z9jpPAPNDvoa5eJ9fzXjlbXJ
         cLNSNDK0//i9tnjl131czYoVc1z8Cp6o6y3CaR4eFuKWBPrBxh39qvWAN7kLkGXFZwAx
         6/tkjf2fslVNGoYyU9XPI7IcMjfiCd/QZJV73uP46TD3X4BG5TW6nyjAp+GLZb6YKcwf
         xerngVE6mcxZehwlPcIaBlombfo81pQaqqIEtZ6zdQeMpuL7aGAzLPQoFCTE3V5OdijY
         HJfxq8N9PCZu6GMEkksjaab89njXAXyEPQg1BvKHuwWaEq4/6uC8QtIWjflUW2waGS5z
         5aMg==
X-Forwarded-Encrypted: i=1; AKwUvBwgANETbWgS5eb7VXsidN75i99dObqIOPfJfOMXKtPzIMPwwnQqstvf+zoNTPJfn0bdbXLtQuBJD8eg@vger.kernel.org
X-Gm-Message-State: AFuF++n3EoqDw5NFbTf9u7JMDRN0zXdnJVurl/phdlLw+pxvXGqhGEno
	2HN+1QQxgw23g30yuNWTf6tByQQ3KCI65iVChGUxbPWaxazMxXQnrmzk8ceTZo7olLJ4tREGBvi
	RH/Ads5QiDCPdBWS/yFM9HQGiND/tFHLe++YeP2ztU0GGK9BMFFUA30l6MzYpwT0w
X-Gm-Gg: AYBFou2D2/eVAn8wc/pFhX6SglqJI98h6lV+u3PvM1va52O7vTduAMjTULKv7DQJn2r
	D6gyn+hL6uV4U0x5L5A0j6VYTu6tmCGGm+FhZt7iKtgMEx6VlXonfDP9wYG9pslkmL5o4geEw5P
	0yOTnStMrWGarqXLxWDp6g76LNkzeA+v7cTsfYJOFNXuyrnpYNYxQQTEMpoi3MNDTjhbZFvPgD0
	YAwDv9RXZn+j1Fn+Q+3SNHdTbhpq/nrtFVnkGIOiyCZtzDgqPjghCS6dPjM7Qqo1Sd742mRN1lZ
	aqPOLMCrN/E5mF6IfgYhViEHqdjoCmJkZFQhLmtTXQn5/+Whma+jyjjA1Pf9y9h0kwTomUdoFoB
	6WiSaqXu494+9MmJPDwlGi0dYqkZ9S+7BmCP8MZvYLvDYroKvmLZRWsz3Yg==
X-Received: by 2002:a17:90b:2244:b0:398:9bd5:490f with SMTP id 98e67ed59e1d1-39aee1476e5mr6271502a91.22.1788354890879;
        Wed, 02 Sep 2026 06:14:50 -0700 (PDT)
X-Received: by 2002:a17:90b:2244:b0:398:9bd5:490f with SMTP id 98e67ed59e1d1-39aee1476e5mr6271329a91.22.1788354889985;
        Wed, 02 Sep 2026 06:14:49 -0700 (PDT)
Received: from [10.110.114.54] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07ba5a70sm7245450eec.20.2026.09.02.06.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 06:14:49 -0700 (PDT)
Message-ID: <3fb17f29-6f74-4b7d-b776-8a95e597f8b9@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 21:14:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/11] block: add /dev/blk-crypto-proxy for host-side
 virtio-blk inline encryption
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
 <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
 <20260901194316.GD729142@fedora>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260901194316.GD729142@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDExNyBTYWx0ZWRfX4KSUwXrVCtGi
 S/trf5cwcC8n5+C3PV88JDBNx8xoB2iXzULtOMBh3i8S/pmKPVrQ+xgIJ6cUxOmFIHKCTl8Sn2x
 ThgQSMbzRYbdfnmN04U3ZRB+STq436VFkBpCbyLCC7g8/BAjmV1+hX9nsXU85Us5iBrCwkPN7ia
 QEOHIjW6tJsJlV3zI/FXdYhD/WJNgWzC1oc1v4HL27ZuBK8afk40CUzKKKWk+3IqX0y3g/nC6EP
 V+LQDfF1H0yLemPb+pSRIhWkFuUnVhOFp1qmqncehHL3rl2POUFnfFtqjCTXm40aTQNLA5+ZYdE
 0EyF1PlzNSpNEAYuPtGH6ikL5MFVr8ASif7vUl3oyLr7tt9SUg+NqWMEIw3aYXrTHQOkw2iSv7x
 n3gr4fZnkJoLeMS6QnNYafglRJ7J1A2Iyz0yfdNhc+1wdN093vy03kytrir/UmKKDlezeOEsNoE
 duDwFNvB0tiFtcNk1Xg==
X-Proofpoint-GUID: iTp0PVsh0QJ5hOP-FaaHE5K9MVfKxDNi
X-Proofpoint-ORIG-GUID: iTp0PVsh0QJ5hOP-FaaHE5K9MVfKxDNi
X-Authority-Analysis: v=2.4 cv=JpnBas4C c=1 sm=1 tr=0 ts=6a98214c cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=u40wfHyFugwGr01bpbQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDExNyBTYWx0ZWRfXyGiH3vdBZTzF
 qtDROE4idu6XM+GJAqCxI11f5itOREeoIimS5ubK4mZFLjgp0nfd9PEA2/QOL4lOJcJhG+YH9D7
 XMvNX+4WeM4/W8hCFAUNv8lu6ykIQtU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_03,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020117



On 9/2/2026 3:43 AM, Stefan Hajnoczi wrote:
> On Thu, Aug 27, 2026 at 09:07:17AM -0700, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> A userspace virtio-blk backend receives VIRTIO_BLK_T_CRYPTO_IN/OUT
>> requests from guests that carry a virtual ICE keyslot index and a data
>> unit number.  The backend must submit the bio to the host storage
>> controller with the correct inline encryption context, but it has
>> no in-kernel interface to do so.
>>
>> Add /dev/blk-crypto-proxy, a misc character device that bridges a
>> userspace virtio-blk backend to the kernel blk-crypto layer.  The
> 
> Question for blk-crypto folks: should this new userspace blk-crypto
> interface be at the block device level or at the VFS level? If you
> envision that applications might want to manage their own keys and
> perform encrypted I/O on files, then maybe this should be at the VFS
> level. Block devices would of course be supported by a VFS interface
> too.
> 
>> interface is three ioctls:
>>
>>   BCP_BIND_CONTEXT      — bind a host block device fd and a hypervisor
>>                           VM fd to this file descriptor; the kernel
>>                           resolves the VM fd to a guest id and holds
>>                           the bdev reference for the fd lifetime.
> 
> Is there anything virtualization-specific in this interface? I think
> it's really a userspace interface for blk-crypto that can be used by any
> userspace application.
> 
> It would be nice to name and document the interface without mentioning
> virtualization so that we can think about it from a more generic point
> of view that allows for new use cases in the future rather than
> focussing too much on just the virtualization use case.

ACK

I'll update it if it exists in the next patch.

> 
>>   BCP_GET_CRYPTO_CAPS   — query the bound device's blk_crypto_profile
>>                           capabilities (supported modes, key types, max
>>                           DUN bytes) and the number of ICE keyslots
>>                           allocated to the bound VM, so the backend can
>>                           populate the virtio config space crypto fields.
>>   BCP_SUBMIT_IO_BY_VSLOT — submit an inline-encrypted bio using the
>>                           virtual slot index supplied by the guest.  The
>>                           kernel resolves virt_slot to a physical ICE
>>                           keyslot via bcp_slot_virt_ops, calls
>>                           bio_crypt_set_ctx_by_slot(), and submits the
>>                           bio synchronously.  Large requests are split
>>                           at data-unit boundaries (BIO_MAX_VECS per bio)
>>                           to preserve DUN/IV correctness. The
>>                           implementation follows the block layer's
>>                           direct-I/O path, with two differences: each
>>                           bio carries an inline encryption context, and
>>                           multiple bios are submitted sequentially
>>                           rather than concurrently now.
> 
> Linux already has multiple userspace interfaces for submitting I/O, like
> preadv(2), io_uring, Linux AIO, etc. I don't think a new ioctl-based
> interface just for submitting I/O with blk-crypto metadata makes sense
> because applications sometimes spend a lot of time optimizing for the
> I/O submission interface (e.g. io_uring) and integrating a new interface
> makes adoption hard.
> 
> Did you look at how to extend preadv()-related interfaces and io_uring
> operations?
> 

Thanks for the feedback!

I agree that introducing a new ioctl-based I/O submission path is not ideal,
especially for VMMs that are already optimized around existing interfaces
such as io_uring or preadv()-based workflows.

My reasoning was that I/O carrying blk-crypto metadata has several
constraints that must be validated before submission:

  1. The starting logical offset must be aligned to the data unit size,
     which is also the granularity at which the DUN increments.
  2. The I/O length must be a multiple of the data unit size. 
     DUN + data_unit_count - 1 must not exceed the maximum representable
     DUN value.
  3. The bio construction and page-segment splitting must not break
     data-unit boundaries.

My assumption was that handling these blk-crypto-specific requirements
inside generic I/O submission interfaces might not be desirable, since
those interfaces are primarily concerned with I/O submission semantics
rather than encryption metadata validation. As a result, I opted for a
separate ioctl-based path.

That said, I understand the concern about introducing a new I/O
interface solely for blk-crypto support. If reusing existing
infrastructure is preferred, io_uring seems like the most suitable
candidate to me. Linux AIO is largely legacy at this point, while
extending preadv()-style APIs would likely require ABI changes to pass
encryption metadata.

I'd appreciate guidance from you, the block and blk-crypto maintainers
on what direction would be considered more acceptable. In particular,
whether these blk-crypto-specific constraints should be handled by
extending an existing I/O submission interface such as io_uring, or
whether a dedicated interface is justified in this case.

>>
>> The driver is hypervisor-agnostic and storage-vendor-agnostic.  Two
>> pluggable op-sets registered by platform drivers fill the gaps:
>>
>>   bcp_hypervisor_ops  — translate a hypervisor VM fd to an opaque
>>                         guest_id; implemented by the hypervisor driver.
>>   bcp_slot_virt_ops   — map (profile, guest_id, virt_slot) to a
>>                         physical ICE keyslot; implemented by the
>>                         platform storage virtualization layer.
>>
>> Both op-sets are RCU-protected singletons; the hot path reads them
>> lock-free.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/block/Kconfig                 |  15 +
>>  drivers/block/Makefile                |   1 +
>>  drivers/block/blk-crypto-proxy.c      | 667 ++++++++++++++++++++++++++
>>  include/linux/blk-crypto-proxy.h      | 100 ++++
>>  include/uapi/linux/blk-crypto-proxy.h | 122 +++++
>>  5 files changed, 905 insertions(+)
>>  create mode 100644 drivers/block/blk-crypto-proxy.c
>>  create mode 100644 include/linux/blk-crypto-proxy.h
>>  create mode 100644 include/uapi/linux/blk-crypto-proxy.h
>>
>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>> index 7790ee2c700c..48ad79734c09 100644
>> --- a/drivers/block/Kconfig
>> +++ b/drivers/block/Kconfig
>> @@ -176,6 +176,21 @@ config BLK_DEV_LOOP
>>  
>>  	  Most users will answer N here.
>>  
>> +config BLK_CRYPTO_PROXY
>> +	tristate "Inline encryption proxy for virtio-blk guests"
>> +	depends on BLK_INLINE_ENCRYPTION
>> +	help
>> +	  Provides /dev/blk-crypto-proxy, a misc character device that allows a
>> +	  userspace virtio-blk backend to submit inline-encrypted block I/O
>> +	  on behalf of guest virtual machines.
>> +
>> +	  Guests supply a virtual keyslot index and data unit number with
>> +	  each encrypted request.  The host kernel translates the virtual
>> +	  slot to a physical hardware keyslot and issues the bio to the
>> +	  storage controller with the correct inline encryption context.
>> +
>> +	  If unsure, say N.
>> +
>>  config BLK_DEV_LOOP_MIN_COUNT
>>  	int "Number of loop devices to pre-create at init time"
>>  	depends on BLK_DEV_LOOP
>> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
>> index 079c910d5fc9..636137248d0d 100644
>> --- a/drivers/block/Makefile
>> +++ b/drivers/block/Makefile
>> @@ -23,6 +23,7 @@ obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
>>  obj-$(CONFIG_SUNVDC)		+= sunvdc.o
>>  
>>  obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
>> +obj-$(CONFIG_BLK_CRYPTO_PROXY)	+= blk-crypto-proxy.o
>>  obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
>>  
>>  obj-$(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) += virtio_blk_crypto_ext.o
>> diff --git a/drivers/block/blk-crypto-proxy.c b/drivers/block/blk-crypto-proxy.c
>> new file mode 100644
>> index 000000000000..60722884dbcd
>> --- /dev/null
>> +++ b/drivers/block/blk-crypto-proxy.c
>> @@ -0,0 +1,667 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#define pr_fmt(fmt) "blk-crypto-proxy: " fmt
>> +
>> +#include <linux/module.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/fs.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/slab.h>
>> +#include <linux/blkdev.h>
>> +#include <linux/bio.h>
>> +#include <linux/mutex.h>
>> +#include <linux/overflow.h>
>> +#include <linux/file.h>
>> +#include <linux/mm.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/rcupdate.h>
>> +#include <linux/uio.h>
>> +#include <linux/blk-crypto.h>
>> +#include <linux/blk-crypto-profile.h>
>> +#include <linux/blk-crypto-proxy.h>
>> +#include <linux/virtio_blk.h>
>> +
>> +static const struct bcp_hypervisor_ops __rcu *g_hypervisor_ops;
>> +static DEFINE_MUTEX(g_hypervisor_ops_lock);
>> +
>> +static const struct bcp_slot_virt_ops __rcu *g_slot_virt_ops;
>> +static DEFINE_MUTEX(g_slot_virt_ops_lock);
>> +
>> +int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&g_hypervisor_ops_lock);
>> +	if (rcu_access_pointer(g_hypervisor_ops))
>> +		ret = -EBUSY;
>> +	else
>> +		rcu_assign_pointer(g_hypervisor_ops, ops);
>> +	mutex_unlock(&g_hypervisor_ops_lock);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(bcp_register_hypervisor_ops);
>> +
>> +void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
>> +{
>> +	mutex_lock(&g_hypervisor_ops_lock);
>> +	if (rcu_access_pointer(g_hypervisor_ops) == ops)
>> +		rcu_assign_pointer(g_hypervisor_ops, NULL);
>> +	mutex_unlock(&g_hypervisor_ops_lock);
>> +	synchronize_rcu();
>> +}
>> +EXPORT_SYMBOL_GPL(bcp_unregister_hypervisor_ops);
>> +
>> +int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
>> +{
>> +	int ret = 0;
>> +
>> +	mutex_lock(&g_slot_virt_ops_lock);
>> +	if (rcu_access_pointer(g_slot_virt_ops))
>> +		ret = -EBUSY;
>> +	else
>> +		rcu_assign_pointer(g_slot_virt_ops, ops);
>> +	mutex_unlock(&g_slot_virt_ops_lock);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(bcp_register_slot_virt_ops);
>> +
>> +void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
>> +{
>> +	mutex_lock(&g_slot_virt_ops_lock);
>> +	if (rcu_access_pointer(g_slot_virt_ops) == ops)
>> +		rcu_assign_pointer(g_slot_virt_ops, NULL);
>> +	mutex_unlock(&g_slot_virt_ops_lock);
>> +	synchronize_rcu();
>> +}
>> +EXPORT_SYMBOL_GPL(bcp_unregister_slot_virt_ops);
>> +
>> +/**
>> + * struct bcp_ctx - per-fd state for /dev/blk-crypto-proxy
>> + * @bdev_file: file handle for the bound block device; NULL until BCP_BIND_CONTEXT.
>> + *             Published with smp_store_release() so hot-path ioctls can read it
>> + *             lock-free via smp_load_acquire() in bcp_ctx_bound().
>> + * @guest_id: guest identifier resolved from vm_fd at bind time.
>> + * @bdev_writable: block_dev_fd was opened with write access.
>> + * @bind_lock: serializes concurrent BCP_BIND_CONTEXT calls on this fd.
>> + */
>> +struct bcp_ctx {
>> +	struct file *bdev_file;
>> +	u32 guest_id;
>> +	bool bdev_writable;
>> +	struct mutex bind_lock;
>> +};
>> +
>> +/*
>> + * True once BCP_BIND_CONTEXT has published ctx->bdev_file.  The acquire pairs
>> + * with smp_store_release() in bcp_ioctl_bind_context(), ensuring ctx->guest_id
>> + * and ctx->bdev_writable are visible to any caller that observes true.
>> + */
>> +static bool bcp_ctx_bound(struct bcp_ctx *ctx)
>> +{
>> +	return smp_load_acquire(&ctx->bdev_file) != NULL;
>> +}
>> +
>> +static int bcp_open(struct inode *inode, struct file *file)
>> +{
>> +	struct bcp_ctx *ctx;
>> +
>> +	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
>> +	if (!ctx)
>> +		return -ENOMEM;
>> +	mutex_init(&ctx->bind_lock);
>> +	file->private_data = ctx;
>> +	return 0;
>> +}
>> +
>> +static int bcp_release(struct inode *inode, struct file *file)
>> +{
>> +	struct bcp_ctx *ctx = file->private_data;
>> +
>> +	if (ctx) {
>> +		if (ctx->bdev_file)
>> +			bdev_fput(ctx->bdev_file);
>> +		mutex_destroy(&ctx->bind_lock);
>> +		kfree(ctx);
>> +		file->private_data = NULL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Resolve a userspace block device fd to a struct file holding a reference
>> + * to the block device, opened with the same access mode as @fd so that a
>> + * read-only fd cannot gain write access via BCP_SUBMIT_IO_BY_VSLOT.
>> + */
>> +static struct file *bcp_bdev_from_fd(int fd, bool *writable)
>> +{
>> +	struct file *f;
>> +	struct inode *inode;
>> +	dev_t dev;
>> +	blk_mode_t mode = 0;
>> +
>> +	f = fget(fd);
>> +	if (!f)
>> +		return ERR_PTR(-EBADF);
>> +	inode = file_inode(f);
>> +	if (!S_ISBLK(inode->i_mode)) {
>> +		fput(f);
>> +		return ERR_PTR(-ENOTBLK);
>> +	}
>> +	if (f->f_mode & FMODE_READ)
>> +		mode |= BLK_OPEN_READ;
>> +	if (f->f_mode & FMODE_WRITE)
>> +		mode |= BLK_OPEN_WRITE;
>> +	if (!mode) {
>> +		fput(f);
>> +		return ERR_PTR(-EACCES);
>> +	}
>> +	*writable = !!(mode & BLK_OPEN_WRITE);
>> +	dev = inode->i_rdev;
>> +	fput(f);
>> +	return bdev_file_open_by_dev(dev, mode, NULL, NULL);
>> +}
>> +
>> +static long bcp_ioctl_bind_context(struct file *file,
>> +				   struct bcp_bind_context_arg __user *argp)
>> +{
>> +	struct bcp_ctx *ctx = file->private_data;
>> +	struct bcp_bind_context_arg arg;
>> +	const struct bcp_hypervisor_ops *hv_ops;
>> +	struct file *bdev_file;
>> +	u32 guest_id;
>> +	bool writable = false;
>> +	int ret;
>> +
>> +	if (!ctx)
>> +		return -EINVAL;
>> +	if (copy_from_user(&arg, argp, sizeof(arg)))
>> +		return -EFAULT;
>> +	if (arg.reserved)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * get_guest_id() may sleep; call it before taking bind_lock.
>> +	 */
>> +	rcu_read_lock();
>> +	hv_ops = rcu_dereference(g_hypervisor_ops);
>> +	if (!hv_ops) {
>> +		rcu_read_unlock();
>> +		return -EOPNOTSUPP;
>> +	}
>> +	ret = hv_ops->get_guest_id(arg.vm_fd, &guest_id);
>> +	rcu_read_unlock();
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * Serialize against concurrent BCP_BIND_CONTEXT calls: two callers
>> +	 * could both pass the ctx->bdev_file == NULL check before either stores.
>> +	 */
>> +	guard(mutex)(&ctx->bind_lock);
>> +
>> +	if (ctx->bdev_file)
>> +		return -EBUSY;
>> +
>> +	bdev_file = bcp_bdev_from_fd(arg.block_dev_fd, &writable);
>> +	if (IS_ERR(bdev_file))
>> +		return PTR_ERR(bdev_file);
>> +
>> +	ctx->guest_id = guest_id;
>> +	ctx->bdev_writable = writable;
>> +	/*
>> +	 * Publish ctx->bdev_file last with a release barrier; bcp_ctx_bound()
>> +	 * reads it with smp_load_acquire() without taking @bind_lock.
>> +	 */
>> +	smp_store_release(&ctx->bdev_file, bdev_file);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Maps VIRTIO_BLK_CRYPTO_MODE_* to enum blk_crypto_mode_num.  The two index
>> + * spaces do not coincide, so modes_supported[] must not be copied positionally.
>> + * Keep in sync with virtio_blk_crypto_mode_map[] in drivers/block/virtio_blk.c.
>> + */
>> +static const enum blk_crypto_mode_num
>> +	bcp_virtio_crypto_mode_map[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] = {
>> +	[VIRTIO_BLK_CRYPTO_MODE_INVALID]	= BLK_ENCRYPTION_MODE_INVALID,
>> +	[VIRTIO_BLK_CRYPTO_MODE_AES_256_XTS]	= BLK_ENCRYPTION_MODE_AES_256_XTS,
>> +};
>> +
>> +static long bcp_ioctl_get_crypto_caps(struct file *file,
>> +				      struct bcp_get_crypto_caps_arg __user *argp)
>> +{
>> +	struct bcp_ctx *ctx = file->private_data;
>> +	struct bcp_get_crypto_caps_arg arg;
>> +	struct block_device *bdev;
>> +	u32 modes[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] = {0};
>> +	struct blk_crypto_profile *profile;
>> +	unsigned int i, n;
>> +	u32 cap, written;
>> +
>> +	if (!ctx || !bcp_ctx_bound(ctx))
>> +		return -ENXIO;
>> +
>> +	if (copy_from_user(&arg, argp, sizeof(arg)))
>> +		return -EFAULT;
>> +	if (arg.num_modes && !arg.modes_ptr)
>> +		return -EINVAL;
>> +
>> +	bdev = file_bdev(ctx->bdev_file);
>> +	profile = bdev_get_queue(bdev)->crypto_profile;
>> +	if (!profile)
>> +		return -EOPNOTSUPP;
>> +
>> +	arg.key_types_supported = profile->key_types_supported;
>> +	/*
>> +	 * Clamp to 8: the @dun wire field is a single __aligned_u64 so nothing
>> +	 * upstream can deliver a wider DUN regardless of what the profile claims.
>> +	 */
>> +	arg.max_dun_bytes = min_t(u32, profile->max_dun_bytes_supported, 8);
>> +
>> +	/*
>> +	 * arg.modes_supported[] is indexed by VIRTIO_BLK_CRYPTO_MODE_* (index 0
>> +	 * is always 0 per the virtio spec).  Translate via the map above; do not
>> +	 * copy profile->modes_supported[] positionally.
>> +	 */
>> +	n = VIRTIO_BLK_CRYPTO_MODE_MAX + 1;
>> +	cap = arg.num_modes;
>> +	written = min_t(u32, cap, n);
>> +
>> +	for (i = 1; i < n; i++) {
>> +		enum blk_crypto_mode_num kmode = bcp_virtio_crypto_mode_map[i];
>> +
>> +		if (!kmode)
>> +			continue;
>> +		modes[i] = profile->modes_supported[kmode];
>> +	}
>> +
>> +	if (written &&
>> +	    copy_to_user(u64_to_user_ptr(arg.modes_ptr), modes,
>> +			 written * sizeof(modes[0])))
>> +		return -EFAULT;
>> +	arg.num_modes = written;
>> +
>> +	arg.max_slots = 0;
>> +	rcu_read_lock();
>> +	{
>> +		const struct bcp_slot_virt_ops *sv_ops =
>> +				rcu_dereference(g_slot_virt_ops);
>> +		if (sv_ops) {
>> +			int nslots = sv_ops->get_guest_slots(profile, ctx->guest_id);
>> +
>> +			if (nslots > 0)
>> +				arg.max_slots = nslots;
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	if (copy_to_user(argp, &arg, sizeof(arg)))
>> +		return -EFAULT;
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Compute the number of pages needed for up to @want_bytes of iovec data
>> + * starting at cursor (@start_idx, @start_off).  The page count is capped at
>> + * @cap to bound the arithmetic; *bytes_out receives the actual byte count.
>> + */
>> +static unsigned int bcp_iov_pages_for_bytes(const struct iovec *iov, u32 iov_cnt,
>> +					    u32 start_idx, u64 start_off,
>> +					      u64 want_bytes, unsigned int cap,
>> +					      u64 *bytes_out)
>> +{
>> +	u64 pages = 0, taken = 0;
>> +	u32 i;
>> +
>> +	for (i = start_idx; i < iov_cnt && taken < want_bytes; i++) {
>> +		u64 base, len;
>> +
>> +		if (i == start_idx) {
>> +			base = (u64)(uintptr_t)iov[i].iov_base + start_off;
>> +			len  = iov[i].iov_len - start_off;
>> +		} else {
>> +			base = (u64)(uintptr_t)iov[i].iov_base;
>> +			len  = iov[i].iov_len;
>> +		}
>> +		if (len == 0)
>> +			continue;
>> +		if (len > want_bytes - taken)
>> +			len = want_bytes - taken;
>> +		pages += DIV_ROUND_UP(len + offset_in_page(base), PAGE_SIZE);
>> +		taken += len;
>> +		if (pages >= cap) {
>> +			*bytes_out = taken;
>> +			return cap;
>> +		}
>> +	}
>> +	*bytes_out = taken;
>> +	return (unsigned int)pages;
>> +}
>> +
>> +/*
>> + * Advance cursor (*idx, *off) forward by @bytes within @iov[0..iov_cnt).
>> + */
>> +static void bcp_iov_advance_cursor(const struct iovec *iov, u32 iov_cnt,
>> +				   u32 *idx, u64 *off, u64 bytes)
>> +{
>> +	while (bytes > 0 && *idx < iov_cnt) {
>> +		u64 seg_remaining = iov[*idx].iov_len - *off;
>> +		u64 take = min_t(u64, seg_remaining, bytes);
>> +
>> +		*off += take;
>> +		bytes -= take;
>> +		if (*off == iov[*idx].iov_len) {
>> +			(*idx)++;
>> +			*off = 0;
>> +		}
>> +	}
>> +}
>> +
>> +static long bcp_ioctl_submit_io_by_vslot(struct file *file,
>> +					 struct bcp_submit_io_by_vslot_arg __user *argp)
>> +{
>> +	struct bcp_ctx *ctx = file->private_data;
>> +	struct bcp_submit_io_by_vslot_arg arg;
>> +	struct block_device *bdev;
>> +	struct blk_crypto_profile *profile;
>> +	struct iovec *iov = NULL;
>> +	struct iov_iter iter;
>> +	struct blk_crypto_slot slot;
>> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
>> +	u64 bytes_done = 0;
>> +	u64 align, stride;
>> +	u64 total_bytes;
>> +	u32 seg_idx = 0;
>> +	u64 seg_off = 0;
>> +	unsigned int phy_slot;
>> +	int ret = -EFAULT;
>> +
>> +	if (!ctx || !bcp_ctx_bound(ctx))
>> +		return -ENXIO;
>> +
>> +	if (copy_from_user(&arg, argp, sizeof(arg)))
>> +		return -EFAULT;
>> +	if (arg.reserved2)
>> +		return -EINVAL;
>> +
>> +	bdev = file_bdev(ctx->bdev_file);
>> +
>> +	if (arg.direction != BCP_DIR_READ && arg.direction != BCP_DIR_WRITE)
>> +		return -EINVAL;
>> +	/*
>> +	 * blk_mode_t does not stop submit_bio() from writing; enforce the
>> +	 * caller's original fd permission explicitly.
>> +	 */
>> +	if (arg.direction == BCP_DIR_WRITE && !ctx->bdev_writable)
>> +		return -EACCES;
>> +	/*
>> +	 * bdev_read_only() can change after bind time; submit_bio_noacct()'s
>> +	 * bio_check_ro() only warns rather than errors in this kernel.
>> +	 */
>> +	if (arg.direction == BCP_DIR_WRITE && bdev_read_only(bdev))
>> +		return -EROFS;
>> +	if (arg.flags != BCP_SUBMIT_IO_F_IOV)
>> +		return -EINVAL;
>> +	if (arg.iov_cnt == 0 || arg.iov_cnt > BCP_MAX_IOV)
>> +		return -EINVAL;
>> +	/* A shift amount >= 64 would be undefined behavior. */
>> +	if (arg.data_unit_size_bits >= 64)
>> +		return -EINVAL;
>> +
>> +	profile = bdev_get_queue(bdev)->crypto_profile;
>> +	if (!profile)
>> +		return -EOPNOTSUPP;
>> +
>> +	/* Resolve virt_slot → phy_slot. */
>> +	rcu_read_lock();
>> +	{
>> +		const struct bcp_slot_virt_ops *sv_ops =
>> +				rcu_dereference(g_slot_virt_ops);
>> +		if (!sv_ops) {
>> +			rcu_read_unlock();
>> +			return -EOPNOTSUPP;
>> +		}
>> +		ret = sv_ops->vslot_to_pslot(profile, ctx->guest_id,
>> +					     arg.virt_slot, &phy_slot);
>> +	}
>> +	rcu_read_unlock();
>> +	if (ret)
>> +		return ret;
>> +
>> +	memset(dun, 0, sizeof(dun));
>> +	dun[0] = arg.dun;
>> +
>> +	slot.phy_slot            = phy_slot;
>> +	slot.data_unit_size_bits = arg.data_unit_size_bits;
>> +
>> +	align = 1ULL << arg.data_unit_size_bits;
>> +	/*
>> +	 * Split bios at stride (smallest multiple of the data unit size >=
>> +	 * PAGE_SIZE) boundaries so each bio ends on a whole data unit.
>> +	 * bio_crypt_check_alignment() is skipped for slot-based bios (bc_key
>> +	 * == NULL), so a mid-unit split would silently mis-encrypt/mis-decrypt.
>> +	 */
>> +	stride = DIV_ROUND_UP(PAGE_SIZE, align) * align;
>> +
>> +	/*
>> +	 * Import the caller's iovec once.  import_iovec() validates every
>> +	 * segment with access_ok(), returns the total byte count, and takes a
>> +	 * private kernel copy that eliminates TOCTOU from a guest mutating its
>> +	 * own iovec array mid-ioctl.
>> +	 */
>> +	ret = import_iovec(arg.direction == BCP_DIR_READ ? ITER_DEST : ITER_SOURCE,
>> +			   (const struct iovec __user *)u64_to_user_ptr(arg.iov_ptr),
>> +			   arg.iov_cnt, 0, &iov, &iter);
>> +	if (ret < 0)
>> +		return ret;
>> +	total_bytes = ret;
>> +
>> +	/*
>> +	 * Reject a misaligned total length up front: bio_crypt_check_alignment()
>> +	 * is skipped for slot-based bios so nothing downstream will catch it.
>> +	 */
>> +	if (total_bytes == 0 || (total_bytes & (align - 1)) ||
>> +	    (total_bytes & (SECTOR_SIZE - 1))) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Fail fast if the request exceeds the device.  bio_check_eod() would
>> +	 * also catch this, but only on the last bio after earlier bios have
>> +	 * already done real I/O.
>> +	 */
>> +	{
>> +		sector_t nr_sectors = total_bytes >> SECTOR_SHIFT;
>> +		sector_t maxsector = bdev_nr_sectors(bdev);
>> +
>> +		if (nr_sectors > maxsector || arg.sector > maxsector - nr_sectors) {
>> +			ret = -EIO;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Reject an out-of-range DUN: slot-based bios skip
>> +	 * bio_crypt_check_alignment(), so an overflow would silently truncate
>> +	 * in the hardware DUN field rather than error out.
>> +	 */
>> +	{
>> +		u64 total_units = total_bytes >> arg.data_unit_size_bits;
>> +		u64 max_dun_used, dun_limit;
>> +
>> +		if (check_add_overflow(arg.dun, total_units - 1, &max_dun_used)) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		dun_limit = profile->max_dun_bytes_supported >= 8 ? U64_MAX :
>> +			(1ULL << (8 * profile->max_dun_bytes_supported)) - 1;
>> +		if (max_dun_used > dun_limit) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Submit the request as a sequence of bios (submit_bio_wait() per
>> +	 * bio), each holding at most BIO_MAX_VECS pages.  Sequential
>> +	 * submission avoids DUN/IV correctness concerns across concurrent
>> +	 * in-flight bios.
>> +	 */
>> +	while (seg_idx < arg.iov_cnt) {
>> +		unsigned int pages_used = 0;
>> +		u64 bio_bytes = 0;
>> +		u32 la_idx = seg_idx;
>> +		u64 la_off = seg_off;
>> +		u64 remaining_before;
>> +		struct bio *bio;
>> +
>> +		/*
>> +		 * Lookahead: count how many whole stride units fit within a
>> +		 * fresh bio's BIO_MAX_VECS page budget.
>> +		 */
>> +		for (;;) {
>> +			u64 unit_bytes;
>> +			unsigned int unit_pages;
>> +
>> +			unit_pages = bcp_iov_pages_for_bytes(iov, arg.iov_cnt,
>> +							     la_idx, la_off, stride,
>> +							BIO_MAX_VECS + 1,
>> +							&unit_bytes);
>> +			if (unit_bytes == 0)
>> +				break; /* only empty segments remain */
>> +
>> +			if (pages_used + unit_pages > BIO_MAX_VECS) {
>> +				if (pages_used == 0) {
>> +					/* data_unit_size_bits too large to fit one unit. */
>> +					ret = -EINVAL;
>> +					goto out;
>> +				}
>> +				break; /* finalize this bio; unit deferred to next */
>> +			}
>> +
>> +			pages_used += unit_pages;
>> +			bio_bytes  += unit_bytes;
>> +			bcp_iov_advance_cursor(iov, arg.iov_cnt, &la_idx, &la_off,
>> +					       unit_bytes);
>> +		}
>> +
>> +		if (bio_bytes == 0)
>> +			break;
>> +
>> +		bio = bio_alloc(bdev, pages_used,
>> +				arg.direction == BCP_DIR_WRITE ?
>> +					REQ_OP_WRITE : REQ_OP_READ,
>> +				GFP_KERNEL);
>> +		if (!bio) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		bio->bi_iter.bi_sector = arg.sector + (bytes_done >> SECTOR_SHIFT);
>> +
>> +		/*
>> +		 * Use bio_iov_iter_get_pages() to pin pages into the bio,
>> +		 * the same as the O_DIRECT path.  Truncate the iter to this
>> +		 * bio's byte budget, then reexpand for the next iteration.
>> +		 */
>> +		remaining_before = iov_iter_count(&iter);
>> +		iov_iter_truncate(&iter, bio_bytes);
>> +		ret = bio_iov_iter_get_pages(bio, &iter, 0, 0);
>> +		if (ret < 0) {
>> +			bio_put(bio);
>> +			goto out;
>> +		}
>> +		if (iov_iter_count(&iter) != 0) {
>> +			/*
>> +			 * The lookahead verified bio_bytes fits in BIO_MAX_VECS;
>> +			 * if bio_iov_iter_get_pages() stopped early, its page
>> +			 * accounting disagreed with bcp_iov_pages_for_bytes().
>> +			 */
>> +			bio_put(bio);
>> +			ret = -EIO;
>> +			goto out;
>> +		}
>> +		iov_iter_reexpand(&iter, remaining_before - bio_bytes);
>> +
>> +		/*
>> +		 * Match __blkdev_direct_IO(): mark pages dirty on reads into
>> +		 * user-backed memory.
>> +		 */
>> +		if (arg.direction == BCP_DIR_READ && user_backed_iter(&iter))
>> +			bio_set_pages_dirty(bio);
>> +
>> +		bcp_iov_advance_cursor(iov, arg.iov_cnt, &seg_idx, &seg_off,
>> +				       bio_bytes);
>> +
>> +		bio_crypt_set_ctx_by_slot(bio, &slot, dun, GFP_KERNEL);
>> +
>> +		ret = submit_bio_wait(bio);
>> +		bio_put(bio);
>> +		if (ret)
>> +			goto out;
>> +
>> +		/*
>> +		 * Advance dun by this bio's contribution only, not by
>> +		 * recomputing from arg.dun + bytes_done, to avoid silent
>> +		 * truncation when bytes_done grows past UINT_MAX data units.
>> +		 */
>> +		bio_crypt_dun_increment(dun, (unsigned int)(bio_bytes >> arg.data_unit_size_bits));
>> +		bytes_done += bio_bytes;
>> +	}
>> +	ret = 0;
>> +
>> +out:
>> +	kfree(iov);
>> +	return ret;
>> +}
>> +
>> +static long bcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>> +{
>> +	void __user *argp = (void __user *)arg;
>> +
>> +	switch (cmd) {
>> +	case BCP_BIND_CONTEXT:
>> +		return bcp_ioctl_bind_context(file, argp);
>> +	case BCP_GET_CRYPTO_CAPS:
>> +		return bcp_ioctl_get_crypto_caps(file, argp);
>> +	case BCP_SUBMIT_IO_BY_VSLOT:
>> +		return bcp_ioctl_submit_io_by_vslot(file, argp);
>> +	default:
>> +		return -ENOTTY;
>> +	}
>> +}
>> +
>> +static const struct file_operations bcp_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.open		= bcp_open,
>> +	.release	= bcp_release,
>> +	.unlocked_ioctl	= bcp_ioctl,
>> +	.compat_ioctl	= compat_ptr_ioctl,
>> +};
>> +
>> +static struct miscdevice bcp_misc = {
>> +	.minor	= MISC_DYNAMIC_MINOR,
>> +	.name	= "blk-crypto-proxy",
>> +	.fops	= &bcp_fops,
>> +};
>> +
>> +static int __init blk_crypto_proxy_init(void)
>> +{
>> +	int ret;
>> +
>> +	ret = misc_register(&bcp_misc);
>> +	if (ret)
>> +		return ret;
>> +	return 0;
>> +}
>> +
>> +static void __exit blk_crypto_proxy_exit(void)
>> +{
>> +	misc_deregister(&bcp_misc);
>> +}
>> +
>> +module_init(blk_crypto_proxy_init);
>> +module_exit(blk_crypto_proxy_exit);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("Host-side inline crypto proxy for virtio-blk guests");
>> diff --git a/include/linux/blk-crypto-proxy.h b/include/linux/blk-crypto-proxy.h
>> new file mode 100644
>> index 000000000000..6cf1ff0703e9
>> --- /dev/null
>> +++ b/include/linux/blk-crypto-proxy.h
>> @@ -0,0 +1,100 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +
>> +#ifndef __LINUX_BLK_CRYPTO_PROXY_H
>> +#define __LINUX_BLK_CRYPTO_PROXY_H
>> +
>> +#include <uapi/linux/blk-crypto-proxy.h>
>> +#include <linux/types.h>
>> +
>> +struct blk_crypto_profile;
>> +
>> +/**
>> + * struct bcp_hypervisor_ops - hypervisor VM identity operations
>> + *
>> + * Translates a hypervisor-specific VM fd to the opaque u32 vm_id used
>> + * throughout blk-crypto-proxy.  Register once at module init time.
>> + */
>> +struct bcp_hypervisor_ops {
>> +	/**
>> +	 * @get_guest_id: Resolve @vm_fd to an opaque guest identifier.
>> +	 *
>> +	 * Verify the caller is permitted to act on behalf of the VM and write
>> +	 * its u32 id to @guest_id_out.  The value is passed verbatim to
>> +	 * bcp_slot_virt_ops callbacks.
>> +	 *
>> +	 * Returns 0 on success, -errno on failure.
>> +	 */
>> +	int (*get_guest_id)(int vm_fd, u32 *guest_id_out);
>> +};
>> +
>> +/**
>> + * bcp_register_hypervisor_ops() - register the hypervisor op-set
>> + * @ops: op-set to register; must remain valid until unregistered.
>> + *
>> + * Returns 0 on success, -EBUSY if an op-set is already registered.
>> + */
>> +int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
>> +
>> +/**
>> + * bcp_unregister_hypervisor_ops() - unregister the hypervisor op-set
>> + * @ops: must be the pointer that was passed to bcp_register_hypervisor_ops().
>> + *
>> + * Blocks until all in-flight callers have finished, then clears the
>> + * registration.  Safe to call from module exit.
>> + */
>> +void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
>> +
>> +/**
>> + * struct bcp_slot_virt_ops - ICE keyslot virtualization operations
>> + *
>> + * Per-VM ICE keyslot accounting and virtual-to-physical slot translation.
>> + * The implementation owns the slot allocation table and is registered once
>> + * at platform driver probe time.
>> + *
>> + * @profile is passed to every callback so an implementation supporting
>> + * multiple storage controllers can distinguish between them.
>> + *
>> + * All callbacks may be called concurrently and must not sleep (called
>> + * under RCU read lock).
>> + */
>> +struct bcp_slot_virt_ops {
>> +	/**
>> +	 * @get_guest_slots: Return the number of ICE keyslots allocated to @guest_id.
>> +	 *
>> +	 * Returns the slot count (≥ 1) on success, -ENOKEY if @guest_id is
>> +	 * not in the allocation table.
>> +	 */
>> +	int (*get_guest_slots)(struct blk_crypto_profile *profile, u32 guest_id);
>> +
>> +	/**
>> +	 * @vslot_to_pslot: Translate a VM-local virtual slot to a physical slot.
>> +	 * @guest_id:       hypervisor-assigned VM identifier.
>> +	 * @virt_slot:   0-based slot index within @guest_id's allocation.
>> +	 * @phy_slot_out: receives the physical ICE keyslot index on success.
>> +	 *
>> +	 * Returns 0 on success, -ENOKEY if @guest_id is unknown, -EINVAL if
>> +	 * @virt_slot >= the VM's allocation.
>> +	 */
>> +	int (*vslot_to_pslot)(struct blk_crypto_profile *profile,
>> +			      u32 guest_id, u32 virt_slot,
>> +			      unsigned int *phy_slot_out);
>> +};
>> +
>> +/**
>> + * bcp_register_slot_virt_ops() - register the slot-virt op-set
>> + * @ops: op-set to register; must remain valid until unregistered.
>> + *
>> + * Returns 0 on success, -EBUSY if an op-set is already registered.
>> + */
>> +int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
>> +
>> +/**
>> + * bcp_unregister_slot_virt_ops() - unregister the slot-virt op-set
>> + * @ops: must be the pointer passed to bcp_register_slot_virt_ops().
>> + *
>> + * Blocks until all in-flight callers have finished, then clears the
>> + * registration.  Safe to call from module exit.
>> + */
>> +void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
>> +
>> +#endif /* __LINUX_BLK_CRYPTO_PROXY_H */
>> diff --git a/include/uapi/linux/blk-crypto-proxy.h b/include/uapi/linux/blk-crypto-proxy.h
>> new file mode 100644
>> index 000000000000..dc8adc8ef5ed
>> --- /dev/null
>> +++ b/include/uapi/linux/blk-crypto-proxy.h
>> @@ -0,0 +1,122 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +
>> +#ifndef __UAPI_LINUX_BLK_CRYPTO_PROXY_H
>> +#define __UAPI_LINUX_BLK_CRYPTO_PROXY_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/ioctl.h>
>> +
>> +#define BCP_DIR_READ     0
>> +#define BCP_DIR_WRITE    1
>> +
>> +/*
>> + * BCP_BIND_CONTEXT - bind a host block device and hypervisor VM fd.
>> + *
>> + * Must be called once after open(), before any other ioctl.
>> + * Returns -EBUSY if already bound, -EOPNOTSUPP if no hypervisor op-set
>> + * is registered.
>> + *
>> + * @block_dev_fd: fd of the host block device to bind.
>> + * @vm_fd:        hypervisor VM fd identifying the guest.
>> + * @reserved:     must be zero.
>> + */
>> +struct bcp_bind_context_arg {
>> +	__s32 block_dev_fd;
>> +	__s32 vm_fd;
>> +	__u32 reserved;
>> +};
>> +
>> +/*
>> + * BCP_GET_CRYPTO_CAPS - query crypto capabilities of the bound block device.
>> + *
>> + * Requires BCP_BIND_CONTEXT; returns -ENXIO otherwise.
>> + *
>> + * @key_types_supported:  [out] BLK_CRYPTO_KEY_TYPE_* bitmask.
>> + * @max_dun_bytes:        [out] maximum DUN bytes supported.
>> + * @max_slots:            [out] maximum ICE keyslots available for the bound VM;
>> + *                              0 if the VM is not found in the table.
>> + * @num_modes:            [in] capacity of the buffer pointed to by @modes_ptr,
>> + *                              in entries. [out] number of entries actually
>> + *                              written to @modes_ptr (may be less than the
>> + *                              given capacity; the caller must use this
>> + *                              value, not its own capacity, to know how many
>> + *                              entries are valid).
>> + * @modes_ptr:             [in] pointer to a caller-allocated __u32 array of
>> + *                              at least @num_modes (as given) entries. Must
>> + *                              be non-NULL if @num_modes (as given) is > 0.
>> + *                              On return, holds a per-mode data_unit_size
>> + *                              bitmask array indexed by VIRTIO_BLK_CRYPTO_MODE_*
>> + *                              (virtio wire numbering, uapi/linux/virtio_blk.h)
>> + *                              -- NOT by enum blk_crypto_mode_num. Index 0 is
>> + *                              reserved and always 0, matching struct
>> + *                              virtio_blk_crypto_modes.modes[].
>> + *
>> + * @modes_ptr is a pointer + count rather than a fixed-size array embedded in
>> + * this struct so that sizeof(struct bcp_get_crypto_caps_arg) -- and hence the
>> + * _IOWR-encoded ioctl number -- does not depend on VIRTIO_BLK_CRYPTO_MODE_MAX.
>> + * The caller and this kernel may be built against different virtio_blk.h
>> + * versions (and thus different values of that constant); embedding a
>> + * VIRTIO_BLK_CRYPTO_MODE_MAX-sized array directly in this struct would make
>> + * the ioctl fail to even dispatch (-ENOTTY) whenever the two disagree.
>> + */
>> +
>> +struct bcp_get_crypto_caps_arg {
>> +	__u32 key_types_supported;
>> +	__u32 max_dun_bytes;
>> +	__u32 max_slots;
>> +	__u32 num_modes;
>> +	__aligned_u64 modes_ptr;
>> +};
>> +
>> +/*
>> + * BCP_SUBMIT_IO_BY_VSLOT - submit an encrypted bio using a virtual slot.
>> + *
>> + * The kernel resolves virt_slot to a physical ICE keyslot and submits the
>> + * I/O synchronously.  Large requests are split at data-unit boundaries
>> + * (BIO_MAX_VECS pages per bio).  Requires BCP_BIND_CONTEXT; returns -ENXIO
>> + * otherwise.
>> + *
>> + * @virt_slot:           guest-visible slot index (0-based within the VM's range).
>> + * @direction:           BCP_DIR_READ or BCP_DIR_WRITE.
>> + * @flags:               must be BCP_SUBMIT_IO_F_IOV.
>> + * @data_unit_size_bits: log2 of the encryption data unit size in bytes.
>> + * @sector:              start sector (512-byte units).
>> + * @dun:                 data unit number (single 64-bit limb, little-endian).
>> + * @iov_ptr:             pointer to scatter-gather array of struct bcp_iovec.
>> + * @iov_cnt:             number of entries in @iov_ptr[].
>> + * @reserved2:           must be zero.
>> + *
>> + * @sector, @dun and @iov_ptr use __aligned_u64 to guarantee identical struct
>> + * layout between 32-bit and 64-bit callers, as required by
>> + * .compat_ioctl = compat_ptr_ioctl.
>> + */
>> +
>> +/* Maximum iovec segments per BCP_SUBMIT_IO_BY_VSLOT call (matches UIO_MAXIOV). */
>> +#define BCP_MAX_IOV            1024
>> +
>> +#define BCP_SUBMIT_IO_F_IOV    (1U << 0)	/* scatter-gather mode; must always be set */
>> +
>> +struct bcp_iovec {
>> +	__u64 iov_base;
>> +	__u64 iov_len;
>> +};
>> +
>> +struct bcp_submit_io_by_vslot_arg {
>> +	__u32 virt_slot;
>> +	__u32 direction;
>> +	__u32 flags;
>> +	__u32 data_unit_size_bits;
>> +	__aligned_u64 sector;
>> +	__aligned_u64 dun;
>> +	__aligned_u64 iov_ptr;
>> +	__u32 iov_cnt;
>> +	__u32 reserved2;
>> +};
>> +
>> +#define BCP_IOC_MAGIC    0xC7
>> +
>> +#define BCP_BIND_CONTEXT       _IOW(BCP_IOC_MAGIC, 1, struct bcp_bind_context_arg)
>> +#define BCP_GET_CRYPTO_CAPS    _IOWR(BCP_IOC_MAGIC, 2, struct bcp_get_crypto_caps_arg)
>> +#define BCP_SUBMIT_IO_BY_VSLOT  _IOW(BCP_IOC_MAGIC, 3, struct bcp_submit_io_by_vslot_arg)
>> +
>> +#endif /* __UAPI_LINUX_BLK_CRYPTO_PROXY_H */
>> -- 
>> 2.34.1
>>

