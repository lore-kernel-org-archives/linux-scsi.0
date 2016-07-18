From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v5 4/8] char: rpmb: provide a user space interface
Date: Mon, 18 Jul 2016 18:15:22 -0400
Message-ID: <CAP=VYLqZCXjWUohLZ35Kvrx7B8z7cbEFzDt4ugaUosrh2ca+8g@mail.gmail.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com> <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 18, 2016 at 4:27 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> The user space API is achieved via two synchronous IOCTL.
> Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is performed
> by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD where
> the whole RPMB sequence including RESULT_READ is supplied by the caller.
> The latter is intended for  easier adjusting  of the  applications that
> use MMC_IOC_MULTI_CMD ioctl.
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---

[...]

> diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
> index c5e6e909efce..6794be9fcc5e 100644
> --- a/drivers/char/rpmb/Kconfig
> +++ b/drivers/char/rpmb/Kconfig
> @@ -6,3 +6,10 @@ config RPMB
>           access RPMB partition.
>
>           If unsure, select N.
> +
> +config RPMB_INTF_DEV
> +       bool "RPMB character device interface /dev/rpmbN"

A bool Kconfig should ideally....

> +       depends on RPMB
> +       help
> +         Say yes here if you want to access RPMB from user space
> +         via character device interface /dev/rpmb%d
> diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
> index 812b3ed264c0..b5dc087b1299 100644
> --- a/drivers/char/rpmb/Makefile
> +++ b/drivers/char/rpmb/Makefile
> @@ -1,4 +1,5 @@
>  obj-$(CONFIG_RPMB) += rpmb.o
>  rpmb-objs += core.o
> +rpmb-$(CONFIG_RPMB_INTF_DEV) += cdev.o
>
>  ccflags-y += -D__CHECK_ENDIAN__
> diff --git a/drivers/char/rpmb/cdev.c b/drivers/char/rpmb/cdev.c
> new file mode 100644
> index 000000000000..f3ad3444f76d
> --- /dev/null
> +++ b/drivers/char/rpmb/cdev.c
> @@ -0,0 +1,269 @@
> +/*
> + * Copyright (C) 2015-2016 Intel Corp. All rights reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>

....not use module.h or any MODULE_ macros from within it.

Thanks,
Paul.
--

> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/compat.h>
> +#include <linux/slab.h>
> +#include <linux/capability.h>
> +
> +#include <linux/rpmb.h>
> +
> +#include "rpmb-cdev.h"
> +
> +static dev_t rpmb_devt;
