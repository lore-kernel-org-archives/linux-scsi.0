From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 02 Jul 2008 09:08:35 +0200
Message-ID: <87zlp0n4p8.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:44899 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759005AbYGBHIz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 03:08:55 -0400
In-Reply-To: <1214963700.3316.41.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 01 Jul 2008 20:55:00 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, stable@kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-07-01 at 23:37 +0200, Elias Oltmanns wrote:
>> Hi James,
>
>> 
>> sorry for bothering you but I've just noticed that the patch below has
>> neither been scheduled for the stable review, nor queued up for Linus.
>> May be you just don't consider this serious enough for these trees but I
>> wanted to make sure that the situation will be dealt with eventualy. The
>> patch applies to 2.6.26-rc8.
>
> OK, well at first glance, the locking around device_blocked and
> host_blocked looks pointless.  What are the failure traces you're using
> to decide they need spinlock protection?

scsi_queue_insert() as well as scsi_finish_command() can be called at
any time as part of regular command completion or error handling. There
is no reason why the ->request_fn() for the same device or for another
device on the same host should not be in progress at the same time.

>
> The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> itself looks like it might not entirely need the queue lock ... I need
> to investigate more closely.

Well, I rather think it does. We have to serialise access to the
unplug_timer and there is a call to __set_bit() which, as I understand,
requires the calling function to ensure atomicity.

Regards,

Elias
