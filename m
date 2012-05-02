From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 17:49:58 +0200
Message-ID: <4FA157A6.7050209@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502135123.GF16976@quack.suse.cz> <4FA13DDF.9010006@redhat.com> <20120502161038.01ee9b59@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab2EBPuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 May 2012 11:50:35 -0400
In-Reply-To: <20120502161038.01ee9b59@pyramind.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 02/05/2012 17:10, Alan Cox ha scritto:
>>> Also I tend to side with Alan that I don't quite see
>>> the point in trying to restrict CAP_SYS_RAWIO threads and thus breaking the
>>> compatibility
>>
>> For example, we have a customer that wants this:
>>
>> * a VM should be able to send vendor-specific commands to a disk via
>> SG_IO (vendor-specific commands require CAP_SYS_RAWIO).
>>
>> * they want to assign logical volumes or partitions to the same VM
>> without letting it read or write outside the logical volume or partition.
> 
> And if the process has CAP_SYS_RAWIO it can do it anyway.

How so?  Assuming /dev/sdb is not accessible, /dev/sdb1 is accessible,
and no iopl/ioperm.

> Or you could just do the special case ioctl magic out of band in the apps.

You mentioned crass/gross hacks.  Forcing apps to detect if you're
targeting a partition or a block device _is_ gross.

> It's hardly an ultra performance critical path for the SG_IO cases.

That I agree with.

>> Of course a better solution for this would be customizable filters for
>> SG_IO commands, where a privileged application would open the block
>> device with CAP_SYS_RAWIO, set the filter and hand the file descriptor
>> to QEMU.  Or alternatively some extension of the device cgroup.  But
>> either solution would require a large amount of work.
> 
> Customisable filters are not hard. We've got all the filtering code in
> kernel and the ability to verify filters, even the ability to JIT them.
> Just support adding/removing/running a BPF filter on the channel in
> question.
> 
> So it shouldn't be much code to do what you want.

Yes, it's not much code if I don't get into cgroups land and stick with
a ioctl to add and remove BPF filters that look at CDBs.  One downside
is that such filtering would likely be enabled by CAP_SYS_RAWIO.
Because of this, tweaking the filter on the fly is still not too easy
because I want to run as unprivileged as possible.  I guess some
privileged helper program can set the filter and send me back the file
descriptor via SCM_RIGHTS.  The filter will be preserved across that, right?

I still believe this is suboptimal in the general case, and that Jan's
customer has a bug.  But hey I would have ended up implementing the
filters anyway sooner or later, so I'd rather avoid further flames and
work on them with someone supporting the idea. :)  Reluctantly

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
