Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AFF3C1F41;
	Mon, 31 Aug 2026 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159791; cv=none; b=McW9kMFpRMQrktq+VXbtdlrDYI5ykDz3iLeOLvVm/ZK7RAw0YgCLK9JEDqISFuLga/5VDj6TojIpZle47wZ/qAhWPGRTMlYjAvOHdOV8OCYH1p01RieKiY421xtChEbHr1mGwZh4H2rscIGQMdqiEU3D5FZmxc/ANKBcFxfGQv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159791; c=relaxed/simple;
	bh=FuQ851PfshFiRk3uhpNVrhVFhLs/jdwnfxgD2UpyroM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nf+iH71fQQ7wfphhgDhGI+6Vg36EkfdlWRSolNHM4GK/+cgEqYKNdplULKJ9AREejtPKdP06YDDIp8xncFI3i4DHtt0Pbx3lVCh63W1M6ifI2Ipyr7DyRORrZdLY0yYyL3CHVx0daSr9JPJUctBPfEoMdkBDDVYcnl555e2djpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7ETrDor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7ETrDor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E891F000E9;
	Mon, 31 Aug 2026 07:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788159790;
	bh=gtysBxzeGSXmu4wHgGSC8bfmfpjHhEjufETjVjxWzso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a7ETrDorflER8l8a2z0hsi/GQ1tOv95n9Gx0gj3bbf2vlFVZoIL5vgaGPgO2y5HzF
	 4oIrqmljOSuPYewQ4xxJFqwNOmaikEYjjwSP/SRC1j1IrRLlAxnIRkqszzj+on7Kg0
	 QUeLovttgmvOZW9TnEMsEv+qrtsOVdEruxuOWaqkqaG4As7AKU2aMI32i3Tq9S4fwp
	 yD3xuFCS6kOo4wEkQZSIM+hoRaD9s7iRkZZsyJ4/Y1hlWIzTP1TxGwi/W8wiYqUN33
	 M8O6EfuIxVt66VQgTDGHMRpVGEnPINIvqj9QZfgctPK3KTZskMwHhbAz0cjOGj/GYX
	 uvwmTlKbPxOnw==
Message-ID: <e23142e8-41b3-40f5-9d63-53c9c38fba38@kernel.org>
Date: Mon, 31 Aug 2026 09:02:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/11] soc: qcom: add ICE keyslot partitioning driver
 for guest VMs
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
 <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 27/08/2026 18:07, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> 
> On Qualcomm platforms the ICE hardware has a fixed number of physical
> keyslots shared across the host and all guest VMs.  A userspace
> virtio-blk backend handling VIRTIO_BLK_T_CRYPTO_IN/OUT requests needs
> to translate a guest's virtual keyslot index to the corresponding
> physical ICE keyslot without letting one VM access another VM's slots.
> 
> Add QCOM_ICE_SLOTS, a platform driver that implements bcp_slot_virt_ops
> for the /dev/blk-crypto-proxy device.  It parses a
> qcom,ice-keyslot-map device-tree node describing the per-VM keyslot
> allocation table, where each child entry maps a guest_id to a
> contiguous physical slot range [slot_offset .. slot_offset +
> max_ice_slots).  Entry 0 is reserved for the host; guest entries start
> at index 1 and are excluded from the guest-facing translation so that
> blk-crypto-proxy cannot accidentally route a guest request into the
> host's physical keyslots.
> 
> The driver exposes two callbacks:
> 
>   get_guest_slots()  — return the number of ICE keyslots allocated to
>                        a given guest_id; used by BCP_GET_CRYPTO_CAPS to
>                        populate the max_slots field in the virtio config
>                        space.
>   vslot_to_pslot()   — translate a (guest_id, virtual-slot) pair to the
>                        corresponding physical ICE keyslot index; used by
>                        BCP_SUBMIT_IO_BY_VSLOT before calling
>                        bio_crypt_set_ctx_by_slot().
> 
> The singleton pointer to the parsed table is RCU-protected; the hot
> path reads it lock-free.  Probe validates that no two VM entries share
> a guest_id or overlapping physical slot ranges.
> 
> Note: This patch is submitted for visibility. The keyslot partitioning
> is based on the current DT-based keyslot allocation with vm_id known.
> We are aware this may be revised to use a TZ SCM query interface in a
> future version of this series, submit it RFC for design discussion.
> 
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/Kconfig          |  18 +++
>  drivers/soc/qcom/Makefile         |   1 +
>  drivers/soc/qcom/qcom_ice_slots.c | 232 ++++++++++++++++++++++++++++++
>  3 files changed, 251 insertions(+)
>  create mode 100644 drivers/soc/qcom/qcom_ice_slots.c
> 
> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 6c632d114d45..e1f383b4dc63 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -294,6 +294,24 @@ endif
>  # Options selected by other drivers from different subsystems must be outside
>  # of the menuconfig if-block:
>  
> +config QCOM_ICE_SLOTS
> +	tristate "Qualcomm ICE keyslot partitioning for VM guests"
> +	depends on ARCH_QCOM || COMPILE_TEST
> +	depends on BLK_CRYPTO_PROXY
> +	depends on BLK_INLINE_ENCRYPTION
> +	help
> +	  Parses the qcom,ice-keyslot-map device-tree node and provides
> +	  per-VM ICE keyslot accounting and virtual-to-physical slot
> +	  translation for guest VMs sharing ICE hardware on Qualcomm
> +	  platforms.
> +
> +	  When enabled, guest virtual keyslot indices are mapped to the
> +	  physical ICE keyslot range allocated to each VM, preventing one
> +	  VM from accessing another VM's keyslots.
> +
> +	  Say M here when multiple VMs share ICE keyslots on a Qualcomm
> +	  platform.  If unsure, say N.
> +
>  config QCOM_INLINE_CRYPTO_ENGINE
>  	tristate
>  	select QCOM_SCM
> diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
> index 6d4b7546d1fb..952a57554f9d 100644
> --- a/drivers/soc/qcom/Makefile
> +++ b/drivers/soc/qcom/Makefile
> @@ -38,6 +38,7 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
>  obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
>  obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
>  qcom_ice-objs			+= ice.o
> +obj-$(CONFIG_QCOM_ICE_SLOTS)	+= qcom_ice_slots.o
>  obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
>  obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
>  obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
> diff --git a/drivers/soc/qcom/qcom_ice_slots.c b/drivers/soc/qcom/qcom_ice_slots.c
> new file mode 100644
> index 000000000000..364ac93077c1
> --- /dev/null
> +++ b/drivers/soc/qcom/qcom_ice_slots.c
> @@ -0,0 +1,232 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * qcom_ice_slots.c - Qualcomm ICE keyslot partitioning for guest VMs
> + *
> + * Implements bcp_slot_virt_ops: translates a (guest_id, virtual-slot) pair to
> + * a physical ICE keyslot index using a per-VM allocation table parsed from
> + * the device-tree node with compatible = "qcom,ice-keyslot-map".
> + *
> + * Device-tree layout:
> + *
> + *   ice_keyslot_map: ice-keyslot-map {
> + *       compatible = "qcom,ice-keyslot-map";

NAK, there is no such stuff.

Drivers for undocumented downstream DTS are not allowed.

...

> +
> +	dev_info(dev, "registered: %u VMs, %u total ICE slots\n",
> +		 idx, total_slots);

This does not look like useful printk message. Drivers should be silent
on success:
https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/coding-style.rst#L913
https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/debugging/driver_development_debugging_guide.rst#L79


Best regards,
Krzysztof
