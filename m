From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: 3ware: fix 32-bit time calculations
Date: Mon, 20 Nov 2017 22:06:04 -0500
Message-ID: <yq1wp2kmiub.fsf@oracle.com>
References: <20171110155840.1941250-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171110155840.1941250-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 10 Nov 2017 16:58:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> twl_aen_queue_event/twa_aen_queue_event, we use do_gettimeofday()
> to read the lower 32 bits of the current time in seconds, to pass
> them to the TW_IOCTL_GET_NEXT_EVENT ioctl or the 3ware_aen_read
> sysfs file.
>
> This will overflow on all architectures in year 2106, there is
> not much we can do about that without breaking the ABI. User
> space has 90 years to learn to deal with it, so it's probably ok.
>
> I'm changing it to use ktime_get_real_seconds() with a comment
> to document what happens when.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
