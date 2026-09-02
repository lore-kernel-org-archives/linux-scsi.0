Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4852437880B
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 05:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328708; cv=none; b=DbONd6AiShk7ao7QNnjJRZUzZaB1B87Z/xmyFTqee68LZXM9Cy/AYiv4MwP5u1ug4/KdMDh7DpYSLQdILEMZn5wJ5AIhdbQVxRToOTjaJXFd+2OYIVCI1v/Nl3W/xLOo9f1SNQZlfCiJ/n+hnCvvN61Z65Ie47OLHARBK5DiPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328708; c=relaxed/simple;
	bh=YU8UPMKZ/ySiuNk1+MpS6FNLDJVxn5Pnh3Srux/+E3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRhp0QZN3Hn6xh5V4FuOWC5gDKuoOIjXZOVDx2I9f78+oLXKGDjnPFJHE3dCF/lsZaH0/ckaeiDJKeEhHBBm1JBgry25nx0ys4bJMR3gli8vloyLAX/ug/qZEo82psawLfxH90fv3C8ojPXQUzFhkzRqzn5feh3K2KwyeMh5V/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z3Cupj4x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VvGu/Hbs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z3Cupj4x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VvGu/Hbs"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6825YHtH4146081
	for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2026 05:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=; b=Z3Cupj4xK0M8m9+n
	HjPNoKTjeyNo+c+jG+BW7b81ZBszWFE9bGKqqv8VtmKwpjwQmAyzR9DQy6XOEOTn
	JIik4SxlBmNoATDKXWCRQOhT1fTMHvT+qwulbIt7juSNHHiX/sfhKDwfUPiA/vMp
	Rb1Lz+1LQuMZlkDq/BmEUf/fRmTSsKks3w9dcB9pHDaM5AZYj6bxXdUhl5/JO6r1
	qTgIw7Qh7P9izcq01KhGO8WPbBSMNT4QlAB8p2HTuw8skaSvhoN7q0g9q+j71Yfi
	8nMskBlrvZH0VVkD4Fejfvz5RHKCV/nQCnOGHuDmB3DZXWw5NCwZAfxoUbguo3IS
	cLMX2g==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge35k2d4n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 05:58:26 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1340428a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 22:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788328706; x=1788933506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=;
        b=VvGu/HbsQTDRB/ELpMwv5hYLbnia3iQxcd+R0H6MWLsbUYg+8sZW9KzB+VNB+8ay+5
         c2H6lU/rEFspuzoxYak5vrp5XqtI7dEiT/BNAgX9IDO2YsFSfcqOgR6pFq3fQcsQ7j3V
         Zp1clPfH3sQ5kAUaZwKCNiCtUbWt9ASnNsAPsAqzDx54ols1X9AzsNnQONorAmrB3oXH
         VjJGsDm+Q/sorQw3cMA94OjHS2exuguMQTJCT3wl5nJMq93sI8BgM68nJ1HuFEOxkABK
         /RCNorTM2Hknmm5/1RK0VtQys/jIl6unKerOLfqtATwpsxqOKjrW9JzA9DbzO5TBPuOF
         +9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788328706; x=1788933506;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=;
        b=hj71xQtcGPKd3VYtOBX7ByhxPQacb7n7CSe5M8E4YcE1tz8OKNPGGimB9sU4dQCH3L
         KXITK7ent0ucYBkNHXv9v2ayYbtFIJ6rJ9/6hs1XJLb6eVDD81aKtchdPLuSK5flRjnV
         8QLxBeToOzfltT4CsfIwAIml1V4ceHav0qXw0ZUZta3/TgV9rCac8lkRg+mAD1MABGn2
         I3HlX6f7iLMDF8msLx6rcyNg1QB1Rg2Sm8CyNXFZ1huUtmZgzWOs8ycNOtY6T6qDIvNP
         0oTP0Z3pYsrIjs4NfI1zECqfwsVl5Nsxnm7d/fLLq+k9wKl6JZSFwzFqLNB8sGjpvyoT
         lUMw==
X-Forwarded-Encrypted: i=1; AKwUvBwpBfLiylfzHo4EAT2kDICgqqh37Cvn2Atvf5L2Cyk6Auyj7YPwRmdWvoBq+vcnlhne9ON1D3xF89I3@vger.kernel.org
X-Gm-Message-State: AFuF++nBU1qGUSkRFdKZ1uD9S1k4nZHhLHteCKDDZEr9ZtElp/Zh1yL7
	046WOa9TtNthoyW/suvFcTUfDFeaJ/2oel2iawEA1Jv+gG6032QxJ1lqXMiAsuLPifMv70nZAEt
	SmID+ap/tUFr3gEK0DR1FCsVDPWJ5QnvNlt9uYCbEcwEG8ggvU4gWntUGdmuDQkCb
X-Gm-Gg: AYBFou3E1yHvKPw6evG966FTQB2/4tYLMQzzxQTwA5U0WYu65wVKKpfZAkdBOUkAj6i
	KLksUMmIV3XabHD2rWPgZyWus+OvyB4qF/k42AhoLlB/QAoL/Av3Bwhh+VcuPYjyhJf2Jv0kzvZ
	dl6AhTIaTrObZh82fW6DnNtvI4JR7US8aIHlT04mQvrHtPAslApxE+ZGEyUw+HSGt7cha8Ml2Hf
	ZxWjpD3SpbjrUqujvbuiJyoBJFSXA1fRTf+BJ3652cBZ1hePjUD0dC1HBlguLymqCPHNQwtbxyI
	cJmnj76GBvFspINxrtOAcT3roN0qmHzCGblr55xRDM8QD9n2ybzKY1DrvA4UdWhPDJMVd34qXTy
	8sHRcbSladJbK7/iFTE5B8vOBckHRxBgle2FnAJtlUoubFtV1ZOzJf77U
