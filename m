From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver - 2nd request
Date: Sun, 19 Oct 2014 11:54:10 +0300
Message-ID: <27E642F6-B018-4D4E-9AFC-9E4669282924@kolumbus.fi>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com> <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi> <753462044.46450262.1413577229927.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs17.mail.saunalahti.fi ([62.142.117.198]:49560 "EHLO
	vs17.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaJSJDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 05:03:19 -0400
In-Reply-To: <753462044.46450262.1413577229927.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

Hello,

I am responding to this, but noticed your next, fixed version.

> On 17.10.2014, at 23.20, Laurence Oberman <loberman@redhat.com> wrote:
> 
> Hello Kai
> 
> You have seen this patch before. The first time around, given that we don't enable DEBUG by default, I let it go.
> However we have been looking into defining DEBUG 1 by default here at Redhat and then setting the default to disabled.
> 
> Are you open to considering changing the driver based on this patch.
> i.e. default DEFINE 1 and adding this code with default set to off.
> 
Yes. I certainly think defining DEBUG 1 and changing the default to zero should be done if it is useful for supporting users. The runtime overhead is negligible and the extra code does not matter nowadays (it did matter, at least theoretically, for years ago).

I am not so sure about the module option. When the debugging code is compiled in, debugging can be enabled and disabled for each device by the MTIOCTOP ioctl (e.g., mtst -f tape_device stsetoptions debug). The module option enables debugging for all tape devices. However, if you think this additional module option is useful, I am not against it. It does not remove the possibility for controlling debugging for each device for those who want to do it that way.

Anyway, you should modify the documentation (Documentation/scsi/st.txt) according to the changes.

> Note that with DEBUG 0, as you know you need to change that and recompile. 
> That is exactly what I am trying to avoid with Enterprise customers.
> 
I have also noticed this when someone has asked me about some tape problems.

> This patch adds a debug_flag parameter that can be set on module load, and allows the DEBUG facility without a module recompile.
> Note that now DEBUG 1 is the default with this patch.
> 
> Usage: modprobe st debug_flag=1
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> 
> diff -Nur a/st.c b/st.c
> --- a/st.c	2014-10-17 16:15:54.103810627 -0400
> +++ b/st.c	2014-10-17 16:22:12.303810392 -0400
> @@ -56,7 +56,7 @@
> 
> /* The driver prints some debugging information on the console if DEBUG
>    is defined and non-zero. */
> -#define DEBUG 0
> +#define DEBUG 1
> 
> #define ST_DEB_MSG  KERN_NOTICE
> #if DEBUG
> @@ -80,6 +80,7 @@
> static int try_direct_io = TRY_DIRECT_IO;
> static int try_rdio = 1;
> static int try_wdio = 1;
> +static int debug_flag = 0;
> 
> static struct class st_sysfs_class;
> static const struct attribute_group *st_dev_groups[];
> @@ -100,6 +101,9 @@
> MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (256)");
> module_param_named(try_direct_io, try_direct_io, int, 0);
> MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer and tape drive (1)");
> +module_param_named(debug_flag, debug_flag, int, 0);
> +MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting debugging=1");
> +
> 
> /* Extra parameters for testing */
> module_param_named(try_rdio, try_rdio, int, 0);
> @@ -124,6 +128,9 @@
> 	},
> 	{
> 		"try_direct_io", &try_direct_io
> +        },
> +        {
> +                "debug_flag", &debug_flag
> 	}
> };
> #endif
> @@ -4306,6 +4313,11 @@
> 
> 	validate_options();
> 
> +        debugging = (debug_flag > 0) ? debug_flag : DEBUG;
> +         if (debugging)
> +                printk(KERN_INFO "st: Debugging enabled debug_flag = %d\n",debugging);
> +
> +

I think you have an extra newline here?

I also think that the kernel log would look nicer if the print below would be before setting the option. The driver would introduce itself first and print the debug flag status after that.

> 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
> 		verstr, st_fixed_buffer_size, st_max_sg_segs);

Thanks,
Kai

