From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 10/21] lpfc: Fix provide host name and OS name in RSNN-NN
 FC-GS command
Date: Mon, 16 Feb 2015 11:22:20 -0500
Message-ID: <54E2193C.3020204@emulex.com>
References: <1423164268.7917.34.camel@myfc17> <54D4B18D.2070306@redhat.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:31093 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbbBPQW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2015 11:22:58 -0500
In-Reply-To: <54D4B18D.2070306@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org

agree - nice nit.

I'll add this to the list of things to merge in the next patch update.

-- james


On 2/6/2015 7:20 AM, Tomas Henzl wrote:
> On 02/05/2015 08:24 PM, James Smart wrote:
>> ---
>>   drivers/scsi/lpfc/lpfc_ct.c | 23 ++++++++++++++++++++---
>>   1 file changed, 20 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
>> index 61a32cd..5091184 100644
>> --- a/drivers/scsi/lpfc/lpfc_ct.c
>> +++ b/drivers/scsi/lpfc/lpfc_ct.c
>> @@ -1070,12 +1070,29 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
>>   	size_t size)
>>   {
>>   	char fwrev[FW_REV_STR_SIZE];
>> -	int n;
>> +	int n = 0;
> No need for this^ initialisation , as 'n' is directly set  two lines later
>
>>   
>>   	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
>>   
>> -	n = snprintf(symbol, size, "Emulex %s FV%s DV%s",
>> -		vport->phba->ModelName, fwrev, lpfc_release_version);
>> +	n = snprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
>> +
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
>> +
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " DV%s", lpfc_release_version);
>> +
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " HN:%s", init_utsname()->nodename);
>> +
>> +	/* Note :- OS name is "Linux" as per requirement BZ168199. */
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
>> +
>>   	return n;
>>   }
>>   
>
>

