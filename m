From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] mpt3sas: Fix for Endianness issue.
Date: Mon, 24 Oct 2016 16:53:46 +0200
Message-ID: <959280c2-a07f-bbcd-896f-f8d77df54084@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-11-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-11-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> Use le16_to_cpu only for accessing two byte data provided by controller.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6d17f66..981be7b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -5384,10 +5384,10 @@ _scsih_check_device(struct MPT3SAS_ADAPTER *ioc,
>  			sas_device->handle, handle);
>  		sas_target_priv_data->handle = handle;
>  		sas_device->handle = handle;
> -		if (sas_device_pg0.Flags &
> +		if (le16_to_cpu(sas_device_pg0.Flags) &
>  		     MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
>  			sas_device->enclosure_level =
> -				le16_to_cpu(sas_device_pg0.EnclosureLevel);
> +				sas_device_pg0.EnclosureLevel;
>  			memcpy(sas_device->connector_name,
>  				sas_device_pg0.ConnectorName, 4);
>  			sas_device->connector_name[4] = '\0';
> @@ -5516,9 +5516,10 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phy_num,
>  	sas_device->fast_path = (le16_to_cpu(sas_device_pg0.Flags) &
>  	    MPI25_SAS_DEVICE0_FLAGS_FAST_PATH_CAPABLE) ? 1 : 0;
>
> -	if (sas_device_pg0.Flags & MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
> +	if (le16_to_cpu(sas_device_pg0.Flags)
> +		& MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
>  		sas_device->enclosure_level =
> -			le16_to_cpu(sas_device_pg0.EnclosureLevel);
> +			sas_device_pg0.EnclosureLevel;
>  		memcpy(sas_device->connector_name,
>  			sas_device_pg0.ConnectorName, 4);
>  		sas_device->connector_name[4] = '\0';
> @@ -7056,7 +7057,7 @@ Mpi2SasDevicePage0_t *sas_device_pg0)
>  			if (sas_device_pg0->Flags &
>  			      MPI2_SAS_DEVICE0_FLAGS_ENCL_LEVEL_VALID) {
>  				sas_device->enclosure_level =
> -				   le16_to_cpu(sas_device_pg0->EnclosureLevel);
> +				   sas_device_pg0->EnclosureLevel;
>  				memcpy(&sas_device->connector_name[0],
>  					&sas_device_pg0->ConnectorName[0], 4);
>  			} else {
> @@ -7118,6 +7119,7 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
>  		sas_device_pg0.SASAddress =
>  				le64_to_cpu(sas_device_pg0.SASAddress);
>  		sas_device_pg0.Slot = le16_to_cpu(sas_device_pg0.Slot);
> +		sas_device_pg0.Flags = le16_to_cpu(sas_device_pg0.Flags);
>  		_scsih_mark_responding_sas_device(ioc, &sas_device_pg0);
>  	}
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
