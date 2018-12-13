From: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Thu, 13 Dec 2018 19:39:33 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
 <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Parshuram Raju Thombare <pthombar@cadence.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal
List-Id: linux-scsi@vger.kernel.org

On 12/12/18 5:52 AM, Parshuram Raju Thombare wrote:=0A=
> Hello Eric,=0A=
> =0A=
> Thank you for a comment.=0A=
> =0A=
>> -----Original Message-----=0A=
>> From: Eric Biggers <ebiggers@kernel.org>=0A=
>> Sent: Tuesday, December 11, 2018 11:47 PM=0A=
>> To: Parshuram Raju Thombare <pthombar@cadence.com>=0A=
>> Cc: axboe@kernel.dk; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;=0A=
>> martin.petersen@oracle.com; mchehab+samsung@kernel.org;=0A=
>> gregkh@linuxfoundation.org; davem@davemloft.net; akpm@linux-=0A=
>> foundation.org; nicolas.ferre@microchip.com; arnd@arndb.de; linux-=0A=
>> kernel@vger.kernel.org; linux-block@vger.kernel.org; linux-=0A=
>> scsi@vger.kernel.org; Alan Douglas <adouglas@cadence.com>; Janek Kotas=
=0A=
>> <jank@cadence.com>; Rafal Ciepiela <rafalc@cadence.com>; AnilKumar=0A=
>> Chimata <anilc@codeaurora.org>; Ladvine D Almeida <ladvine@synopsys.com>=
;=0A=
>> Satya Tangirala <satyat@google.com>; Paul Crowley=0A=
>> <paulcrowley@google.com>=0A=
>> Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD=
=0A=
>>=0A=
>> EXTERNAL MAIL=0A=
>>=0A=
>>=0A=
>> [+Cc other people who have been working on this]=0A=
Eric, Thanks for cc-ing me to the mail chain.=0A=
=0A=
Parshuram,=0A=
Glad to know that you are working on the Inline Encryption support.=0A=
My concerns are mentioned inline below.=0A=
=0A=
>>=0A=
>>=0A=
>>=0A=
>> Hi Parshuram,=0A=
>>=0A=
>>=0A=
>>=0A=
>> On Tue, Dec 11, 2018 at 09:50:27AM +0000, Parshuram Thombare wrote:=0A=
>>=0A=
>>> Add real time crypto support to UFS HCD using new device=0A=
>>=0A=
>>> mapper 'crypto-ufs'. dmsetup tool can be used to enable=0A=
>>=0A=
>>> real time / inline crypto support using device mapper=0A=
>>=0A=
>>> 'crypt-ufs'.=0A=
=0A=
Where is Crypto target 'crypto-ufs' implementation available? Did you=0A=
submitted any other patch for the same?=0A=
Also, it is better to provide a generic name as the target is valid for=0A=
all other block devices.=0A=
=0A=
>>=0A=
>>>=0A=
>>=0A=
>>> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>=0A=
>>=0A=
>>> ---=0A=
>>=0A=
>>>  MAINTAINERS                      |    7 +=0A=
>>=0A=
>>>  block/Kconfig                    |    5 +=0A=
>>=0A=
>>>  drivers/scsi/ufs/Kconfig         |   12 +=0A=
>>=0A=
>>>  drivers/scsi/ufs/Makefile        |    1 +=0A=
>>=0A=
>>>  drivers/scsi/ufs/ufshcd-crypto.c |  453=0A=
>> ++++++++++++++++++++++++++++++++++++++=0A=
>>=0A=
>>>  drivers/scsi/ufs/ufshcd-crypto.h |  102 +++++++++=0A=
>>=0A=
>>>  drivers/scsi/ufs/ufshcd.c        |   27 +++-=0A=
>>=0A=
>>>  drivers/scsi/ufs/ufshcd.h        |    6 +=0A=
>>=0A=
>>>  drivers/scsi/ufs/ufshci.h        |    1 +=0A=
>>=0A=
>>>  9 files changed, 613 insertions(+), 1 deletions(-)=0A=
>>=0A=
>>>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c=0A=
>>=0A=
>>>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h=0A=
>>=0A=
>>>=0A=
>>=0A=
>>> diff --git a/MAINTAINERS b/MAINTAINERS=0A=
>>=0A=
>>> index f485597..3a68126 100644=0A=
>>=0A=
>>> --- a/MAINTAINERS=0A=
>>=0A=
>>> +++ b/MAINTAINERS=0A=
>>=0A=
>>> @@ -15340,6 +15340,13 @@ S:	Supported=0A=
>>=0A=
>>>  F:	Documentation/scsi/ufs.txt=0A=
>>=0A=
>>>  F:	drivers/scsi/ufs/=0A=
>>=0A=
>>>=0A=
>>=0A=
>>> +UNIVERSAL FLASH STORAGE HOST CONTROLLER CRYPTO DRIVER=0A=
>>=0A=
>>> +M:	Parshuram Thombare <pthombar@cadence.com>=0A=
>>=0A=
>>> +L:	linux-scsi@vger.kernel.org=0A=
>>=0A=
>>> +S:	Supported=0A=
>>=0A=
>>> +F:	drivers/scsi/ufs/ufshcd-crypto.c=0A=
>>=0A=
>>> +F:	drivers/scsi/ufs/ufshcd-crypto.h=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS=0A=
>>=0A=
>>>  M:	Joao Pinto <jpinto@synopsys.com>=0A=
>>=0A=
>>>  L:	linux-scsi@vger.kernel.org=0A=
>>=0A=
>>> diff --git a/block/Kconfig b/block/Kconfig=0A=
>>=0A=
>>> index f7045aa..6afe131 100644=0A=
>>=0A=
>>> --- a/block/Kconfig=0A=
>>=0A=
>>> +++ b/block/Kconfig=0A=
>>=0A=
>>> @@ -224,4 +224,9 @@ config BLK_MQ_RDMA=0A=
>>=0A=
>>>  config BLK_PM=0A=
>>=0A=
>>>  	def_bool BLOCK && PM=0A=
>>=0A=
>>>=0A=
>>=0A=
>>> +config BLK_DEV_HW_RT_ENCRYPTION=0A=
>>=0A=
>>> +	bool=0A=
>>=0A=
>>> +	depends on SCSI_UFSHCD_RT_ENCRYPTION=0A=
>>=0A=
>>> +	default n=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>>  source block/Kconfig.iosched=0A=
>>=0A=
>>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig=0A=
>>=0A=
>>> index 2ddbb26..09a3ec0 100644=0A=
>>=0A=
>>> --- a/drivers/scsi/ufs/Kconfig=0A=
>>=0A=
>>> +++ b/drivers/scsi/ufs/Kconfig=0A=
>>=0A=
>>> @@ -136,3 +136,15 @@ config SCSI_UFS_BSG=0A=
>>=0A=
>>>=0A=
>>=0A=
>>>  	  Select this if you need a bsg device node for your UFS controller.=
=0A=
>>=0A=
>>>  	  If unsure, say N.=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +config SCSI_UFSHCD_RT_ENCRYPTION=0A=
>>=0A=
>>> +	bool "Universal Flash Storage Controller RT encryption support"=0A=
>>=0A=
>>> +	depends on SCSI_UFSHCD=0A=
>>=0A=
>>> +	default n=0A=
>>=0A=
>>> +	select BLK_DEV_HW_RT_ENCRYPTION if SCSI_UFSHCD_RT_ENCRYPTION=0A=
>>=0A=
>>> +	select BLK_DEV_DM if SCSI_UFSHCD_RT_ENCRYPTION=0A=
>>=0A=
>>> +	help=0A=
>>=0A=
>>> +	Universal Flash Storage Controller RT encryption support=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	Select this if you want to enable real time encryption on UFS control=
ler=0A=
>>=0A=
>>> +	If unsure, say N.=0A=
>>=0A=
>>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile=0A=
>>=0A=
>>> index a3bd70c..6169096 100644=0A=
>>=0A=
>>> --- a/drivers/scsi/ufs/Makefile=0A=
>>=0A=
>>> +++ b/drivers/scsi/ufs/Makefile=0A=
>>=0A=
>>> @@ -7,6 +7,7 @@ obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o=0A=
>>=0A=
>>>  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o=0A=
>>=0A=
>>>  ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o=0A=
>>=0A=
>>>  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+=3D ufs_bsg.o=0A=
>>=0A=
>>> +ufshcd-core-$(CONFIG_SCSI_UFSHCD_RT_ENCRYPTION) +=3D ufshcd-crypto.o=
=0A=
>>=0A=
>>>  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o=0A=
>>=0A=
>>>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o=0A=
>>=0A=
>>>  obj-$(CONFIG_SCSI_UFS_HISI) +=3D ufs-hisi.o=0A=
>>=0A=
>>> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd=
-crypto.c=0A=
>>=0A=
>>> new file mode 100644=0A=
>>=0A=
>>> index 0000000..9c95ff3=0A=
>>=0A=
>>> --- /dev/null=0A=
>>=0A=
>>> +++ b/drivers/scsi/ufs/ufshcd-crypto.c=0A=
>>=0A=
>>> @@ -0,0 +1,453 @@=0A=
>>=0A=
>>> +// SPDX-License-Identifier: GPL-2.0=0A=
>>=0A=
>>> +/*=0A=
>>=0A=
>>> + * UFS Host controller crypto driver=0A=
>>=0A=
>>> + *=0A=
>>=0A=
>>> + * Copyright (C) 2018 Cadence Design Systems, Inc.=0A=
>>=0A=
>>> + *=0A=
>>=0A=
>>> + * Authors:=0A=
>>=0A=
>>> + *	Parshuram Thombare <pthombar@cadence.com>=0A=
>>=0A=
>>> + *=0A=
>>=0A=
>>> + */=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +#include <linux/module.h>=0A=
>>=0A=
>>> +#include <linux/kernel.h>=0A=
>>=0A=
>>> +#include <crypto/aes.h>=0A=
>>=0A=
>>> +#include <linux/device-mapper.h>=0A=
>>=0A=
>>> +#include "ufshcd.h"=0A=
>>=0A=
>>> +#include "ufshcd-crypto.h"=0A=
>>=0A=
>>> +#include "scsi/scsi_device.h"=0A=
>>=0A=
>>> +#include "scsi/scsi_host.h"=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +struct ufshcd_dm_ctx {=0A=
>>=0A=
>>> +	struct dm_dev *dev;=0A=
>>=0A=
>>> +	sector_t start;=0A=
>>=0A=
>>> +	unsigned short int sector_size;=0A=
>>=0A=
>>> +	unsigned char sector_shift;=0A=
>>=0A=
>>> +	int cci;=0A=
>>=0A=
>>> +	int cap_idx;=0A=
>>=0A=
>>> +	char key[AES_MAX_KEY_SIZE];=0A=
>>=0A=
>>> +	struct ufs_hba *hba;=0A=
>>=0A=
>>> +};=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static int dm_registered;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static inline int=0A=
>>=0A=
>>> +ufshcd_key_id_to_len(int key_id)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	int key_len =3D -1;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	switch (key_id) {=0A=
>>=0A=
>>> +	case UFS_CRYPTO_KEY_ID_128BITS:=0A=
>>=0A=
>>> +		key_len =3D AES_KEYSIZE_128;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	case UFS_CRYPTO_KEY_ID_192BITS:=0A=
>>=0A=
>>> +		key_len =3D AES_KEYSIZE_192;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	case UFS_CRYPTO_KEY_ID_256BITS:=0A=
>>=0A=
>>> +		key_len =3D AES_KEYSIZE_256;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	default:=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +	return key_len;=0A=
>>=0A=
>>> +}=0A=
=0A=
Why not -EINVAL for invalid key length?=0A=
=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static inline int=0A=
>>=0A=
>>> +ufshcd_key_len_to_id(int key_len)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	int key_id =3D -1;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	switch (key_len) {=0A=
>>=0A=
>>> +	case AES_KEYSIZE_128:=0A=
>>=0A=
>>> +		key_id =3D UFS_CRYPTO_KEY_ID_128BITS;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	case AES_KEYSIZE_192:=0A=
>>=0A=
>>> +		key_id =3D UFS_CRYPTO_KEY_ID_192BITS;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	case AES_KEYSIZE_256:=0A=
>>=0A=
>>> +		key_id =3D UFS_CRYPTO_KEY_ID_256BITS;=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	default:=0A=
>>=0A=
>>> +		break;=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +	return key_id;=0A=
>>=0A=
>>> +}=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static void=0A=
>>=0A=
>>> +ufshcd_read_crypto_capabilities(struct ufs_hba *hba)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	u32 tmp, i;=0A=
>>=0A=
>>> +	struct ufshcd_crypto_ctx *cctx =3D hba->cctx;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	for (i =3D 0; i < cctx->cap_cnt; i++) {=0A=
>>=0A=
>>> +		tmp =3D ufshcd_readl(hba, REG_UFS_CRYPTOCAP + i);=0A=
>>=0A=
>>> +		cctx->ccaps[i].key_id =3D (tmp & CRYPTO_CAPS_KS_MASK) >>=0A=
>>=0A=
>>> +						CRYPTO_CAPS_KS_SHIFT;=0A=
>>=0A=
>>> +		cctx->ccaps[i].sdusb =3D (tmp & CRYPTO_CAPS_SDUSB_MASK) >>=0A=
>>=0A=
>>> +						CRYPTO_CAPS_SDUSB_SHIFT;=0A=
>>=0A=
>>> +		cctx->ccaps[i].alg_id =3D (tmp & CRYPTO_CAPS_ALG_ID_MASK) >>=0A=
>>=0A=
>>> +						CRYPTO_CAPS_ALG_ID_SHIFT;=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +}=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static inline int=0A=
>>=0A=
>>> +ufshcd_get_cap_idx(struct ufshcd_crypto_ctx *cctx, int alg_id,=0A=
>>=0A=
>>> +	int key_id)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	int cap_idx;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	for (cap_idx =3D 0; cap_idx < cctx->cap_cnt; cap_idx++) {=0A=
>>=0A=
>>> +		if (((cctx->ccaps[cap_idx].alg_id =3D=3D alg_id) &&=0A=
>>=0A=
>>> +			cctx->ccaps[cap_idx].key_id =3D=3D key_id))=0A=
>>=0A=
>>> +			break;=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +	return ((cap_idx < cctx->cap_cnt) ? cap_idx : -1);=0A=
>>=0A=
>>> +}=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static inline int=0A=
>>=0A=
>>> +ufshcd_get_cci_slot(struct ufshcd_crypto_ctx *cctx)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	int  cci;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	for (cci =3D 0; cci < cctx->config_cnt; cci++) {=0A=
>>=0A=
>>> +		if (!cctx->cconfigs[cci].cfge) {=0A=
>>=0A=
>>> +			cctx->cconfigs[cci].cfge =3D 1;=0A=
>>=0A=
>>> +			break;=0A=
>>=0A=
>>> +		}=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +	return ((cci < cctx->config_cnt) ? cci : -1);=0A=
>>=0A=
>>> +}=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +static void=0A=
>>=0A=
>>> +ufshcd_aes_ecb_set_key(struct ufshcd_dm_ctx *ctx)=0A=
>>=0A=
>>> +{=0A=
>>=0A=
>>> +	int i, key_size;=0A=
>>=0A=
>>> +	u32 val, cconfig16, crypto_config_addr;=0A=
>>=0A=
>>> +	struct ufshcd_crypto_ctx *cctx;=0A=
>>=0A=
>>> +	struct ufshcd_crypto_config *cconfig;=0A=
>>=0A=
>>> +	struct ufshcd_crypto_cap ccap;=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	cctx =3D ctx->hba->cctx;=0A=
>>=0A=
>>> +	if (ctx->cci <=3D 0)=0A=
>>=0A=
>>> +		ctx->cci =3D ufshcd_get_cci_slot(cctx);=0A=
>>=0A=
>>> +	/* If no slot is available, slot 0 is shared */=0A=
>>=0A=
>>> +	ctx->cci =3D ctx->cci < 0 ? 0 : ctx->cci;=0A=
>>=0A=
>>> +	cconfig =3D &(cctx->cconfigs[ctx->cci]);=0A=
>>=0A=
>>> +	ccap =3D cctx->ccaps[ctx->cap_idx];=0A=
>>=0A=
>>> +	key_size =3D ufshcd_key_id_to_len(ccap.key_id);=0A=
>>=0A=
>>> +=0A=
>>=0A=
>>> +	if ((cconfig->cap_idx !=3D ctx->cap_idx) ||=0A=
>>=0A=
>>> +		((key_size > 0) &&=0A=
>>=0A=
>>> +		memcmp(cconfig->key, ctx->key, key_size))) {=0A=
>>=0A=
>>> +		cconfig->cap_idx =3D ctx->cap_idx;=0A=
>>=0A=
>>> +		memcpy(cconfig->key, ctx->key, key_size);=0A=
>>=0A=
>>> +		crypto_config_addr =3D cctx->crypto_config_base_addr +=0A=
>>=0A=
>>> +				ctx->cci * CRYPTO_CONFIG_SIZE;=0A=
>>=0A=
>>> +		cconfig16 =3D ccap.sdusb | (1 <<=0A=
>> CRYPTO_CCONFIG16_CFGE_SHIFT);=0A=
>>=0A=
>>> +		cconfig16 |=3D ((ctx->cap_idx <<=0A=
>> CRYPTO_CCONFIG16_CAP_IDX_SHIFT) &=0A=
>>=0A=
>>> +				CRYPTO_CCONFIG16_CAP_IDX_MASK);=0A=
>>=0A=
>>> +		spin_lock(&cctx->crypto_lock);=0A=
>>=0A=
>>> +		for (i =3D 0; i < key_size; i +=3D 4) {=0A=
>>=0A=
>>> +			val =3D (ctx->key[i] | (ctx->key[i + 1] << 8) |=0A=
>>=0A=
>>> +				(ctx->key[i + 2] << 16) |=0A=
>>=0A=
>>> +				(ctx->key[i + 3] << 24));=0A=
>>=0A=
>>> +			ufshcd_writel(ctx->hba, val, crypto_config_addr + i);=0A=
>>=0A=
>>> +		}=0A=
>>=0A=
>>> +		ufshcd_writel(ctx->hba, cpu_to_le32(cconfig16),=0A=
>>=0A=
>>> +				crypto_config_addr + (4 * 16));=0A=
>>=0A=
>>> +		spin_unlock(&cctx->crypto_lock);=0A=
>>=0A=
>>> +		/* Make sure keys are programmed */=0A=
>>=0A=
>>> +		mb();=0A=
>>=0A=
>>> +	}=0A=
>>=0A=
>>> +}=0A=
>>=0A=
>>=0A=
>>=0A=
>> First of all, thanks for working on this.  A lot of Android device vendo=
rs would=0A=
>>=0A=
>> like to have upstream support for inline encryption.  However, are you a=
ware of=0A=
>>=0A=
>> previous (unsuccessful) patchsets by other people working on this?  Have=
 you=0A=
