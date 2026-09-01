Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0047DF84
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 10:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259744; cv=none; b=IgyTdlObwsgbFUwvoeW8LjbxhR5E4EQHSYsykUX0qPvM2YU4WiwRQTlxf3gdwAatiIyDG/NqE3TxMfNkBlPffLv5j9i0IHknjN3hIgsf8o0zBIpzW7yCi4W4Kr4fjJlVm4QlTQoYWhflBO8GHDbvpkYfCr9Ej8u/TmTvXa48exc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259744; c=relaxed/simple;
	bh=SLGSseQaf0vJp+4kOQXKmxaBEuZ8Z93Jn47quXknsh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQWTZGv4i4TICwiSNAYHeefNlYf4dPyIxfzQE2duyPNkA2fWlAVX5ZG1LyZP1ymZvEqKxkY6ntbeph0MY131YwORlz1e6OtV110EVAoh31TIjdUOEAMsMvk1vJbPmMlyoWdhj46heN0Q7NAyyzAB3HQf54tuf5ZSfHazOjZeoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T0tDVZcd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MKMfKjbe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T0tDVZcd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MKMfKjbe"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJbhM2323353
	for <linux-scsi@vger.kernel.org>; Tue, 1 Sep 2026 10:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=; b=T0tDVZcdsuc35KoL
	Gl6yMhEOiZ77racbSuMPOeyFCek1TfOwHIawgO58AD9OmvRvrARY9NNGUnCcHrMn
	Hk58PTGkYRaetFb9JtWN9d5dCPDB+51x3xDF20d07maqT2CRv5oPFo1qP/6huy4V
	SBL/fT9yi09owKqSlStcb1zk8wojBlOpQAT4bz7n7S88JLlFeZJqvbsF4C5fdWow
	PL7iWTXsp26kkr4zeqPTC/6WPQZnP5b3rF4g8SeCBgIHcqgBYdgfgubpbUI9J2PH
	7GJKwOwuD6uMGiZXuqdhzTbzR+TBcyy5usm+NBIinlvT1wx4GpXrpn6eksXn6r4N
	8YE1qg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdp7ca10u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 10:49:01 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0aso1464201a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 03:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788259741; x=1788864541; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=;
        b=MKMfKjbelcA0HP11llbBwNuf/bV6IYf7La50QZxNGwMoYKO4HFLdT4p+8qpIv0y2NL
         +xoxJ7jPxFlr1FyOqiMkft2z7WQcHB26SOoPFBi4iw0t32IeeqobyFOTB71uDNANuCHl
         W+ZqJiwArus59xfi1o7MTapVLj8k/HEIy7l3AYld2Yr4nfpC1rr8Nkz7rssnftWdDEO8
         7XKTKIhHdLTii5BCMZuUKrT4iwwi/DOxqhd0tTxTc/mVl4IX6pXUnSRtOM4OCu3odWFa
         4pKMZDMhdQ+Bjm40WD1TW7zp9TR2waKTSUiUh64jtVCbfxqXHGVhSFNpwcgIPq7AdCWH
         eoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788259741; x=1788864541;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=;
        b=H+cJrUbmnt7K6vYbtojHzsr5+EFe0gjdS/ArCAOb6ovVB4G+MxuFT4U9ctRYpiwZW6
         hV1DwbkX6RbCZHZTYrwf6mon1eLHDKyyxcLBvu0/CbwXxOLZukx7H5VXFH6Z9PIUhZTS
         pa84j+I5+7QQ4IDR3jWQUiUHytYYyPp3ZkFvGu+XxwLFXM025J56YSyTYbXTR6F1v9NH
         dOmAJvYuHZmOIKg0X6uiuqoeDkKmi96vTrRjZF3QNtq3/0ANG1qqEf0EQTQw76EKCguG
         49+O156YlDmp3qcZCazFsMADnrzu5g0GGesH64xW3V/I5tCFwPptwOrfQUFaNMkKxcoI
         H5iw==
X-Forwarded-Encrypted: i=1; AKwUvBxYeTWY/OlAyOcN23K5j9F5ytIDPqxKFQ1cTlLFz9BuHfw0tE61ctq2dMTJxS706pRpTCR7LqwKH3JU@vger.kernel.org
X-Gm-Message-State: AFuF++noc8THthG3exaZYnKJWih4GAkn1r1xj+EuN6rbUVKGL+yTayrU
	gMUxmVwWp8l03CVHvRRVFgcgPazC2rbFeDGg2BctpGgkQy+8y4TQSNPf2QNLGnBRFv8yDjk8kRf
	Eu4HGS2uRDBhr7AJMpOa/HKAqeXK/smPjGs0u3lRL88KtlF0h9aNh1eQs3hBR9B+O
