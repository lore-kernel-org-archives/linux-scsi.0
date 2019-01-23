From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/7] SCSI: cleanup debugfs usage
Date: Wed, 23 Jan 2019 09:23:55 +0000
Message-ID: <de49a145-cdbe-75a4-da8a-e2d376baad19@huawei.com>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 22/01/2019 15:08, Greg Kroah-Hartman wrote:
> When calling debugfs code, there is no need to ever check the return
> value of the call, as no logic should ever change if a call works
> properly or not.  Fix up a bunch of x86-specific code to not care about
> the results of debugfs.
>
> Greg Kroah-Hartman (7):
>   scsi: bfa: no need to check return value of debugfs_create functions
>   scsi: csiostor: no need to check return value of debugfs_create
>     functions
>   scsi: fnic: no need to check return value of debugfs_create functions
>   scsi: snic: no need to check return value of debugfs_create functions
>   scsi: lpfc: no need to check return value of debugfs_create functions
>   scsi: qlogic: no need to check return value of debugfs_create
>     functions
>   scsi: qla2xxx: no need to check return value of debugfs_create
>     functions
>

JFYI, Martin has some more debugfs usage queued for 5.1 here:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/mkp/scsi/+log/5.1/scsi-queue/drivers/scsi/hisi_sas

I'll send a patch to tidy-up, as above. It would not be x86 specific, 
but I am not sure what above is.

Thanks,
John



>  drivers/scsi/bfa/bfad_debugfs.c   |  17 ---
>  drivers/scsi/csiostor/csio_init.c |   6 +-
>  drivers/scsi/fnic/fnic_debugfs.c  |  88 +---------------
>  drivers/scsi/fnic/fnic_main.c     |   7 +-
>  drivers/scsi/fnic/fnic_stats.h    |   2 +-
>  drivers/scsi/fnic/fnic_trace.c    |  17 +--
>  drivers/scsi/fnic/fnic_trace.h    |   4 +-
>  drivers/scsi/lpfc/lpfc_debugfs.c  | 170 ------------------------------
>  drivers/scsi/qedf/qedf_debugfs.c  |  18 +---
>  drivers/scsi/qedi/qedi_debugfs.c  |  17 +--
>  drivers/scsi/qla2xxx/qla_dfs.c    |  43 +-------
>  drivers/scsi/snic/snic_debugfs.c  | 133 +++++------------------
>  drivers/scsi/snic/snic_main.c     |  14 +--
>  drivers/scsi/snic/snic_stats.h    |   2 +-
>  drivers/scsi/snic/snic_trc.c      |  12 +--
>  drivers/scsi/snic/snic_trc.h      |   4 +-
>  16 files changed, 48 insertions(+), 506 deletions(-)
>
