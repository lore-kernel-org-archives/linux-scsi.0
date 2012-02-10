From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Fri, 10 Feb 2012 15:04:27 -0500
Message-ID: <4F35784B.4000902@redhat.com>
References: <1325618414-26992-1-git-send-email-revers@redhat.com> <4F0EAB53.7020404@suse.de> <4F0F124D.3000708@redhat.com> <4F0F4F43.2010902@suse.de> <4F0F3A73.9060602@cs.wisc.edu> <4F0F3BB1.7090902@cs.wisc.edu> <4F0F5B17.3090606@suse.de> <4F106F11.5050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2BJUEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 15:04:40 -0500
In-Reply-To: <4F106F11.5050702@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On 01/13/2012 12:51 PM, Rob Evers wrote:
> On 01/12/2012 05:13 PM, Hannes Reinecke wrote:
>> On 01/12/2012 08:59 PM, Mike Christie wrote:
>>> On 01/12/2012 01:54 PM, Mike Christie wrote:
>>>> alua_check_sense will return ADD_TO_MLQUEUE_DELAY then 
>>>> scsi_check_sense
>>>> will pass that up and scsi_decide_disposition will return that right
>>>> away.
>>>
>>> I mean it is one of those weird ones where we do not do the goto
>>> maybe_retry in scsi_decide_disposition, so we do not see the fast fail
>>> bit set. This happens for ADD_TO_MLQUEUE_DELAY and ADD_TO_MLQUEUE.
>>>
>> Hmm. Not sure here.
>> With the above reasoning SG_IO would be retried, too.
>> Which it most definitely isn't.
>>
>> I'll be digging deeper here tomorrow.
>>
>> Cheers,
>>
>> Hannes
>
> Hannes,
>
> I ran some tests today to verify what you said about rtpg not ending
> up executing the ADD_TO_MLQUEUE_DELAY path via scsi_softirq_done.
>
> So yes, looks like another delay is required in alua_rtpg.

It turns out that the rtpg activity on an array is limited during these
transitions and scales with the number of paths connected to the array.

What I have seen for rtpg sense codes after the first alua_rtpg retry is:

06/29/00
06/2a/06

and 1-2 retries in alua_rtpg for the first retry condition.  This is for
every path to an array.

This activity follows shortly after an array controller reboot.
The rtpg retries all occur within a second of each other.

The rtpg sense codes never match the modifications to alua_check_sense
where a ADD_TO_MLQUEUE_DELAY condition gets triggered (2/4/a).  This is
confirmed by our array vendor partner.

The 1st rtpg retries in alua_rtpg don't get delayed by the sdevice queue 
being
delayed, at least they are never seperated by 2 seconds as would 
indicate that.

I could use an explanation of why the rtpgs retries don't get delayed, 
if someone knows and would be so kind.

The alua_check_sense 2/4/a triggers the ADD_TO_MLQUEUE_DELAY condition
and this does cause the sdevice queue to delay, and this repeats every 2 
seconds
as expected during the transitions.

Hannes,

Can you revisit this?

Thanks, Rob
