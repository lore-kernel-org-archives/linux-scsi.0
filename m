From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 03/18 ver2] libosd: OSDv1 Headers
Date: Wed, 12 Nov 2008 08:48:27 -0800
Message-ID: <491B08DB.1030809@oracle.com>
References: <491073BB.4000900@panasas.com>	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>	<4916F934.4090205@panasas.com> <20081110092940.57b4c169.randy.dunlap@oracle.com> <491AD5C8.8030406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753496AbYKLQvO@vger.kernel.org>
In-Reply-To: <491AD5C8.8030406@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>, johannes@sipsolutions.net
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> 
> Thank you Randy for your review, I will post a fixed
> patch shortly. I have changed according to your comments
> except in one place, see arguments below.
> 
>>> ---
>>>  include/scsi/osd_initiator.h |  332 ++++++++++++++++++++++++++++
>>>  include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++++++++++
>>>  include/scsi/osd_sec.h       |   45 ++++
>>>  include/scsi/osd_types.h     |   40 ++++
>>>  4 files changed, 914 insertions(+), 0 deletions(-)
>>>  create mode 100644 include/scsi/osd_initiator.h
>>>  create mode 100644 include/scsi/osd_protocol.h
>>>  create mode 100644 include/scsi/osd_sec.h
>>>  create mode 100644 include/scsi/osd_types.h

>>> +/**
>> Don't start comment blocks with /** when they are not kernel-doc,
>> like this one is not.
>>
> 
> OK, I must confess my kernel-doc total ignorance. I was imagining that
> each source file's kernel-doc comments are collected into an html file.
> I thought that this comment will be like an introduction to the following
> function-by-function reference. Anyway it's fixed

You can choose to have comments included in the kernel-doc's collected
output.  You do this by using this notation:

/** DOC <topic_name>:
 * <these lines are added to kernel-doc output when you use:
!P<filename> <topic_name>
 * a Documentation/DocBook/*.tmpl file.
 */

See Documentation/DocBook/mac80211.tmpl for examples.

Johannes, I thought that you had some usage documentation for DOC:.
Did you not or did it not get merged??
It needs to be added to Documentation/kernel-doc-nano-HOWTO.txt.


>>> + * How to use the osd library:
>>> + *
>>> + * osd_start_request
>>> + *	Allocates a request.
>>> + *
>>> + * osd_req_*
>>> + *	Call one of, to encode the desired operation.
>>> + *
>>> + * osd_add_{get,set}_attr
>>> + *	Optionally add attributes to the CDB, list or page mode.
>>> + *
>>> + * osd_finalize_request
>>> + *	Computes final data out/in offsets and signs the request,
>>> + *	making it ready for execution.
>>> + *
>>> + * osd_execute_request
>>> + *	May be called to execute it through the block layer. Other wise submit
>>> + *	the associated block request in some other way.
>>> + *
>>> + * After execution:
>>> + * osd_req_decode_sense
>>> + *	Decodes sense information to verify execution results.
>>> + *
>>> + * osd_req_decode_get_attr
>>> + *	Retrieve osd_add_get_attr_list() values if used.
>>> + *
>>> + * osd_end_request
>>> + *	Must be called to deallocate the request.
>>> + */

>>> +int osd_finalize_request(struct osd_request *or,
>>> +	u8 options, const void *cap, const u8 *cap_key);
>>> +
>>> +/**
>>> + * osd_execute_request - Execute the request synchronously through
>>> + *                       the block-layer
>> Function name and short description need to be on one line.
>>
> 
> OK I re-worded so it will fit in one line. What happens if it does not
> fit, both name and description, in 80 characters? is there a continuation
> symbol or something?

Nope.  It can (a) be longer than 80 characters (an exception is made here)
or (b) split up like this:

/**
 * func_name - some short description here
 * @prm1: prm1 description
 * @prmn: prmn description
 *
 * <longer function description here>
 */

>>> + * @or:		osd_request to Executed
>>> + *
>>> + * Calls blk_execute_rq to q the command and waits for completion.
>>> + */
>>> +int osd_execute_request(struct osd_request *or);

>>> diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
>>> new file mode 100644
>>> index 0000000..77a74a3
>>> --- /dev/null
>>> +++ b/include/scsi/osd_protocol.h
>>> @@ -0,0 +1,497 @@
>>> +/*
>>> + * osd_protocol.h - OSD T10 standard C definitions.
>>> + *
>>> + * Copyright (C) 2008 Panasas Inc.  All rights reserved.
>>> + *
>>> + * Authors:
>>> + *   Boaz Harrosh <bharrosh@panasas.com>
>>> + *   Benny Halevy <bhalevy@panasas.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2
>>> + *
>>> + * This file contains types and constants that are defined by the protocol
>>> + * Note: All names and symbols are taken from the OSD standard's text.
>>> + */
>>> +#ifndef __OSD_PROTOCOL_H__
>>> +#define __OSD_PROTOCOL_H__
>>> +
>>> +#include <linux/types.h>
>>> +#include <asm/unaligned.h>
>>> +#include <scsi/scsi.h>

...

>>> +/* (osd-r10:4.9.2.2)
>>> + * osd2r03:4.11.2.2 Capability format
>>> + */
>>> +struct osd_capability_head {
>>> +	u8 format; /* low nibble */
>>> +	u8 integrity_algorithm__key_version; /* MAKE_BYTE(integ_alg, key_ver) */
>>> +	u8 security_method;
>>> +	u8 reserved1;
>>> +/*04*/	struct osd_timestamp expiration_time;
>>> +/*10*/	u8 audit[30-10];
>>> +/*30*/	u8 discriminator[42-30];
>>> +/*42*/	struct osd_timestamp object_created_time;
>>> +/*48*/	u8 object_type;
>>> +	u8 permissions_bit_mask[54-49];
>> The offset comments are OK with me, but please lose the [b-a] length specifiers.
>>
> 
> I would, please, like to keep them. For the user it does not matter.
> Because he is not suppose to care if he is doing:
> -	memset(och->permissions_bit_mask, 0, 5); // BAD
> +	memset(och->permissions_bit_mask, 0, sizeof(och->permissions_bit_mask)); // GOOD
> 
> But for the protocol reader / debuggerer this is much easier since this is the
> way he will see them on the wire and the way it is laid out in the standard text.
> 
> It was much easier to read the standard text and develop the header this way, complicated
> by the fact that OSD v2 was a moving target and the changes from OSD v1. And it helped in
> finding bugs. Now to go over all of them and calculate the difference and remove it. I'm
> loosing information, and I feel sad to loose it.
> 
> But if you are totally not convinced I will remove them?

I've debugged plenty of code so I'll respectfully disagree with you.
It's confusing and ugly.  But I don't control whether it is merged upstream
or not.

>>> +/*54*/	u8 reserved2;
>>> +/*55*/	u8 object_descriptor_type; /* high nibble */
>>> +} __packed;

-- 
~Randy
