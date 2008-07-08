From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/16 v3] ibmvscsi: driver enablement for CMO
Date: Tue, 8 Jul 2008 12:41:15 -0500
Message-ID: <20080708174114.GC21578@linux.vnet.ibm.com>
References: <20080704125631.GR1310@linux.vnet.ibm.com> <4872298D.8050802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36710 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbYGHRl2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 13:41:28 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m68HfRNP029656
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 13:41:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m68HfRLN173042
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 11:41:27 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m68HfQOj005362
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2008 11:41:27 -0600
Content-Disposition: inline
In-Reply-To: <4872298D.8050802@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>, David Darrington <ddarring@linux.vnet.ibm.com>, benh@kernel.crashing.org

* Brian King (brking@linux.vnet.ibm.com) wrote:
> Robert Jennings wrote:
> > @@ -1613,6 +1624,26 @@ static struct scsi_host_template driver_
> >  };
> >  
> >  /**
> > + * ibmvscsi_get_desired_dma - Calculate IO entitlement needed by the driver
> > + *
> > + * @vdev: struct vio_dev for the device whose entitlement is to be returned
> > + *
> > + * Return value:
> > + *	Number of bytes of IO data the driver will need to perform well.
> > + */
> > +static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
> > +{
> > +	/* iu_storage data allocated in initialize_event_pool */
> > +	unsigned long io_entitlement = max_requests * sizeof(union viosrp_iu);
> 
> Since you are removing the use of "entitlement" in the function description,
> you should probably remove it everywhere in this patch.

I'll clean this up.

> > +
> > +	/* add io space for sg data */
> > +	io_entitlement += (IBMVSCSI_MAX_SECTORS_DEFAULT *
> > +	                     IBMVSCSI_CMDS_PER_LUN_DEFAULT);
> > +
> > +	return IOMMU_PAGE_ALIGN(io_entitlement);
> 
> I really think this function should just return the number of bytes and
> let the caller round it up to any boundary requirements it might have.

I agree.  I'll be posting a new patch after a work out another issue I'm
having.  Hope to have that out soon.

--Rob Jennings
