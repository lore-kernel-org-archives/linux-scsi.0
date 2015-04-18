From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in RSNN-NN
 FC-GS command
Date: Sat, 18 Apr 2015 11:40:59 -0400
Message-ID: <55327B0B.2010009@emulex.com>
References: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com> <20150415000218.00007e7c@localhost>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:19060 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbbDRPlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2015 11:41:25 -0400
In-Reply-To: <20150415000218.00007e7c@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

Fixes those things that parse the result of what data is registered with 
the fabric.

-- james


On 4/14/2015 6:02 PM, Sebastian Herbszt wrote:
> James Smart wrote:
>> Fix provide host name and OS name in RSNN-NN FC-GS command
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
>> Signed-off-by: James Smart <james.smart@emulex.com>
>> ---
>>   drivers/scsi/lpfc/lpfc_ct.c | 21 +++++++++++++++++++--
>>   1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
>> index 61a32cd..5fb431a 100644
>> --- a/drivers/scsi/lpfc/lpfc_ct.c
>> +++ b/drivers/scsi/lpfc/lpfc_ct.c
>> @@ -1074,8 +1074,25 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
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
>> +	/* Note :- OS name is "Linux" */
>> +	if (size < n)
>> +		return n;
>> +	n += snprintf(symbol + n, size - n, " OS:%s", init_utsname()->sysname);
>> +
>>   	return n;
>>   }
> Does this actually "fix" anything? If not maybe drop "fix" from the
> patch subject and description.
>
> Sebastian
>
>

