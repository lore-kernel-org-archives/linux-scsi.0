Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE8AC47247
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 03:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A43208DB
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 03:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FwtM9eRE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgEBDTe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 23:19:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgEBDTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 23:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588389572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LOxZvtc9ZZEmuqbDmpzJaRw6qpZJ+sCQWYVNRHuFab8=;
        b=FwtM9eREIUW8DegcbJAmfb4BAsJ7UVyxR4Q4eoF3eH3/EJTE5YgynLjelVc6ZjsS/lfDiK
        +ehAqoPdIdiY90BKFJcgIXo0cbt9pO8AfazP7gdudmzhz+yH2F8sGXg/WS33eMnutBBcF9
        //y9/Lk+LDWK2NVUnnrZeVrZ1PTONHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-GKk3LuRRO4yrZ5bTdxK0ZA-1; Fri, 01 May 2020 23:19:30 -0400
X-MC-Unique: GKk3LuRRO4yrZ5bTdxK0ZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4D4A18764D7;
        Sat,  2 May 2020 03:19:28 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE631579A1;
        Sat,  2 May 2020 03:19:21 +0000 (UTC)
Date:   Sat, 2 May 2020 11:19:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 29/41] snic: use reserved commands
Message-ID: <20200502031916.GC1013372@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-30-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-30-hare@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:52PM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Use a reserved command for host and device reset.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/snic/snic.h      |   4 +-
>  drivers/scsi/snic/snic_main.c |   8 +++
>  drivers/scsi/snic/snic_scsi.c | 140 +++++++++++++++++-------------------------
>  3 files changed, 66 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
> index de0ab5fc8474..7dc529ae8a90 100644
> --- a/drivers/scsi/snic/snic.h
> +++ b/drivers/scsi/snic/snic.h
> @@ -59,7 +59,6 @@
>   */
>  #define SNIC_TAG_ABORT		BIT(30)		/* Tag indicating abort */
>  #define SNIC_TAG_DEV_RST	BIT(29)		/* Tag for device reset */
> -#define SNIC_TAG_IOCTL_DEV_RST	BIT(28)		/* Tag for User Device Reset */
>  #define SNIC_TAG_MASK		(BIT(24) - 1)	/* Mask for lookup */
>  #define SNIC_NO_TAG		-1
>  
> @@ -278,6 +277,7 @@ struct snic {
>  
>  	/* Scsi Host info */
>  	struct Scsi_Host *shost;
> +	struct scsi_device *shost_dev;
>  
>  	/* vnic related structures */
>  	struct vnic_dev_bar bar0;
> @@ -380,7 +380,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>  int snic_abort_cmd(struct scsi_cmnd *);
>  int snic_device_reset(struct scsi_cmnd *);
>  int snic_host_reset(struct scsi_cmnd *);
> -int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
> +int snic_reset(struct Scsi_Host *);
>  void snic_shutdown_scsi_cleanup(struct snic *);
>  
>  
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 14f4ce665e58..f520da64ec8e 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -303,6 +303,7 @@ static int
>  snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
>  {
>  	int ret = 0;
> +	struct snic *snic = shost_priv(shost);
>  
>  	ret = scsi_add_host(shost, &pdev->dev);
>  	if (ret) {
> @@ -313,6 +314,12 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
>  		return ret;
>  	}
>  
> +	snic->shost_dev = scsi_get_virtual_dev(shost, 1, 0);
> +	if (!snic->shost_dev) {
> +		SNIC_HOST_ERR(shost,
> +			      "snic: scsi_get_virtual_dev failed\n");
> +		return -ENOMEM;
> +	}
>  	SNIC_BUG_ON(shost->work_q != NULL);
>  	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%d",
>  		 shost->host_no);
> @@ -385,6 +392,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  		goto prob_end;
>  	}
> +	shost->nr_reserved_cmds = 2;

Not see .can_queue is increased by 2 in this patch, please comment on
the reason. Otherwise, IO performance drop may be caused.


Thanks,
Ming

