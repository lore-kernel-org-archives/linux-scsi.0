From: Parshuram Raju Thombare <pthombar@cadence.com>
Subject: RE: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Wed, 12 Dec 2018 05:51:30 +0000
Message-ID: <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211181647.GC221175@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal
List-Id: linux-scsi@vger.kernel.org

Hello Eric,

Thank you for a comment.

>-----Original Message-----
>From: Eric Biggers <ebiggers@kernel.org>
>Sent: Tuesday, December 11, 2018 11:47 PM
>To: Parshuram Raju Thombare <pthombar@cadence.com>
>Cc: axboe@kernel.dk; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com; mchehab+samsung@kernel.org;
>gregkh@linuxfoundation.org; davem@davemloft.net; akpm@linux-
>foundation.org; nicolas.ferre@microchip.com; arnd@arndb.de; linux-
>kernel@vger.kernel.org; linux-block@vger.kernel.org; linux-
>scsi@vger.kernel.org; Alan Douglas <adouglas@cadence.com>; Janek Kotas
><jank@cadence.com>; Rafal Ciepiela <rafalc@cadence.com>; AnilKumar
>Chimata <anilc@codeaurora.org>; Ladvine D Almeida <ladvine@synopsys.com>;
>Satya Tangirala <satyat@google.com>; Paul Crowley
><paulcrowley@google.com>
>Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
>
>EXTERNAL MAIL
>
>
>[+Cc other people who have been working on this]
>
>
>
>Hi Parshuram,
>
>
>
>On Tue, Dec 11, 2018 at 09:50:27AM +0000, Parshuram Thombare wrote:
>
>> Add real time crypto support to UFS HCD using new device
>
>> mapper 'crypto-ufs'. dmsetup tool can be used to enable
>
>> real time / inline crypto support using device mapper
>
>> 'crypt-ufs'.
>
>>
>
>> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
>
>> ---
>
>>  MAINTAINERS                      |    7 +
>
>>  block/Kconfig                    |    5 +
>
>>  drivers/scsi/ufs/Kconfig         |   12 +
>
>>  drivers/scsi/ufs/Makefile        |    1 +
>
>>  drivers/scsi/ufs/ufshcd-crypto.c |  453
>++++++++++++++++++++++++++++++++++++++
>
>>  drivers/scsi/ufs/ufshcd-crypto.h |  102 +++++++++
>
>>  drivers/scsi/ufs/ufshcd.c        |   27 +++-
>
>>  drivers/scsi/ufs/ufshcd.h        |    6 +
>
>>  drivers/scsi/ufs/ufshci.h        |    1 +
>
>>  9 files changed, 613 insertions(+), 1 deletions(-)
>
>>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
>
>>  create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h
>
>>
>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>
>> index f485597..3a68126 100644
>
>> --- a/MAINTAINERS
>
>> +++ b/MAINTAINERS
>
>> @@ -15340,6 +15340,13 @@ S:	Supported
>
>>  F:	Documentation/scsi/ufs.txt
>
>>  F:	drivers/scsi/ufs/
>
>>
>
>> +UNIVERSAL FLASH STORAGE HOST CONTROLLER CRYPTO DRIVER
>
>> +M:	Parshuram Thombare <pthombar@cadence.com>
>
>> +L:	linux-scsi@vger.kernel.org
>
>> +S:	Supported
>
>> +F:	drivers/scsi/ufs/ufshcd-crypto.c
>
>> +F:	drivers/scsi/ufs/ufshcd-crypto.h
>
>> +
>
>>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
>
>>  M:	Joao Pinto <jpinto@synopsys.com>
>
>>  L:	linux-scsi@vger.kernel.org
>
>> diff --git a/block/Kconfig b/block/Kconfig
>
>> index f7045aa..6afe131 100644
>
>> --- a/block/Kconfig
>
>> +++ b/block/Kconfig
>
>> @@ -224,4 +224,9 @@ config BLK_MQ_RDMA
>
>>  config BLK_PM
>
>>  	def_bool BLOCK && PM
>
>>
>
>> +config BLK_DEV_HW_RT_ENCRYPTION
>
>> +	bool
>
>> +	depends on SCSI_UFSHCD_RT_ENCRYPTION
>
>> +	default n
>
>> +
>
>>  source block/Kconfig.iosched
>
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>
>> index 2ddbb26..09a3ec0 100644
>
>> --- a/drivers/scsi/ufs/Kconfig
>
>> +++ b/drivers/scsi/ufs/Kconfig
>
>> @@ -136,3 +136,15 @@ config SCSI_UFS_BSG
>
>>
>
>>  	  Select this if you need a bsg device node for your UFS controller.
>
>>  	  If unsure, say N.
>
>> +
>
>> +config SCSI_UFSHCD_RT_ENCRYPTION
>
>> +	bool "Universal Flash Storage Controller RT encryption support"
>
>> +	depends on SCSI_UFSHCD
>
>> +	default n
>
>> +	select BLK_DEV_HW_RT_ENCRYPTION if SCSI_UFSHCD_RT_ENCRYPTION
>
>> +	select BLK_DEV_DM if SCSI_UFSHCD_RT_ENCRYPTION
>
>> +	help
>
>> +	Universal Flash Storage Controller RT encryption support
>
>> +
>
>> +	Select this if you want to enable real time encryption on UFS controll=
er
>
>> +	If unsure, say N.
>
>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
>
>> index a3bd70c..6169096 100644
>
>> --- a/drivers/scsi/ufs/Makefile
>
>> +++ b/drivers/scsi/ufs/Makefile
>
>> @@ -7,6 +7,7 @@ obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
>
>>  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
>
>>  ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o
>
>>  ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+=3D ufs_bsg.o
>
>> +ufshcd-core-$(CONFIG_SCSI_UFSHCD_RT_ENCRYPTION) +=3D ufshcd-crypto.o
>
>>  obj-$(CONFIG_SCSI_UFSHCD_PCI) +=3D ufshcd-pci.o
>
>>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) +=3D ufshcd-pltfrm.o
>
>>  obj-$(CONFIG_SCSI_UFS_HISI) +=3D ufs-hisi.o
>
>> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-=
crypto.c
>
>> new file mode 100644
>
>> index 0000000..9c95ff3
>
>> --- /dev/null
>
>> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
>
>> @@ -0,0 +1,453 @@
>
>> +// SPDX-License-Identifier: GPL-2.0
>
>> +/*
>
>> + * UFS Host controller crypto driver
>
>> + *
>
>> + * Copyright (C) 2018 Cadence Design Systems, Inc.
>
>> + *
>
>> + * Authors:
>
>> + *	Parshuram Thombare <pthombar@cadence.com>
>
>> + *
>
>> + */
>
>> +
>
>> +#include <linux/module.h>
>
>> +#include <linux/kernel.h>
>
>> +#include <crypto/aes.h>
>
>> +#include <linux/device-mapper.h>
>
>> +#include "ufshcd.h"
>
>> +#include "ufshcd-crypto.h"
>
>> +#include "scsi/scsi_device.h"
>
>> +#include "scsi/scsi_host.h"
>
>> +
>
>> +struct ufshcd_dm_ctx {
>
>> +	struct dm_dev *dev;
>
>> +	sector_t start;
>
>> +	unsigned short int sector_size;
>
>> +	unsigned char sector_shift;
>
>> +	int cci;
>
>> +	int cap_idx;
>
>> +	char key[AES_MAX_KEY_SIZE];
>
>> +	struct ufs_hba *hba;
>
>> +};
>
>> +
>
>> +static int dm_registered;
>
>> +
>
>> +static inline int
>
>> +ufshcd_key_id_to_len(int key_id)
>
>> +{
>
>> +	int key_len =3D -1;
>
>> +
>
>> +	switch (key_id) {
>
>> +	case UFS_CRYPTO_KEY_ID_128BITS:
>
>> +		key_len =3D AES_KEYSIZE_128;
>
>> +		break;
>
>> +	case UFS_CRYPTO_KEY_ID_192BITS:
>
>> +		key_len =3D AES_KEYSIZE_192;
>
>> +		break;
>
>> +	case UFS_CRYPTO_KEY_ID_256BITS:
>
>> +		key_len =3D AES_KEYSIZE_256;
>
>> +		break;
>
>> +	default:
>
>> +		break;
>
>> +	}
>
>> +	return key_len;
>
>> +}
>
>> +
>
>> +static inline int
>
>> +ufshcd_key_len_to_id(int key_len)
>
>> +{
>
>> +	int key_id =3D -1;
>
>> +
>
>> +	switch (key_len) {
>
>> +	case AES_KEYSIZE_128:
>
>> +		key_id =3D UFS_CRYPTO_KEY_ID_128BITS;
>
>> +		break;
>
>> +	case AES_KEYSIZE_192:
>
>> +		key_id =3D UFS_CRYPTO_KEY_ID_192BITS;
>
>> +		break;
>
>> +	case AES_KEYSIZE_256:
>
>> +		key_id =3D UFS_CRYPTO_KEY_ID_256BITS;
>
>> +		break;
>
>> +	default:
>
>> +		break;
>
>> +	}
>
>> +	return key_id;
>
>> +}
>
>> +
>
>> +static void
>
>> +ufshcd_read_crypto_capabilities(struct ufs_hba *hba)
>
>> +{
>
>> +	u32 tmp, i;
>
>> +	struct ufshcd_crypto_ctx *cctx =3D hba->cctx;
>
>> +
>
>> +	for (i =3D 0; i < cctx->cap_cnt; i++) {
>
>> +		tmp =3D ufshcd_readl(hba, REG_UFS_CRYPTOCAP + i);
>
>> +		cctx->ccaps[i].key_id =3D (tmp & CRYPTO_CAPS_KS_MASK) >>
>
>> +						CRYPTO_CAPS_KS_SHIFT;
>
>> +		cctx->ccaps[i].sdusb =3D (tmp & CRYPTO_CAPS_SDUSB_MASK) >>
>
>> +						CRYPTO_CAPS_SDUSB_SHIFT;
>
>> +		cctx->ccaps[i].alg_id =3D (tmp & CRYPTO_CAPS_ALG_ID_MASK) >>
>
>> +						CRYPTO_CAPS_ALG_ID_SHIFT;
>
>> +	}
>
>> +}
>
>> +
>
>> +static inline int
>
>> +ufshcd_get_cap_idx(struct ufshcd_crypto_ctx *cctx, int alg_id,
>
>> +	int key_id)
>
>> +{
>
>> +	int cap_idx;
>
>> +
>
>> +	for (cap_idx =3D 0; cap_idx < cctx->cap_cnt; cap_idx++) {
>
>> +		if (((cctx->ccaps[cap_idx].alg_id =3D=3D alg_id) &&
>
>> +			cctx->ccaps[cap_idx].key_id =3D=3D key_id))
>
>> +			break;
>
>> +	}
>
>> +	return ((cap_idx < cctx->cap_cnt) ? cap_idx : -1);
>
>> +}
>
>> +
>
>> +static inline int
>
>> +ufshcd_get_cci_slot(struct ufshcd_crypto_ctx *cctx)
>
>> +{
>
>> +	int  cci;
>
>> +
>
>> +	for (cci =3D 0; cci < cctx->config_cnt; cci++) {
>
>> +		if (!cctx->cconfigs[cci].cfge) {
>
>> +			cctx->cconfigs[cci].cfge =3D 1;
>
>> +			break;
>
>> +		}
>
>> +	}
>
>> +	return ((cci < cctx->config_cnt) ? cci : -1);
>
>> +}
>
>> +
>
>> +static void
>
>> +ufshcd_aes_ecb_set_key(struct ufshcd_dm_ctx *ctx)
>
>> +{
>
>> +	int i, key_size;
>
>> +	u32 val, cconfig16, crypto_config_addr;
>
>> +	struct ufshcd_crypto_ctx *cctx;
>
>> +	struct ufshcd_crypto_config *cconfig;
>
>> +	struct ufshcd_crypto_cap ccap;
>
>> +
>
>> +	cctx =3D ctx->hba->cctx;
>
>> +	if (ctx->cci <=3D 0)
>
>> +		ctx->cci =3D ufshcd_get_cci_slot(cctx);
>
>> +	/* If no slot is available, slot 0 is shared */
>
>> +	ctx->cci =3D ctx->cci < 0 ? 0 : ctx->cci;
>
>> +	cconfig =3D &(cctx->cconfigs[ctx->cci]);
>
>> +	ccap =3D cctx->ccaps[ctx->cap_idx];
>
>> +	key_size =3D ufshcd_key_id_to_len(ccap.key_id);
>
>> +
>
>> +	if ((cconfig->cap_idx !=3D ctx->cap_idx) ||
>
>> +		((key_size > 0) &&
>
>> +		memcmp(cconfig->key, ctx->key, key_size))) {
>
>> +		cconfig->cap_idx =3D ctx->cap_idx;
>
>> +		memcpy(cconfig->key, ctx->key, key_size);
>
>> +		crypto_config_addr =3D cctx->crypto_config_base_addr +
>
>> +				ctx->cci * CRYPTO_CONFIG_SIZE;
>
>> +		cconfig16 =3D ccap.sdusb | (1 <<
>CRYPTO_CCONFIG16_CFGE_SHIFT);
>
>> +		cconfig16 |=3D ((ctx->cap_idx <<
>CRYPTO_CCONFIG16_CAP_IDX_SHIFT) &
>
>> +				CRYPTO_CCONFIG16_CAP_IDX_MASK);
>
>> +		spin_lock(&cctx->crypto_lock);
>
>> +		for (i =3D 0; i < key_size; i +=3D 4) {
>
>> +			val =3D (ctx->key[i] | (ctx->key[i + 1] << 8) |
>
>> +				(ctx->key[i + 2] << 16) |
>
>> +				(ctx->key[i + 3] << 24));
>
>> +			ufshcd_writel(ctx->hba, val, crypto_config_addr + i);
>
>> +		}
>
>> +		ufshcd_writel(ctx->hba, cpu_to_le32(cconfig16),
>
>> +				crypto_config_addr + (4 * 16));
>
>> +		spin_unlock(&cctx->crypto_lock);
>
>> +		/* Make sure keys are programmed */
>
>> +		mb();
>
>> +	}
>
>> +}
>
>
>
>First of all, thanks for working on this.  A lot of Android device vendors=
 would
