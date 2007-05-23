From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 5/7] genhd: send async notification on media change
Date: Wed, 23 May 2007 12:40:43 -0700
Message-ID: <20070523124043.dcbcb1bd.kristen.c.accardi@intel.com>
References: <20070510072247.063476979@intel.com>
	<20070509163835.56ad28e0.kristen.c.accardi@intel.com>
	<20070522141211.fe00333f.akpm@linux-foundation.org>
	<20070523093119.e3a58fcc.kristen.c.accardi@intel.com>
	<1179939835.5569.3.camel@mulgrave.il.steeleye.com>
	<20070523112643.955e1426.kristen.c.accardi@intel.com>
	<1179946311.5569.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbXEWToK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 15:44:10 -0400
In-Reply-To: <1179946311.5569.18.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

On Wed, 23 May 2007 13:51:51 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-05-23 at 11:26 -0700, Kristen Carlson Accardi wrote:
> > On Wed, 23 May 2007 12:03:55 -0500
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > On Wed, 2007-05-23 at 09:31 -0700, Kristen Carlson Accardi wrote:
> > > > On Tue, 22 May 2007 14:12:11 -0700
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > On Wed, 9 May 2007 16:38:35 -0700
> > > > > Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> > > > > 
> > > > > > Send an uevent to user space to indicate that a media change event has occurred.
> > > > > > 
> > > > > > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > > > > > 
> > > > > > Index: 2.6-git/block/genhd.c
> > > > > > ===================================================================
> > > > > > --- 2.6-git.orig/block/genhd.c
> > > > > > +++ 2.6-git/block/genhd.c
> > > > > > @@ -643,6 +643,27 @@ struct seq_operations diskstats_op = {
> > > > > >  	.show	= diskstats_show
> > > > > >  };
> > > > > >  
> > > > > > +static void media_change_notify_thread(struct work_struct *work)
> > > > > > +{
> > > > > > +	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
> > > > > > +	char event[] = "MEDIA_CHANGE=1";
> > > > > > +	char *envp[] = { event, NULL };
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * set enviroment vars to indicate which event this is for
> > > > > > +	 * so that user space will know to go check the media status.
> > > > > > +	 */
> > > > > > +	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
> > > > > > +	put_device(gd->driverfs_dev);
> > > > > > +}
> > > > > > +
> > > > > > +void genhd_media_change_notify(struct gendisk *disk)
> > > > > > +{
> > > > > > +	get_device(disk->driverfs_dev);
> > > > > > +	schedule_work(&disk->async_notify);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL_GPL(genhd_media_change_notify);
> > > > > > +
> > > > > >  struct gendisk *alloc_disk(int minors)
> > > > > >  {
> > > > > >  	return alloc_disk_node(minors, -1);
> > > > > > @@ -672,6 +693,8 @@ struct gendisk *alloc_disk_node(int mino
> > > > > >  		kobj_set_kset_s(disk,block_subsys);
> > > > > >  		kobject_init(&disk->kobj);
> > > > > >  		rand_initialize_disk(disk);
> > > > > > +		INIT_WORK(&disk->async_notify,
> > > > > > +			media_change_notify_thread);
> > > > > >  	}
> > > > > >  	return disk;
> > > > > 
> > > > > Why does this do a schedule_work() rather than calling kobject_uevent_env()
> > > > > directly?
> > > > > 
> > > > 
> > > > Because it is called at Interrupt time.
> > > 
> > > It better not be ... there's two GFP_KERNEL allocations just above this
> > > line in the file.
> > > 
> > > James
> > > 
> > 
> > Where?  We are talking about the call to genhd_media_change_notify().
> > the calling path is this:
> > ahci_host_intr()->ata_scsi_media_change_notify()->genhd_media_change_notify().
> > 
> > I don't see the allocations - are they hidden somewhere?
> 
> Sorry, I thought you were saying alloc_disk_node() could be called from
> interrupt context.
> 
> <gets back on ball>
> 
> If you just want to invoke guaranteed user context from a place in the
> code which *may* be called from interrupt, then
> execute_in_process_context() might be a better way of doing it ... at
> least it avoids setting up a workqueue where none is needed.
> 
> James
> 

That is good to know - although in this particular case we are guaranteed
to always be called from interrupt context since our uevent needs to be
sent in response to an Interrupt received from the disk, so it wouldn't
buy us anything.

Kristen
