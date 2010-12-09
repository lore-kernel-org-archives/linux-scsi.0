From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [Open-FCoE] [PATCH] add stats info for FC rports
Date: Thu, 09 Dec 2010 11:17:44 -0800
Message-ID: <4D012B58.3030804@cisco.com>
References: <AANLkTi=mwHmJwNwCqJXxGXsfyULpnTX0t7rOq3eV9YOF@mail.gmail.com>	<4D000183.9050804@cisco.com> <AANLkTikWJ-M53Qvd+bM9_xZ11it=gz3p5qVQN037fGT_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:65411 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab0LITSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 14:18:31 -0500
In-Reply-To: <AANLkTikWJ-M53Qvd+bM9_xZ11it=gz3p5qVQN037fGT_@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org



On 12/9/10 6:18 AM, Hillf Danton wrote:
> On Thu, Dec 9, 2010 at 6:06 AM, Joe Eykholt <jeykholt@cisco.com> wrote:
>>
>>
>> On 12/8/10 5:27 AM, Hillf Danton wrote:
>>> Stats info is added, in the define of local port, to monitor the usage
>>> of remote ports.
>>>
>>> Then it is simple to answer how many rport data leaked in the life
>>> cycle of lport.
>>>
>>> This work is motivated to capture mm leak of rports of
>>> FC_FID_DIR_SERV, and thanks for dropping a reply to this message if
>>> captured.
>>
>> This sounds like code that could be done locally and then
>> tossed out once the leak is found.  Also, there is already a list
>> of remote ports, I think, so the count is redundant info.
> 
> It is fine to read your comments, Joe, in winter evening.
> 
> Though the list is defined, rport of FC_FID_DIR_SERV is not added
> onto it, at least when created, which is hard to trace then.
> 
> And FC_FID_DIR_SERV is the major concern of this work.
> If captured, fix should have been delivered.
> 
>>
>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>> ---
>>>
>>> --- a/include/scsi/libfc.h    2010-11-01 19:54:12.000000000 +0800
>>> +++ b/include/scsi/libfc.h    2010-12-08 21:05:46.000000000 +0800
>>> @@ -803,6 +803,9 @@ struct fc_lport {
>>>       void                           *scsi_priv;
>>>       struct fc_disc                 disc;
>>>
>>> +     /* stats info of the usage of rports */
>>> +     unsigned long                   nr_rdata;
>>> +
>>>       /* Virtual port information */
>>>       struct list_head               vports;
>>>       struct fc_vport                *vport;
>>> --- a/drivers/scsi/libfc/fc_rport.c   2010-11-01 19:54:12.000000000 +0800
>>> +++ b/drivers/scsi/libfc/fc_rport.c   2010-12-08 21:16:40.000000000 +0800
>>> @@ -128,7 +128,7 @@ static struct fc_rport_priv *fc_rport_cr
>>>       rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
>>>       if (!rdata)
>>>               return NULL;
>>> -
>>> +     lport->nr_rdata++;
>>>       rdata->ids.node_name = -1;
>>>       rdata->ids.port_name = -1;
>>>       rdata->ids.port_id = port_id;
>>> @@ -159,6 +159,7 @@ static void fc_rport_free_rcu(struct rcu
>>>       struct fc_rport_priv *rdata;
>>>
>>>       rdata = container_of(rcu, struct fc_rport_priv, rcu);
>>> +     rdata->local_port->nr_rdata--;
>>
>> What about locking?  I don't think you should do this in the rcu
> 
> Locking here looks unnecessary, since lport could not goto Mars.
> If could, lot of orphans have to stay on Earth with no more care.

The lport could go away before the rport is freed by rcu.
Also, two rports could be freed in rcu callbacks at the same time,
so two decrements of nr_rdata could be concurrent and you would
get nondeterministic results since the decrement isn't atomic.


>> callback because the local port may no longer exist. Instead, I
>> would do it in fc_rport_destroy.
>>
>>>       kfree(rdata);
>>>  }
>>>
>>> @@ -1880,7 +1881,7 @@ int fc_rport_init(struct fc_lport *lport
>>>
>>>       if (!lport->tt.rport_destroy)
>>>               lport->tt.rport_destroy = fc_rport_destroy;
>>> -
>>> +     lport->nr_rdata = 0;
>>
>> Everything in the lport starts as zero, so no need to insert this explicitly.
> 
> When initing lport, clarity could be redundant.

So, you agree or not?

>>>       return 0;
>>>  }
>>>  EXPORT_SYMBOL(fc_rport_init);
>>> --- a/drivers/scsi/libfc/fc_fcp.c     2010-11-01 19:54:12.000000000 +0800
>>> +++ b/drivers/scsi/libfc/fc_fcp.c     2010-12-08 21:19:20.000000000 +0800
>>> @@ -2184,6 +2184,11 @@ void fc_fcp_destroy(struct fc_lport *lpo
>>>  {
>>>       struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
>>>
>>> +     if (lport->nr_rdata != 0)
>>> +             printk(KERN_WARNING "libfc: %lu Leaked rports when "
>>> +                     "destroying local port (%6.6x)\n",
>>> +                     lport->nr_rdata, lport->port_id);
>>> +
>>
>> The equivalent of this check should go into fc_rport.c, not here.
> 
> When destroying lport, it is the right place to report leakage.

Yes, but there's a call from lport destroy into rport, and that's the
place to report rport leakage, not in the FCP module.  For one thing,
not all LLDs use that fcp module.

> Cheers
> Hillf
> 
>>
>>>       if (!list_empty(&si->scsi_pkt_queue))
>>>               printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
>>>                      "port (%6.6x)\n", lport->port_id);
>>> _______________________________________________
>>> devel mailing list
>>> devel@open-fcoe.org
>>> http://www.open-fcoe.org/mailman/listinfo/devel
>>
