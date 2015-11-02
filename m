From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 4/8] pm80xx: add support for ATTO devices during SAS
 address initiailization
Date: Mon, 2 Nov 2015 09:06:40 +0100
Message-ID: <CAD+HZHWhNFDq4z_MLaSNyY9jV-9Ub2ywtuT7wraRGo=FiNFRqA@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-5-git-send-email-brood@attotech.com>
	<56371681.4020102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34685 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbbKBIGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:06:41 -0500
Received: by lbbwb3 with SMTP id wb3so82428764lbb.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:06:40 -0800 (PST)
In-Reply-To: <56371681.4020102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Benjamin Rood <brood@attotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <benjaminjrood@gmail.com>

2015-11-02 8:53 GMT+01:00 Hannes Reinecke <hare@suse.de>:
> On 10/30/2015 03:53 PM, Benjamin Rood wrote:
>> ATTO SAS controllers retrieve the SAS address from the NVRAM in a location
>> different from non-ATTO PMC Sierra SAS controllers.  This patch makes the
>> necessary adjustments in order to retrieve the SAS address on these types
>> of adapters.
>>
>> Signed-off-by: Benjamin Rood <brood@attotech.com>
>> ---
>>  drivers/scsi/pm8001/pm8001_init.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
>> index feaf504..fdbfab6 100644
>> --- a/drivers/scsi/pm8001/pm8001_init.c
>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>> @@ -636,6 +636,11 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>>                       payload.minor_function = 0;
>>                       payload.length = 128;
>>               }
>> +     } else if ((pm8001_ha->chip_id == chip_8070 ||
>> +                     pm8001_ha->chip_id == chip_8072) &&
>> +             pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
>> +             payload.minor_function = 4;
>> +             payload.length = 4096;
>>       } else {
>>               payload.minor_function = 1;
>>               payload.length = 4096;
>> @@ -662,6 +667,11 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
>>                       else if (deviceid == 0x0042)
>>                               pm8001_ha->sas_addr[j] =
>>                                       payload.func_specific[0x010 + i];
>> +             } else if ((pm8001_ha->chip_id == chip_8070 ||
>> +                             pm8001_ha->chip_id == chip_8072) &&
>> +             pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
>> +                     pm8001_ha->sas_addr[j] =
>> +                                     payload.func_specific[0x010 + i];
>>               } else
>>                       pm8001_ha->sas_addr[j] =
>>                                       payload.func_specific[0x804 + i];
>>
> The indentation is a bit skewed here.
> Other than that:
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
>
> Cheers,
>
> Hannes
Agree with Hannes :), please fix this if you post V2.

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
