From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 03/23] scsi: hisi_sas: optimise the usage of hisi_hba.lock
Date: Mon, 12 Jun 2017 11:45:49 +0200
Message-ID: <CAK8P3a1jpah1ERvg2_ESmHizvJH9veTHTXU1cADt0wyfB80bsw@mail.gmail.com>
References: <201706110427.UEjoe6NO%fengguang.wu@intel.com> <aec6fd20-3b7c-0684-7e49-57ff61de6064@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aec6fd20-3b7c-0684-7e49-57ff61de6064@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 12, 2017 at 10:26 AM, John Garry <john.garry@huawei.com> wrote:
> On 10/06/2017 21:44, kbuild test robot wrote:
>
>
> I don't think that reusing flags variable is in error, as there would be no
> nested spinlock at this point within the function.
>
> If it is not recommended or not permitted to reuse flags variable for
> separate spinlocks, then that can be changed - I don't know.

No, look again: coccinelle is right as the locks are nested in
https://github.com/0day-ci/linux/blob/bf95e9cccde4af4ed2012a6ec44d48b545d5ffed/drivers/scsi/hisi_sas/hisi_sas_main.c#L1208

dq->lock is already held and you acquire task->task_state_lock in
line 1208, which overwrites the flags.

      Arnd
