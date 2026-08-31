Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52135C69E;
	Mon, 31 Aug 2026 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159428; cv=none; b=nvLVqvhZGnTeJgvILwXCQDX9yy8hzohUEd91kwabDhUWMRfye3LpTcYaIdHkMl3RaklNVcHOSy4Bl/SMnPirGMqWhQwNyLn7IzSzjjD2T7q9stZRmSz8x7eHg6BNpn0t5GEzc9nr/X5nbtmJqSck3Nhk6KC+dNyj0o/xVIvboyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159428; c=relaxed/simple;
	bh=m23XB4gEkQJL9Es5LXuXflPmezKzXFUftiKreIU4ppQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNq+dtl29PQjwl77Vuaup2EKi2D2jqwByJtHmy5veejGnGbgZPsO5m9Q/HAgB7i08PZtPIS8pKaYEWNZQjWH7bC9heIbh0otsvCsJhAPMs0HEUJnnE6o/ZSDXLn6xkyAOPzo0dZah5LoJkkG3OzEor6DoPpw2q6lLXbE0UNhda0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQhosI+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQhosI+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EFF1F000E9;
	Mon, 31 Aug 2026 06:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788159424;
	bh=PVHNgyx2aYNCoOEnb8EC/QQ+u2iOfaOFJGm+gN8AQPI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SQhosI+ZzsHo8MNO93IAnhukvs+fy6ORlUVqG5FUMSiUIxNDUG9y1yNvZw/NgjuZu
	 kxqR/sr7/eAUn7Q/o8pvNPEWRN4X0PSqOIw/sEwViAIXM3c4+I+PYXlc1CvWuDAXa8
	 iIBcXJ+4kgUGjtEXkyMWH12KhF4fHJCI0Mlzp19kIVP6Y4E/FO1o+RcFdSehg1bXqL
	 V5FnABrl045mj0p+/buu7SlO1PpHAQppq7pXrTUsa1Vz61hRTKlScWxvDB6eMcteiJ
	 zdGCvuf1V7JR1jYjuRwDlpiwIPLMaOMSA8zDI+NdTvt25N9/MK9RqRtGKcIn7eF5v1
	 4HugIUCJDdteg==
Message-ID: <f5915133-ffac-4777-b7d9-cf38ba163d43@kernel.org>
Date: Mon, 31 Aug 2026 08:56:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/11] soc: qcom: add crypto_virt backend for
 virtio-blk inline crypto
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
 <20260827160806.1295313-3-linlin.zhang@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260827160806.1295313-3-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/2026 18:07, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
> 
> In a Qualcomm GVM environment the ICE hardware is controlled by the

What is GVM?

