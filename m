From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 2/5] bnx2fc: Release the reference to hba only after
 the interface is destroyed
Date: Mon, 25 Apr 2011 16:15:32 -0700
Message-ID: <4DB60094.3030205@broadcom.com>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
 <1303759810-22570-2-git-send-email-bprakash@broadcom.com>
 <DBFB1B45AF80394ABD1C807E9F28D157032A5620C4@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1648 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1DYXPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 19:15:45 -0400
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D157032A5620C4@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shyam_Iyer@Dell.com" <Shyam_Iyer@Dell.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>

On 4/25/2011 3:49 PM, Shyam_Iyer@Dell.com wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Bhanu Prakash Gollapudi
>> Sent: Monday, April 25, 2011 3:30 PM
>> To: linux-scsi@vger.kernel.org; devel@open-fcoe.org
>> Cc: Nithin Nayak Sujir; Bhanu Prakash Gollapudi
>> Subject: [PATCH 2/5] bnx2fc: Release the reference to hba only after
>> the interface is destroyed
>>
>> From: Nithin Nayak Sujir<nsujir@broadcom.com>
>>
>> Prematurely decrementing the reference may lead to cmd_mgr becoming
>> NULL with
>> the cmds are still active.
>>
>> Signed-off-by: Nithin Nayak Sujir<nsujir@broadcom.com>
>> Signed-off-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
>> ---
>>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index 8fb9b6e..734d8c1 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -1370,8 +1370,6 @@ static void bnx2fc_if_destroy(struct fc_lport
>> *lport)
>>   	/* Free existing transmit skbs */
>>   	fcoe_clean_pending_queue(lport);
>>
>> -	bnx2fc_interface_put(hba);
>> -
>>   	/* Free queued packets for the receive thread */
>>   	bnx2fc_clean_rx_queue(lport);
>>
>> @@ -1399,6 +1397,8 @@ static void bnx2fc_if_destroy(struct fc_lport
>> *lport)
>>
>>   	/* Release Scsi_Host */
>>   	scsi_host_put(lport->host);
>> +
>> +	bnx2fc_interface_put(hba);
>>   }
>>
>
>
> Shouldn't we decrease refcount for interface before the scsi host refcount is decreased..?
> It doesn't probably make a difference here since we are having a 1:1 between an interface and a host but it saves bugs later when things change..

Shyam, Thanks for the review.

Actually, it doesn't matter either way. When the hba refcount goes to 0, 
FIP controller and driver's command manager are destroyed which have no 
dependency on scsi_host. There is a 1-1 mapping between lport and the 
scsi_host, where as hba can have multiple scsi hosts, one per NPIV lport.

>
> Also it probably makes sense to call scsi_host_put in bnx2fc_destroy rather than in bnx2fc_if_destroy..
scsi_host is not only for the physical ports, but also for NPIV ports. 
scsi_host_put should also be called for NPIV ports, and hence 
bnx2fc_if_destroy is the right place to call scsi_host_put.

>
> Maybe we could have more interfaces for a scsi host..
>
> Shout if this doesn't make any sense.
>
> -Shyam Iyer
>
>


