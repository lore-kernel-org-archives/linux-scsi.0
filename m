From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
 commands
Date: Sun, 04 Jan 2009 14:53:28 -0600
Message-ID: <496121C8.4040205@cs.wisc.edu>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu> <1230914541.3304.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47867 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZADUxt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 15:53:49 -0500
In-Reply-To: <1230914541.3304.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

James Bottomley wrote:
> On Tue, 2008-12-16 at 23:55 -0600, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> This patch fixes a regression in scsi-misc introduced with:
>> 312efe5efcdb02d604ea37a41d965f32ca276d6a
>> [SCSI] simplify scsi_io_completion().
>>
>> The problem is that in previous kernels scsi_io_completion would call
>> scsi_requeue_command, but now it can call scsi_queue_insert for
>> something like a UNIT_ATTENTION (for netapp targets we get
>> UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
>> will call scsi_device_unbusy, but in the scsi_io_completion code path
>> scsi_finish_command has already called this so we now end up
>> with invalid host, target and device busy values.
>>
>> Patch was made over scsi-misc.
> 
> This is a bad bug, but not quite the way I'd like to fix it.  Whether
> the queue should be unbusied or not is really separate from the block
> action, so it should have its own flag (plus it's not really a flag many
> people should be using).  Since, really, the wrong use is confined to
> the defining file, how about this:
> 

Patch fixed my problem here. Thanks.