> host, GVM has no direct access to it. So, key operation in GVM is
> done through SCM calls rather than direct register access. In this
> way the access to ICE registers are offloaded to Trust Zone.
> 
> Add QCOM_CRYPTO_VIRT, which implements struct virtblk_crypto_variant_ops
> for the virtio_blk_crypto_ext dispatch layer. It maps keyslot
> program/evict to qcom_scm_ice_set_key() and
> qcom_scm_ice_invalidate_key(), and software-secret derivation to
> qcom_scm_derive_sw_secret().
> 
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/Kconfig       | 12 +++++
>  drivers/soc/qcom/Makefile      |  1 +
>  drivers/soc/qcom/crypto_virt.c | 89 ++++++++++++++++++++++++++++++++++
>  3 files changed, 102 insertions(+)
>  create mode 100644 drivers/soc/qcom/crypto_virt.c
> 
> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 2b524154d9fb..6c632d114d45 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -298,6 +298,18 @@ config QCOM_INLINE_CRYPTO_ENGINE
>  	tristate
>  	select QCOM_SCM
>  
> +config QCOM_CRYPTO_VIRT
> +	tristate "Qualcomm Technologies, Inc. Crypto Virt driver"
> +	depends on VIRTBLK_CRYPTO_VIRTUALIZATION
> +	depends on QCOM_SCM
> +	default VIRTBLK_CRYPTO_VIRTUALIZATION if ARCH_QCOM
> +	help
> +	  GVM-side hardware-wrapped-key SCM operations exposed to
> +	  virtio_blk's inline crypto layer: per-slot key programming and
> +	  eviction, and key derive/generate/prepare/import.
> +	  Say Y here to compile the driver as a part of kernel or M to compile
> +	  as a module.
> +
>  config QCOM_KRYO_L2_ACCESSORS
>  	bool
>  	depends on ARM64
> diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
> index 798643be3590..6d4b7546d1fb 100644
> --- a/drivers/soc/qcom/Makefile
> +++ b/drivers/soc/qcom/Makefile
> @@ -39,5 +39,6 @@ obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
>  obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
>  qcom_ice-objs			+= ice.o
>  obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
> +obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
>  obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
>  obj-$(CONFIG_QCOM_UBWC_CONFIG) += ubwc_config.o
> diff --git a/drivers/soc/qcom/crypto_virt.c b/drivers/soc/qcom/crypto_virt.c
> new file mode 100644
> index 000000000000..4ee2a36af6c1
> --- /dev/null
> +++ b/drivers/soc/qcom/crypto_virt.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/blk-crypto.h>
> +#include <linux/virtio_blk_crypto_ext.h>
> +#include <linux/firmware/qcom/qcom_scm.h>
> +
> +static int crypto_virt_program_key(const struct blk_crypto_key *key,
> +				   unsigned int slot)
> +{
> +	u32 dus_512_units;
> +	int ret;
> +
> +	if (!key || !key->size) {
> +		pr_err("%s: invalid key\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* Only AES-256-XTS has been tested so far. */
> +	if (key->crypto_cfg.crypto_mode !=
> +	    BLK_ENCRYPTION_MODE_AES_256_XTS) {
> +		pr_err_ratelimited("Unsupported crypto mode: %d\n",
> +				    key->crypto_cfg.crypto_mode);
> +		return -EINVAL;
> +	}
> +
> +	/* qcom_scm_ice_set_key()'s data_unit_size is expressed in 512-byte units */
> +	dus_512_units = key->crypto_cfg.data_unit_size / 512;
> +
> +	ret = qcom_scm_ice_set_key(slot, key->bytes, key->size,
> +		QCOM_SCM_ICE_CIPHER_AES_256_XTS, dus_512_units);
> +	if (ret)
> +		pr_err("%s: slot=%u ret=%d\n", __func__, slot, ret);
> +
> +	return ret;
> +}
> +
> +static int crypto_virt_invalidate_key(unsigned int slot)
> +{
> +	int ret;
> +
> +	ret = qcom_scm_ice_invalidate_key(slot);
> +	if (ret)
> +		pr_err("%s: slot=%u ret=%d\n", __func__, slot, ret);
> +
> +	return ret;
> +}
> +
> +static int crypto_virt_derive_sw_secret_key(const u8 *eph_key, size_t eph_key_size,
> +					    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	int ret;
> +
> +	ret = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
> +					sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
> +	if (ret == -EIO || ret == -EINVAL)
> +		ret = -EBADMSG; /* probably invalid key */
> +
> +	if (ret)
> +		pr_err("%s: ret=%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static struct virtblk_crypto_variant_ops virtblk_crypto_qcom_vops = {

Why is a crypto-handling code in drivers/soc/?

> +	.owner = THIS_MODULE,
> +	.program_key = crypto_virt_program_key,
> +	.evict_key = crypto_virt_invalidate_key,
> +	.derive_sw_secret_key = crypto_virt_derive_sw_secret_key,
> +};
> +
> +static int __init crypto_virt_init(void)
> +{
> +	virtblk_set_crypto_ops(&virtblk_crypto_qcom_vops);
> +	return 0;
> +}
> +module_init(crypto_virt_init);
> +
> +#if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
> +static void __exit crypto_virt_exit(void)
> +{
> +	virtblk_set_crypto_ops(NULL);
> +}
> +module_exit(crypto_virt_exit);
> +#endif

How do you instantiate this driver exactly?

Best regards,
Krzysztof
