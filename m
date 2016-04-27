From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5] qla1280: Don't allocate 512kb of host tags
Date: Wed, 27 Apr 2016 12:39:00 +0200
Message-ID: <572096C4.4090705@suse.de>
References: <1461746932-123934-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1461746932-123934-1-git-send-email-jthumshirn@suse.de>
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Reed <mdr@sgi.com>, Laura Abbott <labbott@redhat.com>, Laurence Oberman <loberman@redhat.com>, Lee Duncan <lduncan@suse.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.4@suse.de
List-Id: linux-scsi@vger.kernel.org

On 04/27/2016 10:48 AM, Johannes Thumshirn wrote:
> The qla1280 driver sets the scsi_host_template's can_queue field to 0=
xfffff
> which results in an allocation failure when allocating the block laye=
r tags
> for the driver's queues. This was introduced with the change for host=
 wide
> tags in commit 64d513ac31b - "scsi: use host wide tags by default".
>=20
> Reduce can_queue to MAX_OUTSTANDING_COMMANDS (512) to solve the alloc=
ation
> error.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 64d513ac31b - "scsi: use host wide tags by default"
> Cc: stable@vger.kernel.org # v4.4
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Michael Reed <mdr@sgi.com>
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
> Changes to v4:
> * Make subject more meaningfull
> * Remove warning's backtrace
> * Re-add reference to commit  64d513ac31b - "scsi: use host wide tags=
 by default"
>=20
> Changes to v3:
> * Use  MAX_OUTSTANDING_COMMANDS insted of hard coded magical number
>=20
> Changes to v2:
> * Change can_queue to 512 upon James' request
>=20
>  drivers/scsi/qla1280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 5d0ec42..634254a 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -4214,7 +4214,7 @@ static struct scsi_host_template qla1280_driver=
_template =3D {
>  	.eh_bus_reset_handler	=3D qla1280_eh_bus_reset,
>  	.eh_host_reset_handler	=3D qla1280_eh_adapter_reset,
>  	.bios_param		=3D qla1280_biosparam,
> -	.can_queue		=3D 0xfffff,
> +	.can_queue		=3D MAX_OUTSTANDING_COMMANDS,
>  	.this_id		=3D -1,
>  	.sg_tablesize		=3D SG_ALL,
>  	.use_clustering		=3D ENABLE_CLUSTERING,
>=20
Hmm.

The driver has this:

	ha->request_ring =3D pci_alloc_consistent(ha->pdev,
			((REQUEST_ENTRY_CNT + 1) * sizeof(request_t)),
			&ha->request_dma);

and

/* ISP request and response entry counts (37-65535) */
#define REQUEST_ENTRY_CNT	255 /* Number of request entries. */
#define RESPONSE_ENTRY_CNT	63  /* Number of response entries. */

IE the driver (as it stands currently) will never be able to queue
more than 255 requests.
So where's the point in setting can_queue to 512? Shouldn't we
rather use 255 here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
