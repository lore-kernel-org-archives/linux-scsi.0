From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: skip RTPG for devices only supporting
 active/optimized
Date: Wed, 13 Dec 2017 10:14:32 +0100
Message-ID: <ae1e8739-d9e6-c370-dc7e-e4075505b288@suse.de>
References: <1512728048-84729-1-git-send-email-hare@suse.de>
 <1513036829.2747.36.camel@wdc.com>
 <b4b9333f-090f-0f78-a208-a07b061b38fe@suse.de>
 <1513103148.2999.30.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdLMJOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 04:14:35 -0500
In-Reply-To: <1513103148.2999.30.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 12/12/2017 07:25 PM, Bart Van Assche wrote:
> On Tue, 2017-12-12 at 08:01 +0100, Hannes Reinecke wrote:
>> On 12/12/2017 01:00 AM, Bart Van Assche wrote:
>>> On Fri, 2017-12-08 at 11:14 +0100, Hannes Reinecke wrote:
>>>> @@ -541,6 +544,20 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>>>>  	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
>>>>  
>>>>  	if (retval) {
>>>> +		/*
>>>> +		 * If the target only supports active/optimized there's
>>>> +		 * not much we can do; it's not that we can switch paths
>>>> +		 * or somesuch.
>>>> +		 * So ignore any errors to avoid spurious failures during
>>>> +		 * path failover.
>>>> +		 */
>>>> +		if ((pg->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
>>>> +			sdev_printk(KERN_INFO, sdev,
>>>> +				    "%s: ignoring rtpg result %d\n",
>>>> +				    ALUA_DH_NAME, retval);
>>>> +			kfree(buff);
>>>> +			return SCSI_DH_OK;
>>>> +		}
>>>
>>> Hello Hannes,
>>>
>>> Sorry but this change looks weird to me. If an RTPG fails, shouldn't
>>> alua_rtpg() return SCSI_DH_IO independent of what ALUA states the target
>>> supports? Are you perhaps trying to implement a work-around for an array
>>> that does not respond to RTPG during path transitions?
>>>
>>
>> Yes, precisely.
>>
>> Thing is: if an array is only supporting active/optimized the entire
>> device-handler stuff is basically a no-op as we can't switch paths anyway.
>> So it doesn't really matter if the RTPG fails; in fact, we could just
>> short-circuit the entire logic. I did not do that to allow for a state
>> modification (ie arrays _might_ decide to announce additional states
>> eventually, and only starting off with active/optimized as an initial
>> state set).
>>
>> But if we return SCSI_DH_IO here the multipath logic will not attempt to
>> switch paths, and failover will not work.
> 
> Hello Hannes,
> 
> I would appreciate it if it would be mentioned more clearly in the comment
> above pg->valid_states & ~TPGS_SUPPORT_OPTIMIZED that the newly added code
> is a workaround for non-standard array behavior. I'm afraid that otherwise
> people who will read that code will be puzzled about why that code has been
> added.
> 
Okay, not a problem.
Will be sending out a v2.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
