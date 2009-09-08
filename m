From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Tue, 08 Sep 2009 17:20:54 -0500
Message-ID: <4AA6D8C6.3040303@cs.wisc.edu>
References: <20090908194135.GA14891@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36247 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZIHWVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 18:21:09 -0400
In-Reply-To: <20090908194135.GA14891@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sfr@canb.auug.org.au

On 09/08/2009 02:41 PM, Jayamohan Kallickal wrote:
> This patch contains fixes to  remove virt_to_* family from the driver.
> It also contains some function name changes to a few low level functions
> to avoid name clash with our net driver.
>
> This patch is a diff on
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be.h       |    2 +-
>   drivers/scsi/be2iscsi/be_cmds.c  |   15 +++++----
>   drivers/scsi/be2iscsi/be_cmds.h  |    6 ++--
>   drivers/scsi/be2iscsi/be_iscsi.c |   62 +++++++++++++++++++++++++++++++++++--
>   drivers/scsi/be2iscsi/be_iscsi.h |    2 +
>   drivers/scsi/be2iscsi/be_main.c  |   58 +++++++++++++++++-----------------
>   drivers/scsi/be2iscsi/be_main.h  |    3 +-
>   7 files changed, 103 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 8c973a2..751721e 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -177,7 +177,7 @@ static inline void swap_dws(void *wrb, int len)
>   #endif /* __BIG_ENDIAN */
>   }
>
> -extern void be_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
> +extern void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
>   		u16 num_popped);
>
>   #endif /* BEISCSI_H */
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index 63afea2..4b92a7b 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -60,7 +60,8 @@ static inline bool is_link_state_evt(u32 trailer)
>   		ASYNC_TRAILER_EVENT_CODE_MASK) == ASYNC_EVENT_CODE_LINK_STATE);
>   }
>
> -void be_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm, u16 num_popped)
> +void beiscsi_cq_notify(struct be_ctrl_info *ctrl, u16 qid, bool arm,
> +							 u16 num_popped)


Looks like you got tab happy.



> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 5a8fa33..a58c704 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -43,6 +43,15 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
>   {
>   	struct Scsi_Host *shost;
>   	struct beiscsi_endpoint *beiscsi_ep;
> +	struct iscsi_cls_session *cls_session;
> +	struct iscsi_session *sess;
> +	struct beiscsi_hba *phba;
> +	struct iscsi_task *task;
> +	struct beiscsi_io_task *io_task;
> +	unsigned int max_size, num_cmd;
> +	dma_addr_t bus_add;
> +	u64 pa_addr;
> +	void *vaddr;
>
>   	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_create\n");
>
> @@ -51,7 +60,8 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
>   		return NULL;
>   	}
>   	beiscsi_ep = ep->dd_data;
> -	shost = beiscsi_ep->phba->shost;
> +	phba = beiscsi_ep->phba;
> +	shost = phba->shost;
>   	if (cmds_max>  beiscsi_ep->phba->params.wrbs_per_cxn) {
>   		shost_printk(KERN_ERR, shost, "Cannot handle %d cmds."
>   			     "Max cmds per session supported is %d. Using %d. "
> @@ -61,9 +71,53 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
>   		cmds_max = beiscsi_ep->phba->params.wrbs_per_cxn;
>   	}
>
> -	return iscsi_session_setup(&beiscsi_iscsi_transport, shost, cmds_max,
> -				   sizeof(struct beiscsi_io_task),
> -				   initial_cmdsn, ISCSI_MAX_TARGET);
> +	 cls_session = iscsi_session_setup(&beiscsi_iscsi_transport,
> +					    shost, cmds_max,
> +					    sizeof(struct beiscsi_io_task),
> +					    initial_cmdsn, ISCSI_MAX_TARGET);
> +	if (!cls_session)
> +		return NULL;
> +	sess = cls_session->dd_data;
> +	max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * sess->cmds_max;
> +	vaddr = pci_alloc_consistent(phba->pcidev,


Do you just want a dma/pci pool? It will align structs for you too, I think.


> +						max_size,
> +						&bus_add);


No need to break this up into multiple lines. Just put it on the same 
line as the as the pci_alloc_consistent.
