From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: hpsa: fix uninitialized variable access
Date: Tue, 22 Nov 2016 15:47:09 +0100
Message-ID: <04f7cd82-8979-0f08-8b16-3cf863795ccf@suse.com>
References: <20161122143303.1871678-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161122143303.1871678-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/22/2016 03:32 PM, Arnd Bergmann wrote:
> A bugfix has left the 'sd' variable uninitialized:
> 
> drivers/scsi/hpsa.c: In function 'hpsa_slave_alloc':
> drivers/scsi/hpsa.c:2033:5: error: 'sd' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> This reverts back to calling lookup_hpsa_scsi_dev() for the
> HPSA_PHYSICAL_DEVICE_BUS case, but also keeps doing that when
> hpsa_find_device_by_sas_rphy() returns NULL, as is currently
> done.
> 
> The patch that caused this is marked for stable backports,
> so this one has to be backported on top as well.
> 
> Fixes: 4eb307f7b18d ("scsi: hpsa: use bus '3' for legacy HBA devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I did not try hard to figure out what the correct behavior
> should be, so please treat this as a bugreport that might contain
> the right fix.
> ---
>  drivers/scsi/hpsa.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index ea64c01f3d42..d17ee63045c3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2029,7 +2029,10 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
>  			sd->target = sdev_id(sdev);
>  			sd->lun = sdev->lun;
>  		}
> +	} else {
> +		sd = NULL;
>  	}
> +
>  	if (!sd)
>  		sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
>  					sdev_id(sdev), sdev->lun);
> 
Hmm.

I'd prefer this:

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 05f7782..ee6f852 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2031,7 +2031,7 @@ static struct hpsa_scsi_dev_t
*lookup_hpsa_scsi_dev(struct ctlr_info *h,

 static int hpsa_slave_alloc(struct scsi_device *sdev)
 {
-       struct hpsa_scsi_dev_t *sd;
+       struct hpsa_scsi_dev_t *sd = NULL;
        unsigned long flags;
        struct ctlr_info *h;


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
