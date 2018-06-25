From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] sg: mitigate read/write abuse
Date: Sun, 24 Jun 2018 17:46:21 -0700
Message-ID: <CALCETrUCQzY7vuYS6NZDUA04QMYZW5srP0FzE26a8-qp1K-P_w@mail.gmail.com>
References: <20180621151809.10921-1-jannh@google.com> <eafae3a5-346b-5361-4551-7dc5a146e1da@interlog.com>
 <CAG48ez1EgmS9Gp2G__doddRQQU2iuSQ=7WXymrKUFDwWHjx91A@mail.gmail.com> <06d662b8-89f1-458f-bc09-519c9442c63d@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-13637-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <06d662b8-89f1-458f-bc09-519c9442c63d@interlog.com>
To: dgilbert@interlog.com
Cc: Jann Horn <jannh@google.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, fujita.tomonori@lab.ntt.co.jp, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org, bblock@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 23, 2018 at 3:06 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2018-06-21 08:56 PM, Jann Horn wrote:
> > On Thu, Jun 21, 2018 at 6:53 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
> >>
> >> On 2018-06-21 05:18 PM, Jann Horn wrote:
> >>> As Al Viro noted in commit 128394eff343 ("sg_write()/bsg_write() is not fit
> >>> to be called under KERNEL_DS"), sg improperly accesses userspace memory
> >>> outside the provided buffer, permitting kernel memory corruption via
> >>> splice().
> >>> But it doesn't just do it on ->write(), also on ->read().
> >>>
> >>> As a band-aid, make sure that the ->read() and ->write() handlers can not
> >>> be called in weird contexts (kernel context or credentials different from
> >>> file opener), like for ib_safe_file_access().
> >>>
> >>> If someone needs to use these interfaces from different security contexts,
> >>> a new interface should be written that goes through the ->ioctl() handler.
> >>>
> >>> I've mostly copypasted ib_safe_file_access() over as sg_safe_file_access()
> >>> because I couldn't find a good common header - please tell me if you know a
> >>> better way.
> >>> The duplicate pr_err_once() calls are so that each of them fires once;
> >>> otherwise, this would probably have to be a macro.
> >>>
> >>> changed in v2:
> >>>    - remove the bsg parts per Christoph Hellwig's request
> >>>
> >>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Jann Horn <jannh@google.com>
> >>> ---
> >>>    drivers/scsi/sg.c | 29 ++++++++++++++++++++++++++++-
> >>>    1 file changed, 28 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >>> index 53ae52dbff84..51b685192646 100644
> >>> --- a/drivers/scsi/sg.c
> >>> +++ b/drivers/scsi/sg.c
> >>> @@ -51,6 +51,7 @@ static int sg_version_num = 30536;  /* 2 digits for each component */
> >>>    #include <linux/atomic.h>
> >>>    #include <linux/ratelimit.h>
> >>>    #include <linux/uio.h>
> >>> +#include <linux/cred.h> /* for sg_safe_file_access() */
> >>>
> >>>    #include "scsi.h"
> >>>    #include <scsi/scsi_dbg.h>
> >>> @@ -209,6 +210,23 @@ static void sg_device_destroy(struct kref *kref);
> >>>        sdev_prefix_printk(prefix, (sdp)->device,               \
> >>>                           (sdp)->disk->disk_name, fmt, ##a)
> >>>
> >>> +/*
> >>> + * The SCSI interfaces that use read() and write() as an asynchronous variant of
> >>> + * ioctl(..., SG_IO, ...) are fundamentally unsafe, since there are lots of ways
> >>> + * to trigger read() and write() calls from various contexts with elevated
> >>> + * privileges. This can lead to kernel memory corruption (e.g. if these
> >>> + * interfaces are called through splice()) and privilege escalation inside
> >>> + * userspace (e.g. if a process with access to such a device passes a file
> >>> + * descriptor to a SUID binary as stdin/stdout/stderr).
> >>> + *
> >>> + * This function provides protection for the legacy API by restricting the
> >>> + * calling context.
> >>> + */
> >>> +static inline bool sg_safe_file_access(struct file *filp)
> >>> +{
> >>> +     return filp->f_cred == current_cred() && !uaccess_kernel();
> >>> +}
> >>> +
> >>>    static int sg_allow_access(struct file *filp, unsigned char *cmd)
> >>>    {
> >>>        struct sg_fd *sfp = filp->private_data;
> >>> @@ -393,6 +411,12 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
> >>>        struct sg_header *old_hdr = NULL;
> >>>        int retval = 0;
> >>>
> >>> +     if (!sg_safe_file_access(filp)) {
> >>> +             pr_err_once("%s: process %d (%s) changed security contexts after opening file descriptor, this is not allowed.\n",
> >>> +                     __func__, task_tgid_vnr(current), current->comm);
> >>> +             return -EINVAL;
> >>
> >> The error message and returned code apply to the
> >> (filp->f_cred == current_cred()) case, not so much to !uaccess_kernel().
> >> While on the error path could you not break out the !uaccess_kernel()
> >> with an appropriate error message and a return code of -EACCES ? Perhaps
> >> a message is unneeded since EACCES is clear.
> >>
> >> Not that wild about EINVAL either since it suggests (to me) a "front end"
> >> error (e.g. associated with a badly formed request). How about EPERM for
> >> the changing credentials case.
> >
> > I used EINVAL since infiniband uses that error case, but I see how it
> > would be a relatively confusing error code in the context of an sg
> > device - I agree that EACCES and EPERM might be a better fit here.
> > I'll adjust the patch.
> > However, shouldn't it be EPERM in the uaccess_kernel() case and EACCES
> > in the filp->f_cred!=current_cred() case (instead of the other way
> > around)?
>
> NO!
>
> See 'man errno':
>     EACCES     Permission denied
>     EPERM      Operation not permitted
>

Usually EPERM means the caller doesn't have access and EACCES means
the fd doesn't have access.

What we really want is -EDRIVERISAPIECEOFCRAP.

--Andy
