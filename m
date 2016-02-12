From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] bio: return EINTR if copying to user space got
 interrupted
Date: Fri, 12 Feb 2016 11:15:13 -0500
Message-ID: <1455293713.22112.373.camel@localhost.localdomain>
References: <1455266355-44676-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1455266355-44676-1-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v.3.11+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-02-12 at 09:39 +0100, Hannes Reinecke wrote:
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
> 
> This can be reproduced by issuing SG_IO ioctl()s in one thread while
> constantly sending signals to it.

Well, this is definitely an improvement, since it now indicates to
the user that there was a problem instead of silently returning with
no data and no error, but it doesn't completely fix the issue.

For one thing, if the SG_IO is performed to a sequential media device,
the I/O is actually performed, and the position changes, it is just the
data that is not copied back.  So e.g. a user program making calls to
read from a tape device that gets signals and retrying on -EINTR will
skip blocks.  There is a similar problem already with SG_IO and
-ERESTARTSYS.  I believe that that only way around this is to mask the
signals.  (This is also problem with non-idempotent commands, such as
COMPARE AND WRITE.)

I should mention that the patch "sg: Fix user memory corruption when
SG_IO is interrupted by a signal" broke a 3rd-party kernel module that
happened to use SG_IO to pass *kernel* addresses for I/O.  Which worked
for them until the current->mm test was added.  (I don't know why they
didn't just put I/O on the request queue like everyone else, though.)

This patch should go in, though.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

> 
> Fixes: 35dc248 [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: stable@vger.kernel.org # v.3.11+
> ---
>  block/bio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index dbabd48..24e5b69 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1090,9 +1090,12 @@ int bio_uncopy_user(struct bio *bio)
>  	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
>  		/*
>  		 * if we're in a workqueue, the request is orphaned, so
> -		 * don't copy into a random user address space, just free.
> +		 * don't copy into a random user address space, just free
> +		 * and return -EINTR so user space doesn't expect any data.
>  		 */
> -		if (current->mm && bio_data_dir(bio) == READ)
> +		if (!current->mm)
> +			ret = -EINTR;
> +		else if (bio_data_dir(bio) == READ)
>  			ret = bio_copy_to_iter(bio, bmd->iter);
>  		if (bmd->is_our_pages)
>  			bio_free_pages(bio);
