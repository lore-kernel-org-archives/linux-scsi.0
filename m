From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 16:10:38 +0100
Message-ID: <20120502161038.01ee9b59@pyramind.ukuu.org.uk>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
	<20120502135123.GF16976@quack.suse.cz>
	<4FA13DDF.9010006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2EBPIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 11:08:00 -0400
In-Reply-To: <4FA13DDF.9010006@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

> > Also I tend to side with Alan that I don't quite see
> > the point in trying to restrict CAP_SYS_RAWIO threads and thus breaking the
> > compatibility
> 
> For example, we have a customer that wants this:
> 
> * a VM should be able to send vendor-specific commands to a disk via
> SG_IO (vendor-specific commands require CAP_SYS_RAWIO).
> 
> * they want to assign logical volumes or partitions to the same VM
> without letting it read or write outside the logical volume or partition.

And if the process has CAP_SYS_RAWIO it can do it anyway. So not only is
your agenda destructive - it doesn't actually work.

> Of course a better solution for this would be customizable filters for
> SG_IO commands, where a privileged application would open the block
> device with CAP_SYS_RAWIO, set the filter and hand the file descriptor
> to QEMU.  Or alternatively some extension of the device cgroup.  But
> either solution would require a large amount of work.

Or you could just do the special case ioctl magic out of band in the apps.
It's hardly an ultra performance critical path for the SG_IO cases.

Customisable filters are not hard. We've got all the filtering code in
kernel and the ability to verify filters, even the ability to JIT them.
Just support adding/removing/running a BPF filter on the channel in
question.

So it shouldn't be much code to do what you want.

Alan



