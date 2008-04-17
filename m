From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Thu, 17 Apr 2008 12:14:25 -0500
Message-ID: <48078571.9040806@cs.wisc.edu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>	<20080416011842.19580.92056.sendpatchset@chandra-ubuntu>	<4806294C.9090703@cs.wisc.edu>
	<1208390384.1025.40.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1208390384.1025.40.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> On Wed, 2008-04-16 at 11:29 -0500, Mike Christie wrote:
>> Chandra Seetharaman wrote:
>>> +
>>> +static int send_cmd(struct scsi_device *sdev, int cmd)
>>> +{
>>> +	struct request *rq = get_req(sdev, cmd);
>>> +
>>> +	if (!rq)
>>> +		return SCSI_DH_RES_TEMP_UNAVAIL;
>>> +
>>> +	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
>>> +}
>>> +
>> My only concerns are:
>>
>> 1. EMC and HP need to send a command to every device to transition them. 
>> Because we do blk_execute_rq from the dm multipath workqueue we can now 
>> only failover/failback for a couple devices at a time.
>>
> 
>> I am not sure if this is a big deal, because this the error handler path 
>> so it is going to be slower than the normal path. But it seems like 
> 
> Yes. But...
> 
> pg_init() due to failover/failback will be sent only when I/O is
> sent/resent to a multipath device, isn't it ? and we don't expect I/Os
> to be sent to all the devices at the same time (all the time), do we ?
> 

I am not sure what you mean by all the time, because I am talking about 
failover times above. And for failover I think I said yes in the 
previous mail. For EMC we are currently sending failover commands to all 
the devices at the same time, because EMC does not do the controller 
failover RDAC does.

> So, as you pointed, is it a big deal ? :)
> 

In the previous mail I specifically said users might care, because they 
are picky about failover times, so the answer is to your question is 
what I said before, maybe :) I said I am not sure, because I do not have 
any numbers for the failover times.

> BTW, As you know, it was originally coded that way(patchset posted on
> Jan 23, 2008) and later changed as per James comments (through you) that
> the code was overusing blk_execute_rq_nowait().
>  

Yes, I know, and as you know I did not agree with James. The reason I 
bring it up again is that Ed is not doing dm-multipath stuff, so EMC 
does not have a good reviewer right now, and I want to make sure these 
issues are raised on the list during the review so we can all discuss 
them together.

If James thinks it is a big enough problem he can offer some of this 
alternatives. If not then he will merge it and we can see if people even 
notice and handle it later. I just want to make sure we all know what is 
going on, because Alasdair is not a scsi guy. James does not know all 
the fun details of every box. And the EMC guys are not up to speed on 
linux. I am just worried we are going to get a bad review.
