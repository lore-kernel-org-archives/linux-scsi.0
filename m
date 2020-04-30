Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814C7C47247
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B362082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 15:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsr96dhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD3PYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:24:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49259 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgD3PYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 11:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588260276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vgpPKmP45yB4mNwFxINXBvW3ulQDfX4KEAXypxtLIJ8=;
        b=gsr96dhFNo39Cu/PF9kmR02pRuJfvDxPoLXlfGs0JC0kAmcyuYTa2DPYikCYAjdE76ckyn
        QqcR0iqzphvkrp0q/ae4f4BTY/F6Ex/wAON0qJrOfqZtLhZFRGq7pg+tcIfWf1jfErGheq
        AZC9P5w7ffT4jWdzmbI66psezqtt4Ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-OBXdglyYOEe3MB29Pl3Mxw-1; Thu, 30 Apr 2020 11:24:33 -0400
X-MC-Unique: OBXdglyYOEe3MB29Pl3Mxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84753468;
        Thu, 30 Apr 2020 15:24:31 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20E5610013BD;
        Thu, 30 Apr 2020 15:24:21 +0000 (UTC)
Date:   Thu, 30 Apr 2020 23:24:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 07/41] fnic: use reserved commands
Message-ID: <20200430152417.GD1005453@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-8-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-8-hare@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:30PM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Remove hack to get tag for the reset command by using reserved
> commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 147 ++++++++++++++----------------------------
>  1 file changed, 49 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index b60795893994..228729013e21 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -101,7 +101,7 @@ static const char *fnic_fcpio_status_to_str(unsigned int status)
>  	return fcpio_status_str[status];
>  }
>  
> -static void fnic_cleanup_io(struct fnic *fnic, int exclude_id);
> +static void fnic_cleanup_io(struct fnic *fnic);
>  
>  static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
>  					    struct scsi_cmnd *sc)
> @@ -637,7 +637,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
>  	atomic64_inc(&reset_stats->fw_reset_completions);
>  
>  	/* Clean up all outstanding io requests */
> -	fnic_cleanup_io(fnic, SCSI_NO_TAG);
> +	fnic_cleanup_io(fnic);
>  
>  	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
>  	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
> @@ -1359,7 +1359,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
>  	return wq_work_done;
>  }
>  
> -static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
> +static void fnic_cleanup_io(struct fnic *fnic)
>  {
>  	int i;
>  	struct fnic_io_req *io_req;
> @@ -1370,9 +1370,6 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
>  	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
>  
>  	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
> -		if (i == exclude_id)
> -			continue;
> -
>  		io_lock = fnic_io_lock_tag(fnic, i);
>  		spin_lock_irqsave(io_lock, flags);
>  		sc = scsi_host_find_tag(fnic->lport->host, i);
> @@ -2125,9 +2122,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
>   * successfully aborted, 1 otherwise
>   */
>  static int fnic_clean_pending_aborts(struct fnic *fnic,
> -				     struct scsi_cmnd *lr_sc,
> -					 bool new_sc)
> -
> +				     struct scsi_cmnd *lr_sc)
>  {
>  	int tag, abt_tag;
>  	struct fnic_io_req *io_req;
> @@ -2148,7 +2143,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>  		 * ignore this lun reset cmd if issued using new SC
>  		 * or cmds that do not belong to this lun
>  		 */
> -		if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev) {
> +		if (!sc || sc == lr_sc || sc->device != lun_dev) {
>  			spin_unlock_irqrestore(io_lock, flags);
>  			continue;
>  		}
> @@ -2287,38 +2282,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>  	return ret;
>  }
>  
> -/**
> - * fnic_scsi_host_start_tag
> - * Allocates tagid from host's tag list
> - **/
> -static inline int
> -fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
> -{
> -	struct request_queue *q = sc->request->q;
> -	struct request *dummy;
> -
> -	dummy = blk_mq_alloc_request(q, REQ_OP_WRITE, BLK_MQ_REQ_NOWAIT);
> -	if (IS_ERR(dummy))
> -		return SCSI_NO_TAG;
> -
> -	sc->tag = sc->request->tag = dummy->tag;
> -	sc->host_scribble = (unsigned char *)dummy;
> -
> -	return dummy->tag;
> -}
> -
> -/**
> - * fnic_scsi_host_end_tag
> - * frees tag allocated by fnic_scsi_host_start_tag.
> - **/
> -static inline void
> -fnic_scsi_host_end_tag(struct fnic *fnic, struct scsi_cmnd *sc)
> -{
> -	struct request *dummy = (struct request *)sc->host_scribble;
> -
> -	blk_mq_free_request(dummy);
> -}
> -
>  /*
>   * SCSI Eh thread issues a Lun Reset when one or more commands on a LUN
>   * fail to get aborted. It calls driver's eh_device_reset with a SCSI command
> @@ -2335,19 +2298,19 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	spinlock_t *io_lock;
>  	unsigned long flags;
>  	unsigned long start_time = 0;
> +	struct scsi_device *sdev = sc->device;
>  	struct scsi_lun fc_lun;
>  	struct fnic_stats *fnic_stats;
>  	struct reset_stats *reset_stats;
>  	int tag = 0;
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
> -	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
> -	bool new_sc = 0;
> +	struct scsi_cmnd *reset_sc = NULL;
>  
>  	/* Wait for rport to unblock */
>  	fc_block_scsi_eh(sc);
>  
>  	/* Get local-port, check ready and link up */
> -	lp = shost_priv(sc->device->host);
> +	lp = shost_priv(sdev->host);
>  
>  	fnic = lport_priv(lp);
>  	fnic_stats = &fnic->fnic_stats;
> @@ -2355,10 +2318,10 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  
>  	atomic64_inc(&reset_stats->device_resets);
>  
> -	rport = starget_to_rport(scsi_target(sc->device));
> +	rport = starget_to_rport(scsi_target(sdev));
>  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>  		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
> -		      rport->port_id, sc->device->lun, sc);
> +		      rport->port_id, sdev->lun, sc);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up))
>  		goto fnic_device_reset_end;
> @@ -2369,42 +2332,31 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  		goto fnic_device_reset_end;
>  	}
>  
> -	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
> -	/* Allocate tag if not present */
> +	reset_sc = scsi_get_reserved_cmd(sdev, DMA_NONE);

scsi_get_reserved_cmd() returns NULL if .nr_reserved_cmds isn't passed,
so I guess you forget to do that?

Thanks,
Ming

