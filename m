From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 02/22] scsi: hisi_sas: optimise the usage of hisi_hba.lock
Date: Fri, 26 May 2017 10:52:26 +0200
Message-ID: <CAK8P3a2skEcBm+F4CjaTGCxGfRXWsrz8zCd3sRcfQXGF=9K3tg@mail.gmail.com>
References: <1495713911-80476-3-git-send-email-john.garry@huawei.com> <201705260816.A7uMTHAu%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201705260816.A7uMTHAu%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: John Garry <john.garry@huawei.com>, kbuild-all@01.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 26, 2017 at 2:23 AM, kbuild test robot <lkp@intel.com> wrote:
> Hi Xiang,
>
> [auto build test ERROR on mkp-scsi/for-next]
> [also build test ERROR on v4.12-rc2 next-20170525]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/John-Garry/hisi_sas-hip08-support/20170526-011153
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: "__umoddi3" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!

I think it must come from this line:

+       int queue_id = sas_dev->device_id % hisi_hba->queue_count;

Doing a 64-bit division seems like a rather inefficient way to
pick a queue, especially if you do it on each request. Can you
store the queue_id in sas_dev itself, or use a mask to generate
it instead?

      Arnd
