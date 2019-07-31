From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v5 15/29] compat_ioctl: move tape handling into drivers
Date: Wed, 31 Jul 2019 12:50:39 +0200
Message-ID: <20190731105039.GB3488@osiris>
References: <20190730192552.4014288-1-arnd@arndb.de>
 <20190730195819.901457-1-arnd@arndb.de>
 <20190730195819.901457-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190730195819.901457-3-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 30, 2019 at 09:55:31PM +0200, Arnd Bergmann wrote:
> MTIOCPOS and MTIOCGET are incompatible between 32-bit and 64-bit user
> space, and traditionally have been translated in fs/compat_ioctl.c.
> 
> To get rid of that translation handler, move a corresponding
> implementation into each of the four drivers implementing those commands.
> 
> The interesting part of that is now in a new linux/mtio.h header that
> wraps the existing uapi/linux/mtio.h header and provides an abstraction
> to let drivers handle both cases easily. Using an in_compat_syscall()
> check, the caller does not have to keep track of whether this was
> called through .unlocked_ioctl() or .compat_ioctl().
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Besides the two minor things below

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

> diff --git a/include/linux/mtio.h b/include/linux/mtio.h
> new file mode 100644
> index 000000000000..fa2783fd37d1
> --- /dev/null
> +++ b/include/linux/mtio.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MTIO_COMPAT_H
> +#define _LINUX_MTIO_COMPAT_H
> +
> +#include <linux/compat.h>
> +#include <uapi/linux/mtio.h>
> +#include <linux/uaccess.h>
> +
> +/*
> + * helper functions for implementing compat ioctls on the four tape
> + * drivers: we define the 32-bit layout of each incompatible strucucture,

typo: structure

> + * plus a wrapper function to copy it to user space in either format.
> + */
> +
> +struct	mtget32 {
> +	s32	mt_type;
> +	s32	mt_resid;
> +	s32	mt_dsreg;
> +	s32	mt_gstat;
> +	s32	mt_erreg;
> +	s32	mt_fileno;
> +	s32	mt_blkno;
> +};
> +#define	MTIOCGET32	_IOR('m', 2, struct mtget32)
> +
> +struct	mtpos32 {
> +	s32 	mt_blkno;
> +};
> +#define	MTIOCPOS32	_IOR('m', 3, struct mtpos32)
> +
> +static inline int put_user_mtget(void __user *u, struct mtget *k)
> +{
> +	struct mtget32 k32 = {
> +		.mt_type   = k->mt_type,
> +		.mt_resid  = k->mt_resid,
> +		.mt_dsreg  = k->mt_dsreg,
> +		.mt_gstat  = k->mt_gstat,
> +		.mt_fileno = k->mt_fileno,
> +		.mt_blkno  = k->mt_blkno,
> +	};

mt_erreg is missing here.