X-Gm-Gg: AYBFou19Fej5scoh65zE7rERhXysSSPp3yI+DcnAlI8bPP6djCUcBR4HG4oIa59AWsf
	hgXUyY4lF/bFMFg3zgGOsYx+WEmvzZHuP6tgq/e/eCMqdWJqS75bIwe7QoD+ly49VnKnnJV9tk2
	1S3OJ8RKGqVEXBs1xPZfwgCvN7t45X++392QGHKioAoiE7OxCuhgvb4UH2nf6MLZ1zweytyPlFc
	qO8jZbM7mX+pyXREPusSNZbhS/4K7tTiF6PCAsLF6dUWhjKKCFNHffm/Iu740boshUe/IM777Xx
	fEeukLofC8bkGFqLpjBr7B8bc+TyKNtJJEFKTEpGHFwWU1qwn8hX0djPjQKSBr3/93jabS0q1bI
	klxdjyVVjtBil6YJlt8pwdT9vopcHBQddgtLpQcLQavFNpvk0OH5E3/AJ
X-Received: by 2002:a17:90b:5586:b0:398:c8f3:d076 with SMTP id 98e67ed59e1d1-3990f93210fmr4804428a91.31.1788259739707;
        Tue, 01 Sep 2026 03:48:59 -0700 (PDT)
X-Received: by 2002:a17:90b:5586:b0:398:c8f3:d076 with SMTP id 98e67ed59e1d1-3990f93210fmr4803842a91.31.1788259734429;
        Tue, 01 Sep 2026 03:48:54 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b5bef7683sm23429688eec.12.2026.09.01.03.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 03:48:54 -0700 (PDT)
Message-ID: <4d2d0d17-391c-4c81-8748-bf1025ea6f75@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 18:48:46 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/11] soc: qcom: add ICE keyslot partitioning driver
 for guest VMs
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
 <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
 <e23142e8-41b3-40f5-9d63-53c9c38fba38@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <e23142e8-41b3-40f5-9d63-53c9c38fba38@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=OcyoyBTY c=1 sm=1 tr=0 ts=6a96ad9d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=puuXhSqztIu-OQ_ZuWYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-ORIG-GUID: s6gyxOiuUZsItgSteo98LMSMMxwlESXp
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+BWvBrfQSx74
 c/KpdxJ7GNnUc+ADopIn225830jV69TBwRBFNZLTsKboDgaqC8nn28k/zk45lgI8OjwRcNKHq/z
 hWU9BfGzhzWvP+adFGzKxaiiYghvuj4=
X-Proofpoint-GUID: s6gyxOiuUZsItgSteo98LMSMMxwlESXp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6SiI5mmlJxXM
 0qgL9GMhgwP9RcwmkrLs0dFcOw4bQtrQnUx+kFlb83VahaMP5Ui2BlbB4LkKQ5ucpPAtQ5cRgS4
 5AOrGXahVt6nqzwQ21hVmea2ZUxMo4GNXUtutS+DqFiCPEFrXr//9hdprHMYMSBKJeoAYLnQ3db
 kNWb/rED5UnfDdnRp8V044j4H/7+a6+fNm6fpIZZ5qmIBa3Joc9kxlL+DI6GH162aBpTivRT+n7
 OSS1FjnShAlO00JwyGuet96vptZDBX4J9vH1mlycdYIRzhf82Ri+vNI+ZFI3HKuClNz0oqmXmUo
 wXC9Qkke7TeqXg/Q+PDmKVlAbxgV/7Xz380l+dd4Qz7GUe5hH4mEJ2FkxaW1Rh6TCvmGIm+CQ9J
 NzzNJiDDASRie6eu9BiMUL6miVbc66sowObW9JuDyMOZVmG6+RuR4jhQgvbZJ5OcnAUAuZ4oonM
 r0amn6B3MLiKhDGT0Ow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010095