>
>like to have upstream support for inline encryption.  However, are you awa=
re of
>
>previous (unsuccessful) patchsets by other people working on this?  Have y=
ou
>
>addressed the concerns and improved on their work, or is this just yet ano=
ther
>
>new effort starting from scratch?
>
>
>
>AnilKumar Chimata <anilc@codeaurora.org> (Qualcomm) in October 2018:
>
>
>
>	https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
>3A__patchwork.kernel.org_cover_10645739_&d=3DDwIBAg&c=3DaUq983L2pue2FqKF
>oP6PGHMJQyoJ7kl3s3GZ-_haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-
>rKC1FRbk0it-
>LDs&m=3DL9VLjsZ31dZ4TP4LdveuvcjPFzdZWGlZaZnzqGZH3zc&s=3DZzYaAaVic5TB4RUS
>cR5kzcM_8gvLYdlNAzuY80_ASzI&e=3D
>
>
>
>Ladvine D Almeida <ladvine@synopsys.com> in May 2018:
>
>
>
>	https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__lists-
>2Darchives.com_linux-2Dkernel_29135393-2Dscsi-2Dufs-2Dufs-2Dhost-
>2Dcontroller-2Dcrypto-
>2Dchanges.html&d=3DDwIBAg&c=3DaUq983L2pue2FqKFoP6PGHMJQyoJ7kl3s3GZ-
>_haXqY&r=3DGTefrem3hiBCnsjCOqAuapQHRN8-rKC1FRbk0it-
>LDs&m=3DL9VLjsZ31dZ4TP4LdveuvcjPFzdZWGlZaZnzqGZH3zc&s=3D3pxSBZrt_DpDSz-
>ZXrM7_bj0QXmRzcbasPl_wB259Us&e=3D
>
>
>
>Satya Tangirala <satyat@google.com> is also working on it but I don't beli=
eve
>
>he's sent out a patchset yet.
>
>
>
>It would be nice to coordinate to get a proper solution upstream that work=
s for
>
>everyone, rather than having everyone try independently and fail repeatedl=
y :-)
I had look at Ladvine's submission and think the approach of using Linux cr=
ypto API and
adding algorithm which is supposed to work inline (and with UFS devices onl=
y) in global
pool of algorithms (which is supposed to be generic) makes it risky, if sel=
ected/used for
other type of device not supporting inline encryption. Also apparently it i=
s not possible to
support multiple UFS controllers in the system with that approach.
There was suggestion from Milan to use separate device mapper which seems c=
leaner way
of enabling inline encryption. Hence new device mapper is used.
I think this is better idea to coordinate and come up with a generic soluti=
on.
>
>
>
>Also, note that ECB mode is not appropriate for disk encryption.  So this =
patch
>
>(and the hardware you tested it on, if that's all it supports) is effectiv=
ely
>
>useless as-is.  You need to support XTS mode.
For now only AES-ECB is supported, we are working on adding other modes.
>
>
>
>Thanks!
>
>
>
>- Eric

Regards,
Parshuram Thombare
