From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Tue, 13 Oct 2015 18:14:25 +0100
Message-ID: <561D3BF1.8060600@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-10-git-send-email-john.garry@huawei.com>
 <561CA0CB.5090802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561CA0CB.5090802-l3A5Bk7waGM@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 13/10/2015 07:12, Hannes Reinecke wrote:
> On 10/12/2015 05:20 PM, John Garry wrote:
>> This SAS ID is chosen as Huawei IEEE id: 001882
>>
>> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_init.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
>> index 44fc524..c295c39 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_init.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
>> @@ -283,6 +283,19 @@ err_out:
>>   	return NULL;
>>   }
>>
>> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
>> +{
>> +	u8 i;
>> +
>> +	/* Huawei IEEE id (001882) */
>> +	for (i = 0; i < hisi_hba->n_phy; i++)
>> +		hisi_hba->phy[i].dev_sas_addr =
>> +			cpu_to_be64(0x5001882016072015ULL);
>> +
> Ouch. Each phy has the same SAS address?
> For all boards? Ever?
>
> Not sure if that's a good idea, nor even valid.
> It'll confuse the hell out of any SAS array.
>
> Please provide a means of having individual SAS addresses for each HBA.
>
> Cheers,
>
> Hannes
>
Hello,

Are you saying we should be getting the SAS address from fw with 
sas_request_addr() or the like?

Marvell solution seems to hardcode it.

thanks,
John

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
