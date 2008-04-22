From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Tue, 22 Apr 2008 16:47:52 -0500
Message-ID: <480E5D08.3000905@cs.wisc.edu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>	
	<20080416011842.19580.92056.sendpatchset@chandra-ubuntu>	
	<4806294C.9090703@cs.wisc.edu>
	<1208390384.1025.40.camel@chandra-ubuntu>	
	<48078571.9040806@cs.wisc.edu>
	<1208898559.1025.191.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1208898559.1025.191.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, device-mapper development <dm-devel@redhat.com>, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> On Thu, 2008-04-17 at 12:14 -0500, Mike Christie wrote:
>> Chandra Seetharaman wrote:
>>> On Wed, 2008-04-16 at 11:29 -0500, Mike Christie wrote:
>>>> Chandra Seetharaman wrote:
>>>>> +
>>>>> +static int send_cmd(struct scsi_device *sdev, int cmd)
>>>>> +{
>>>>> +	struct request *rq = get_req(sdev, cmd);
>>>>> +
>>>>> +	if (!rq)
>>>>> +		return SCSI_DH_RES_TEMP_UNAVAIL;
>>>>> +
>>>>> +	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
>>>>> +}
>>>>> +
>>>> My only concerns are:
>>>>
>>>> 1. EMC and HP need to send a command to every device to transition them. 
>>>> Because we do blk_execute_rq from the dm multipath workqueue we can now 
>>>> only failover/failback for a couple devices at a time.
>>>>
>>>> I am not sure if this is a big deal, because this the error handler path 
>>>> so it is going to be slower than the normal path. But it seems like 
>>> Yes. But...
>>>
>>> pg_init() due to failover/failback will be sent only when I/O is
>>> sent/resent to a multipath device, isn't it ? and we don't expect I/Os
>>> to be sent to all the devices at the same time (all the time), do we ?
>>>
>> I am not sure what you mean by all the time, because I am talking about 
> 
> What I meant was that we do not expect I/Os to be sent to all the
> devices at all the times (pg_init will be sent only when I/Os fails on a
> path, right ?).
> 
> Sorry for not being clear.
> 

No problem.


>> failover times above. And for failover I think I said yes in the 
>> previous mail. For EMC we are currently sending failover commands to all 
>> the devices at the same time, because EMC does not do the controller 
>> failover RDAC does.
> 
> RDAC doesn't do controller failover. It also does per lun failover.
> 

Oh yeah, I forgot.


>>> So, as you pointed, is it a big deal ? :)
>>>
>> In the previous mail I specifically said users might care, because they 
>> are picky about failover times, real    3m39.728s
> user    0m4.135s
> sys     0m14.536s
> 
>> so the answer is to your question is 
>> what I said before, maybe :) I said I am not sure, because I do not have 
>> any numbers for the failover times.
> 
> Since RDAC also does the failover per device (as is the case with EMC),
> I ran tests on about 49 luns. I ran disktest on all the disks at the

Thanks.

> same time and disabled/enabled the port to the preferred path to
> generate failover and failback.
> 
> Let me know what do you think.
> 
> Here are the results:
> Tests run in an idle system. With 49 luns and the following script:
> ******************************************************
> for i in `ls -1 /dev/mapper/mpath*`
> do
> 	disktest $i -L 4000 -t 100 -P X &
> 	sleep 1
> done
> 
> wait
> ******************************************************
> Simple Run:
> 
> with patchset:		2.6.25-mm1:
> real    3m30.122s	real    3m29.746s
> user    0m4.069s	user    0m4.099s
> sys     0m14.876s	sys     0m14.535s
> -----------------------------------------------

Is this just a boot up test or a test just running IO but no 
failback/failover?

> 
> Failover Run:
> 
> with patchset:		2.6.25-mm1:
> real    5m18.875s	real    5m31.741s
> user    0m4.069s	user    0m3.883s
> sys     0m14.838s	sys     0m13.822s

Ehh, I have no idea if this is good or bad. Does it mean it is talking 
13 more seconds to complete?

Have you seen the type of thread on dm-devel or the iscsi list where 
people are concerned with getting the time the failure is detected to 
the time IO is running on a new path down from something like 10 to 5 
seconds. One time the iscsi driver did not implement time2wait correctly 
and by fixing it we shaved only 2 seconds off and users were very happy 
with the extra 2 seconds. We added the nop timer stuff so we could get 
faster failovers. We have the fast io fail tmo so we can speed up the 
process even more. Shaving off a second here or there is really nitpicky 
and if I were you I would give me the middle finger :) It just seems 
like people expect better performance from this type of error.

If my comment is too nitpicky then I am fine with ignoring this for now. 
We just have to fix the emc short/long tress pass code then. I added 
another EMC guy to the thread so he can ping the other EMC devs to get 
going (I had sent them questions on how to handle it and have not got a 
response).
