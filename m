From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v8 03/13] libsas: async ata scanning
Date: Fri, 10 Feb 2012 13:34:24 -0500
Message-ID: <4F356330.4060703@garzik.org>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com> <20120210084454.25701.66737.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084454.25701.66737.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On 02/10/2012 03:44 AM, Dan Williams wrote:
> libsas ata error handling is already async but this does not help the
> scan case.  Move initial link recovery out from under host->scan_mutex,
> and delay synchronization with eh until after all port probe/recovery
> work has been queued.
>
> Device ordering is maintained with scan order by still calling
> sas_rphy_add() in order of domain discovery.
>
> Since we now scan the domain list when invoking libata-eh we need to be
> careful to check for fully initialized ata ports.
>
> Cc: Xiangliang Yu<yuxiangl@marvell.com>
> Cc: Luben Tuikov<ltuikov@yahoo.com>
> Acked-by: Jack Wang<jack_wang@usish.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/ata/libata-core.c           |   34 +++++++++-------
>   drivers/ata/libata-scsi.c           |   13 ++++++
>   drivers/ata/libata.h                |    1
>   drivers/scsi/aic94xx/aic94xx_init.c |    1
>   drivers/scsi/isci/init.c            |    1
>   drivers/scsi/libsas/sas_ata.c       |   74 ++++++++++++++++++++++++++++++-----
>   drivers/scsi/libsas/sas_discover.c  |   22 +++++-----
>   drivers/scsi/libsas/sas_internal.h  |    9 ++++
>   drivers/scsi/libsas/sas_scsi_host.c |   18 ---------
>   drivers/scsi/mvsas/mv_init.c        |    1
>   drivers/scsi/pm8001/pm8001_init.c   |    1
>   include/linux/libata.h              |    1
>   include/scsi/libsas.h               |    1
>   include/scsi/sas_ata.h              |   12 +++---
>   14 files changed, 123 insertions(+), 66 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



