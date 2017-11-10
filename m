From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 3/3] scsi: 3w-9xxx: rework lock timeouts
Date: Fri, 10 Nov 2017 11:36:50 -0800
Message-ID: <CAHtARFEeDeyac7C7ev3RtVkHfNg5V2nHZxMVPJ3H9QA_i-jd1g@mail.gmail.com>
References: <20171110155840.1941250-1-arnd@arndb.de> <20171110155840.1941250-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110155840.1941250-3-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 10, 2017 at 7:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The TW_IOCTL_GET_LOCK ioctl uses do_gettimeofday() to check whether
> a lock has expired. This can misbehave due to a concurrent
> settimeofday() call, as it is based on 'real' time, and it
> will overflow in y2038 on 32-bit architectures, producing
> unexpected results when used across the overflow time.
>
> This changes it to using monotonic time, using ktime_get()
> to simplify the code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/3w-9xxx.c | 13 ++++++-------
>  drivers/scsi/3w-9xxx.h |  2 +-
>  2 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index b1c9bd9c1bfd..b42c9c479d4b 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -645,8 +645,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
>         TW_Command_Full *full_command_packet;
>         TW_Compatibility_Info *tw_compat_info;
>         TW_Event *event;
> -       struct timeval current_time;
> -       u32 current_time_ms;
> +       ktime_t current_time;
>         TW_Device_Extension *tw_dev = twa_device_extension_list[iminor(inode)];
>         int retval = TW_IOCTL_ERROR_OS_EFAULT;
>         void __user *argp = (void __user *)arg;
> @@ -837,17 +836,17 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
>                 break;
>         case TW_IOCTL_GET_LOCK:
>                 tw_lock = (TW_Lock *)tw_ioctl->data_buffer;
> -               do_gettimeofday(&current_time);
> -               current_time_ms = (current_time.tv_sec * 1000) + (current_time.tv_usec / 1000);
> +               current_time = ktime_get();
>
> -               if ((tw_lock->force_flag == 1) || (tw_dev->ioctl_sem_lock == 0) || (current_time_ms >= tw_dev->ioctl_msec)) {
> +               if ((tw_lock->force_flag == 1) || (tw_dev->ioctl_sem_lock == 0) ||
> +                   ktime_after(current_time, tw_dev->ioctl_time)) {
>                         tw_dev->ioctl_sem_lock = 1;
> -                       tw_dev->ioctl_msec = current_time_ms + tw_lock->timeout_msec;
> +                       tw_dev->ioctl_time = ktime_add_ms(current_time, tw_lock->timeout_msec);
>                         tw_ioctl->driver_command.status = 0;
>                         tw_lock->time_remaining_msec = tw_lock->timeout_msec;
>                 } else {
>                         tw_ioctl->driver_command.status = TW_IOCTL_ERROR_STATUS_LOCKED;
> -                       tw_lock->time_remaining_msec = tw_dev->ioctl_msec - current_time_ms;
> +                       tw_lock->time_remaining_msec = ktime_ms_delta(tw_dev->ioctl_time, current_time);
>                 }
>                 break;
>         case TW_IOCTL_RELEASE_LOCK:
> diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
> index b6c208cc474f..d88cd3499bd5 100644
> --- a/drivers/scsi/3w-9xxx.h
> +++ b/drivers/scsi/3w-9xxx.h
> @@ -666,7 +666,7 @@ typedef struct TAG_TW_Device_Extension {
>         unsigned char           event_queue_wrapped;
>         unsigned int            error_sequence_id;
>         int                     ioctl_sem_lock;
> -       u32                     ioctl_msec;
> +       ktime_t                 ioctl_time;
>         int                     chrdev_request_id;
>         wait_queue_head_t       ioctl_wqueue;
>         struct mutex            ioctl_lock;
> --
> 2.9.0
>

Looks good...  Thanks for this fix!

Acked-by: Adam Radford <aradford@gmail.com>
