From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 09:59:53 -0700
Message-ID: <20120911165953.GK7677@google.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Jul 20, 2012 at 06:30:01PM +0200, Paolo Bonzini wrote:
> These commands cannot be issued right now without giving CAP_SYS_RAWIO to
> the process who wishes to send them.  These commands can be useful also to
> non-privileged programs who have access to the block devices.  For example
> a virtual machine monitor needs them to forward trim/discard to host disks.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/scsi_ioctl.c |    3 ++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 260fa80..dd71f18 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -168,13 +168,16 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>  	/* Basic writing commands */
>  	__set_bit(WRITE_6, filter->write_ok);
>  	__set_bit(WRITE_10, filter->write_ok);
> +	__set_bit(WRITE_SAME, filter->write_ok);
>  	__set_bit(WRITE_VERIFY, filter->write_ok);
>  	__set_bit(WRITE_12, filter->write_ok);
>  	__set_bit(WRITE_VERIFY_12, filter->write_ok);
>  	__set_bit(WRITE_16, filter->write_ok);
> +	__set_bit(WRITE_SAME_16, filter->write_ok);
>  	__set_bit(WRITE_LONG, filter->write_ok);
>  	__set_bit(WRITE_LONG_2, filter->write_ok);
>  	__set_bit(ERASE, filter->write_ok);
> +	__set_bit(UNMAP, filter->write_ok);

FWIW, I don't think this is the right way to expose functionality
which needs management in terms of access control, interpretation
(stacking drivers) and serving concurrent users.  SG_IO filtering was
mostly for cd/dvd burning and other removeable devices.  Especially
for the former, the possibility of having a properly encapsulated
interface was long lost and I think significant part of that is how
the underlying technology and its hardware interface developed.  We
basically just gave up.  Fortunately, they're going the way of
floppies.

So, it wouldn't be a good idea to abuse SG_IO filtering for exposing
trim/discard.  It's something which should be retired or at least
severely restricted in time.  I don't think we want to be developing
new uses of it.

I think trim/discards are fairly easy to abstract and common enough to
justify having properly abstracted interface.  In fact, we already
have block layer interface for it - BLKDISCARD.  If it's lacking,
let's improve that.

Thanks.

-- 
tejun
