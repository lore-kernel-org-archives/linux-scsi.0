From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 23:16:27 +0200
Message-ID: <4FA1A42B.7090204@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com> <20120502135123.GF16976@quack.suse.cz> <4FA13DDF.9010006@redhat.com> <20120502194945.GB18339@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47903 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2EBVQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 17:16:34 -0400
In-Reply-To: <20120502194945.GB18339@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Il 02/05/2012 21:49, Jan Kara ha scritto:
>   I'm not sure they would be willing to try a different kernel because it's
> a production system. But maybe I can find out what SG_IO command is sent
> via strace?

Yes.

Hmm, you mentioned Veritas and that reminds me of
https://bugzilla.redhat.com/show_bug.cgi?id=740504.  If that is the
case, the filesystem is simply pinging the destination with INQUIRY
commands, something for which it would be worthwhile to have a
non-privileged ioctl anyway.

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
>   But then it seems like they really want to be able to forbid sending
> SG_IO commands to some devices while allowing them for other devices and
> the distinction by partition / non-partition is a bit arbitrary?

Yes, forbidding SG_IO commands on some disks would be nice.  Still,
partition/non-partition is an important distinction.  If you pass a
whole disk and give CAP_SYS_RAWIO to QEMU, the guest may do some damage
but not more than what a bare-metal system could do.  If you pass a
partition, the guest can stomp on other VMs or the host's data and even
write them, which is a security problem.

So you could add a more restrictive filter to partitions, but then
you're adding hack above hack to justify a wrong decision.

>> Of course a better solution for this would be customizable filters for
>> SG_IO commands, where a privileged application would open the block
>> device with CAP_SYS_RAWIO, set the filter and hand the file descriptor
>> to QEMU.  Or alternatively some extension of the device cgroup.  But
>> either solution would require a large amount of work.
>
>   I'm not sure whether you need to filter individual SG_IO commands or not.
> For your use case it seems that being able to forbid SG_IO completely for
> some fd (which would be passed to qemu) would be enough? But maybe filters
> are simpler to implement because they already exist, I don't really know...

If you implement a yes/no toggle, some use case will pop up later for
filters (in fact, a rudimentary filter based on CAP_SYS_RAWIO is
_already_ in the kernel which already proves this).

Paolo
