From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] vfs: add copy_file_range syscall and vfs helper
Date: Fri, 10 Apr 2015 18:36:41 -0400
Message-ID: <CAHQdGtSwSf0j6ge7rCue48bZ08212Ny2Crz9WMadSno11N8z_g@mail.gmail.com>
References: <1428703236-24735-1-git-send-email-zab@redhat.com>
	<1428703236-24735-2-git-send-email-zab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428703236-24735-2-git-send-email-zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Zach,

On Fri, Apr 10, 2015 at 6:00 PM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Add a copy_file_range() system call for offloading copies between
> regular files.
>
> This gives an interface to underlying layers of the storage stack which
> can copy without reading and writing all the data.  There are a few
> candidates that should support copy offloading in the nearer term:
>
> - btrfs shares extent references with its clone ioctl
> - NFS has patches to add a COPY command which copies on the server
> - SCSI has a family of XCOPY commands which copy in the device
>
> This system call avoids the complexity of also accelerating the creation
> of the destination file by operating on an existing destination file
> descriptor, not a path.
>
> Currently the high level vfs entry point limits copy offloading to files
> on the same mount and super (and not in the same file).  This can be
> relaxed if we get implementations which can copy between file systems
> safely.
>
> Signed-off-by: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/read_write.c                   | 129 ++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h                |   3 +
>  include/uapi/asm-generic/unistd.h |   4 +-
>  kernel/sys_ni.c                   |   1 +
>  4 files changed, 136 insertions(+), 1 deletion(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 8e1b687..c65ce1d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -17,6 +17,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/splice.h>
>  #include <linux/compat.h>
> +#include <linux/mount.h>
>  #include "internal.h"
>
>  #include <asm/uaccess.h>
> @@ -1424,3 +1425,131 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
>         return do_sendfile(out_fd, in_fd, NULL, count, 0);
>  }
>  #endif
> +
> +/*
> + * copy_file_range() differs from regular file read and write in that it
> + * specifically allows return partial success.  When it does so is up to
> + * the copy_file_range method.
> + */
> +ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> +                           struct file *file_out, loff_t pos_out,
> +                           size_t len, int flags)

I'm going to repeat a gripe with this interface. I really don't think
we should treat copy_file_range() as taking a size_t length, since
that is not sufficient to do a full file copy on 32-bit systems w/ LFS
support.

Could we perhaps instead of a length, define a 'pos_in_start' and a
'pos_in_end' offset (with the latter being -1 for a full-file copy)
and then return an 'loff_t' value stating where the copy ended?

Note that both btrfs and NFSv4.2 allow for 64-bit lengths, so this
interface would be closer to what is already in use anyway.

Cheers
  Trond
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