On 8/31/2026 3:02 PM, Krzysztof Kozlowski wrote:
> On 27/08/2026 18:07, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> On Qualcomm platforms the ICE hardware has a fixed number of physical
>> keyslots shared across the host and all guest VMs.  A userspace
>> virtio-blk backend handling VIRTIO_BLK_T_CRYPTO_IN/OUT requests needs
>> to translate a guest's virtual keyslot index to the corresponding
>> physical ICE keyslot without letting one VM access another VM's slots.
>>
>> Add QCOM_ICE_SLOTS, a platform driver that implements bcp_slot_virt_ops
>> for the /dev/blk-crypto-proxy device.  It parses a
>> qcom,ice-keyslot-map device-tree node describing the per-VM keyslot
>> allocation table, where each child entry maps a guest_id to a
>> contiguous physical slot range [slot_offset .. slot_offset +
>> max_ice_slots).  Entry 0 is reserved for the host; guest entries start
>> at index 1 and are excluded from the guest-facing translation so that
>> blk-crypto-proxy cannot accidentally route a guest request into the
>> host's physical keyslots.
>>
>> The driver exposes two callbacks:
>>
>>   get_guest_slots()  — return the number of ICE keyslots allocated to
>>                        a given guest_id; used by BCP_GET_CRYPTO_CAPS to
>>                        populate the max_slots field in the virtio config
>>                        space.
>>   vslot_to_pslot()   — translate a (guest_id, virtual-slot) pair to the
>>                        corresponding physical ICE keyslot index; used by
>>                        BCP_SUBMIT_IO_BY_VSLOT before calling
>>                        bio_crypt_set_ctx_by_slot().
>>
>> The singleton pointer to the parsed table is RCU-protected; the hot
>> path reads it lock-free.  Probe validates that no two VM entries share
>> a guest_id or overlapping physical slot ranges.
>>
>> Note: This patch is submitted for visibility. The keyslot partitioning
>> is based on the current DT-based keyslot allocation with vm_id known.
>> We are aware this may be revised to use a TZ SCM query interface in a
>> future version of this series, submit it RFC for design discussion.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/Kconfig          |  18 +++
>>  drivers/soc/qcom/Makefile         |   1 +
>>  drivers/soc/qcom/qcom_ice_slots.c | 232 ++++++++++++++++++++++++++++++
>>  3 files changed, 251 insertions(+)
>>  create mode 100644 drivers/soc/qcom/qcom_ice_slots.c
>>
>> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
>> index 6c632d114d45..e1f383b4dc63 100644
>> --- a/drivers/soc/qcom/Kconfig
>> +++ b/drivers/soc/qcom/Kconfig
>> @@ -294,6 +294,24 @@ endif
>>  # Options selected by other drivers from different subsystems must be outside
>>  # of the menuconfig if-block:
>>  
>> +config QCOM_ICE_SLOTS
>> +	tristate "Qualcomm ICE keyslot partitioning for VM guests"
>> +	depends on ARCH_QCOM || COMPILE_TEST
>> +	depends on BLK_CRYPTO_PROXY
>> +	depends on BLK_INLINE_ENCRYPTION
>> +	help
>> +	  Parses the qcom,ice-keyslot-map device-tree node and provides
>> +	  per-VM ICE keyslot accounting and virtual-to-physical slot
>> +	  translation for guest VMs sharing ICE hardware on Qualcomm
>> +	  platforms.
>> +
>> +	  When enabled, guest virtual keyslot indices are mapped to the
>> +	  physical ICE keyslot range allocated to each VM, preventing one
>> +	  VM from accessing another VM's keyslots.
>> +
>> +	  Say M here when multiple VMs share ICE keyslots on a Qualcomm
>> +	  platform.  If unsure, say N.
>> +
>>  config QCOM_INLINE_CRYPTO_ENGINE
>>  	tristate
>>  	select QCOM_SCM
>> diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
>> index 6d4b7546d1fb..952a57554f9d 100644
>> --- a/drivers/soc/qcom/Makefile
>> +++ b/drivers/soc/qcom/Makefile
>> @@ -38,6 +38,7 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
>>  obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
>>  obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
>>  qcom_ice-objs			+= ice.o
>> +obj-$(CONFIG_QCOM_ICE_SLOTS)	+= qcom_ice_slots.o
>>  obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
>>  obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
>>  obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
>> diff --git a/drivers/soc/qcom/qcom_ice_slots.c b/drivers/soc/qcom/qcom_ice_slots.c
>> new file mode 100644
>> index 000000000000..364ac93077c1
>> --- /dev/null
>> +++ b/drivers/soc/qcom/qcom_ice_slots.c
>> @@ -0,0 +1,232 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * qcom_ice_slots.c - Qualcomm ICE keyslot partitioning for guest VMs
>> + *
>> + * Implements bcp_slot_virt_ops: translates a (guest_id, virtual-slot) pair to
>> + * a physical ICE keyslot index using a per-VM allocation table parsed from
>> + * the device-tree node with compatible = "qcom,ice-keyslot-map".
>> + *
>> + * Device-tree layout:
>> + *
>> + *   ice_keyslot_map: ice-keyslot-map {
>> + *       compatible = "qcom,ice-keyslot-map";
> 
> NAK, there is no such stuff.
> 
> Drivers for undocumented downstream DTS are not allowed.
> 

ACK

This is used to set slot mapping table in DT node. It will be moved
to Trust Zone if current out-of-band key operation is approved. Otherwise,
if virtio block devices implement blk_crypto_ops, this driver is unnecessary.

> ...
> 
>> +
>> +	dev_info(dev, "registered: %u VMs, %u total ICE slots\n",
>> +		 idx, total_slots);
> 
> This does not look like useful printk message. Drivers should be silent
> on success:
> https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/coding-style.rst#L913
> https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/debugging/driver_development_debugging_guide.rst#L79

ACK

> 
> 
> Best regards,
> Krzysztof

