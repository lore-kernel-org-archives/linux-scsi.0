From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 15:59:59 +0200
Message-ID: <4FA13DDF.9010006@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502135123.GF16976@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab2EBOA3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 May 2012 10:00:29 -0400
In-Reply-To: <20120502135123.GF16976@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 02/05/2012 15:51, Jan Kara ha scritto:
>> > NACK.  I would bet that all the warnings you've seen are for ioctl that
>> > would have failed anyway with ENOTTY.
>   Actually, you would loose the bet ;)

Doh. :)

> The customer was complaining about
> warning about SG_IO ioctl. Apparently some Veritas filesystem thread generates
> a *lot* of these (I don't know if they happen to do all the filesystem IO
> with SG_IO and I'm not sure I want to know ;).

Can you at least ask the customer for help finding which command was
sent?  And perhaps have them try a kernel that blocks SG_IO to see what
breaks if anything?

> Also I tend to side with Alan that I don't quite see
> the point in trying to restrict CAP_SYS_RAWIO threads and thus breaking the
> compatibility

For example, we have a customer that wants this:

* a VM should be able to send vendor-specific commands to a disk via
SG_IO (vendor-specific commands require CAP_SYS_RAWIO).

* they want to assign logical volumes or partitions to the same VM
without letting it read or write outside the logical volume or partition.

Of course a better solution for this would be customizable filters for
SG_IO commands, where a privileged application would open the block
device with CAP_SYS_RAWIO, set the filter and hand the file descriptor
to QEMU.  Or alternatively some extension of the device cgroup.  But
either solution would require a large amount of work.

Paolo

> (if ioctls would be restricted for partitions from the
> beginning, then sure it seems like a cleaner choice). But I don't feel that
> strongly about it.

