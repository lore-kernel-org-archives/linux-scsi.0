Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B832941A;
	Mon, 31 Aug 2026 07:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159842; cv=none; b=nkQHbk+sF7at0Xz5HeZ++R9BJccW5cml7iB0ppD7BLyghA4k87T7S+TGtokwK/EH/bDbMYuTtGK0RhW+FcXKLp8KloHB4G+if9D4YM+MFQlLmrqc4yCiLicLoR2Y/ReSxhrHkfgTNYJWnaFZSa8r2hFi/16wDmvr852xv+kIXvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159842; c=relaxed/simple;
	bh=gmNMkW8BJZK0ghbj5E3UG1lGb6HMaLQ+7eEIVm4U4TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aueIJjjPO6MFW3gkEjUct6uxt9BcVD99g0zB8CGS1fIrYLZy44vgFZqALhQqC/hG7bZLcee/u5aL8TJ18r3Sjdl0p+FnXbuXpawN3vnh55rUdcUYDUhK+EPGCz3SoyL9nW9LaEHNSDpLqFIjzeNHUqVXCzU6uji/hpLjs7X2MEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFKrmk+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFKrmk+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696831F000E9;
	Mon, 31 Aug 2026 07:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788159841;
	bh=dn2CLObij1YYUhH1wWw0aDiMly3mPdNFWYv1tBBXevA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AFKrmk+5vDmyG9G8H1JEEwJbmAk+fBzl7A0jPF47kKkG+EJygmQXSJwqVFQbAzhk/
	 PQWVVpn+fKH7QbCTKRdmHwFbsuYrC/B8t8Gz0lS/xu7n/SOD6dRijaAxUSDkoyUoBR
	 gBEi1NI5wl7DxC/qfV/hOWx4BA3YQJYDQfGeltl2TY784nvgMeCm7JtPYj72kkecdA
	 tbubdBPTQfwKEazPBtnDGmq5dwRnog+8wTykLf3KSUrjIcF419bX1TSvaUkxIKVTxl
	 8eiNF0B12+vwHQhjYN33moZ5mka0UJHlAnck/1tYihFEFYWZMlx7lc3ostmD3wvR2I
	 KM0aMaRSvf+pw==
Message-ID: <046e4b62-6d25-40fc-baa3-2978eb96eb70@kernel.org>
Date: Mon, 31 Aug 2026 09:03:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/11] scsi: ufs: ufs-qcom: support ICE keyslot
 partitioning for guest VMs
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, ebiggers@kernel.org,
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
 <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/2026 18:07, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> 
> On Qualcomm platforms where UFS inline encryption is shared between
> the host and guest VMs, the ICE hardware keyslots must be partitioned
> so that each VM operates only within its own physical slot range.
> Without this, the host's blk_crypto_profile would manage all hardware
> slots, conflicting with slots already allocated to guests.
> 
> Add ufs_qcom_ice_parse_slot_table() to read the qcom,ice-keyslot-map
> device-tree node.  The function parses all child entries and validates
> that no entry's slot range or the combined total exceeds the hardware
> slot count from REG_UFS_CCAP.  The first child entry is taken as the
> host's own reservation; its slot count and offset are returned to the
> caller.
> 
> In ufs_qcom_ice_init(), use the parsed host reservation to initialize
> the blk_crypto_profile with only the host's slot count rather than the
> full hardware range.  Set profile->slot_offset so that
> blk_crypto_keyslot_index() returns the correct physical ICE slot
> number when programming hardware.  If no qcom,ice-keyslot-map node is
> present, the existing behaviour (profile manages all slots) is
> preserved.
> 
> Note: This patch is submitted for visibility. The ufs-qcom driver
> gets its max_slots and slot_offset based on the the current
> DT-based keyslot mechanis. we are aware this may need to be replaced
> by a TZ SCM interface, submit it RFC for design discussion.
> 
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 91 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 62396212a0a7..0611ab50f4cc 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -163,6 +163,74 @@ static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
>  		qcom_ice_enable(host->ice);
>  }
>  
> +/**
> + * ufs_qcom_ice_parse_slot_table() - parse qcom,ice-keyslot-map DT node
> + * @dev:          UFS controller device
> + * @hw_max_slots: total physical ICE keyslots reported by REG_UFS_CCAP
> + * @num_slots:    receives host max_ice_slots (0 = no partitioning)
> + * @slot_offset:  receives host ice-slot-offset
> + *
> + * Parses the qcom,ice-keyslot-map device-tree node.  The first child entry
> + * is the host's own reservation; subsequent children are guest reservations.
> + * Validates that no entry's range exceeds @hw_max_slots and that the sum of
> + * all entries does not exceed @hw_max_slots.
> + *
> + * If no qcom,ice-keyslot-map phandle is present, sets @num_slots to 0 and
> + * returns 0.  Returns -EINVAL if any entry or the total exceeds @hw_max_slots.
> + */
> +static int ufs_qcom_ice_parse_slot_table(struct device *dev,
> +					 unsigned int hw_max_slots,
> +					 unsigned int *num_slots,
> +					 unsigned int *slot_offset)
> +{
> +	struct device_node *slots_np, *child;
> +	unsigned int total_slots = 0;
> +	bool first = true;
> +	int ret = 0;
> +
> +	*num_slots   = 0;
> +	*slot_offset = 0;
> +
> +	slots_np = of_parse_phandle(dev->of_node, "qcom,ice-keyslot-map", 0);

No

> +	if (!slots_np)
> +		return 0;
> +
> +	for_each_child_of_node(slots_np, child) {
> +		u32 off, max;
> +
> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))

No, there is no such ABI.


Best regards,
Krzysztof
