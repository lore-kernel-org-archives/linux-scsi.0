From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] snic: Return error code on memory allocation failure
Date: Wed, 21 Dec 2016 11:31:37 -0500
Message-ID: <1482337897.8200.83.camel@localhost.localdomain>
References: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbcLUQbk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 11:31:40 -0500
In-Reply-To: <1482327953-4140-1-git-send-email-burak-kernel@bur0k.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Burak Ok <burak-kernel@bur0k.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin K Petersen <martin.petersen@oracle.com>, James E J Bottomley <jejb@linux.vnet.ibm.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>, linux-kernel@i4.cs.fau.de, Andreas Schaertl <andreas.schaertl@fau.de>

On Wed, 2016-12-21 at 14:45 +0100, Burak Ok wrote:
> If a call to mempool_create_slab_pool() in snic_probe() returns NULL,
> return -ENOMEM to indicate failure. mempool_creat_slab_pool() only fails if
> it cannot allocate memory.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=189061
> 
> Reported-by: bianpan2010@ruc.edu.cn
> Signed-off-by: Burak Ok <burak-kernel@bur0k.de>
> Signed-off-by: Andreas Schaertl <andreas.schaertl@fau.de>
> ---
>  drivers/scsi/snic/snic_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 396b32d..7cf70aa 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -591,6 +591,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!pool) {
>  		SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
>  
> +		ret = -ENOMEM;
>  		goto err_free_res;
>  	}
>  
> @@ -601,6 +602,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!pool) {
>  		SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
>  
> +		ret = -ENOMEM;
>  		goto err_free_dflt_sgl_pool;
>  	}
>  
> @@ -611,6 +613,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!pool) {
>  		SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
>  
> +		ret = -ENOMEM;
>  		goto err_free_max_sgl_pool;
>  	}
>  

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


