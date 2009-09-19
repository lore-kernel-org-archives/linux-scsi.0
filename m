From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] be2iscsi: Moving to pci_pools
Date: Fri, 18 Sep 2009 20:18:05 -0500
Message-ID: <4AB4314D.5060401@cs.wisc.edu>
References: <20090918161822.GA8468@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59336 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbZISBSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 21:18:12 -0400
In-Reply-To: <20090918161822.GA8468@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Jayamohan Kallickal wrote:
>  This patch contains changes to use pci_pools for iscsi hdr
> instead of pci_alloc_consistent. Here we alloc and free to pool
> for every IO
> 

Sorry,  missed some things when you sent this offlist.


> Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c |   52 +++++++++++++++++++------------------
>  drivers/scsi/be2iscsi/be_main.c  |   28 +++++++++++++++++++-
>  drivers/scsi/be2iscsi/be_main.h  |    1 -
>  3 files changed, 53 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index f18e643..62b94a7 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -45,14 +45,9 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
>  	struct beiscsi_endpoint *beiscsi_ep;
>  	struct iscsi_cls_session *cls_session;
>  	struct beiscsi_hba *phba;
> -	struct iscsi_task *task;
>  	struct iscsi_session *sess;
>  	struct beiscsi_session *beiscsi_sess;
>  	struct beiscsi_io_task *io_task;
> -	unsigned int max_size, num_cmd;
> -	dma_addr_t bus_add;
> -	u64 pa_addr;
> -	void *vaddr;
>  
>  	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_create\n");
>  
> @@ -80,20 +75,18 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
>  	if (!cls_session)
>  		return NULL;
>  	sess = cls_session->dd_data;
> -	max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * sess->cmds_max;
> -	vaddr = pci_alloc_consistent(phba->pcidev, max_size, &bus_add);
> -	pa_addr = (__u64) bus_add;
> +	beiscsi_sess = sess->dd_data;
> +	beiscsi_sess->bhs_pool =  pci_pool_create("beiscsi_bhs_pool",
> +						   phba->pcidev,
> +						   sizeof(struct be_cmd_bhs),
> +						   64, 0);
> +	if (!beiscsi_sess->bhs_pool)
> +		goto destroy_sess;
>  
> -	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
> -		task = sess->cmds[num_cmd];
> -		io_task = task->dd_data;
> -		io_task->cmd_bhs = vaddr;
> -		io_task->bhs_pa.u.a64.address = pa_addr;
> -		io_task->alloc_size = max_size;
> -		vaddr += ALIGN(sizeof(struct be_cmd_bhs), 64);
> -		pa_addr += ALIGN(sizeof(struct be_cmd_bhs), 64);
> -	}
>  	return cls_session;
> +destroy_sess:
> +	iscsi_session_teardown(cls_session);
> +	return NULL;
>  }
>  
>  /**
> @@ -107,16 +100,20 @@ void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
>  {
>  	struct iscsi_task *task;
>  	struct beiscsi_io_task *io_task;
> +	unsigned int num_cmd;
>  	struct iscsi_session *sess = cls_session->dd_data;
> -	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
> -	struct beiscsi_hba *phba = iscsi_host_priv(shost);
> +	struct beiscsi_session *beiscsi_sess = sess->dd_data;
>  
> -	task = sess->cmds[0];
> -	io_task = task->dd_data;
> -	pci_free_consistent(phba->pcidev,
> -			    io_task->alloc_size,
> -			    io_task->cmd_bhs,
> -			    io_task->bhs_pa.u.a64.address);
> +	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
> +		task = sess->cmds[num_cmd];
> +		io_task = task->dd_data;
> +		if (io_task->cmd_bhs) {
> +			pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
> +				      io_task->bhs_pa.u.a64.address);
> +			io_task->cmd_bhs = NULL;
> +		}


You should not need this. libiscsi should loop over running task and 
call cleanup task.

Did you hit a leak?



> +	}
> +	pci_pool_destroy(beiscsi_sess->bhs_pool);
>  	iscsi_session_teardown(cls_session);
>  }
>  
> @@ -133,6 +130,8 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
>  	struct iscsi_cls_conn *cls_conn;
>  	struct beiscsi_conn *beiscsi_conn;
>  	struct iscsi_conn *conn;
> +	struct iscsi_session *sess;
> +	struct beiscsi_session *beiscsi_sess;
>  
>  	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
>  		 "from iscsi layer=%d\n", cid);
> @@ -148,6 +147,9 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
>  	beiscsi_conn->ep = NULL;
>  	beiscsi_conn->phba = phba;
>  	beiscsi_conn->conn = conn;
> +	sess = cls_session->dd_data;
> +	beiscsi_sess = sess->dd_data;
> +	beiscsi_conn->beiscsi_sess = beiscsi_sess;
>  	return cls_conn;
>  }
>  
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index d520fe8..c3aeba0 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2880,6 +2880,13 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  	struct hwi_wrb_context *pwrb_context;
>  	struct hwi_controller *phwi_ctrlr;
>  	itt_t itt;
> +	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
> +
> +	io_task->cmd_bhs = pci_pool_alloc(beiscsi_sess->bhs_pool,
> +					  GFP_KERNEL,
> +					  &io_task->bhs_pa.u.a64.address);
> +	if (!io_task->cmd_bhs)
> +		return -ENOMEM;
>  
>  	io_task->pwrb_handle = alloc_wrb_handle(phba,
>  						beiscsi_conn->beiscsi_conn_cid,
> @@ -2901,6 +2908,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  			free_wrb_handle(phba, pwrb_context,
>  						io_task->pwrb_handle);
>  			io_task->pwrb_handle = NULL;
> +			pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
> +				      io_task->bhs_pa.u.a64.address);
> +			io_task->cmd_bhs = NULL;
>  			SE_DEBUG(DBG_LVL_1,
>  				 "Alloc of SGL_ICD Failed \n");
>  			return -ENOMEM;
> @@ -2921,6 +2931,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  					free_wrb_handle(phba, pwrb_context,
>  							io_task->pwrb_handle);
>  					io_task->pwrb_handle = NULL;
> +					pci_pool_free(beiscsi_sess->bhs_pool,
> +						      io_task->cmd_bhs,
> +						      io_task->
> +						      bhs_pa.u.a64.address);
> +					io_task->cmd_bhs = NULL;
>  					SE_DEBUG(DBG_LVL_1, "Alloc of "
>  						"MGMT_SGL_ICD Failed \n");
>  					return -ENOMEM;
> @@ -2943,6 +2958,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
>  				free_wrb_handle(phba, pwrb_context,
>  							io_task->pwrb_handle);
>  				io_task->pwrb_handle = NULL;
> +				pci_pool_free(beiscsi_sess->bhs_pool,
> +					      io_task->cmd_bhs,
> +					      io_task->bhs_pa.u.a64.address);
> +				io_task->cmd_bhs = NULL;
>  				SE_DEBUG(DBG_LVL_1, "Alloc of "
>  					 "MGMT_SGL_ICD Failed \n");
>  				return -ENOMEM;



You probably want to do a goto for the error handler cleanup instead of 
duplicating it so many times.
