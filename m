From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: [PATCH] st: allow debug output to be enabled or disabled via sysfs
Date: Mon, 12 Oct 2015 11:01:12 -0400
Message-ID: <CAAzz28hmYr3O3AS-7q0wz=kutQMjR_066VqwOPZTainGnn4TxA@mail.gmail.com>
References: <DDB9C85B850785449757F9914A034FCB444ABDC8@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:33481 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbJLPBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:01:13 -0400
Received: by vkaw128 with SMTP id w128so31259312vka.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2015 08:01:12 -0700 (PDT)
In-Reply-To: <DDB9C85B850785449757F9914A034FCB444ABDC8@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>, "loberman@redhat.com" <loberman@redhat.com>
Cc: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@odin.com>

I support this addition as it can be done without the module reload
provided by my prior patch.

Reviewed-by: Laurence Oberman <oberman.l@gmail.com>

On Mon, Oct 12, 2015 at 12:31 AM, Seymour, Shane M
<shane.seymour@hpe.com> wrote:
>
> Change st driver to allow enabling or disabling debug output
> via sysfs file /sys/bus/scsi/drivers/st/debug_flag.
>
> Previously the only way to enable debug output was:
>
> 1. loading the driver with the module parameter debug_flag=1
> 2. an ioctl call (this method was also the only way to dynamically
> disable debug output).
>
> To use the ioctl you need a second tape drive (if you are
> actively testing the first tape drive) since a second process
> cannot open the first tape drive if it is in use.
>
> The this change is only functional if the value of the macro
> DEBUG in st.c is a non-zero value (which it is by default).
>
> Signed-off-by: Shane Seymour <shane.seymour@hpe.com>
> ---
> --- a/drivers/scsi/st.c 2015-10-06 17:11:16.299801789 -0500
> +++ b/drivers/scsi/st.c 2015-10-11 14:45:10.595060995 -0500
> @@ -4452,11 +4452,41 @@ static ssize_t version_show(struct devic
>  }
>  static DRIVER_ATTR_RO(version);
>
> +#if DEBUG
> +static ssize_t debug_flag_store(struct device_driver *ddp,
> +       const char *buf, size_t count)
> +{
> +/* We only care what the first byte of the data is the rest is unused.
> + * if it's a '1' we turn on debug and if it's a '0' we disable it. All
> + * other values have -EINVAL returned if they are passed in.
> + */
> +       if (count > 0) {
> +               if (buf[0] == '0') {
> +                       debugging = NO_DEBUG;
> +                       return count;
> +               } else if (buf[0] == '1') {
> +                       debugging = 1;
> +                       return count;
> +               }
> +       }
> +       return -EINVAL;
> +}
> +
> +static ssize_t debug_flag_show(struct device_driver *ddp, char *buf)
> +{
> +       return scnprintf(buf, PAGE_SIZE, "%d\n", debugging);
> +}
> +static DRIVER_ATTR_RW(debug_flag);
> +#endif
> +
>  static struct attribute *st_drv_attrs[] = {
>         &driver_attr_try_direct_io.attr,
>         &driver_attr_fixed_buffer_size.attr,
>         &driver_attr_max_sg_segs.attr,
>         &driver_attr_version.attr,
> +#if DEBUG
> +       &driver_attr_debug_flag.attr,
> +#endif
>         NULL,
>  };
>  ATTRIBUTE_GROUPS(st_drv);
> diff -uprN a/Documentation/ABI/testing/sysfs-driver-st b/Documentation/ABI/testing/sysfs-driver-st
> --- a/Documentation/ABI/testing/sysfs-driver-st 1969-12-31 18:00:00.000000000 -0600
> +++ b/Documentation/ABI/testing/sysfs-driver-st 2015-10-11 14:28:43.537128220 -0500
> @@ -0,0 +1,12 @@
> +What:          /sys/bus/scsi/drivers/st/debug_flag
> +Date:          October 2015
> +Kernel Version:        ?.?
> +Contact:       shane.seymour@hpe.com
> +Description:
> +               This file allows you to turn debug output from the st driver
> +               off if you write a '0' to the file or on if you write a '1'.
> +               Note that debug output requires that the module be compiled
> +               with the #define DEBUG set to a non-zero value (this is the
> +               default). If DEBUG is set to 0 then this file will not
> +               appear in sysfs as its presence is conditional upon debug
> +               output support being compiled into the module.
> --- a/Documentation/scsi/st.txt 2015-10-06 17:11:12.323802060 -0500
> +++ b/Documentation/scsi/st.txt 2015-10-11 14:19:48.176164681 -0500
> @@ -569,7 +569,9 @@ Debugging code is now compiled in by def
>  with the kernel module parameter debug_flag defaulting to 0.  Debugging
>  can still be switched on and off with an ioctl.  To enable debug at
>  module load time add debug_flag=1 to the module load options, the
> -debugging output is not voluminous.
> +debugging output is not voluminous. Debugging can also be enabled
> +and disabled by writing a '0' (disable) or '1' (enable) to the sysfs
> +file /sys/bus/scsi/drivers/st/debug_flag.
>
>  If the tape seems to hang, I would be very interested to hear where
>  the driver is waiting. With the command 'ps -l' you can see the state
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