X-Received: by 2002:a17:90b:4ac9:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39aee0b498dmr2783819a91.19.1788328705739;
        Tue, 01 Sep 2026 22:58:25 -0700 (PDT)
X-Received: by 2002:a17:90b:4ac9:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39aee0b498dmr2783746a91.19.1788328705240;
        Tue, 01 Sep 2026 22:58:25 -0700 (PDT)
Received: from [10.110.50.50] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07b79898sm3792600eec.15.2026.09.01.22.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 22:58:24 -0700 (PDT)
Message-ID: <d7229be4-36f9-4050-8a45-1f89b1283b9a@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 13:58:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/11] virtio_blk: add inline encryption support
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
 <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
 <20260901194817.GE729142@fedora>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260901194817.GE729142@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfXxebxUk2//Lf5
 zMd4OKoWvuiE2PEW2+EVZbsVXPtIreA2uKJCp1M5LckGnAvruKoz7IJYUuJKf6161gBKSwqgvON
 A/dBEtSXER/8YmaseJe0lQJlduHjLyrNO4w6U0AWWXHVKZ2wxONUsDLryXOW9sbYz9/q7yR66ji
 Cd2GcP8YNCtv4IC60spAgzKIEPtDLOBnUf3dVIs4OnIah67UvxLxOt2ToNyl8vCcf6kXkjts1BA
 6MLF9zpXT67lONnWWDoH5pHoC/oIaNtS6eN47cWSBnfdfOjcMPbne9YVcOUCgththeaQyZAHfhZ
 KaES6U8E+3ZFPIrNeFmBeR31uhKHGByPhmj0ixnfEKeaZL5n/kGPxa6JZNX4iPdLLPIEsukySzR
 ErujMSvK0V2NsegnNwnc8NOOZWOLQt6h+sqPTUHegjZ5WOZ42YKBZd3tdS2vwaMcDgO9aJ9wkeX
 o+lBRiVJBVaPdCrP0DA==
X-Proofpoint-GUID: PGBDi1To2OJotRkdzECxaltjL97R5rk2
X-Proofpoint-ORIG-GUID: PGBDi1To2OJotRkdzECxaltjL97R5rk2
X-Authority-Analysis: v=2.4 cv=VLrtWdPX c=1 sm=1 tr=0 ts=6a97bb02 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=dlkBk7sggpSz48gVZtEA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX91Ee2baNDGln
 LBxNZVGkx/6oeDZIR87tZXle6wh6pdtflp5EJeMmH6uhSPL2tATx9SiYLs/1BGiVNojdveHmhTU
 OujBFjMEoA07i9/zEPxps7PMh75mrXE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020051



On 9/2/2026 3:48 AM, Stefan Hajnoczi wrote:
> On Thu, Aug 27, 2026 at 09:07:10AM -0700, Linlin Zhang wrote:
>> From: linlzhan <linlzhan@qti.qualcomm.com>
>>
>> Negotiate VIRTIO_BLK_F_INLINE_ENCRYPTION with the host and wire it into
>> the block layer's inline-crypto framework to enable inline encryption
>> on virtio block device.
>>
>> When the feature is present, the driver reads crypto characteristics from
>> virtio config space (key-slot count, DUN size, supported key types) and
>> issues VIRTIO_BLK_T_GET_CRYPTO_MODES to discover supported cipher and
>> data-unit-size combinations.  Encrypted requests use new request types
>> VIRTIO_BLK_T_CRYPTO_IN/OUT, which append a virtio_blk_crypto_msg
>> (keyslot index, DUN, data-unit-size-bits) to the standard outhdr.
>>
>> A new virtio block crypto extension driver (virtio_blk_crypto_ext),
>> owns the blk_crypto_profile singleton and the blk_crypto_ll_ops dispatch
>> table. Actual key operations are forwarded to a platform-specific
>> backend registered via virtblk_set_crypto_ops(); without one,
>> VIRTIO_BLK_F_INLINE_ENCRYPTION is still negotiated and the
>> profile is registered, but every keyslot operation returns -EOPNOTSUPP.
>>
>> The shared profile is a singleton as per blk_crypto_profile is
>> corresponding to one ICE hardware: the first device to negotiate the
>> feature initializes it; subsequent devices reuse it only when their
>> negotiated capabilities (slot count, DUN size, key types) match exactly.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/block/Kconfig                 |  13 ++
>>  drivers/block/Makefile                |   2 +
>>  drivers/block/virtio_blk.c            | 199 ++++++++++++++++--
>>  drivers/block/virtio_blk_crypto_ext.c | 283 ++++++++++++++++++++++++++
>>  include/linux/virtio_blk_crypto_ext.h |  78 +++++++
>>  include/uapi/linux/virtio_blk.h       |  62 ++++++
>>  6 files changed, 623 insertions(+), 14 deletions(-)
>>  create mode 100644 drivers/block/virtio_blk_crypto_ext.c
>>  create mode 100644 include/linux/virtio_blk_crypto_ext.h
> 
> Thanks for sending this as we discuss the VIRTIO spec changes.
> 
> Although it's nice to have all the Linux patches together, there are two
> separate parts: 1. the virtio_blk.ko guest driver changes and 2. the
> hypervisor blk-crypto uapi. I suggest splitting this into two patch
> series to avoid confusion between these parts. It may also make review
> and merging easier if we stay focussed on just the guest or just the
> host parts.

Thanks for the comments!

I can separate them as 2 patch series in next patch.

> 
> Stefan

