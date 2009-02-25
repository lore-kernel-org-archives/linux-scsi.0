From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2 2.6.29-rc] cxgb3i - add handling of chip reset
Date: Wed, 25 Feb 2009 11:29:43 -0600
Message-ID: <49A58007.20304@cs.wisc.edu>
References: <200902250128.n1P1SJOD007746@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34681 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZBYR3z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 12:29:55 -0500
In-Reply-To: <200902250128.n1P1SJOD007746@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Some other comments about the host and snic allocation.

Karen Xie wrote:
> +/**
> + * cxgb3i_adapter_open - initiate or update a s3 adapter structure and
> + *	any h/w settings
> + * @t3dev: t3cdev adapter
> + */
> +static inline int adapter_update(struct cxgb3i_adapter *snic)


The function name and comment got out of sync.


> -void cxgb3i_adapter_remove(struct t3cdev *t3dev)
> +void cxgb3i_adapter_open(struct t3cdev *t3dev)
>  {
> -	int i;
> -	struct cxgb3i_adapter *snic;
> +	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(t3dev);
> +	int err;
>  
> -	/* remove from the list */
> -	write_lock(&cxgb3i_snic_rwlock);
> -	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
> -		if (snic->tdev == t3dev) {
> -			list_del(&snic->list_head);
> -			break;
> -		}
> +	if (snic)
> +		err = adapter_update(snic);
> +	else {
> +		snic = kzalloc(sizeof(*snic), GFP_KERNEL);
> +		if (snic) {
> +			spin_lock_init(&snic->lock);
> +			snic->tdev = t3dev;
> +			err = adapter_add(snic);
> +		} else
> +			err = -ENOMEM;
>

Does the snic represent the actual card. So if I had a dual ported card, 
I would have one snic and then have multple shosts/cxgb3i_hba for each 
port right?

It seemed strange because cxgb3i_hba_host_add sets the shost's parent to 
the pci device, and we get the pci device from the snic->pdev. And so I 
thought we see a pci device per port, so we would also should have a 
snic per port?

