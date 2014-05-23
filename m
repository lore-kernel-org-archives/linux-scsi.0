From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Fri, 23 May 2014 12:37:46 +0200
Message-ID: <537F24FA.7000608@acm.org>
References: <537CAA79.2030304@acm.org> <537EE637.50408@suse.de> <537F13B6.2060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:49619 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaEWKhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 06:37:50 -0400
In-Reply-To: <537F13B6.2060708@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 05/23/14 11:24, Paolo Bonzini wrote:
> Il 23/05/2014 08:09, Hannes Reinecke ha scritto:
>>
>> And when freeing a command we absolutely need to make sure that
>> the workqueue is empty.
>> So calling cancel_delayed_work() was the obvious thing to do.
> 
> You would need cancel_delayed_work_sync, but if it really happened that
> the work item is running, it would cause a double free.
> 
>> I'd be fine with adding a WARN_ON(!list_empty(&cmd->abort_work))
>> here, however. This will clear up the intent of this statement.
> 
> BUG_ON even, since you'd get badness from the double free anyway.

Hello Paolo,

Are you aware that Linus strongly prefers WARN_ON_ONCE() over BUG_ON() ?
See e.g. https://lkml.org/lkml/2012/9/27/461 or
https://lkml.org/lkml/2014/4/28/657.

Bart.

