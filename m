From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] bnx2fc: Do not log error for netevents that need no
 action
Date: Thu, 12 Jun 2014 14:01:10 -0400
Message-ID: <alpine.OSX.2.00.1406121400240.3733@administrators-macbook-pro.local>
References: <1402077959-13170-1-git-send-email-spargaonkar@suse.com> <1402435746.18569.5.camel@lbirv-waie-lx2.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:54698 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbaFLSC0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2014 14:02:26 -0400
In-Reply-To: <1402435746.18569.5.camel@lbirv-waie-lx2.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: shirishpargaonkar@gmail.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, Giridhar Malavali <giridhar.malavali@qlogic.com>


On Tue, 10 Jun 2014, Eddie Wai wrote:

> On Fri, 2014-06-06 at 13:05 -0500, shirishpargaonkar@gmail.com wrote:
>> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>>
>>
>> Do not log error for netevents that need no action such as
>> NETDEV_REGISTER 0x0005, NETDEV_CHANGEADDR, and NETDEV_CHANGENAME.
>> It results in logging error messages such as these
>>
>> [   35.315872] bnx2fc: Unknown netevent 5
>> [   35.315935] bnx2fc: Unknown netevent 8
>> [   35.353866] bnx2fc: Unknown netevent 10
>>
>> and generating bug reports.
>> Remove logging this message as an ERROR instead of turning them into
>> either DEBUG or INFO level messages.
>>
>>
>> Signed-by: Shirish Pargaonkar <spargaonkar@suse.com>
>> ---
>>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index 1d41f4b..c7388a8 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -856,7 +856,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
>>  		return;
>>
>>  	default:
>> -		printk(KERN_ERR PFX "Unknown netevent %ld", event);
>>  		return;
>>  	}
>>
> Thanks for fixing this, Shirish.  It makes sense to suppress the
> unwanted netevent messages.
>
> The patch looks good to me, but we should really get the current bnx2fc
> maintainer from Qlogic to ACK this.
>
> Acked-by: Eddie Wai <eddie.wai@broadcom.com>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Looks fine to me as well.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
