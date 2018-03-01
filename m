From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] scsi: sd: Keep disk read-only when re-reading partition
Date: Thu, 1 Mar 2018 16:14:55 +0200
Message-ID: <CAHp75Vc6g1+sO_xD=FPdBd8dZJqqA_Se6N3EnZav8uGKex6_fg@mail.gmail.com>
References: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01000161e1e448a5-d54e05d2-58f2-4480-b05b-67185d4ffae7-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 1, 2018 at 4:08 PM, Jeremy Cline <jeremy@jcline.org> wrote:
> If the read-only flag is true on a SCSI disk, re-reading the partition
> table sets the flag back to false.
>
> To observe this bug, you can run:
>
> 1. blockdev --setro /dev/sda
> 2. blockdev --rereadpt /dev/sda
> 3. blockdev --getro /dev/sda
>
> This commit reads the disk's old state and combines it with the device
> disk-reported state rather than unconditionally marking it as RW.

> -               sdkp->write_prot = ((data.device_specific & 0x80) != 0);
> +               sdkp->write_prot = ((data.device_specific & 0x80) != 0) ||
> +                       disk_ro;

Perhaps
               sdkp->write_prot = (data.device_specific & 0x80) || disk_ro;

will save a line.

-- 
With Best Regards,
Andy Shevchenko
