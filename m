From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Linux specific scsi CDBs vs REQ_TYPE_LINUX_BLOCK requests
Date: Thu, 15 May 2008 12:58:29 +0200
Message-ID: <87ej83ygtm.fsf@denkblock.local>
References: <87r6ccadzd.fsf@denkblock.local>
	<20080509115520.GS16217@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:50063 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbYEOK73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 06:59:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, May 08 2008, Elias Oltmanns wrote:
[...]
>> In fact, unless you are definitely in favour of the block layer approach
>> (as realised in [2]) and can give me a hint as to how I could solve the
>> problems described above, I will probably prepare a patch series using
>> ioctls and post it on linux-ide. The reason is that this approach might
>> even solve another problem I see further down the road.
>
> There isn't going to be a lot of common code, since all the park
> handling will be driver/device specific.

Yes, it's just the expiration timer and possibly the interface to user
space that could be considered common code.

> It still makes sense to use the queue as the transport for the command
> though, using an ioctl is both ugly from a design POV and (more
> importantly) has serialization issues since it's an out-of-band
> signalling mechanism. If you pass down a request as the park request,
> then you need only deal with the device specific details of parking
> the head.

Well, the request queue is certainly the most obvious and preferable way
to solve these serialisation issues -- the only drawback being that
other paths might involve less memory allocations, thus reducing
potential issues with paging in when time is of the essence. The
question remains, however, who should be responsible for enqueueing such
a request? And if it is going to be a REQ_TYPE_LINUX_BLOCK request, how
am I supposed to get it past scsi midlayer to the LLDD? But I'll discuss
that particular issue in a seperate mail.

Here is another aspect which I'd like to have your opinion as maintainer
of the block layer about. The more I think about it, the more I am
opposed to the idea to expose a generic queue freezing facility to user
space for *all* block devices. Or rather, I don't consider disk shock
protection an extension, as it were, of such a generic facility. The
reason is simply that I don't see how the two concepts can be generally
compatible. If queue freezing was sufficient for any given application
and for any given block device, then we'd most likely want to freeze the
queue of ATA devices just as we'd do  for other devices, i.e., without
disk head unloading. This is because the number of head unloads is
considered an indicator of disk aging.

So, I'd like to export an interface to user space which is specifically
dedicated to disk shock protection, i.e., only available for ATA / IDE
devices. On the other hand, it would be desirable to make this interface
transparent, so user space doesn't have to differentiate between devices
driven by the libata or the ide subsystem. A sysfs attribute
/sys/block/.../queue/protect or even just /sys/block/.../protect would
be very convenient from a user's point of view. However, this would
require something like a blk_register_protect_attr() /
blk_unregister_protect_attr() interface so that libata and ide can
export this attribute for disks after calling blk_init_queue(). Would
that be alright with you? Otherwise, I'd have to implement this
interface directly in the subsystems and *thats* where ioctls seem to be
the easiest way to make this interface as transparent as possible to
user space. In this case a park request of some sort would be fed to the
request queue internally.

Any comments?

Elias
