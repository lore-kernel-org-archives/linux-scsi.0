From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH] SCSI: remove dev->power.power_state from mesh
 driver
Date: Fri, 23 May 2008 16:53:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805231651440.3106-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0803071118040.4398-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38137 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756372AbYEWUxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 16:53:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803071118040.4398-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Paul Mackerras <paulus@au.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, SCSI development list <linux-scsi@vger.kernel.org>

There hasn't been any comment on the patch below, and it hasn't been 
applied yet.  Do I need to submit it somewhere else?

Alan Stern


On Fri, 7 Mar 2008, Alan Stern wrote:

> power.power_state is scheduled for removal.  This patch (as1055)
> removes all uses of that field from the SCSI mesh driver.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Paul Mackerras <paulus@au.ibm.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/mesh.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/mesh.c
> +++ usb-2.6/drivers/scsi/mesh.c
> @@ -1765,7 +1765,7 @@ static int mesh_suspend(struct macio_dev
>  	default:
>  		return 0;
>  	}
> -	if (mesg.event == mdev->ofdev.dev.power.power_state.event)
> +	if (ms->phase == sleeping)
>  		return 0;
>  
>  	scsi_block_requests(ms->host);
> @@ -1780,8 +1780,6 @@ static int mesh_suspend(struct macio_dev
>  	disable_irq(ms->meshintr);
>  	set_mesh_power(ms, 0);
>  
> -	mdev->ofdev.dev.power.power_state = mesg;
> -
>  	return 0;
>  }
>  
> @@ -1790,7 +1788,7 @@ static int mesh_resume(struct macio_dev 
>  	struct mesh_state *ms = (struct mesh_state *)macio_get_drvdata(mdev);
>  	unsigned long flags;
>  
> -	if (mdev->ofdev.dev.power.power_state.event == PM_EVENT_ON)
> +	if (ms->phase != sleeping)
>  		return 0;
>  
>  	set_mesh_power(ms, 1);
> @@ -1801,8 +1799,6 @@ static int mesh_resume(struct macio_dev 
>  	enable_irq(ms->meshintr);
>  	scsi_unblock_requests(ms->host);
>  
> -	mdev->ofdev.dev.power.power_state.event = PM_EVENT_ON;
> -
>  	return 0;
>  }

