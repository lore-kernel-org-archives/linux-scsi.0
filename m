From: "Ed Lin" <ed.lin@promise.com>
Subject: Re: stex driver panic in kernel 2.6.23
Date: Mon, 29 Oct 2007 10:46:36 -0700
Message-ID: <NONAMEWEXxt5BBBVhye0000037a@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.14.ptr.us.xo.net ([67.111.72.14]:2037 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbYAITdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 14:33:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jeff <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>


>On Wed, Oct 24 2007, James Bottomley wrote:
>> On Wed, 2007-10-24 at 12:17 -0700, Andrew Morton wrote:
>> > On Wed, 24 Oct 2007 11:59:30 -0700 "Ed Lin" <ed.lin@promise.com> wrote:
>> > 
>> > > The shared tag issue was not fixed yet. Kernel panic
>> > > happened while running I/O test in kernel 2.6.23
>> > > (information attached). After applying the patch I posted
>> > > (or the version James modified), panic disappeared.
>> > > Switch back to standard kernel, panic again.
>> > 
>> > Did either of those patches get merged in 2.6.24-rc1?
>> 
>> No ... Jens did one instead (commit
>> f3da54ba140c6427fa4a32913e1bf406f41b5dda), which now looks like it might
>> not have fixed the issue.
>
>I think there's one more bug there, for shared maps. For the locking to
>work, only the tag map and tag bit map may be shared (incidentally, I
>was just explaining this to Nick yesterday, but I apparently didn't
>review the code well enough myself). But we also share the busy list!
>The busy_list must be queue private, or we need a block_queue_tag
>covering lock as well.
>
>So we have to move the busy_list to the queue. This'll work fine, and
>it'll actually also fix a problem with blk_queue_invalidate_tags() which
>will invalidate tags across all shared queues. This is a bit confusing,
>the low level driver should call it for each queue seperately since
>otherwise you cannot kill tags on just a single queue for eg a hard
>drive that stops responding. Since the function has no callers
>currently, it's not an issue.
>
>Please test.
>

With this patch the stex driver passed I/O test. So maybe this problem is
fixed finally. Thanks. Please apply.

Ed Lin


