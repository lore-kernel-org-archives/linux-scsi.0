From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] mpt3sas: set EEDP-escape-flags for SAS35 devices.
Date: Mon, 24 Oct 2016 16:51:10 +0200
Message-ID: <da4d096f-982c-9692-968a-cbcdc908fb1d@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-9-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57283 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935236AbcJXOvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:51:18 -0400
In-Reply-To: <1476966018-10457-9-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> An UNMAP command on a PI formatted device will leave the Logical Block
> Application Tag and Logical Block Reference Tag as all F's (for those LBAs
> that are unmapped). To avoid IO errors if those LBAs are subsequently read
> before they are written with valid tag fields, the MPI SCSI IO requests
> need to set the EEDPFlags element EEDP Escape Mode field, Bits [7:6]
> appropriately. A value of 2 should be set to disable all PI checks if the
> Logical Block Application Tag is 0xFFFF for PI types 1 and 2.  A value
> of 3 should be set to disable all PI checks if the Logical Block
> Application Tag is 0xFFFF and the Logical Block Reference Tag is
> 0xFFFFFFFF for PI type 3.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index a1c541d..c58f326 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3989,6 +3989,9 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
>
>  	mpi_request_3v->EEDPBlockSize =
>  	    cpu_to_le16(scmd->device->sector_size);
> +
> +	if (ioc->is_gen35_ioc)
> +		eedp_flags |= MPI25_SCSIIO_EEDPFLAGS_APPTAG_DISABLE_MODE;
>  	mpi_request->EEDPFlags = cpu_to_le16(eedp_flags);
>  }
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
