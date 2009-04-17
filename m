From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: LSF: Multipathing and path checking question
Date: Fri, 17 Apr 2009 10:21:54 -0500
Message-ID: <49E89E92.7070709@cs.wisc.edu>
References: <49E7B845.70400@cs.wisc.edu> <49E834CD.1090306@suse.de>
	<49E89866.50205@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E89866.50205@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Oops, I mashed two topics together. See below.

Mike Christie wrote:
> Hannes Reinecke wrote:
>>
>> FC Transport already maintains an attribute for the path state, and even
>> sends netlink events if and when this attribute changes. For iSCSI I have
> 
> Are you referring to fc_host_post_event? Is the same thing we talked 
> about last year, where you wanted events? Is this in multipath tools now 
> or just in the SLES ones?
> 
> For something like FCH_EVT_LINKDOWN, are you going to fail the path at 
> that time or when would the multipath path be marked failed?
> 

I was asking this because it seems we have people always making 
bugzillas saying they did not want the path to be marked failed for 
short problems.

There was the problem where we might get DID_ERROR for temporary dropped 
frame. That would be fixed by just listening to transport events like 
you explained.

But then I thought there was the case where if we get a linkdown then 
linkup within a couple seconds, we would not want to transition the 
multipath path state.

So below while you were talking about when to remove the device, I was 
talking about when to mark the path failed.



> 
> You got my hopes up for a solution in the the long explanation, then you 
> destroyed them :)
> 
> 
> Was the reason people did not like this because of the scsi device 
> lifetime issue?
> 
> 
> I think we still want someone to set the fast io fail tmo for users when 
> multipath is being used, because we want IO out of the queues and 
> drivers and sent to the multipath layer before dev_loss_tmo if 
> dev_loss_tmo is still going to be a lot longer. fast io fail tmo is 
> usually less than 10 or 5 and for dev_loss_tmo seems like we still have 
> user setting that to minutes.
> 
> 
> Can't the transport layers just send two events?
> 1. On the initial link down when the port/session is blocked.
> 2. When there fast io fail tmos fire.


So for #2, I just want a way to figure out when the transport is giving 
up on executing IO and is going to fail everything. At that time, I was 
thinking we want to mark the path failed.

I guess if multipiath tools is going to set fast io fail, it could also 
use that as its down timer to decide when to fail the path and not have 
to send SG IO or a bsg transport command.


> 
> Today, instead of #2, the Red Hat multipath tools guy and I were talking 
> about doing a probe with SG_IO. For example we would send down a path 
> tester IO and then wait for it to be failed with DID_TRANSPORT_FAILFAST.
> 
> Or for #2 if we cannot have a new event, can we send a transport level 
> bsg request? For iscsi this would be a nop. For FC, I am not sure what 
> it would be?
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
