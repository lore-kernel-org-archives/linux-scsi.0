From: "Mike Miller (OS Dev)" <mike.miller@hp.com>
Subject: Re: [PATCH 1/1] cciss: bug fix to prevent cciss from loading in
 kdump crash kernel
Date: Fri, 03 May 2013 13:09:42 -0500
Message-ID: <1367604582.11907.4798.camel@thumper.usa.hp.com>
References: <20130423172539.GA11255@beardog.cce.hp.com>
	 <1367604167.5981.40.camel@dabdike>
Reply-To: mike.miller@hp.com, mikem@beardog.cce.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:24753 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762781Ab3ECSRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 14:17:50 -0400
In-Reply-To: <1367604167.5981.40.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-05-03 at 11:02 -0700, James Bottomley wrote:
> On Tue, 2013-04-23 at 12:25 -0500, Mike Miller wrote:
> > PATCH 1/1
> > 
> > By default the cciss driver supports all "older" HP Smart Array controllers
> > and hpsa supports all controllers starting with the G6 family. There are
> > module parameters that allow a user to override those defaults and use hpsa
> > for any HP Smart Array controller.
> > If the user does override the default behavior and uses hpsa for older
> > controllers it is possible that cciss may try to load in a kdump crash
> > kernel. This may happen if cciss is loaded first from the kdump initrd
> > image. If cciss does load rather than hpsa and reset_devices is true we
> > immediately call cciss_hard_reset_controller. This will result in a kernel
> > panic and the core file cannot be created.
> > This patch prevents cciss from trying to load in this scenario.
> > 
> > Tested with 3.9.0-rc7.
> > 
> > From: Mike <mike.miller@hp.com>
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> > 
> > ---
> >  drivers/block/cciss.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index 1c1b8e5..06c8dba 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -4960,6 +4960,16 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  	ctlr_info_t *h;
> >  	unsigned long flags;
> >  
> > +	/*
> > +	 * By default the cciss driver is used for all older HP Smart Array
> > +	 * controllers. There are module paramaters that allow a user to
> > +	 * override this behavior and instead use the hpsa SCSI driver. If
> > +	 * this is the case cciss may be loaded first from the kdump initrd
> > +	 * image and cause a kernel panic. So if reset_devices is true and
> > +	 * cciss_allow_hpsa is set just bail.
> > +	 */
> > +	if ((reset_devices) && (cciss_allow_hpsa == 1))
> > +		return -ENODEV;
> >  	rc = cciss_init_reset_devices(pdev);
> >  	if (rc) {
> >  		if (rc != -ENOTSUPP)
> 
> Sigh, right change log, incomplete bug fix.
> 
> Can we all agree that this is the right one?
> 
> James

I submitted 2 patches. Below the 2 are combined and make the fix
complete.

-- mikem

> 
> ---
> >From 746ba9f715b9037264ae0b8175c6286f5f8f62d4 Mon Sep 17 00:00:00 2001
> From: Mike Miller <mike.miller@hp.com>
> Date: Thu, 18 Apr 2013 13:49:37 -0500
> Subject: [PATCH] [SCSI] cciss: bug fix to prevent cciss from loading in kdump
>  crash kernel
> 
> By default the cciss driver supports all "older" HP Smart Array controllers
> and hpsa supports all controllers starting with the G6 family. There are
> module parameters that allow a user to override those defaults and use hpsa
> for any HP Smart Array controller.
> If the user does override the default behavior and uses hpsa for older
> controllers it is possible that cciss may try to load in a kdump crash
> kernel. This may happen if cciss is loaded first from the kdump initrd
> image. If cciss does load rather than hpsa and reset_devices is true we
> immediately call cciss_hard_reset_controller. This will result in a kernel
> panic and the core file cannot be created.
> This patch prevents cciss from trying to load in this scenario.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 1c1b8e5..daaab88 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -75,6 +75,12 @@ module_param(cciss_simple_mode, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(cciss_simple_mode,
>  	"Use 'simple mode' rather than 'performant mode'");
>  
> +static int cciss_allow_hpsa;
> +module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(cciss_allow_hpsa,
> +	"Prevent cciss driver from accessing hardware known to be "
> +	" supported by the hpsa driver");
> +
>  static DEFINE_MUTEX(cciss_mutex);
>  static struct proc_dir_entry *proc_cciss;
>  
> @@ -4960,6 +4966,16 @@ static int cciss_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ctlr_info_t *h;
>  	unsigned long flags;
>  
> +	/*
> +	 * By default the cciss driver is used for all older HP Smart Array
> +	 * controllers. There are module paramaters that allow a user to
> +	 * override this behavior and instead use the hpsa SCSI driver. If
> +	 * this is the case cciss may be loaded first from the kdump initrd
> +	 * image and cause a kernel panic. So if reset_devices is true and
> +	 * cciss_allow_hpsa is set just bail.
> +	 */
> +	if ((reset_devices) && (cciss_allow_hpsa == 1))
> +		return -ENODEV;
>  	rc = cciss_init_reset_devices(pdev);
>  	if (rc) {
>  		if (rc != -ENOTSUPP)
> 
> 


