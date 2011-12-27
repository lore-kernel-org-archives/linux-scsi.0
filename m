From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v2 28/28] libsas: don't recover 'gone' devices in sas_ata_hard_reset()
Date: Tue, 27 Dec 2011 17:23:13 +0800
Message-ID: <3550CA95F3F349D48E2D8D3BB26CA6EC@usish.com.cn>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6> <20111223030054.21827.18482.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111223030054.21827.18482.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I pull the new V2 patchset, it works fine.
I found another bug in libsas, will send out later.

Jack

[PATCH v2 28/28] libsas: don't recover 'gone' devices in
> sas_ata_hard_reset()
> 
> The commands that timeout when a disk is forcibly removed may trigger
> libata to attempt recovery of the device.  If libsas has decided to
> remove the device don't permit ata to continue to issue resets to its
> last known phy.
> 
> The primary motivation for this patch is hotplug testing by writing 0 to
> /sys/class/sas_phy/phyX/enable.  Without this check this test leads to
> libata issuing a reset and re-enabling the device that wants to be torn
> down.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_ata.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 96f316f..2814731 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -321,6 +321,9 @@ static int sas_ata_hard_reset(struct ata_link *link,
> unsigned int *class,
>  	struct domain_device *dev = ap->private_data;
>  	struct sas_internal *i = dev_to_sas_internal(dev);
> 
> +	if (dev->gone)
> +		return -ENODEV;
> +
>  	res = i->dft->lldd_I_T_nexus_reset(dev);
> 
>  	if (res != TMF_RESP_FUNC_COMPLETE)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