>>=0A=
>> addressed the concerns and improved on their work, or is this just yet a=
nother=0A=
>>=0A=
>> new effort starting from scratch?=0A=
>>=0A=
>>=0A=
>>=0A=
>> AnilKumar Chimata <anilc@codeaurora.org> (Qualcomm) in October 2018:=0A=
>>=0A=
>>=0A=
>>=0A=
>> 	https://urldefense.proofpoint.com/v2/url?u=3Dhttps-=0A=
>> 3A__patchwork.kernel.org_cover_10645739_&d=3DDwIBAg&c=3DaUq983L2pue2FqKF=
=0A=
>> oP6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-=0A=
>> rKC1FRbk0it-=0A=
>> LDs&m=3DL9VLjsZ31dZ4TP4LdveuvcjPFzdZWGlZaZnzqGZH3zc&s=3DZzYaAaVic5TB4RUS=
=0A=
>> cR5kzcM_8gvLYdlNAzuY80_ASzI&e=3D=0A=
>>=0A=
>>=0A=
>>=0A=
>> Ladvine D Almeida <ladvine@synopsys.com> in May 2018:=0A=
>>=0A=
>>=0A=
>>=0A=
>> 	https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__lists-=0A=
>> 2Darchives.com_linux-2Dkernel_29135393-2Dscsi-2Dufs-2Dufs-2Dhost-=0A=
>> 2Dcontroller-2Dcrypto-=0A=
>> 2Dchanges.html&d=3DDwIBAg&c=3DaUq983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-=0A=
>> _haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-rKC1FRbk0it-=0A=
>> LDs&m=3DL9VLjsZ31dZ4TP4LdveuvcjPFzdZWGlZaZnzqGZH3zc&s=3D3pxSBZrt_DpDSz-=
=0A=
>> ZXrM7_bj0QXmRzcbasPl_wB259Us&e=3D=0A=
>>=0A=
>>=0A=
>>=0A=
>> Satya Tangirala <satyat@google.com> is also working on it but I don't be=
lieve=0A=
>>=0A=
>> he's sent out a patchset yet.=0A=
>>=0A=
>>=0A=
>>=0A=
>> It would be nice to coordinate to get a proper solution upstream that wo=
rks for=0A=
>>=0A=
>> everyone, rather than having everyone try independently and fail repeate=
dly :-)=0A=
> I had look at Ladvine's submission and think the approach of using Linux =
crypto API and=0A=
> adding algorithm which is supposed to work inline (and with UFS devices o=
nly) in global=0A=
> pool of algorithms (which is supposed to be generic) makes it risky, if s=
elected/used for=0A=
> other type of device not supporting inline encryption. Also apparently it=
 is not possible to=0A=
> support multiple UFS controllers in the system with that approach.=0A=
> There was suggestion from Milan to use separate device mapper which seems=
 cleaner way=0A=
> of enabling inline encryption. Hence new device mapper is used.=0A=
> I think this is better idea to coordinate and come up with a generic solu=
tion.=0A=
=0A=
Suggest to take a look into the article https://lwn.net/Articles/717754=0A=
My real concern is how to achieve it without any modifications to the=0A=
bio.(because key slot information has to finally reach the target block=0A=
device)=0A=
=0A=
>>=0A=
>>=0A=
>>=0A=
>> Also, note that ECB mode is not appropriate for disk encryption.  So thi=
s patch=0A=
>>=0A=
>> (and the hardware you tested it on, if that's all it supports) is effect=
ively=0A=
>>=0A=
>> useless as-is.  You need to support XTS mode.=0A=
> For now only AES-ECB is supported, we are working on adding other modes.=
=0A=
>>=0A=
>>=0A=
>>=0A=
>> Thanks!=0A=
>>=0A=
>>=0A=
>>=0A=
>> - Eric=0A=
> =0A=
> Regards,=0A=
> Parshuram Thombare=0A=
> =0A=
=0A=
Thanks,=0A=
Ladvine=0A=
=0A=
