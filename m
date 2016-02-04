From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver 07/10] mpt3sas: Add support for configurable
 Chain Frame Size
Date: Thu, 4 Feb 2016 16:05:38 +0100
Message-ID: <56B368C2.8080607@redhat.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-8-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453963027-19770-8-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 28.1.2016 07:37, Suganath prabu Subaramani wrote:
> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>
> Added support for configurable Chain Frame Size. Calculate the
> Chain Message Frame size from the IOCMaxChainSegementSize (iocfacts).
> Applicable only for mpt3sas/SAS3.0 HBA's.
>
> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>

Is this done in order to prepare for some future patch, or how  does it work?
I noticed only changes in allocation of (probably larger) fields, but
how is it actually used ?

--tm

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 27 ++++++++++++++++++++++-----
>  drivers/scsi/mpt3sas/mpt3sas_base.h |  8 +++++++-
>  2 files changed, 29 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index a1a3b39..0f623fb 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3248,6 +3248,19 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
>  	/* reply frame size */
>  	ioc->reply_sz = facts->ReplyFrameSize * 4;
>  
> +	/* chain segment size */
> +	if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
> +		if (facts->IOCMaxChainSegmentSize)
> +			ioc->chain_segment_sz =
> +					facts->IOCMaxChainSegmentSize *
> +					MAX_CHAIN_ELEMT_SZ;
> +		else
> +		/* set to 128 bytes size if IOCMaxChainSegmentSize is zero */
> +			ioc->chain_segment_sz = DEFAULT_NUM_FWCHAIN_ELEMTS *
> +						    MAX_CHAIN_ELEMT_SZ;
> +	} else
> +		ioc->chain_segment_sz = ioc->request_sz;
> +
>  	/* calculate the max scatter element size */
>  	sge_size = max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
>  
> @@ -3259,7 +3272,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
>  	ioc->max_sges_in_main_message = max_sge_elements/sge_size;
>  
>  	/* now do the same for a chain buffer */
> -	max_sge_elements = ioc->request_sz - sge_size;
> +	max_sge_elements = ioc->chain_segment_sz - sge_size;
>  	ioc->max_sges_in_chain_message = max_sge_elements/sge_size;
>  
>  	/*
> @@ -3451,7 +3464,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
>  		goto out;
>  	}
>  	ioc->chain_dma_pool = pci_pool_create("chain pool", ioc->pdev,
> -	    ioc->request_sz, 16, 0);
> +	    ioc->chain_segment_sz, 16, 0);
>  	if (!ioc->chain_dma_pool) {
>  		pr_err(MPT3SAS_FMT "chain_dma_pool: pci_pool_create failed\n",
>  			ioc->name);
> @@ -3465,13 +3478,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
>  			ioc->chain_depth = i;
>  			goto chain_done;
>  		}
> -		total_sz += ioc->request_sz;
> +		total_sz += ioc->chain_segment_sz;
>  	}
>   chain_done:
>  	dinitprintk(ioc, pr_info(MPT3SAS_FMT
>  		"chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
> -		ioc->name, ioc->chain_depth, ioc->request_sz,
> -		((ioc->chain_depth *  ioc->request_sz))/1024));
> +		ioc->name, ioc->chain_depth, ioc->chain_segment_sz,
> +		((ioc->chain_depth *  ioc->chain_segment_sz))/1024));
>  
>  	/* initialize hi-priority queue smid's */
>  	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
> @@ -4332,6 +4345,10 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
>  	facts->FWVersion.Word = le32_to_cpu(mpi_reply.FWVersion.Word);
>  	facts->IOCRequestFrameSize =
>  	    le16_to_cpu(mpi_reply.IOCRequestFrameSize);
> +	if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
> +		facts->IOCMaxChainSegmentSize =
> +			le16_to_cpu(mpi_reply.IOCMaxChainSegmentSize);
> +	}
>  	facts->MaxInitiators = le16_to_cpu(mpi_reply.MaxInitiators);
>  	facts->MaxTargets = le16_to_cpu(mpi_reply.MaxTargets);
>  	ioc->shost->max_id = -1;
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 4b52a07..d1fee34 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -129,6 +129,9 @@
>  
>  #define MPT3SAS_INVALID_DEVICE_HANDLE	0xFFFF
>  
> +#define MAX_CHAIN_ELEMT_SZ		16
> +#define DEFAULT_NUM_FWCHAIN_ELEMTS	8
> +
>  /*
>   * reset phases
>   */
> @@ -759,7 +762,7 @@ struct mpt3sas_facts {
>  	u32			IOCCapabilities;
>  	union mpi3_version_union	FWVersion;
>  	u16			IOCRequestFrameSize;
> -	u16			Reserved3;
> +	u16			IOCMaxChainSegmentSize;
>  	u16			MaxInitiators;
>  	u16			MaxTargets;
>  	u16			MaxSasExpanders;
> @@ -906,6 +909,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
>   * @max_sges_in_chain_message: number sg elements per chain
>   * @chains_needed_per_io: max chains per io
>   * @chain_depth: total chains allocated
> + * @chain_segment_sz: gives the max number of
> + *			SGEs accommodate on single chain buffer
>   * @hi_priority_smid:
>   * @hi_priority:
>   * @hi_priority_dma:
> @@ -1113,6 +1118,7 @@ struct MPT3SAS_ADAPTER {
>  	u16		max_sges_in_chain_message;
>  	u16		chains_needed_per_io;
>  	u32		chain_depth;
> +	u16		chain_segment_sz;
>  
>  	/* hi-priority queue */
>  	u16		hi_priority_smid;
