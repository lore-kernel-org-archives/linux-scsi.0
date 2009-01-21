From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Q] In sg_io_v4 what to use as flag for "queue at_head"
Date: Wed, 21 Jan 2009 10:12:20 +0200
Message-ID: <4976D8E4.2010500@panasas.com>
References: <49746197.200@panasas.com>	<4974BBC5.3080001@interlog.com> <20090121133437Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27502 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753218AbZAUIM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2009 03:12:27 -0500
In-Reply-To: <20090121133437Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

FUJITA Tomonori wrote:
> On Mon, 19 Jan 2009 12:43:33 -0500
> Douglas Gilbert <dgilbert@interlog.com> wrote:
> 
>> Boaz Harrosh wrote:
>>> Douglas Gilbert <dougg@torque.net> wrote ...
>>>> struct sg_io_v4 {
>>>> 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
>>>> 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
>>>> 	__u32 subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
>>>> 				   management function, .... */
>>>>
>>>> 	__u32 request_len;	/* [i] in bytes */
>>>> 	__u64 request;		/* [i], [*i] {SCSI: cdb} */
>>>> 	__u64 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
>>>> 	__u32 request_attr;	/* [i] {SCSI: task attribute} */
>>>> 	__u32 request_priority;	/* [i] {SCSI: task priority} */
>>>> 	__u32 request_extra;	/* [i] {spare, for padding} */
>>>> 	__u32 max_response_len;	/* [i] in bytes */
>>>> 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
>>>>
>>>>         /* "dout_": data out (to device); "din_": data in (from device) */
>>>> 	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
>>>> 				   dout_xfer points to array of iovec */
>>>> 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
>>>> 	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
>>>> 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
>>>> 	__u64 dout_xferp;	/* [i], [*i] */
>>>> 	__u64 din_xferp;	/* [i], [*o] */
>>>>
>>>> 	__u32 timeout;		/* [i] units: millisecond */
>>>> 	__u32 flags;		/* [i] bit mask */
>>>> 	__u64 usr_ptr;		/* [i->o] unused internally */
>>>> 	__u32 spare_in;		/* [i] */
>>>>       ...
>>> Currently because of a twisted accident sg and bsg queue their async
>>> request with the "at_head" flag set when calling blk_execute_rq_nowait.
>>>
>>> Since sg_io_v4 is new and as plenty of possible choices, what would be
>>> the best place to put the "at_head" flag?
>>>
>>> Douglas ?
>>> What was your intention with the above:
>>>  	__u32 request_priority;	/* [i] {SCSI: task priority} */
>>>
>>> [And while at it, what was:
>>>  	__u32 request_attr;	/* [i] {SCSI: task attribute} */
>> Yes, task attribute. That is the term used by SAM-4
>> (and earlier). Unfortunately SAM-4 defines the names
>> but not values; those values are left up to the
>> transport. That presents a problem for a transport
>> agnostic SCSI pass-through interface like sg_io_v4.
>>
>> For backward compatibility we probably need to make the value
>> 0 mean "head of queue" (or whatever the mid-level default
>> task attribute is for pass-through SCSI commands).
>>
>> Also we probably don't have a clean pass-through of task
>> attributes in the SCSI mid-level currently. I mean "clean"
>> in the sense of "leave them alone" and do not act on the
>> command completion status (e.g. TASK SET FULL).
>>
>>> Should I define (bsg.h):
>>> enum {
>>> 	BSG_AT_HEAD = 0, /* compatible with old code */
>>> 	BSG_AT_TAIL,
>>> }
>>> And put it in request_priority
>> or (adding "_TA_" for task attribute):
>>    enum {
>>          BSG_TA_DEFAULT = 0,  // lk 2.4, 2.6 series: head of queue
>>          BSG_TA_HEAD_OF_Q = 0x1000,
>>          BSG_TA_SIMPLE,
>>          BSG_TA_ORDERED,
>>          BSG_TA_ACA,
>>          ....
>>> or define:
>>> #define SG_FLAG_AT_TAIL 0x10  /* See sg.h for more/other flags (sg.h flags are ignored by bsg) */
>>>
>>> And OR that into the old flags member that is otherwise
>>> unused by current bsg code
>> I would prefer using the request_attr field.
>>
>> Tomo, what do you think?
> 
> It should be request_attr, as you planed. request_priority is for the
> task (command) priority.
> 
> I'm not sure about inventing BSG_TA_* thing. If we do that, the
> transport classes need to have the own function to convert BSG_TA_* to
> their own attribute values, iscsi_bsg_to_attr(), fc_bsg_to_attr... If
> there are tons of users who want task attribute support in bsg, then
> it's worth doing that but...
> 
> How about letting users to do the proper thing? That's is, if he wants
> to send a command to iSCSI devices, he needs to set iSCSI task
> attribute value.

TOMO, Doug.

You have both not addressed my little need. I need a boolean flag to indicate
"at_head". Clearly request_attr and request_priority is not it since they
have a SCSI meaning, however unused. I will go head with my bit in flags.

And yes at_head matters a lot. Because the order of commands matter.
For one bsg's write() supports multiple requests so I will need to reverse
order them, and even so It is playing Russian roulette since the commands
can start executing and you can never know when. It is even worse if I don't
use multiple commands. I start queuing commands some are executed, new one comes
in I can never know if they execute in order. Come on clearly an "at_head" is a
mess, you must realize that. It is exactly for when things get messy, then
it's needed.

I will go with a new bit at the second nibble of flags.

Thanks
Boaz
