From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [RFC PATCH 00/32] separate operations from flags in
 the bio/request structs
Date: Wed, 4 Nov 2015 08:49:00 -0800
Message-ID: <563A36FC.6010001@sandisk.com>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:26149
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030498AbbKDQtG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 11:49:06 -0500
In-Reply-To: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com

On 11/04/2015 08:32 AM, mchristi@redhat.com wrote:
> There are a couple new block layer commands we are trying to add support
> for in the near term:
>
> compare and write
> http://www.spinics.net/lists/target-devel/msg07826.html
>
> copy offload/extended copy/xcopy
> https://www.redhat.com/archives/dm-devel/2014-July/msg00070.html
>
> The problem is if we contine to add more commands we will have to one day
> extend the cmd_flags/bi_rw fields again. To prevent that, this patchset
> separates the operation (REQ_WRITE, REQ_DISCARD, REQ_WRITE_SAME, etc) from
> the flags (REQ_SYNC, REQ_QUIET, etc) in the bio and request structs. In the
> end of this set, we will have two fields bio->bi_op/request->op and
> bio->bi_rw/request->cmd_flags.
>
> The patches were made against Jens's linux-block tree's for-linus branch:
> https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git/log/?h=for-linus
> (last commit a22c4d7e34402ccdf3414f64c50365436eba7b93).
>
> I have done some basic testing for a lot of the drivers and filesystems,
> but I wanted to get comments before trying to track down more hardware/
> systems for testing.
>
>
> Known issues:
> - REQ_FLUSH is still a flag, but should probably be a operation.
>   For lower level drivers like SCSI where we only get a flush, it makes
> more sense to be a operation. However, upper layers like filesystems
> can send down flushes with writes, so it is more of a flag for them.
> I am still working on this.
>
> - There is a regression with the dm flakey target. It currently
> cannot corrupt the operation values.
>
> - The patchset is a little awkward. It touches so much code,
> but I wanted to maintain git bisectibility, so there is lots of compat code
> left around until the last patches where everyting is cleaned up.

Hello Mike,

If you have to touch submit_bio() and submit_bio_wait(), how about 
requiring the callers of these functions to set the cmd and flags 
arguments in the bio structure and to leave out the cmd and flags 
arguments from the submit_bio() and submit_bio_wait() functions ? A 
(compile tested only) patch that implements this idea is available at 
https://lkml.org/lkml/2014/6/2/173.

Bart.
