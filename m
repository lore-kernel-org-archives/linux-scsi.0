From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 05/15] be2iscsi: Fix freeing CXN specific driver resources.
Date: Sat, 23 Mar 2013 00:56:23 -0500
Message-ID: <514D4407.8010203@cs.wisc.edu>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com> <1363063186-4902-5-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60687 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab3CWF4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Mar 2013 01:56:34 -0400
In-Reply-To: <1363063186-4902-5-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohank@gmail.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 03/11/2013 11:39 PM, jayamohank@gmail.com wrote:
> From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>
> 
>  Free CXN specific resource held by driver when login redirection
>  or connection retry happens. Login redirection was failing
>  because WRB/SGL were not allocated from the CID on which
>  doorbell was rung.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan.Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c |   15 +++++++++
>  drivers/scsi/be2iscsi/be_main.c  |   68 ++++++++++++++++++++++++++------------
>  drivers/scsi/be2iscsi/be_main.h  |    1 +
>  3 files changed, 62 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 1097fa2..a4eb610 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -990,9 +990,24 @@ static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
>  static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
>  {
>  	struct beiscsi_hba *phba = beiscsi_ep->phba;
> +	struct beiscsi_conn *beiscsi_conn;
>  
>  	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
>  	beiscsi_ep->phba = NULL;
> +
> +	/**
> +	 * Check if any connection resource allocated by driver
> +	 * is to be freed.This case occurs when target redirection
> +	 * or connection retry is done.
> +	 **/
> +	if (!beiscsi_ep->conn)
> +		return;
> +
> +	beiscsi_conn = beiscsi_ep->conn;
> +	if (beiscsi_conn->login_in_progress) {
> +		beiscsi_free_mgmt_task_handles(beiscsi_conn);
> +		beiscsi_conn->login_in_progress = 0;
> +	}
>  }
>  
>  /**
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 72e4052..22882cb 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4066,6 +4066,49 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
>  }
>  
>  /**
> + * beiscsi_free_mgmt_task_handles()- Free driver CXN resources
> + * @beiscsi_conn: ptr to the conn to be cleaned up
> + *
> + * Free driver mgmt resources binded to CXN.
> + **/
> +void
> +beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn)
> +{
> +	struct beiscsi_io_task *io_task;
> +	struct beiscsi_hba *phba = beiscsi_conn->phba;
> +	struct hwi_wrb_context *pwrb_context;
> +	struct hwi_controller *phwi_ctrlr;
> +
> +	phwi_ctrlr = phba->phwi_ctrlr;
> +	pwrb_context = &phwi_ctrlr->wrb_context
> +		       [beiscsi_conn->beiscsi_conn_cid
> +		       - phba->fw_config.iscsi_cid_start];
> +	io_task = beiscsi_conn->task->dd_data;
> +
> +	if (io_task->pwrb_handle) {
> +		memset(io_task->pwrb_handle->pwrb, 0,
> +		       sizeof(struct iscsi_wrb));
> +		free_wrb_handle(phba, pwrb_context,
> +				io_task->pwrb_handle);
> +		io_task->pwrb_handle = NULL;
> +	}
> +
> +	if (io_task->psgl_handle) {
> +		spin_lock(&phba->mgmt_sgl_lock);

I think you need to do the bh locking here. In the beiscsi_free_ep path
the bhs will not be disabled.



