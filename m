From: wangyijing <wangyijing@huawei.com>
Subject: Re: [RFC][PATCH v2 0/2] Improve libsas hotplug
Date: Fri, 11 Nov 2016 16:26:57 +0800
Message-ID: <582580D1.6040806@huawei.com>
References: <1474946145-29755-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474946145-29755-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: hare@suse.de, tj@kernel.org, chenqilin2@huawei.com, fangwei1@huawei.com, heyousong@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James, sorry to bother you, these two patches try to fix several issues
in libsas, Dan Williams and John Garry also found similar issue, and post
some patches before. Dan Williams's solution fix the sysfs warning calltrace,
but may introduce new flutter issue.

In these two patches, we introduce a new workqueue to fix the flutter issue.
Do you have time to look at these patches ? Your comments is important to us,
It help us to know whether we are in the right direction to fix these issues.

Thanks!
Yijing.

在 2016/9/27 11:15, Yijing Wang 写道:
> v1-v2: Fix memory allocation issue in interrupt context.
> 
> Yijing Wang (2):
>   libsas: Alloc dynamic work to avoid missing sas events
>   libsas: Fix hotplug issue in libsas
> 
>  drivers/scsi/libsas/sas_ata.c       |  34 ++---
>  drivers/scsi/libsas/sas_discover.c  | 245 ++++++++++++++++++++++++++----------
>  drivers/scsi/libsas/sas_event.c     |  61 +++++----
>  drivers/scsi/libsas/sas_expander.c  |  54 ++++++--
>  drivers/scsi/libsas/sas_init.c      |  31 ++++-
>  drivers/scsi/libsas/sas_internal.h  |  45 ++++++-
>  drivers/scsi/libsas/sas_phy.c       |  50 +++-----
>  drivers/scsi/libsas/sas_port.c      |  35 ++++--
>  drivers/scsi/libsas/sas_scsi_host.c |  23 ++++
>  include/scsi/libsas.h               |  13 +-
>  include/scsi/sas_ata.h              |   4 +-
>  11 files changed, 404 insertions(+), 191 deletions(-)
> 
