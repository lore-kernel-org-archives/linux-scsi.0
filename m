From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Wed, 14 Oct 2015 10:40:33 +0200
Message-ID: <561E1501.2070507@suse.de>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-10-git-send-email-john.garry@huawei.com> <561CA0CB.5090802@suse.de> <561D3BF1.8060600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbbJNIkf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 04:40:35 -0400
In-Reply-To: <561D3BF1.8060600@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, James.Bottomley@HansenPartnership.com
Cc: devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie

On 10/13/2015 07:14 PM, John Garry wrote:
> On 13/10/2015 07:12, Hannes Reinecke wrote:
>> On 10/12/2015 05:20 PM, John Garry wrote:
>>> This SAS ID is chosen as Huawei IEEE id: 001882
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/scsi/hisi_sas/hisi_sas_init.c | 15 +++++++++++++++
>>>   1 file changed, 15 insertions(+)
>>>
>>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c
>>> b/drivers/scsi/hisi_sas/hisi_sas_init.c
>>> index 44fc524..c295c39 100644
>>> --- a/drivers/scsi/hisi_sas/hisi_sas_init.c
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
>>> @@ -283,6 +283,19 @@ err_out:
>>>       return NULL;
>>>   }
>>>
>>> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
>>> +{
>>> +    u8 i;
>>> +
>>> +    /* Huawei IEEE id (001882) */
>>> +    for (i =3D 0; i < hisi_hba->n_phy; i++)
>>> +        hisi_hba->phy[i].dev_sas_addr =3D
>>> +            cpu_to_be64(0x5001882016072015ULL);
>>> +
>> Ouch. Each phy has the same SAS address?
>> For all boards? Ever?
>>
>> Not sure if that's a good idea, nor even valid.
>> It'll confuse the hell out of any SAS array.
>>
>> Please provide a means of having individual SAS addresses for each
>> HBA.
>>
>> Cheers,
>>
>> Hannes
>>
> Hello,
>=20
> Are you saying we should be getting the SAS address from fw with
> sas_request_addr() or the like?
>=20
> Marvell solution seems to hardcode it.
>=20
Doesn't make it any better, nor even valid.

Problem is that using a hardcoded SAS address makes it impossible
do any resource allocation on a SAS target array.
The SAS target array is allocating / mapping the LUNs based on the
SAS address, so if HBAs from different machines coming in with the
same SAS address the SAS array will assume that all ports belong to
the same machine, thus allowing access to all of them.

And don't try to _ever_ connect these HBAs to a SAS switch; that
will be even more confused.

So please, if you have a chance _DO_ get the SAS address from fw.
If the firmware doesn't provide it you really should get in touch
with the firmware team to get you one.

To clarify the situation the SAS spec states:

  Device names are worldwide unique names for devices within a
  transport protocol (see SAM-3).

and:
  The VENDOR - SPECIFIC IDENTIFIER contains a 36-bit numeric value
  that is uniquely assigned by the organization associated with the
  company identifier in the IEEE COMPANY ID field.

So as you are using the Huawei Vendor ID Huawei as a company needs
to ensure uniqueness of the vendor-specific identifier (ie the last
36 bits of the SAS address). Which the above patch most patently
fails to address.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
