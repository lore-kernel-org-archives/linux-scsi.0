From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/1] Fusion SAS and Fibre Channel: target missing after resetting external raid
Date: Thu, 20 Mar 2008 16:46:57 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70DB4B84@NAMAIL4.ad.lsil.com>
References: <47D98654.1030708@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43685 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbYCTWrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 18:47:06 -0400
Content-class: urn:content-classes:message
In-reply-to: <47D98654.1030708@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>

On Thursday, March 13, 2008 1:54 PM,  Michael Reed wrote:
> Adjusting the patch to reflect Eric's comments.  The change WRT
> max_id is from Hannes.  FC should also be subject to the same issue.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> --- gitu/drivers/message/fusion/mptfc.c	2008-01-24 
> 14:58:37.000000000 -0800
> +++ git/drivers/message/fusion/mptfc.c	2008-03-13 
> 12:37:52.176015612 -0700
> @@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const 
>  	sh->max_id = ioc->pfacts->MaxDevices;
>  	sh->max_lun = max_lun;
>  
> -	sh->this_id = ioc->pfacts[0].PortSCSIID;
> -
>  	/* Required entry.
>  	 */
>  	sh->unique_id = ioc->id;
> --- gitu/drivers/message/fusion/mptsas.c	2008-03-10 
> 13:23:46.000000000 -0700
> +++ git/drivers/message/fusion/mptsas.c	2008-03-13 
> 12:38:01.912440308 -0700
> @@ -3181,8 +3181,6 @@ mptsas_probe(struct pci_dev *pdev, const
>  
>  	sh->transportt = mptsas_transport_template;
>  
> -	sh->this_id = ioc->pfacts[0].PortSCSIID;
> -
>  	/* Required entry.
>  	 */
>  	sh->unique_id = ioc->id;
> --- gitu/drivers/message/fusion/mptscsih.c	2008-03-10 
> 13:20:30.000000000 -0700
> +++ git/drivers/message/fusion/mptscsih.c	2008-03-13 
> 12:38:38.070017332 -0700
> @@ -2442,12 +2442,6 @@ mptscsih_slave_configure(struct scsi_dev
>  		    ioc->name, sdev->sdtr, sdev->wdtr,
>  		    sdev->ppr, sdev->inquiry_len));
>  
> -	if (sdev->id > sh->max_id) {
> -		/* error case, should never happen */
> -		scsi_adjust_queue_depth(sdev, 0, 1);
> -		goto slave_configure_exit;
> -	}
> -
>  	vdevice->configured_lun = 1;
>  	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
>  
> @@ -2461,8 +2455,6 @@ mptscsih_slave_configure(struct scsi_dev
>  		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
>  		    vtarget->minSyncFactor));
>  
> -slave_configure_exit:
> -
>  	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>  		"tagged %d, simple %d, ordered %d\n",
>  		ioc->name,sdev->tagged_supported, sdev->simple_tags,
>

ACK 
