From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/10] mpt3sas: Fix possibility of using invalid Enclosure
 Handles for SAS device after host reset
Date: Wed, 11 Oct 2017 18:07:02 +0200
Message-ID: <d5327db8-527b-5174-c2e4-6a7c269d0d14@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-9-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-9-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> Enclosure handles are not updated after host reset.
> As a result, driver device structure is holding previously
>  assigned enclosure handle which is different from the
>  enclosure handle populated in the corresponding device page.
>
> Modified the driver to update devices enclosure handles after
>  host reset to current value, by referring the enclosure handles
>  from corresponding device pages
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 117 ++++++++++++++++++++++++-----------
>  1 file changed, 81 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 17b934b..b819914 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -5383,6 +5383,52 @@ _scsih_check_access_status(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
>  }
>  
>  /**
> + * _scsih_get_enclosure_logicalid_chassis_slot - get device's
> + *			EnclosureLogicalID and ChassisSlot information.
> + * @ioc: per adapter object
> + * @sas_device_pg0: SAS device page0
> + * @sas_device: per sas device object
> + *
> + * Returns nothing.
> + */
> +static void
> +_scsih_get_enclosure_logicalid_chassis_slot(struct MPT3SAS_ADAPTER *ioc,
> +	Mpi2SasDevicePage0_t *sas_device_pg0, struct _sas_device *sas_device)
> +{
> +	Mpi2ConfigReply_t mpi_reply;
> +	Mpi2SasEnclosurePage0_t enclosure_pg0;
> +
> +	if (!sas_device_pg0 || !sas_device)
> +		return;

This test^ implies that  sas_device_pg0 or  sas_device can be null,
is that true?

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
