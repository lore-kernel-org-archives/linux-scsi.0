From: Parshuram Raju Thombare <pthombar@cadence.com>
Subject: RE: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
Date: Wed, 12 Dec 2018 05:29:54 +0000
Message-ID: <CO2PR07MB246947498D76D9A371A7E131C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211120337.GA3023@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181211120337.GA3023@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Douglas <adouglas@cadence.com>, Janek Kotas <jank@cadence.com>, Rafal Ciepiela <rafalc@cadence.com>
List-Id: linux-scsi@vger.kernel.org

Hello Greg,

Thank you for comments.

>-----Original Message-----
>From: Greg KH <gregkh@linuxfoundation.org>
>Sent: Tuesday, December 11, 2018 5:34 PM
>To: Parshuram Raju Thombare <pthombar@cadence.com>
>Cc: axboe@kernel.dk; vinholikatti@gmail.com; jejb@linux.vnet.ibm.com;
>martin.petersen@oracle.com; mchehab+samsung@kernel.org;
>davem@davemloft.net; akpm@linux-foundation.org;
>nicolas.ferre@microchip.com; arnd@arndb.de; linux-kernel@vger.kernel.org;
>linux-block@vger.kernel.org; linux-scsi@vger.kernel.org; Alan Douglas
><adouglas@cadence.com>; Janek Kotas <jank@cadence.com>; Rafal Ciepiela
><rafalc@cadence.com>
>Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
>
>EXTERNAL MAIL
>
>
>On Tue, Dec 11, 2018 at 09:50:27AM +0000, Parshuram Thombare wrote:
>> Add real time crypto support to UFS HCD using new device mapper
>> 'crypto-ufs'. dmsetup tool can be used to enable real time / inline
>> crypto support using device mapper 'crypt-ufs'.
>>
>> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
>
>As you cc:ed me, I'll provide some minor review comments:
>
>> +config BLK_DEV_HW_RT_ENCRYPTION
>> +	bool
>> +	depends on SCSI_UFSHCD_RT_ENCRYPTION
>> +	default n
>
>n is always the default, you never need to list that.
Ok,  I will remove it.
>
>> +
>>  source block/Kconfig.iosched
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
>> 2ddbb26..09a3ec0 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -136,3 +136,15 @@ config SCSI_UFS_BSG
>>
>>  	  Select this if you need a bsg device node for your UFS controller.
>>  	  If unsure, say N.
>> +
>> +config SCSI_UFSHCD_RT_ENCRYPTION
>> +	bool "Universal Flash Storage Controller RT encryption support"
>> +	depends on SCSI_UFSHCD
>> +	default n
>
>Same here.
>
Ok,  I will remove it.
>> +	select BLK_DEV_HW_RT_ENCRYPTION if SCSI_UFSHCD_RT_ENCRYPTION
>> +	select BLK_DEV_DM if SCSI_UFSHCD_RT_ENCRYPTION
>> +	help
>> +	Universal Flash Storage Controller RT encryption support
>> +
>> +	Select this if you want to enable real time encryption on UFS controll=
er
>> +	If unsure, say N.
>
>Don't you need to indent the help lines?
>
Sorry, missed indentation check here. I will indent this.
>> +int ufshcd_crypto_init(struct ufs_hba *hba); void
>> +ufshcd_crypto_remove(struct ufs_hba *hba); void
>> +ufshcd_prepare_for_crypto(struct ufs_hba *hba, struct ufshcd_lrb
>> +*lrbp); #endif
>
>You need to provide inline functions for when your config option is not en=
abled
>here.
>
>That way you don't have to do this mess:
>
Do you mean empty inline function (which are exported) in #else  to avoid #=
ifdef=20
around each call for these functions ?
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 86fe114..a96b038 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -47,6 +47,9 @@
>>  #include "unipro.h"
>>  #include "ufs-sysfs.h"
>>  #include "ufs_bsg.h"
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION #include "ufshcd-crypto.h"
>> +#endif
>
>No need for #ifdefs in .c files at all.  Always include the .h file, and t=
hen since your
>functions are all inline void functions, the code just compiles away into =
nothing.
>
>
Ok,  I will remove it.
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/ufs.h>
>> @@ -2198,6 +2201,14 @@ static void ufshcd_prepare_req_desc_hdr(struct
>> ufshcd_lrb *lrbp,
>>
>>  	dword_0 =3D data_direction | (lrbp->command_type
>>  				<< UPIU_COMMAND_TYPE_OFFSET);
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
>> +	if (lrbp->cci >=3D 0) {
>> +		dword_0 |=3D (1 <<
>CRYPTO_UTP_REQ_DESC_DWORD0_CE_SHIFT);
>> +		dword_0 |=3D ((lrbp->cci <<
>CRYPTO_UTP_REQ_DESC_DWORD0_CCI_SHIFT)
>> +				&
>CRYPTO_UTP_REQ_DESC_DWORD0_CCI_MASK);
>> +	} else
>> +		dword_0 &=3D ~CRYPTO_UTP_REQ_DESC_DWORD0_CE_MASK;
>> +#endif
>
>Some comments on what this is trying to do here?
>
>
This is to enable encryption by setting CCI (crypto config index) and CE cr=
ypto enable bit.
I will add comment here.
>>  	if (lrbp->intr_cmd)
>>  		dword_0 |=3D UTP_REQ_DESC_INT_CMD;
>>
>> @@ -2462,6 +2473,12 @@ static int ufshcd_queuecommand(struct Scsi_Host
>*host, struct scsi_cmnd *cmd)
>>  	lrbp->intr_cmd =3D !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
>>  	lrbp->req_abort_skip =3D false;
>>
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
>> +	lrbp->cci =3D -1;
>
>What does -1 mean?  You should have a type for it if it is something "spec=
ial".
>
-1 means crypto is not enabled or supported by hardware. I think this need =
a comment.
I will add it.
>> +	/* prepare block for crypto */
>> +	if (hba->capabilities & MASK_CRYPTO_SUPPORT)
>> +		ufshcd_prepare_for_crypto(hba, lrbp); #endif
>
>Again, no #ifdefs needed please.
>
>
Ok, I will remove it.
>>  	ufshcd_comp_scsi_upiu(hba, lrbp);
>>
>>  	err =3D ufshcd_map_sg(hba, lrbp);
>> @@ -8119,6 +8136,11 @@ void ufshcd_remove(struct ufs_hba *hba)
>>  	ufs_bsg_remove(hba);
>>  	ufs_sysfs_remove_nodes(hba->dev);
>>  	scsi_remove_host(hba->host);
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
>> +	if (hba->capabilities & MASK_CRYPTO_SUPPORT)
>> +		ufshcd_crypto_remove(hba);
>> +#endif
>
>Same ifdef here, and everywhere else in this file.
>
Ok, I will remove it.
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -193,6 +193,9 @@ struct ufshcd_lrb {
>>  	ktime_t compl_time_stamp;
>>
>>  	bool req_abort_skip;
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
>> +	int cci;
>> +#endif
>
>No need for a #ifdef here.  But comment on exactly what "cci" means, that =
seems
>to not make any sense to me.
>
CCI is crypto config index / slot in UFS. I will add a comment here.
>>  };
>>
>>  /**
>> @@ -706,6 +709,9 @@ struct ufs_hba {
>>
>>  	struct device		bsg_dev;
>>  	struct request_queue	*bsg_queue;
>> +#ifdef CONFIG_SCSI_UFSHCD_RT_ENCRYPTION
>> +	struct ufshcd_crypto_ctx *cctx;
>> +#endif
>
>or here.
>
Ok, I will remove it.
>>  };
>>
>>  /* Returns true if clocks can be gated. Otherwise false */ diff --git
>> a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h index
>> 6fa889d..fe5a92d 100644
>> --- a/drivers/scsi/ufs/ufshci.h
>> +++ b/drivers/scsi/ufs/ufshci.h
>> @@ -90,6 +90,7 @@ enum {
>>  	MASK_64_ADDRESSING_SUPPORT		=3D 0x01000000,
>>  	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	=3D 0x02000000,
>>  	MASK_UIC_DME_TEST_MODE_SUPPORT		=3D 0x04000000,
>> +	MASK_CRYPTO_SUPPORT                     =3D 0x10000000,
>
>Why are you all not using the BIT(N) macro for these?
Yes, I will replace it with BIT(N).
>
>thanks,
>
>greg k-h

Regards,
Parshuram Thombare
