From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv6 8/8] scsi: inline command aborts
Date: Mon, 24 Apr 2017 14:41:15 +0200
Message-ID: <d1851dc4-0864-6d64-872b-1e201d035252@suse.de>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
 <1491485796-44411-9-git-send-email-hare@suse.de>
 <1491869956.4199.35.camel@sandisk.com> <yq1fuh3rfj7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43115 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1045804AbdDXMlX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 08:41:23 -0400
In-Reply-To: <yq1fuh3rfj7.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 04/20/2017 04:14 AM, Martin K. Petersen wrote:
> Bart Van Assche <Bart.VanAssche@sandisk.com> writes:
> 
>> On Thu, 2017-04-06 at 15:36 +0200, Hannes Reinecke wrote:
>>> The block layer always calls the timeout function from a workqueue
>>> context, so there is no need to have yet another workqueue for
>>> running command aborts.
>>>
>>> [ ... ]
>>> @@ -271,10 +266,14 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>>>  		rtn = host->hostt->eh_timed_out(scmd);
>>>  
>>>  	if (rtn == BLK_EH_NOT_HANDLED) {
>>> -		if (scsi_abort_command(scmd) != SUCCESS) {
>>> +		int ret;
>>> +
>>> +		ret = scsi_abort_command(scmd);
>>> +		if (ret == FAILED) {
>>>  			set_host_byte(scmd, DID_TIME_OUT);
>>>  			scsi_eh_scmd_add(scmd);
>>> -		}
>>> +		} else if (ret == FAST_IO_FAIL)
>>> +			rtn = BLK_EH_RESET_TIMER;
>>>  	}
>>
>> Has this patch been tested with the traditional block layer? For the
>> traditional block layer scsi_times_out() is called with the queue lock
>> held. Does this patch cause .eh_abort_handler(), a function that may
>> sleep, to be called with the queue lock held?
> 
> Hannes: Ping!
> 
Looks like Bart's right. Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
