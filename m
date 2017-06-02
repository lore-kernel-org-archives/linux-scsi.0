From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 09/12] Make scsi_mq_prep_fn() call
        scsi_init_command()
Date: Fri, 2 Jun 2017 09:22:27 +0200
Message-ID: <20170602072227.GH560@lst.de>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com> <20170601232711.29062-10-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51499 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdFBHW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jun 2017 03:22:28 -0400
Content-Disposition: inline
In-Reply-To: <20170601232711.29062-10-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

I like this idea, but..

> -void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
> +void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd,
> +		       struct scsi_data_buffer *prot_sdb)
>  {
>  	void *buf = cmd->sense_buffer;
> -	void *prot = cmd->prot_sdb;
>  	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
>  
>  	/* zero out the cmd, except for the embedded scsi_request */
> @@ -1164,7 +1164,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>  
>  	cmd->device = dev;
>  	cmd->sense_buffer = buf;
> -	cmd->prot_sdb = prot;
> +	cmd->prot_sdb = prot_sdb;

What would be the problem of always preserving the original prot_sdb
value instead of passing it by argument?  You;d just need to initialize
it in scsi_init_request when the command is allocated.
