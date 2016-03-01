From: ygardi@codeaurora.org
Subject: Re: [PATCH v5 05/15] scsi: ufs: add support to read device and
 string descriptors
Date: Tue, 1 Mar 2016 10:01:24 -0000
Message-ID: <23b456731105bb2e5dc2fcff7e3370a9.squirrel@us.codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
    <1456666367-11418-6-git-send-email-ygardi@codeaurora.org>
    <56D5463A.5040602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56D5463A.5040602@suse.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
>> This change adds support to read device descriptor and string descri=
ptor
>> from a UFS device
>>
>> Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufs.h    |  1 +
>>  drivers/scsi/ufs/ufshcd.c | 88
>> ++++++++++++++++++++++++++++++++++++++++++++++-
>>  drivers/scsi/ufs/ufshcd.h |  7 ++++
>>  3 files changed, 95 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index 54a16ce..aacb235 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -43,6 +43,7 @@
>>  #define GENERAL_UPIU_REQUEST_SIZE 32
>>  #define QUERY_DESC_MAX_SIZE       255
>>  #define QUERY_DESC_MIN_SIZE       2
>> +#define QUERY_DESC_HDR_SIZE       2
>>  #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
>>  					(sizeof(struct utp_upiu_header)))
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 80031e6..e2ed415 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -39,7 +39,7 @@
>>
>>  #include <linux/async.h>
>>  #include <linux/devfreq.h>
>> -
>> +#include <linux/nls.h>
>>  #include <linux/of.h>
>>  #include "ufshcd.h"
>>  #include "unipro.h"
>> @@ -232,6 +232,16 @@ static inline void ufshcd_disable_irq(struct
>> ufs_hba *hba)
>>  	}
>>  }
>>
>> +/* replace non-printable or non-ASCII characters with spaces */
>> +static inline void ufshcd_remove_non_printable(char *val)
>> +{
>> +	if (!val)
>> +		return;
>> +
>> +	if (*val < 0x20 || *val > 0x7e)
>> +		*val =3D ' ';
>> +}
>> +
>>  /*
>>   * ufshcd_wait_for_register - wait for register value to change
>>   * @hba - per-adapter interface
>> @@ -2021,6 +2031,82 @@ static inline int ufshcd_read_power_desc(stru=
ct
>> ufs_hba *hba,
>>  	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
>>  }
>>
>> +int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
>> +{
>> +	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
>> +}
>> +EXPORT_SYMBOL(ufshcd_read_device_desc);
>> +
>> +/**
>> + * ufshcd_read_string_desc - read string descriptor
>> + * @hba: pointer to adapter instance
>> + * @desc_index: descriptor index
>> + * @buf: pointer to buffer where descriptor would be read
>> + * @size: size of buf
>> + * @ascii: if true convert from unicode to ascii characters
>> + *
>> + * Return 0 in case of success, non-zero otherwise
>> + */
>> +int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8
>> *buf,
>> +				u32 size, bool ascii)
>> +{
>> +	int err =3D 0;
>> +
>> +	err =3D ufshcd_read_desc(hba,
>> +				QUERY_DESC_IDN_STRING, desc_index, buf, size);
>> +
>> +	if (err) {
>> +		dev_err(hba->dev, "%s: reading String Desc failed after %d retrie=
s.
>> err =3D %d\n",
>> +			__func__, QUERY_REQ_RETRIES, err);
>> +		goto out;
>> +	}
>> +
>> +	if (ascii) {
>> +		int desc_len;
>> +		int ascii_len;
>> +		int i;
>> +		char *buff_ascii;
>> +
>> +		desc_len =3D buf[0];
>> +		/* remove header and divide by 2 to move from UTF16 to UTF8 */
>> +		ascii_len =3D (desc_len - QUERY_DESC_HDR_SIZE) / 2 + 1;
>> +		if (size < ascii_len + QUERY_DESC_HDR_SIZE) {
>> +			dev_err(hba->dev, "%s: buffer allocated size is too small\n",
>> +					__func__);
>> +			err =3D -ENOMEM;
>> +			goto out;
>> +		}
>> +
>> +		buff_ascii =3D kmalloc(ascii_len, GFP_KERNEL);
>> +		if (!buff_ascii) {
>> +			err =3D -ENOMEM;
>> +			goto out_free_buff;
>> +		}
>> +
>> +		/*
>> +		 * the descriptor contains string in UTF16 format
>> +		 * we need to convert to utf-8 so it can be displayed
>> +		 */
>> +		utf16s_to_utf8s((wchar_t *)&buf[QUERY_DESC_HDR_SIZE],
>> +				desc_len - QUERY_DESC_HDR_SIZE,
>> +				UTF16_BIG_ENDIAN, buff_ascii, ascii_len);
>> +
>> +		/* replace non-printable or non-ASCII characters with spaces */
>> +		for (i =3D 0; i < ascii_len; i++)
>> +			ufshcd_remove_non_printable(&buff_ascii[i]);
>> +
>> +		memset(buf + QUERY_DESC_HDR_SIZE, 0,
>> +				size - QUERY_DESC_HDR_SIZE);
>> +		memcpy(buf + QUERY_DESC_HDR_SIZE, buff_ascii, ascii_len);
>> +		buf[QUERY_DESC_LENGTH_OFFSET] =3D ascii_len + QUERY_DESC_HDR_SIZE=
;
>> +out_free_buff:
>> +		kfree(buff_ascii);
>> +	}
>> +out:
>> +	return err;
>> +}
>> +EXPORT_SYMBOL(ufshcd_read_string_desc);
>> +
>>  /**
>>   * ufshcd_read_unit_desc_param - read the specified unit descriptor
>> parameter
>>   * @hba: Pointer to adapter instance
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index a6d3572..54e13cc 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -678,6 +678,13 @@ static inline int ufshcd_dme_peer_get(struct
>> ufs_hba *hba,
>>  	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
>>  }
>>
>> +int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)=
;
>> +
>> +#define ASCII_STD true
>> +
>> +int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8
>> *buf,
>> +				u32 size, bool ascii);
>> +
>>  /* Expose Query-Request API */
>>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode=
,
>>  	enum flag_idn idn, bool *flag_res);
>>
>
> Probably shows my ignorance, but _where_ is this function actually us=
ed?
>
> Cheers,
> Hannes


Hello Hannes,
I was asked by reviewer Tomas Winkler, to seperate a patch (v4) into 2
patches in v5.
so, this is part I of the seperation, and the functions here, are being
called by the next patch v5 06/15 - in the quirk.c file in
ufs_get_device_info() routine.
hope that helps.

regards,
Yaniv


> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
