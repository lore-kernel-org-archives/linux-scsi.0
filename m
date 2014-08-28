From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 14:17:45 +0200
Message-ID: <53FF1DE9.5040605@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaH1MR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 08:17:57 -0400
In-Reply-To: <53FF1AD8.9020800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

Il 28/08/2014 14:04, Hannes Reinecke ha scritto:
>>
>> Setting TASK ABORTED aside, the important part is that an abort can do
>> one of two things:
>>
>> - complete the command, and then eh_abort should return after the driver
>> has noticed the completion and called the ->scsi_done callback for the
>> Scsi_Cmnd*.
>>
>> - abort the command, and then the driver should never call the
>> ->scsi_done callback for the Scsi_Cmnd*.
>>
> In practice we rely on the latter behaviour; when ->scsi_done is called
> while the command is under eh_abort _really bad things_
> will happen.
> As soon as eh_abort is called control is transferred back to the
> SCSI midlayer, so any LLDD should never send completions for these
> commands back to the midlayer.

No, this is wrong.  I think we have sorted it out a couple of months
ago.  virtio-scsi for example (due to QEMU quirks) will do the former
more often than not.

Ignoring scsi_eh_done which is just as harmless, ->scsi_done does
nothing more than calling blk_complete_request.  If the command is under
abort, it has already been marked as complete by the block layer's
timeout timer---see blk_rq_timed_out_timer and blk_rq_check_expired---or
by blk_abort_request.

Then, blk_complete_request will do nothing because its call to
blk_mark_rq_complete returns true.

All this, of course, as long as ->scsi_done is called _before_ eh_abort
returns.  Otherwise, occasions abound for uses-after-free, which is what
virtio-scsi got until commit 8faeb529b2da (virtio-scsi: fix various bad
behavior on aborted requests, 2014-06-04).

Paolo
