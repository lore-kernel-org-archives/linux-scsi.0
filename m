From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Wed, 14 Oct 2015 16:05:21 +0100
Message-ID: <561E6F31.9050804@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <1444663237-238302-10-git-send-email-john.garry@huawei.com>
 <561CA0CB.5090802@suse.de> <561D3BF1.8060600@huawei.com>
 <561E1501.2070507@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561E1501.2070507-l3A5Bk7waGM@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 14/10/2015 09:40, Hannes Reinecke wrote:
> On 10/13/2015 07:14 PM, John Garry wrote:
>> On 13/10/2015 07:12, Hannes Reinecke wrote:
>>> On 10/12/2015 05:20 PM, John Garry wrote:
>>>> This SAS ID is chosen as Huawei IEEE id: 001882
>>>>
>>>> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>    drivers/scsi/hisi_sas/hisi_sas_init.c | 15 +++++++++++++++
>>>>    1 file changed, 15 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c
>>>> b/drivers/scsi/hisi_sas/hisi_sas_init.c
>>>> index 44fc524..c295c39 100644
>>>> --- a/drivers/scsi/hisi_sas/hisi_sas_init.c
>>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
>>>> @@ -283,6 +283,19 @@ err_out:
>>>>        return NULL;
>>>>    }
>>>>
>>>> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
>>>> +{
>>>> +    u8 i;
>>>> +
>>>> +    /* Huawei IEEE id (001882) */
>>>> +    for (i = 0; i < hisi_hba->n_phy; i++)
>>>> +        hisi_hba->phy[i].dev_sas_addr =
>>>> +            cpu_to_be64(0x5001882016072015ULL);
>>>> +
>>> Ouch. Each phy has the same SAS address?
>>> For all boards? Ever?
>>>
>>> Not sure if that's a good idea, nor even valid.
>>> It'll confuse the hell out of any SAS array.
>>>
>>> Please provide a means of having individual SAS addresses for each
>>> HBA.
>>>
>>> Cheers,
>>>
>>> Hannes
>>>
>> Hello,
>>
>> Are you saying we should be getting the SAS address from fw with
>> sas_request_addr() or the like?
>>
>> Marvell solution seems to hardcode it.
>>
> Doesn't make it any better, nor even valid.
>
> Problem is that using a hardcoded SAS address makes it impossible
> do any resource allocation on a SAS target array.
> The SAS target array is allocating / mapping the LUNs based on the
> SAS address, so if HBAs from different machines coming in with the
> same SAS address the SAS array will assume that all ports belong to
> the same machine, thus allowing access to all of them.
>
> And don't try to _ever_ connect these HBAs to a SAS switch; that
> will be even more confused.
>
> So please, if you have a chance _DO_ get the SAS address from fw.
> If the firmware doesn't provide it you really should get in touch
> with the firmware team to get you one.
>
> To clarify the situation the SAS spec states:
>
>    Device names are worldwide unique names for devices within a
>    transport protocol (see SAM-3).
>
> and:
>    The VENDOR - SPECIFIC IDENTIFIER contains a 36-bit numeric value
>    that is uniquely assigned by the organization associated with the
>    company identifier in the IEEE COMPANY ID field.
>
> So as you are using the Huawei Vendor ID Huawei as a company needs
> to ensure uniqueness of the vendor-specific identifier (ie the last
> 36 bits of the SAS address). Which the above patch most patently
> fails to address.
>
> Cheers,
>
> Hannes
>
Hi,

OK, we can look at adding the ability to read the SAS HBA address from a 
FW image or EFI variables.

Thanks,
John

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
