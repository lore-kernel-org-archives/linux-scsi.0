From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Mon, 20 Apr 2009 14:35:15 -0500
Message-ID: <49ECCE73.2010302@cs.wisc.edu>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu> <49E90243.7080806@cs.wisc.edu> <49EC46A8.1070704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38176 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZDTTfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 15:35:24 -0400
In-Reply-To: <49EC46A8.1070704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi Mike,
> 
> Mike Christie wrote:
>> Hey Hannes
>>
>> While we are talking about LSF stuff and you are not busy with distro
>> stuff....
>>
> Ah, irony detector kicked in.
> (Current bugilla count is at 114. Ask me about being busy.)
> 
>> I implemented this based on what we talked about at the last LSF.
>>
> Yes, I've seen it. You again beat me to it; I've done an initial implementation
> already but failed to send it mainline. Sigh.
> 
> But yes, we _do_ need something like this.
> 
>> I was thinking that maybe using kobject_uevent_env would be better. The
>> info that gets passed to userspace would be the decoded sense and
>> asc/ascq based on values from the drivers/scsi/constants.c.
>>
> No. This patch has the possibility of generating _huge_ amounts of
> messages, most of which are information only and of no influence
> to the actual operation.
> udev would be flooded with it and won't be able to react to 'important'
> messages while processing them.


Ah yeah.

> 
> Hence a separate mechanism like the proposed SCSI generic netlink
> facility is the better approach.
> 
>> I was also thinking that a udev rule could then just handle something
>> like rescanning for REPORT_LUNS_DATA_CHANGED and handle
>> CAPACITY_DATA_CHANGED by doing all the crap that has to be done.
>>
> Yes, that was my initial thought, too. But Kay objected because
> of the possible message flooding in udev so we have to use a
> separate facility here.
> 
> Actually, I already have a daemon implemented. I can drop you
> a pointer to the location if required.
> 

Yeah, please send it. I will hook it up to the other patch using the 
scsi generic netlink code.
