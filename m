From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Thu, 07 May 2009 22:06:51 -0500
Message-ID: <4A03A1CB.2050906@cs.wisc.edu>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu>	<49E90243.7080806@cs.wisc.edu>	<49EC46A8.1070704@suse.de> <20090508094158T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56992 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762783AbZEHDHE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 23:07:04 -0400
In-Reply-To: <20090508094158T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 20 Apr 2009 11:55:52 +0200
> Hannes Reinecke <hare@suse.de> wrote:
> 
>> Hi Mike,
>>
>> Mike Christie wrote:
>>> Hey Hannes
>>>
>>> While we are talking about LSF stuff and you are not busy with distro
>>> stuff....
>>>
>> Ah, irony detector kicked in.
>> (Current bugilla count is at 114. Ask me about being busy.)
>>
>>> I implemented this based on what we talked about at the last LSF.
>>>
>> Yes, I've seen it. You again beat me to it; I've done an initial implementation
>> already but failed to send it mainline. Sigh.
>>
>> But yes, we _do_ need something like this.
>>
>>> I was thinking that maybe using kobject_uevent_env would be better. The
>>> info that gets passed to userspace would be the decoded sense and
>>> asc/ascq based on values from the drivers/scsi/constants.c.
>>>
>> No. This patch has the possibility of generating _huge_ amounts of
>> messages, most of which are information only and of no influence
>> to the actual operation.
>> udev would be flooded with it and won't be able to react to 'important'
>> messages while processing them.
> 
> Do we really have huge amount of messages, errors, unit attentions,
> etc?
> 
> We already have a mechanism to send events to user space,
> sdev_evt_send(). Could we simply use (or extend) it?

Yeah, I think we could add a SCSI_EVT_SCSI_SENSE event, then pass the 
sense code and asc and ascq in the envp.
