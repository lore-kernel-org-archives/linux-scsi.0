From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Fri, 13 Jan 2012 12:51:13 -0500
Message-ID: <4F106F11.5050702@redhat.com>
References: <1325618414-26992-1-git-send-email-revers@redhat.com> <4F0EAB53.7020404@suse.de> <4F0F124D.3000708@redhat.com> <4F0F4F43.2010902@suse.de> <4F0F3A73.9060602@cs.wisc.edu> <4F0F3BB1.7090902@cs.wisc.edu> <4F0F5B17.3090606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2AMRvX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 12:51:23 -0500
In-Reply-To: <4F0F5B17.3090606@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On 01/12/2012 05:13 PM, Hannes Reinecke wrote:
> On 01/12/2012 08:59 PM, Mike Christie wrote:
>> On 01/12/2012 01:54 PM, Mike Christie wrote:
>>> alua_check_sense will return ADD_TO_MLQUEUE_DELAY then scsi_check_sense
>>> will pass that up and scsi_decide_disposition will return that right
>>> away.
>>
>> I mean it is one of those weird ones where we do not do the goto
>> maybe_retry in scsi_decide_disposition, so we do not see the fast fail
>> bit set. This happens for ADD_TO_MLQUEUE_DELAY and ADD_TO_MLQUEUE.
>>
> Hmm. Not sure here.
> With the above reasoning SG_IO would be retried, too.
> Which it most definitely isn't.
>
> I'll be digging deeper here tomorrow.
>
> Cheers,
>
> Hannes

Hannes,

I ran some tests today to verify what you said about rtpg not ending
up executing the ADD_TO_MLQUEUE_DELAY path via scsi_softirq_done.

So yes, looks like another delay is required in alua_rtpg.

Rob
