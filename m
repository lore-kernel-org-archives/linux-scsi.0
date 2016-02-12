From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] bio: return EINTR if copying to user space got
 interrupted
Date: Fri, 12 Feb 2016 11:05:14 -0500
Message-ID: <56BE02BA.5080001@interlog.com>
References: <1455266355-44676-1-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1455266355-44676-1-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v.3.11+@suse.de
List-Id: linux-scsi@vger.kernel.org

On 16-02-12 03:39 AM, Hannes Reinecke wrote:
> Commit 35dc248383bbab0a7203fca4d722875bc81ef091 introduced a check for
> current->mm to see if we have a user space context and only copies data
> if we do. Now if an IO gets interrupted by a signal data isn't copied
> into user space any more (as we don't have a user space context) but
> user space isn't notified about it.
>
> This patch modifies the behaviour to return -EINTR from bio_uncopy_user()
> to notify userland that a signal has interrupted the syscall, otherwise
> it could lead to a situation where the caller may get a buffer with
> no data returned.

Interesting, the "f091" commit has been in the kernel since 2013
hence your reference to v.3.11 . I always had the feeling that
handling signals that interrupted SG_IO calls was skating on thin
ice. Hence in ddpt (but not sg_dd nor sgp_dd) the code masks out
all signals (that it can) during the SG_IO calls then opens a
signal window briefly after a SG_IO ioctl has finished and before
the next one starts. This approach used by ddpt is borrowed from
dd (in coreutils) which masks signals during its read() and
write() calls.

Any idea how accurate resid is in this scenario?

Doug Gilbert

> This can be reproduced by issuing SG_IO ioctl()s in one thread while
> constantly sending signals to it.
>
> Fixes: 35dc248 [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: stable@vger.kernel.org # v.3.11+
> ---
>   block/bio.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index dbabd48..24e5b69 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1090,9 +1090,12 @@ int bio_uncopy_user(struct bio *bio)
>   	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
>   		/*
>   		 * if we're in a workqueue, the request is orphaned, so
> -		 * don't copy into a random user address space, just free.
> +		 * don't copy into a random user address space, just free
> +		 * and return -EINTR so user space doesn't expect any data.
>   		 */
> -		if (current->mm && bio_data_dir(bio) == READ)
> +		if (!current->mm)
> +			ret = -EINTR;
> +		else if (bio_data_dir(bio) == READ)
>   			ret = bio_copy_to_iter(bio, bmd->iter);
>   		if (bmd->is_our_pages)
>   			bio_free_pages(bio);
>
