From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2/7 add missing scsi_queue_next_request calls
Date: Tue, 25 Mar 2003 14:41:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E80B0EA.2090908@splentec.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Add missing scsi_queue_next_request calls.
> 
> Add missing scsi_put_command and scsi_get_command exports.

No logistic problem here, except that in the future, those
scattered calls to scsi_queue_next_request() will have to
be centralized and their count will have to be ONE.

(My same opinion as before.)

> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.h put_cmd-25/drivers/scsi/scsi.h
> --- starve-25/drivers/scsi/scsi.h	Mon Mar 24 12:14:28 2003
> +++ put_cmd-25/drivers/scsi/scsi.h	Mon Mar 24 12:14:51 2003
> @@ -417,6 +417,7 @@ extern void scsi_setup_cmd_retry(Scsi_Cm
>  extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
>  			       int block_sectors);
>  extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
> +extern void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd);
>  extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
>  extern void scsi_free_queue(request_queue_t *q);
>  extern int scsi_init_queue(void);
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_error.c put_cmd-25/drivers/scsi/scsi_error.c
> --- starve-25/drivers/scsi/scsi_error.c	Tue Mar 18 12:53:33 2003
> +++ put_cmd-25/drivers/scsi/scsi_error.c	Mon Mar 24 12:14:51 2003
> @@ -1681,6 +1681,7 @@ scsi_reset_provider(struct scsi_device *
>  	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
>  	struct request req;
>  	int rtn;
> +	struct request_queue *q;
>  
>  	scmd->request = &req;
>  	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
> @@ -1735,6 +1736,8 @@ scsi_reset_provider(struct scsi_device *
>  	}
>  
>  	scsi_delete_timer(scmd);
> +	q = scmd->device->request_queue;
>  	scsi_put_command(scmd);
> +	scsi_queue_next_request(q, NULL);
>  	return rtn;
>  }
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_lib.c put_cmd-25/drivers/scsi/scsi_lib.c
> --- starve-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:28 2003
> +++ put_cmd-25/drivers/scsi/scsi_lib.c	Mon Mar 24 12:14:51 2003
> @@ -174,14 +174,18 @@ void scsi_do_req(struct scsi_request *sr
>  		 void (*done)(struct scsi_cmnd *),
>  		 int timeout, int retries)
>  {
> +	struct request_queue *q;
> +
>  	/*
>  	 * If the upper level driver is reusing these things, then
>  	 * we should release the low-level block now.  Another one will
>  	 * be allocated later when this request is getting queued.
>  	 */
>  	if (sreq->sr_command) {
> +		q = sreq->sr_command->device->request_queue;
>  		scsi_put_command(sreq->sr_command);
>  		sreq->sr_command = NULL;
> +		scsi_queue_next_request(q, NULL);
>  	}
>  
>  	/*
> @@ -228,6 +232,7 @@ static void scsi_wait_done(struct scsi_c
>  void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
>  		   unsigned bufflen, int timeout, int retries)
>  {
> +	struct request_queue *q;
>  	DECLARE_COMPLETION(wait);
>  	
>  	sreq->sr_request->waiting = &wait;
> @@ -239,7 +244,9 @@ void scsi_wait_req(struct scsi_request *
>  	sreq->sr_request->waiting = NULL;
>  
>  	if (sreq->sr_command) {
> +		q = sreq->sr_command->device->request_queue;
>  		scsi_put_command(sreq->sr_command);
> +		scsi_queue_next_request(q, NULL);
>  		sreq->sr_command = NULL;
>  	}
>  }
> @@ -351,7 +358,7 @@ void scsi_setup_cmd_retry(struct scsi_cm
>   *		permutations grows as 2**N, and if too many more special cases
>   *		get added, we start to get screwed.
>   */
> -static void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
> +void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev, *sdev2;
>  	struct Scsi_Host *shost;
> diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_syms.c put_cmd-25/drivers/scsi/scsi_syms.c
> --- starve-25/drivers/scsi/scsi_syms.c	Thu Mar  6 12:34:52 2003
> +++ put_cmd-25/drivers/scsi/scsi_syms.c	Mon Mar 24 12:14:51 2003
> @@ -60,6 +60,8 @@ EXPORT_SYMBOL(scsi_allocate_request);
>  EXPORT_SYMBOL(scsi_release_request);
>  EXPORT_SYMBOL(scsi_wait_req);
>  EXPORT_SYMBOL(scsi_do_req);
> +EXPORT_SYMBOL(scsi_get_command);
> +EXPORT_SYMBOL(scsi_put_command);
>  
>  EXPORT_SYMBOL(scsi_report_bus_reset);
>  EXPORT_SYMBOL(scsi_block_requests);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Luben Tuikov, Senior Software Engineer, Splentec Ltd.
Bus: +1-905-707-1954x112, 9-5 EDT. Fax: +1-905-707-1974.

