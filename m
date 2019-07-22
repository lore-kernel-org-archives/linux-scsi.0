From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH RESEND] scsi: ufs: revamp string descriptor reading
Date: Mon, 22 Jul 2019 07:40:06 +0000
Message-ID: <SN6PR04MB4925FFBFEC979062E07DC6B8FCC40@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <20190721140212.8980-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190721140212.8980-1-tomas.winkler@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Alex Lemberg <Alex.Lemberg@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

>=20
> Define new a type: uc_string_id for easier string
> handling and less casting. Reduce number or string
> copies in price of a dynamic allocation.
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Tested-by: Avri Altman <avri.altman@wdc.com>
> ---
>=20
> Resend: It was reviewed by not merged.
>=20
>  drivers/scsi/ufs/ufs-sysfs.c |  20 ++---
>  drivers/scsi/ufs/ufs.h       |   2 +-
>  drivers/scsi/ufs/ufshcd.c    | 164 +++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h    |   9 +-
>  4 files changed, 115 insertions(+), 80 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index f478685122ff..13e357f01025 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -570,10 +570,11 @@ static ssize_t _name##_show(struct device *dev,
> 				\
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);			\
>  	int ret;							\
>  	int desc_len =3D QUERY_DESC_MAX_SIZE;				\
> -	u8 *desc_buf;							\
> +	char *desc_buf;							\
> +									\
Leaving it a u8 * here, will assure it would be utf-8,
And save you making param_read_buf opaque,
in ufshcd_read_desc  and ufshcd_read_desc_param.
A fare tradeoff, don't you think?


> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 99a9c4d16f6b..b3e1b2a0f463 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -541,7 +541,7 @@ struct ufs_dev_info {
>   */
>  struct ufs_dev_desc {
>  	u16 wmanufacturerid;
> -	char model[MAX_MODEL_LEN + 1];
> +	char *model;
>  };
Belongs to a different patch?

>  /**
>   * ufshcd_read_string_desc - read string descriptor
>   * @hba: pointer to adapter instance
>   * @desc_index: descriptor index
> - * @buf: pointer to buffer where descriptor would be read
> - * @size: size of buf
> + * @buf: pointer to buffer where descriptor would be read,
> + *       the caller should free the memory.
>   * @ascii: if true convert from unicode to ascii characters
> + *         null terminated string.
Since ascii is always true, maybe omit this argument altogether,
and group the if (asci) clause in some handler?

>  /**
> @@ -6452,6 +6478,9 @@ static int ufs_get_device_desc(struct ufs_hba
> *hba,
>  	u8 model_index;
>  	u8 *desc_buf;
>=20
> +	if (!dev_desc)
> +		return -EINVAL;
> +
A different patch?

>=20
> +static void ufs_put_device_desc(struct ufs_dev_desc *dev_desc)
> +{
> +	kfree(dev_desc->model);
> +	dev_desc->model =3D NULL;
> +}
A different patch?

While it's true that dev_desc->model conclude its part after ufs_fixup_devi=
ce_setup,
Why are you releasing specifically this part of card?


>=20
>  	ufs_fixup_device_setup(hba, &card);
> +	ufs_put_device_desc(&card);
A different patch?

> +
>  	ufshcd_tune_unipro_params(hba);
>=20
>  	/* UFS device is also active now */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 994d73d03207..10935548d1fc 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -885,14 +885,17 @@ int ufshcd_read_desc_param(struct ufs_hba
> *hba,
>  			   enum desc_idn desc_id,
>  			   int desc_index,
>  			   u8 param_offset,
> -			   u8 *param_read_buf,
> +			   void *param_read_buf,
>  			   u8 param_size);
>  int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
>  		      enum attr_idn idn, u8 index, u8 selector, u32
> *attr_val);
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>  	enum flag_idn idn, bool *flag_res);
> -int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
> -			    u8 *buf, u32 size, bool ascii);
> +
> +#define SD_ASCII_STD true
> +#define SD_RAW false
Not really needed?

Thanks,
Avri
