From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 20/22] scsi: hisi_sas: Add v3 code to support ECC and AXI
 bus fatal error
Date: Wed, 17 May 2017 14:27:39 +0200
Message-ID: <CAK8P3a3jh8QqcHgdAkpA9SADZ0RfD2i63A-RHkN9+gJ31sL74g@mail.gmail.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com> <1495018197-120535-21-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-21-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> For ECC 1bit error, logic can recover it, so we only print a warning.
> For ECC multi-bit and AXI bus fatal error, we panic.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>

This one is tricky as there are conflicting requirements:

- For debugging purposes, you want to continue running the system
  to figure out what exactly went wrong. Often enough, having the
  kernel panic means you don't get to see the panic message because
  console access is unavailable and you cannot log in any more

- For data consistency purposes you want to stop the system as
  soon as there is any uncorrectable data error

I see that most scsi drivers don't ever call panic or BUG(), though
you already do so for v1 and v2 hw.

Maybe the SCSI maintainers can provide some more guidance here.

      Arnd
