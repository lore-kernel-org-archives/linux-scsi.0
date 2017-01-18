From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/17] lpfc: NVME Initiator: Base modifications Part A
Date: Wed, 18 Jan 2017 08:07:46 +0100
Message-ID: <4686b4f0-06ab-d0cc-6630-524f839d6842@suse.de>
References: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46479 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbdARHHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 02:07:49 -0500
In-Reply-To: <587ec2ed.BwM2pzG0hT3uy4dN%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 01/18/2017 02:20 AM, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part A of parts A..F.
> 
> Part A is the bulk of the file list changed by the modifications as
> most mods are small-ish. Changes may be for any aspect below.
> 
> *********
> 
> This set of patches (6 parts) adds base modifications for NVME initiator
> support to the lpfc driver.
> 
> The base modifications consist of:
> - Formal split of SLI3 rings from SLI-4 WQs (sometimes referred to as
>   rings as well) as implementation now widely varies between the two.
> - Addition of configuration modes:
>    SCSI initiator only; NVME initiator only; NVME target only; and
>    SCSI and NVME initiator.
>    The configuration mode drives overall adapter configuration,
>    offloads enabled, and resource splits.
>    NVME support is only available on SLI-4 devices and newer fw.
> - Implements the following based on configuration mode:
>   - Exchange resources are split by protocol; Obviously, if only
>      1 mode, then no split occurs. Default is 50/50. module attribute
>      allows tuning.
>   - Each protocol has it's own set of queues, but share interrupt
>     vectors.
>      SCSI:
>        SLI3 devices have few queues and the original style of queue
>          allocation remains.
>        SLI4 devices piggy back on an "io-channel" concept that
>          eventually needs to merge with scsi-mq/blk-mq support (it is
> 	 underway).  For now, the paradigm continues as it existed
> 	 prior. io channel allocates N msix and N WQs (N=4 default)
> 	 and either round robins or uses cpu # modulo N for scheduling.
> 	 A bunch of module parameters allow the configuration to be
> 	 tuned.
>      NVME (initiator):
>        Allocates an msix per cpu (or whatever pci_alloc_irq_vectors
>          gets)
>        Allocates a WQ per cpu, and maps the WQs to msix on a WQ #
>          modulo msix vector count basis.
>        Module parameters exist to cap/control the config if desired.
>   - Each protocol has its own buffer and dma pools.
> 
> Unfortunately, it was very difficult to break out the above into
> functional patches. A such, they are presented as a 6-patch set to
> keep email size reasonable. All patches in the set must be applied to
> create a functional unit.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h           |  77 ++++++++++++++--
>  drivers/scsi/lpfc/lpfc_attr.h      |   1 +
>  drivers/scsi/lpfc/lpfc_bsg.c       |  37 ++++++--
>  drivers/scsi/lpfc/lpfc_crtn.h      |  44 ++++++++-
>  drivers/scsi/lpfc/lpfc_disc.h      |   1 +
>  drivers/scsi/lpfc/lpfc_els.c       |  56 ++++++++----
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 148 +++++++++++++++++++-----------
>  drivers/scsi/lpfc/lpfc_hw.h        |   5 +-
>  drivers/scsi/lpfc/lpfc_hw4.h       | 183 +++++++++++++++++++++++++++++++++++--
>  drivers/scsi/lpfc/lpfc_logmsg.h    |   4 +
>  drivers/scsi/lpfc/lpfc_mbox.c      |  47 ++++++----
>  drivers/scsi/lpfc/lpfc_mem.c       | 111 ++++++++++++++++------
>  drivers/scsi/lpfc/lpfc_nportdisc.c |   9 +-
>  drivers/scsi/lpfc/lpfc_nvme.h      |  87 ++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_scsi.c      | 140 +++++++++++++++++++---------
>  drivers/scsi/lpfc/lpfc_scsi.h      |  18 ++--
>  drivers/scsi/lpfc/lpfc_sli.h       |  37 ++++++--
>  drivers/scsi/lpfc/lpfc_sli4.h      |  75 +++++++++++----
>  drivers/scsi/lpfc/lpfc_version.h   |   1 +
>  drivers/scsi/lpfc/lpfc_vport.c     |   3 +
>  20 files changed, 854 insertions(+), 230 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_nvme.h
> 
[ .. ]
> @@ -605,7 +610,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
>  }
>  
>  /**
> - * lpfc_sli4_post_scsi_sgl_list - Post blocks of scsi buffer sgls from a list
> + * lpfc_sli4_post_scsi_sgl_list - Psot blocks of scsi buffer sgls from a list
>   * @phba: pointer to lpfc hba data structure.
>   * @post_sblist: pointer to the scsi buffer list.
>   *

Psot?

> @@ -734,7 +739,7 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
>  }
>  
>  /**
> - * lpfc_sli4_repost_scsi_sgl_list - Repost all the allocated scsi buffer sgls
> + * lpfc_sli4_repost_scsi_sgl_list - Repsot all the allocated scsi buffer sgls
>   * @phba: pointer to lpfc hba data structure.
>   *
>   * This routine walks the list of scsi buffers that have been allocated and

Repsot? The reverse of 'Psot'?

[ .. ]
> @@ -1133,7 +1138,7 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
>   *
>   * This routine does the pci dma mapping for scatter-gather list of scsi cmnd
>   * field of @lpfc_cmd for device with SLI-3 interface spec. This routine scans
> - * through sg elements and format the bde. This routine also initializes all
> + * through sg elements and format the bdea. This routine also initializes all
>   * IOCB fields which are dependent on scsi command request buffer.
>   *
>   * Return codes:

bdea?

[ .. ]
> @@ -4997,7 +5006,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
>  	if ((status != IOCB_SUCCESS) ||
>  	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
>  		if (status != IOCB_SUCCESS ||
> -		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
> +			iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
>  			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
>  					 "0727 TMF %s to TGT %d LUN %llu "
>  					 "failed (%d, %d) iocb_flag x%x\n",

Wrong indent.

[ .. ]
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
> index 8cb80da..def0c0a5 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.h
> +++ b/drivers/scsi/lpfc/lpfc_scsi.h
> @@ -135,6 +135,8 @@ struct lpfc_scsi_buf {
>  
>  	uint32_t timeout;
>  
> +	uint16_t flags;  /* TBD convert exch_busy to flags */
> +#define LPFC_SBUF_XBUSY         0x1     /* SLI4 hba reported XB on WCQE cmpl */
>  	uint16_t exch_busy;     /* SLI4 hba reported XB on complete WCQE */
>  	uint16_t status;	/* From IOCB Word 7- ulpStatus */
>  	uint32_t result;	/* From IOCB Word 4. */

I thought I had a patch for that ... lemme see.

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
