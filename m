From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 2/2] Use scsi_devinfo functions to do matching of scsi
 IDs device_handler tables.
Date: Thu, 06 Jan 2011 15:36:22 -0500
Message-ID: <4D2627C6.2040200@redhat.com>
References: <1294345890-6089-1-git-send-email-pjones@redhat.com> <1294345890-6089-2-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1AFUgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 15:36:37 -0500
In-Reply-To: <1294345890-6089-2-git-send-email-pjones@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Chandra Seetharaman <sekharan@us.ibm.com>


>  int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
>  {
> +	int i;
> +
>  	if (get_device_handler(scsi_dh->name))
>  		return -EBUSY;
>  
>  	spin_lock(&list_lock);
> +	scsi_dh->idx = scsi_dh_list_idx++;
>  	list_add(&scsi_dh->list, &scsi_dh_list);
>  	spin_unlock(&list_lock);
> +
> +	for (i = 0; scsi_dh->devlist[i].vendor; i++) {
> +		scsi_dev_info_list_add_keyed(1, /* compatible */

This actually needs to be 0, or else this has the exact same bug I originally
set out to fix.

> +					scsi_dh->devlist[i].vendor,
> +					scsi_dh->devlist[i].model,
> +					NULL,
> +					scsi_dh->idx,
> +					SCSI_DEVINFO_DH);
> +	}
