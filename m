From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: fix integer type usage in uapi header
Date: Mon, 15 Oct 2018 22:46:18 -0400
Message-ID: <yq1r2gqwqv9.fsf@oracle.com>
References: <20181012104143.1931393-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181012104143.1931393-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 12 Oct 2018 12:41:28 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Avri Altman <avri.altman@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> We get a warning from 'make headers_check' about a newly introduced
> usage of integer types in the scsi/scsi_bsg_ufs.h uapi header:
>
> usr/include/scsi/scsi_bsg_ufs.h:18: found __[us]{8,16,32,64} type without #include <linux/types.h>
>
> Aside from the missing linux/types.h inclusion, I also noticed that it
> uses the wrong types: 'u32' is not available at all in user space,
> and 'uint32_t' depends on the inclusion of a standard header that
> we should not include from kernel headers.
>
> Change the all to __u32 and similar types here.
>
> I also note the usage of '__be32' and '__be16' that seems unfortunate
> for a user space API. I wonder if it would be better to define the
> interface in terms of a CPU-endian structure and convert it in kernel
> space.

Applied to 4.20/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
