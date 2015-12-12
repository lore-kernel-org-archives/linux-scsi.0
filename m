From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 1/7] iscsi-target: Use a variable initialisation in
 iscsi_set_default_param() directly
Date: Sat, 12 Dec 2015 22:22:55 +0100
Message-ID: <566C902F.8070802@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
 <566C308A.6000109@users.sourceforge.net> <20151212194939.GQ5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151212194939.GQ5284@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>> @@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
>>  		char *name, char *value, u8 phase, u8 scope, u8 sender,
>>  		u16 type_range, u8 use)
>>  {
>> -	struct iscsi_param *param = NULL;
>> +	struct iscsi_param *param = kzalloc(sizeof(*param), GFP_KERNEL);
>>  
>> -	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
>>  	if (!param) {
>>  		pr_err("Unable to allocate memory for parameter.\n");
>>  		goto out;
> 
> It's better to just get rid of the initialization but leave the
> kzalloc() as-is for two reasons.
> 
> 1)  Initializer code normally contains more bugs per line than other
>     code.  I am thinking about dereferencing pointers before checking
>     for NULL or not checking the allocation for failure.

I can follow your concerns a bit.


> 2)  It puts a blank line between the allocation and the check for failure.

Is there a target conflict between "convenient" variable initialisation
in the declaration section and the function outline that seems to be checked
by the script "checkpatch.pl" to some degree while corresponding preferences
or recommendations are not mentioned in the document "CodingStyle"?


>     It's like a new paragraph.

I do not see the separation in a strict way so far.


>     The allocation and the check should be next to each other.

I find that these actions are still close enough in the discussed use case.

Regards,
Markus
