From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Fri, 23 May 2014 11:24:06 +0200
Message-ID: <537F13B6.2060708@redhat.com>
References: <537CAA79.2030304@acm.org> <537EE637.50408@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaEWJYk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 05:24:40 -0400
In-Reply-To: <537EE637.50408@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

Il 23/05/2014 08:09, Hannes Reinecke ha scritto:
>
> And when freeing a command we absolutely need to make sure that
> the workqueue is empty.
> So calling cancel_delayed_work() was the obvious thing to do.

You would need cancel_delayed_work_sync, but if it really happened that 
the work item is running, it would cause a double free.

> I'd be fine with adding a WARN_ON(!list_empty(&cmd->abort_work))
> here, however. This will clear up the intent of this statement.

BUG_ON even, since you'd get badness from the double free anyway.

Paolo
