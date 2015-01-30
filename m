From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2 5/5] scsi: move scsi/sg.h to uapi/linux/sg.h
Date: Thu, 29 Jan 2015 17:14:00 -0800
Message-ID: <1422580440.2091.32.camel@HansenPartnership.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com>
	 <1422579397-18696-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38318 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbbA3BOC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 20:14:02 -0500
In-Reply-To: <1422579397-18696-6-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de

On Thu, 2015-01-29 at 16:56 -0800, Andy Grover wrote:
> This will enable user programs to have access to the most current
> definitions.
> 
> Modify include sites for new path.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  block/bio.c                    |   2 +-
>  block/blk-map.c                |   2 +-
>  block/bsg.c                    |   2 +-
>  block/scsi_ioctl.c             |   2 +-
>  drivers/block/aoe/aoeblk.c     |   2 +-
>  drivers/block/cciss.c          |   2 +-
>  drivers/block/nvme-core.c      |   2 +-
>  drivers/block/nvme-scsi.c      |   2 +-
>  drivers/block/skd_main.c       |   2 +-
>  drivers/message/i2o/i2o_scsi.c |   2 +-
>  drivers/scsi/ips.c             |   2 +-
>  drivers/scsi/scsi_error.c      |   2 +-
>  drivers/scsi/scsi_ioctl.c      |   2 +-
>  drivers/scsi/sg.c              |   2 +-
>  drivers/scsi/st.c              |   2 +-
>  fs/compat_ioctl.c              |   2 +-
>  include/scsi/sg.h              | 274 -----------------------------------------
>  include/uapi/linux/Kbuild      |   1 +
>  include/uapi/linux/sg.h        | 274 +++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                |   2 +-
>  20 files changed, 292 insertions(+), 291 deletions(-)
>  delete mode 100644 include/scsi/sg.h
>  create mode 100644 include/uapi/linux/sg.h
> 
> diff --git a/block/bio.c b/block/bio.c
> index 471d738..ca072bb 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -28,7 +28,7 @@
>  #include <linux/mempool.h>
>  #include <linux/workqueue.h>
>  #include <linux/cgroup.h>
> -#include <scsi/sg.h>		/* for struct sg_iovec */
> +#include <uapi/linux/sg.h>		/* for struct sg_iovec */

Good grief, not like this, please.  uapi/linux/sg.h becomes our public,
or exported set of interfaces, but keep scsi/sg.h as our internal set
but have it include uapi/linux/sg.h (like you did for scsi.h).  That way
if we have any kernel private sg stuff, it stays in scsi/sg.h plus we
don't need to patch the #include path in fifty odd drivers.

Same goes for scsi_ioctl.h

James


