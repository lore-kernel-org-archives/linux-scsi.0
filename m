From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sas: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 18:13:14 +0000
Message-ID: <70f0b708-4b73-ee05-96c3-0b45bcba7dd3@huawei.com>
References: <20171025100800.GA145125@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100800.GA145125@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Jack Wang <jinpu.wang@profitbricks.com>, "lindar_liu@usish.com" <lindar_liu@usish.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Baoyou Xie <baoyou.xie@linaro.org>, "weiyongjun (A)" <weiyongjun1@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 25/10/2017 11:08, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly. This requires adding a pointer to
> hold the timer's target task, as there isn't a link back from slow_task.
>
> Cc: John Garry <john.garry@huawei.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Jack Wang <jinpu.wang@profitbricks.com>
> Cc: lindar_liu@usish.com
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
> Cc: Baoyou Xie <baoyou.xie@linaro.org>
> Cc: Wei Yongjun <weiyongjun1@huawei.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: John Garry <john.garry@huawei.com> #for hisi_sas part
Tested-by: John Garry <john.garry@huawei.com> # basic sanity test for 
hisi_sas (+ libsas)

> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 14 ++++++--------
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  6 +++---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 24 +++++++++++-------------
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
>  drivers/scsi/libsas/sas_expander.c     |  8 ++++----
>  drivers/scsi/libsas/sas_init.c         |  3 ++-
>  drivers/scsi/libsas/sas_scsi_host.c    |  2 +-
>  drivers/scsi/mvsas/mv_init.c           |  3 +--
>  drivers/scsi/mvsas/mv_sas.c            | 15 +++++++--------
>  drivers/scsi/mvsas/mv_sas.h            |  1 -
>  drivers/scsi/pm8001/pm8001_sas.c       | 11 +++++------
>  include/scsi/libsas.h                  |  1 +
>  13 files changed, 42 insertions(+), 49 deletions(-)
