From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Re: [PATCH] Add ALUA hardware handler
Date: Thu, 11 Oct 2007 12:19:51 -0500
Message-ID: <470E5B37.1060902@cs.wisc.edu>
References: <470CCBB0.2020904@suse.de> <470D1DAE.1000900@cs.wisc.edu>
	<470DDF6F.5090909@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <470DDF6F.5090909@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Mike Christie wrote:
>> Hannes Reinecke wrote:
>>> Hi Alasdair,
>>>
>>> this is a patch to add a SPC-3 hardware handler. SPC-3 ALUA has
>>> provisioning for 'explicit' port group state change via the
>>> SET TARGET GROUP STATES command, and some newer storage
>>> arrays do benefit from this.
>>> Eg HP EVAs and newer EMC Clariions already support explicit ALUA.
>>>
>>> Please apply.
>>>
>>> Cheers,
>>>
>>> Hannes
>>>
>> Does this also work for adaptec or snap iscsi targets or whatever they
>> are called targets?
>>
> Don't know, I don't have one. Care to try?

I do not have it. I was asking because some people were asking about 
alua and I told them to talk to you.

> 
>>
>> Just some quick higher level comments
>>
>> +static int submit_std_inquiry(struct alua_handler *h)
>> +{
>> +    struct request *rq;
>> +    unsigned err = (DRIVER_ERROR << 24);
>> +
>> +    rq = prepare_req(h, h->inq, TPGS_INQUIRY_SIZE, READ);
>>
>>
>> I do not think you want to use GFP_KERNEL allocations in this path, so
>> all the prepare_req allocs should be changed. GFP_NOIO is probably best.
>>
> Yes, probably.
> 
>> +    if (!rq)
>> +        return err;
>> +
>> +    /* Prepare the command. */
>> +    rq->cmd[0] = INQUIRY;
>> +    rq->cmd[1] = 0;
>> +    rq->cmd[2] = 0;
>> +    rq->cmd[4] = TPGS_INQUIRY_SIZE;
>> +    rq->cmd_len = COMMAND_SIZE(INQUIRY);
>> +
>> +    blk_execute_rq(rq->q, NULL, rq, 1);
>>
>> There is only one workqueue for all the dm devices, so you do not want
>> to do one command (or how many processors there are) at a time and wait
>> for each one to complete with blk_execute_rq. You should use the async
>> one, blk_execute_rq_nowait, like rdac.
>>
> This is actually by design. Problem here is the port group as returned by
> REPORT TARGET PORT GROUPS does not have any association to the controller
> which handles these ports.
> So if we were to send all REPORT TARGET PORT GROUPS commands (roughly)
> simultaneously we're pretty much guaranteed to hit the same controller
> several times; and if we have to do a SET TARGET PORT GROUPS in addition
> we'll be having to do loads of retries as the controller might be busy
> (if he's transitioning) or reporting an UNIT ATTENTION if the port
> group states have been updated. So I'd rather keep it that way so as
> to not flood the controller. And then we're only having to send two
> commands, so this should okay even sequentially.

What if I have emc box and another non alua box? Your handler blocks 
activity for all other devices.

> 
> And incidentally, rdac implements it's own workqueue per controller

rdac does one single threaded workqueue for the entire module, and it 
does not send IO synchronously.

> as it's only capable to handle one MODE SELECT command at time.
> 

Yeah, and chandra handled it in a way that does not affect all other 
handlers.
