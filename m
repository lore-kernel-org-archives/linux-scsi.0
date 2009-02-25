From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 2/2 2.6.29-rc] cxgb3i - add handling of chip reset
Date: Wed, 25 Feb 2009 10:06:34 -0800
Message-ID: <8A71B368A89016469F72CD08050AD334048CD66E@maui.asicdesigners.com>
References: <200902250128.n1P1SJOD007746@localhost.localdomain> <49A58007.20304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:11899 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZBYSNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 13:13:48 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Wednesday, February 25, 2009 9:30 AM
To: Karen Xie
Cc: open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org;
James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 2/2 2.6.29-rc] cxgb3i - add handling of chip reset

Some other comments about the host and snic allocation.

Karen Xie wrote:
> +/**
> + * cxgb3i_adapter_open - initiate or update a s3 adapter structure
and
> + *	any h/w settings
> + * @t3dev: t3cdev adapter
> + */
> +static inline int adapter_update(struct cxgb3i_adapter *snic)


The function name and comment got out of sync.

[Karen] Thanks, will fix it.


> -void cxgb3i_adapter_remove(struct t3cdev *t3dev)
> +void cxgb3i_adapter_open(struct t3cdev *t3dev)
>  {
> -	int i;
> -	struct cxgb3i_adapter *snic;
> +	struct cxgb3i_adapter *snic =
cxgb3i_adapter_find_by_tdev(t3dev);
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

[Karen] Yes.

It seemed strange because cxgb3i_hba_host_add sets the shost's parent to

the pci device, and we get the pci device from the snic->pdev. And so I 
thought we see a pci device per port, so we would also should have a 
snic per port?

[Karen] Each port/cxgb3i_hba has a pointer point back to the
snic/adapter. So one snic per adapter, each snic contains one or more
ports, each port corresponds to one shost.

