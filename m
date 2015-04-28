From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 19/23] advansys: Remove cmd_per_lun setting
Date: Tue, 28 Apr 2015 14:15:50 -0700
Message-ID: <1430255750.2181.13.camel@HansenPartnership.com>
References: <1429874322-85488-1-git-send-email-hare@suse.de>
		 <1429874322-85488-21-git-send-email-hare@suse.de>
		 <201504261657.01552.linux@rainbow-software.org>
	 <1430074366.2314.3.camel@HansenPartnership.com> <553DDEFA.4000306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34228 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030935AbbD1VPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2015 17:15:52 -0400
In-Reply-To: <553DDEFA.4000306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, Christoph Hellwig <hch@lst.de>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Mon, 2015-04-27 at 09:02 +0200, Hannes Reinecke wrote:
> On 04/26/2015 08:52 PM, James Bottomley wrote:
> > On Sun, 2015-04-26 at 16:57 +0200, Ondrej Zary wrote:
> >> On Friday 24 April 2015 13:18:38 Hannes Reinecke wrote:
> >>> Ancient, and pretty much obsolete by now.
> >>>
> >>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>> ---
> >>>  drivers/scsi/advansys.c | 18 ------------------
> >>>  1 file changed, 18 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> >>> index 74e5518..5a55272 100644
> >>> --- a/drivers/scsi/advansys.c
> >>> +++ b/drivers/scsi/advansys.c
> >>> @@ -11212,24 +11212,6 @@ static int advansys_board_found(struct Scsi_Host
> >>> *shost, unsigned int iop, }
> >>>
> >>>  	/*
> >>> -	 * Following v1.3.89, 'cmd_per_lun' is no longer needed
> >>> -	 * and should be set to zero.
> >>> -	 *
> >>> -	 * But because of a bug introduced in v1.3.89 if the driver is
> >>> -	 * compiled as a module and 'cmd_per_lun' is zero, the Mid-Level
> >>> -	 * SCSI function 'allocate_device' will panic. To allow the driver
> >>> -	 * to work as a module in these kernels set 'cmd_per_lun' to 1.
> >>> -	 *
> >>> -	 * Note: This is wrong.  cmd_per_lun should be set to the depth
> >>> -	 * you want on untagged devices always.
> >>> -	 #ifdef MODULE
> >>> -	 */
> >>> -	shost->cmd_per_lun = 1;
> >>> -/* #else
> >>> -            shost->cmd_per_lun = 0;
> >>> -#endif */
> >>> -
> >>> -	/*
> >>>  	 * Set the maximum number of scatter-gather elements the
> >>>  	 * adapter can handle.
> >>>  	 */
> >>
> >> This patch breaks my setup: "modprobe advansys" hangs.
> >>
> >> It works when all other patches are applied except this one.
> > 
> > The specific problem is that a cmd_per_lun of zero breaks everything
> > because we use it for the initial queue depth and if you don't actually
> > set it, you get zero (because the template is in static memory).  This
> > should be a global fix that changes the default initial queue depth to 1
> > for the probe phase if it's unset in the template or the host.
> > 
> > Hopefully this should set us up for removing cmd_per_lun.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 60aae01..681a59a 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -280,7 +280,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
> >  				    sdev->host->cmd_per_lun, shost->bqt,
> >  				    shost->hostt->tag_alloc_policy);
> >  	}
> > -	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
> > +	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
> > +					sdev->host->cmd_per_lun : 1);
> >  
> >  	scsi_sysfs_device_initialize(sdev);
> >  
> > 
> > 
> > 
> That fixes it on my side; tested with two devices on the narrow
> board and one on the wide board.
> 
> And while at it I've done a patch to clear up all the now-obsolete
> cmd_per_lun = 1 settings in the various drivers.
> 
> James, will you send a formal patch or should I send it, along with
> the second one to clear up cmd_per_lun?

I suppose I should do it formally first.  After that, it might make
sense for you to send it to me so I don't get the order wrong.

James



