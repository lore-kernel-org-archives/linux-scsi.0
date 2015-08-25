From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 15/15] scsi: ufs: add wrapper for retrying sending
 query attribute
Date: Tue, 25 Aug 2015 12:45:29 -0000
Message-ID: <4117ea4cc6f5a3dbfc673553e2f94d6c.squirrel@www.codeaurora.org>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org>
    <1440194989-28835-16-git-send-email-ygardi@codeaurora.org>
    <CAL_JsqKW6Q5u5NfYBFWQdhS0LmcVwQYrqL6zqF5YurY5ti_kGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKW6Q5u5NfYBFWQdhS0LmcVwQYrqL6zqF5YurY5ti_kGA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <jbottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>>
>> Sometimes queries from the device might return a failure so it is
>> recommended to retry sending the query, before giving up.
>> This change adds a wrapper to retry sending a query attribute,
>> in cases where we need to wait longer, before we continue,
>> or before reporting a failure.
>
> Why not just always retry? Are there cases where retrying would be a
> problem?

There is no problem to retry whenever we encounter a query that returns
with and error.
In the code, it's recommended to replace any call to


>
>
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 51
>> ++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 44 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 876148b..bfef67d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1827,6 +1827,43 @@ out:
>>  }
>>
>>  /**
>> + * ufshcd_query_attr_retry() - API function for sending query
>> + * attribute with retries
>> + * @hba: per-adapter instance
>> + * @opcode: attribute opcode
>> + * @idn: attribute idn to access
>> + * @index: index field
>> + * @selector: selector field
>> + * @attr_val: the attribute value after the query request
>> + * completes
>> + *
>> + * Returns 0 for success, non-zero in case of failure
>> +*/
>> +static int ufshcd_query_attr_retry(struct ufs_hba *hba,
>> +       enum query_opcode opcode, enum attr_idn idn, u8 index, u8
>> selector,
>> +       u32 *attr_val)
>> +{
>> +       int ret = 0;
>> +       u32 retries;
>> +
>> +        for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
>> +               ret = ufshcd_query_attr(hba, opcode, idn, index,
>> +                                               selector, attr_val);
>> +               if (ret)
>> +                       dev_dbg(hba->dev, "%s: failed with error %d,
>> retries %d\n",
>> +                               __func__, ret, retries);
>> +               else
>> +                       break;
>> +       }
>> +
>> +       if (ret)
>> +               dev_err(hba->dev,
>> +                       "%s: query attribute, idn %d, failed with error
>> %d after %d retires\n",
>> +                       __func__, idn, ret, retries);
>
> The retry count will be wrong here.

you are correct. will be fixed in V2
>
>> +       return ret;
>> +}
>> +
>> +/**
>>   * ufshcd_query_descriptor - API function for sending descriptor
>> requests
>>   * hba: per-adapter instance
>>   * opcode: attribute opcode
>> @@ -3407,7 +3444,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba,
>> u16 mask)
>>
>>         val = hba->ee_ctrl_mask & ~mask;
>>         val &= 0xFFFF; /* 2 bytes */
>> -       err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>>                         QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>>         if (!err)
>>                 hba->ee_ctrl_mask &= ~mask;
>> @@ -3435,7 +3472,7 @@ static int ufshcd_enable_ee(struct ufs_hba *hba,
>> u16 mask)
>>
>>         val = hba->ee_ctrl_mask | mask;
>>         val &= 0xFFFF; /* 2 bytes */
>> -       err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> +       err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>>                         QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
>>         if (!err)
>>                 hba->ee_ctrl_mask |= mask;
>> @@ -3541,7 +3578,7 @@ static void  ufshcd_force_reset_auto_bkops(struct
>> ufs_hba *hba)
>>
>>  static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32
>> *status)
>>  {
>> -       return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +       return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>>                         QUERY_ATTR_IDN_BKOPS_STATUS, 0, 0, status);
>>  }
>>
>> @@ -3604,7 +3641,7 @@ static int ufshcd_urgent_bkops(struct ufs_hba
>> *hba)
>>
>>  static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32
>> *status)
>>  {
>> -       return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +       return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>>                         QUERY_ATTR_IDN_EE_STATUS, 0, 0, status);
>>  }
>>
>> @@ -4360,9 +4397,9 @@ static void ufshcd_init_icc_levels(struct ufs_hba
>> *hba)
>>         dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
>>                         __func__, hba->init_prefetch_data.icc_level);
>>
>> -       ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> -                       QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
>> -                       &hba->init_prefetch_data.icc_level);
>> +       ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
>> +               QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
>> +               &hba->init_prefetch_data.icc_level);
>>
>>         if (ret)
>>                 dev_err(hba->dev,
>> --
>> 1.8.5.2
>>
>> --
>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
>> member of Code Aurora Forum, hosted by The Linux Foundation
>
