From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] scsi: remove useless variable assignment
Date: Thu, 18 May 2017 12:41:07 -0500
Message-ID: <20170518124107.Horde.TAwM83c0HSIrAfOVg_W7two@gator4166.hostgator.com>
References: <20170518003043.GA5664@embeddedgus>
 <1495082398.2840.14.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.46.107]:11855 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932338AbdERRlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 13:41:12 -0400
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id CF42F400D33EF
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 12:41:09 -0500 (CDT)
In-Reply-To: <1495082398.2840.14.camel@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi James,

Quoting James Bottomley <jejb@linux.vnet.ibm.com>:

> On Wed, 2017-05-17 at 19:30 -0500, Gustavo A. R. Silva wrote:
>> Remove this assignment once the value stored in variable _k_ is
>> overwritten after a few lines.
>>
>> Addresses-Coverity-ID: 1226927
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>  drivers/scsi/qlogicfas408.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qlogicfas408.c
>> b/drivers/scsi/qlogicfas408.c
>> index c3a9151..269440a 100644
>> --- a/drivers/scsi/qlogicfas408.c
>> +++ b/drivers/scsi/qlogicfas408.c
>> @@ -329,7 +329,6 @@ static unsigned int ql_pcmd(struct scsi_cmnd
>> *cmd)
>>  		 */
>>  		if ((k = ql_wai(priv)))
>>  			return (k << 16);
>> -		k = inb(qbase + 5);	/* should be 0x10, bus
>> service */
>
> That doesn't look right to me.  inb() is a statement which has an
> effect on the I/O device regardless of whether the returned value is
> used or discarded.  In this case I think it's being used to clear
> pending interrupts, so removing it will likely cause a phase error.
>

You are right, I get it.

In this case I think a patch to ignore the return value could be applied:

index c3a9151..8f5339a 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -329,7 +329,7 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
                  */
                 if ((k = ql_wai(priv)))
                         return (k << 16);
-               k = inb(qbase + 5);     /* should be 0x10, bus service */
+               inb(qbase + 5); /* should be 0x10, bus service */
         }

What do you think?

Thank you for the clarification.
--
Gustavo A. R. Silva
