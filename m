From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/16 v3] ibmvscsi: driver enablement for CMO
Date: Mon, 07 Jul 2008 09:34:53 -0500
Message-ID: <4872298D.8050802@linux.vnet.ibm.com>
References: <20080704125631.GR1310@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38031 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYGGOe7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2008 10:34:59 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m67EYw00000498
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 10:34:58 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m67EYwbY238294
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 10:34:58 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m67EYv8p010969
	for <linux-scsi@vger.kernel.org>; Mon, 7 Jul 2008 10:34:58 -0400
In-Reply-To: <20080704125631.GR1310@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, Santiago Leon <santil@us.ibm.com>, Nathan Fontenot <nfont@austin.ibm.com>, David Darrington <ddarring@linux.vnet.ibm.com>

Robert Jennings wrote:
> @@ -1613,6 +1624,26 @@ static struct scsi_host_template driver_
>  };
>  
>  /**
> + * ibmvscsi_get_desired_dma - Calculate IO entitlement needed by the driver
> + *
> + * @vdev: struct vio_dev for the device whose entitlement is to be returned
> + *
> + * Return value:
> + *	Number of bytes of IO data the driver will need to perform well.
> + */
> +static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
> +{
> +	/* iu_storage data allocated in initialize_event_pool */
> +	unsigned long io_entitlement = max_requests * sizeof(union viosrp_iu);

Since you are removing the use of "entitlement" in the function description,
you should probably remove it everywhere in this patch.

> +
> +	/* add io space for sg data */
> +	io_entitlement += (IBMVSCSI_MAX_SECTORS_DEFAULT *
> +	                     IBMVSCSI_CMDS_PER_LUN_DEFAULT);
> +
> +	return IOMMU_PAGE_ALIGN(io_entitlement);

I really think this function should just return the number of bytes and
let the caller round it up to any boundary requirements it might have.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


