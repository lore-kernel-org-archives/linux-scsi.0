From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH v2] scsi: 3w-9xxx: fix a missing-check bug
Date: Mon, 7 May 2018 18:42:56 -0700
Message-ID: <CAHtARFEbjf90Es-e7_Uh0k2Mb6pMNknAtS5SE5iFs3Zizd8TAQ@mail.gmail.com>
References: <1525740413-23443-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525740413-23443-1-git-send-email-wang6495@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 7, 2018 at 5:46 PM, Wenwen Wang <wang6495@umn.edu> wrote:
> In twa_chrdev_ioctl(), the ioctl driver command is firstly copied from the
> userspace pointer 'argp' and saved to the kernel object 'driver_command'.
> Then a security check is performed on the data buffer size indicated by
> 'driver_command', which is 'driver_command.buffer_length'. If the security
> check is passed, the entire ioctl command is copied again from the 'argp'
> pointer and saved to the kernel object 'tw_ioctl'. Then, various operations
> are performed on 'tw_ioctl' according to the 'cmd'. Given that the 'argp'
> pointer resides in userspace, a malicious userspace process can race to
> change the buffer size between the two copies. This way, the user can
> bypass the security check and inject invalid data buffer size. This can
> cause potential security issues in the following execution.
>
> This patch checks for capable(CAP_SYS_ADMIN) in twa_chrdev_open()t o avoid
> the above issues.
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/scsi/3w-9xxx.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index b42c9c4..99ba4a7 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -882,6 +882,11 @@ static int twa_chrdev_open(struct inode *inode, struct file *file)
>         unsigned int minor_number;
>         int retval = TW_IOCTL_ERROR_OS_ENODEV;
>
> +       if (!capable(CAP_SYS_ADMIN)) {
> +               retval = -EACCES;
> +               goto out;
> +       }
> +
>         minor_number = iminor(inode);
>         if (minor_number >= twa_device_extension_count)
>                 goto out;
> --
> 2.7.4
>

Acked-by: Adam Radford <aradford@gmail.com>
