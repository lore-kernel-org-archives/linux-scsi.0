From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/11] qla4xxx: added srb referance counter
Date: Thu, 11 Feb 2010 16:57:17 -0600
Message-ID: <4B748B4D.5030809@cs.wisc.edu>
References: <20100130062856.GG10274@linux-qf4p> <4B671BFC.90107@cs.wisc.edu> <20100211110852.GB8237@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34675 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab0BKW5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 17:57:35 -0500
In-Reply-To: <20100211110852.GB8237@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/11/2010 05:08 AM, Ravi Anand wrote:
> On Mon, 01 Feb 2010, Mike Christie wrote:
>>
>> On 01/30/2010 12:28 AM, Ravi Anand wrote:
>>>
>>> -		msleep(2000);
>>> -	} while (max_wait_time--);
>>> +		if (got_ref&&   (atomic_read(&rp->ref_count) == 1)) {
>>> +			done++;
>>> +			break;
>>> +		}
>>> +
>>> +		msleep(ABORT_POLLING_PERIOD);
>>
>>
>> Did you want to use krefs for the refcounting?
>
> We will add it to our to do list and submit a patch later on.
> For right now we will like to stick to it as kref will require
> additional testing.
>
>> And why is this so funky (got_ref arg and refcount peak) compared to the
>> qla2xxx one?
>
> I don't think qla2xxx is doing any reference counting in eh_abort() path.
> Basically its trying to differentiate for case where it takes an additional
> reference when the cmd is with the F/W. In that case if its the last guy,
> then it can go ahead and complete the command.
>

got_ref is always 0 isn't it (at least in the patch it is)? It seems 
like you can just get rid of all that and just copy qla2xxx's code.
