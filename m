From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 09/10] scsi: ufs: return value of pwr_change_notify
Date: Thu, 17 Sep 2015 14:03:42 +0530
Message-ID: <55FA7AE6.3000801@samsung.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
 <1440149281-26336-10-git-send-email-alim.akhtar@samsung.com>
 <CADGdYn4u3bG8vxP09Jjvjh3tEyn5B6=3_7y3iSqi=dfkqLWjSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CADGdYn4u3bG8vxP09Jjvjh3tEyn5B6=3_7y3iSqi=dfkqLWjSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, vinholikatti@gmail.com, JBottomley@odin.com, essuuj@gmail.com
List-Id: linux-scsi@vger.kernel.org


Hi Amit
On 08/26/2015 11:55 AM, amit daniel kachhap wrote:
> On Fri, Aug 21, 2015 at 2:58 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>> From: Seungwon Jeon <tgih.jun@samsung.com>
>>
>> Behavior of the "powwer mode change" contains vendor specific
> s/powwer/power
ok
>> operation known as pwr_change_notify. This change adds return
>> for pwr_change_notify to find success or failure.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c |   22 +++++++++++++++-------
>>   1 file changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 8982da9..142a927 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2579,14 +2579,18 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
>>                  dev_err(hba->dev,
>>                          "%s: power mode change failed %d\n", __func__, ret);
>>          } else {
>> -               if (hba->vops && hba->vops->pwr_change_notify)
>> -                       hba->vops->pwr_change_notify(hba,
>> -                               POST_CHANGE, NULL, pwr_mode);
>> +               if (hba->vops && hba->vops->pwr_change_notify) {
>> +                       ret = hba->vops->pwr_change_notify(hba,
>> +                                       POST_CHANGE, NULL, pwr_mode);
>> +                       if (ret)
>> +                               goto out;
>> +               }
>>
>>                  memcpy(&hba->pwr_info, pwr_mode,
>>                          sizeof(struct ufs_pa_layer_attr));
>>          }
>>
>> +out:
>>          return ret;
>>   }
>>
>> @@ -2601,14 +2605,18 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>>          struct ufs_pa_layer_attr final_params = { 0 };
>>          int ret;
>>
>> -       if (hba->vops && hba->vops->pwr_change_notify)
>> -               hba->vops->pwr_change_notify(hba,
>> -                    PRE_CHANGE, desired_pwr_mode, &final_params);
>> -       else
>> +       if (hba->vops && hba->vops->pwr_change_notify) {
>> +               ret = hba->vops->pwr_change_notify(hba,
>> +                       PRE_CHANGE, desired_pwr_mode, &final_params);
>> +               if (ret)
>> +                       goto out;
>> +       } else {
>>                  memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
>> +       }
>>
>>          ret = ufshcd_change_power_mode(hba, &final_params);
>>
>> +out:
>>          return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
