From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/4] scsi: use 64-bit value for 'max_luns'
Date: Tue, 19 Feb 2013 10:30:12 -0600
Message-ID: <26C9F254-62B6-460A-BEB3-BE41516B5186@cs.wisc.edu>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <1361261883-41467-4-git-send-email-hare@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40026 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451Ab3BSQb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 11:31:27 -0500
In-Reply-To: <1361261883-41467-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>


On Feb 19, 2013, at 2:18 AM, Hannes Reinecke <hare@suse.de> wrote:

> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index b44c1cf..95105c0 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -245,7 +245,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
> }
> EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
> 
> -int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun,
> +int cxgbi_hbas_add(struct cxgbi_device *cdev, uint64_t max_lun,
> 		unsigned int max_id, struct scsi_host_template *sht,
> 		struct scsi_transport_template *stt)
> {
> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
> index 80fa99b..d3b27f8 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.h
> +++ b/drivers/scsi/cxgbi/libcxgbi.h
> @@ -692,7 +692,7 @@ struct cxgbi_device *cxgbi_device_register(unsigned int, unsigned int);
> void cxgbi_device_unregister(struct cxgbi_device *);
> void cxgbi_device_unregister_all(unsigned int flag);
> struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
> -int cxgbi_hbas_add(struct cxgbi_device *, unsigned int, unsigned int,
> +int cxgbi_hbas_add(struct cxgbi_device *, uint64_t, unsigned int,
> 			struct scsi_host_template *,
> 			struct scsi_transport_template *);
> void cxgbi_hbas_remove(struct cxgbi_device *);
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index dfe90ce..9acdb9c 100644


Could it be possible to use u64, so it matches the rest of the driver coding style? The rest of the driver uses the u* definitions instead f the uint*_t ones.

I think it could just be edited when the patch is merged instead of having to send a whole new patchset. We can also just fix it up later of the patches get merged as is.