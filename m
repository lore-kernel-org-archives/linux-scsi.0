From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into
 sas_remove_host
Date: Mon, 24 Apr 2017 11:14:13 +0200
Message-ID: <cf24e5c7-0d3d-6e6e-87f6-5fe15d29979e@suse.de>
References: <20170421121141.20701-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170421121141.20701-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 04/21/2017 02:11 PM, Johannes Thumshirn wrote:
> Move scsi_remove_host call into sas_remove_host and remove it from SAS HBA
> drivers, so we don't mess up the ordering. This solves an issue with double
> deleting sysfs entries that was introduced by the change of sysfs behaviour
> from commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: James Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
> Cc: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/aic94xx/aic94xx_init.c   | 1 -
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
>  drivers/scsi/isci/init.c              | 1 -
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 1 -
>  drivers/scsi/mvsas/mv_init.c          | 1 -
>  drivers/scsi/pm8001/pm8001_init.c     | 1 -
>  drivers/scsi/scsi_transport_sas.c     | 8 ++++++--
>  7 files changed, 6 insertions(+), 8 deletions(-)
> 
Sadly, you've left out mptsas; that's still in use for VMWare installations.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
