From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Mon, 13 Mar 2017 14:55:33 -0700
Message-ID: <1489442133.23810.24.camel@HansenPartnership.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
         <1489088191.2597.9.camel@sandisk.com>
         <22efc8bd-ae71-14c7-247b-7399bfd28c6d@mellanox.com>
         <1489430936.2658.9.camel@sandisk.com>
         <1489432986.23810.12.camel@HansenPartnership.com>
         <1489437175.2658.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59572 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750812AbdCMVzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 17:55:36 -0400
In-Reply-To: <1489437175.2658.17.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "israelr@mellanox.com" <israelr@mellanox.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

On Mon, 2017-03-13 at 20:33 +0000, Bart Van Assche wrote:
> On Mon, 2017-03-13 at 12:23 -0700, James Bottomley wrote:
> > On Mon, 2017-03-13 at 18:49 +0000, Bart Van Assche wrote:
> > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > index 7bfbcfa7af40..b3bb49d06943 100644
> > > --- a/drivers/scsi/scsi.c
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -602,7 +602,7 @@ EXPORT_SYMBOL(scsi_device_get);
> > >   */
> > >  void scsi_device_put(struct scsi_device *sdev)
> > >  {
> > > -       module_put(sdev->host->hostt->module);
> > > +       module_put(sdev->hostt->module);
> > >         put_device(&sdev->sdev_gendev);
> > >  }
> > >  EXPORT_SYMBOL(scsi_device_put);
> > > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > > index 6f7128f49c30..7134487abbb1 100644
> > > --- a/drivers/scsi/scsi_scan.c
> > > +++ b/drivers/scsi/scsi_scan.c
> > > @@ -227,6 +227,7 @@ static struct scsi_device
> > > *scsi_alloc_sdev(struct
> > > scsi_target *starget,
> > >         sdev->model = scsi_null_device_strs;
> > >         sdev->rev = scsi_null_device_strs;
> > >         sdev->host = shost;
> > > +       sdev->hostt = shost->hostt;
> > >         sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
> > >         sdev->id = starget->id;
> > >         sdev->lun = lun;
> > > diff --git a/include/scsi/scsi_device.h
> > > b/include/scsi/scsi_device.h
> > > index 6f22b39f1b0c..cda620ed5922 100644
> > > --- a/include/scsi/scsi_device.h
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -82,6 +82,7 @@ struct scsi_event {
> > >  
> > >  struct scsi_device {
> > >         struct Scsi_Host *host;
> > > +       struct scsi_host_template *hostt;
> > >         struct request_queue *request_queue;
> > >  
> > 
> > The apparent assumption behind this patch is that sdev->host can be
> > freed but the sdev will still exist?  That shouldn't be correct:
> > the
> > rule for struct devices is that the child always holds the parent
> > and
> > the host is parented (albeit not necessarily directly) to the sdev,
> > so
> > it looks like something has gone wrong if the host had been freed
> > before the sdev.
> 
> Hello James,
> 
> scsi_remove_host() decreases the sdev reference count but does not 
> wait until the sdev release work has finished. This is why the SCSI
> host can already have disappeared before the last scsi_device_put()
> call occurs.

This is true, but I don't see how it can cause the host to be freed
before the sdev.  The memory for struct Scsi_Host is freed in the
shost_gendev release routine, which should be pinned by the parent
traversal from sdev.  So it should not be possible for
 scsi_host_dev_release() to be called before
 scsi_device_dev_release_usercontext() becase the latter has the final
put of the parent device.

James
