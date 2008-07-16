From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 15:49:26 -0500
Message-ID: <487E5ED6.9040302@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com> <487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu> <D1D4C3FF75F9354393DB8314DF43DEF2E7F025@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56678 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbYGPUtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 16:49:39 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F025@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
>  
> 
>> -----Original Message-----
>> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
>>
>>> So during a clean shutdown are drivers supposed to remove 
>> the targets by 
>>> calling scsi_remove_target to remove the devices, then 
>> remove the rports 
>>> through the class?
>> Or for the case where we are stopping a host (rmmod or single 
>> host stop 
>> like with fcoe), should drivers call
> 
> Yes - the steps below is what the drivers do today.  And this does all
> work without failing the cache sync (unless something's changed recently
> in the midlayer above us).

You mean if I do rmmod lpfc it should work today? I do not think it 
works anymore because in fc_remove_host we do this:

fc_remove_host()

         /* Remove any remote ports */
         list_for_each_entry_safe(rport, next_rport,
                         &fc_host->rports, peers) {
                 list_del(&rport->peers);
                 rport->port_state = FC_PORTSTATE_DELETED;
                 fc_queue_work(shost, &rport->rport_delete_work);
         }


We set the rport->port_state to deleted before removing the target, so 
when the cache sync is sent later as a result of fc_rport_final_delete 
calling scsi_remove_target, the fc_remote_port_chkready checks in lpfc 
or qla2xxx or mpt's queeucommand will fail the command with 
DID_NO_CONNECT (fc_remote_port_chkready will

> 
>> 1. fc_remove_host()
>> 	This could be modified to cleanup shutdown targets then 
>> remove rports. 
>> We could then have a rport shutdown callback which the class 
>> could call 
>> and drivers could cleanup and shutdown the rport here before 
>> it is freed.
> 
> Is this related to your new scsi-target block code ?

No. It is unrelated. The block code patch is just to handle the case 
where when fc_timeout_fail_rport_io calls terminate_rport_io, and we 
will fail IO in the driver, but if there is IO in the blocked request 
queues we will just queue that back up until dev loss tmo fires. The 
problem there is because the fc_remote_port_chkready calls in the LLDs 
queuecommand will see the rport is blocked with a dev loss pending they 
will return DID_IMM_RETRY.

So if you have fast io fail tmo at 3 seconds and dev loss tmo at 120 
seconds, we could get initial IO errors after 3 seconds, but IO in the 
blocked queue will not be sent upwards until 120 seconds later. With the 
block patches all the IO will be sent upwards after 3 seconds.


> Yes - agree with your comment - we can change it so that it cleansup
> the blocked target, then terminates the rport.
>> 2. scsi_remove_host()
>>
>> 3. cleanup internal host resources.
>>
>> 4. scsi_put_host().
>>
> 
> 
> -- james
> 
> 
> 

