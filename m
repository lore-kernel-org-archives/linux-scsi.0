From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/4] scsi: Return ENODATA on medium error
Date: Tue, 02 Jul 2013 12:14:41 +0900
Message-ID: <51D245A1.6000106@ce.jp.nec.com>
References: <1372684586-41829-1-git-send-email-hare@suse.de> <1372684586-41829-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1372684586-41829-5-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On 07/01/13 22:16, Hannes Reinecke wrote:
> When a medium error is detected the SCSI stack should return
> ENODATA to the upper layers.
> 
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/blk-core.c          |  3 +++
>  drivers/md/dm-mpath.c     | 16 +++++++++++++++-
>  drivers/scsi/scsi_error.c |  2 +-
>  drivers/scsi/scsi_lib.c   |  5 +++++
>  include/scsi/scsi.h       |  1 +
>  5 files changed, 25 insertions(+), 2 deletions(-)
..
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index bdf26f5..57896cea 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c

Thank you for including the change.
But I think this change to dm should be a separate patch in this series
(prerequisite to the SCSI error code change) and Cc to dm-devel.

> @@ -1261,6 +1261,20 @@ static void activate_path(struct work_struct *work)
>  				pg_init_done, pgpath);
>  }
>  
> +static int noretry_error(int error)
> +{
> +	switch(error) {
> +	case -EOPNOTSUPP:
> +	case -EREMOTEIO:
> +	case -EILSEQ:
> +	case -ENODATA:

   	case -ENOSPC:

We don't want to fail the path for -ENOSPC, do we?

> +		return 1;
> +	}
> +
> +	/* Anything else could be a path failure, so should be retried */
> +	return 0;
> +}
> +
>  /*
>   * end_io handling
>   */
> @@ -1284,7 +1298,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (!error && !clone->errors)
>  		return 0;	/* I/O complete */
>  
> -	if (error == -EOPNOTSUPP || error == -EREMOTEIO || error == -EILSEQ)
> +	if (noretry_error(error))
>  		return error;
>  
>  	if (mpio->pgpath)

-- 
Jun'ichi Nomura, NEC Corporation
