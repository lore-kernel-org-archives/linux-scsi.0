From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
 2.6.31-rc1
Date: Tue, 30 Jun 2009 14:45:38 +0000
Message-ID: <1246373138.3816.57.camel@mulgrave.site>
References: <20090629130835.GA3657@mother.pipebreaker.pl>
	 <20090629133431.GM5480@parisc-linux.org>
	 <20090629134602.GN5480@parisc-linux.org>
	 <20090630094046.GE3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43687 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbZF3Opj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 10:45:39 -0400
In-Reply-To: <20090630094046.GE3657@mother.pipebreaker.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Tue, 2009-06-30 at 11:40 +0200, Tomasz Torcz wrote:
> On Mon, Jun 29, 2009 at 07:46:03AM -0600, Matthew Wilcox wrote:
> > > whether it supports 16 byte commands or not.
> > 
> > I should have read the driver more thoroughly before writing that email.
> > 
> > It seems the driver does support larger commands.  Here's the hint:
> > 
> >         hscb->cdb_len = cmd->cmd_len;
> >         if (hscb->cdb_len <= 12) {
> >                 memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len);
> >         } else {
> >                 memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
> >                 scb->flags |= SCB_CDB32_PTR;
> >         }
> > 
> > The aic79xx is a little more tricky ... it seems it has different cases to
> > support 12, 16 and >16 byte CDBs, but it's not clear that the >16 byte CDB case is implemented.  Let's be conservative for now and bump it up to 16 bytes instead of 32.
> > 
> > 
> > diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > index 75b2331..3853f33 100644
> > --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > @@ -1241,6 +1241,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
> >  	host->max_lun = AHD_NUM_LUNS;
> >  	host->max_channel = 0;
> >  	host->sg_tablesize = AHD_NSEG;
> > +	host->max_cmd_len = 16;
> >  	ahd_lock(ahd, &s);
> >  	ahd_set_unit(ahd, ahd_linux_unit++);
> >  	ahd_unlock(ahd, &s);
> > diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > index fd2b978..2d069de 100644
> > --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > @@ -1115,6 +1115,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
> >  	host->max_lun = AHC_NUM_LUNS;
> >  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
> >  	host->sg_tablesize = AHC_NSEG;
> > +	host->max_cmd_len = 32;
> >  	ahc_lock(ahc, &s);
> >  	ahc_set_unit(ahc, ahc_linux_unit++);
> >  	ahc_unlock(ahc, &s);
> 
> 
>   I did a rebuild and driver is not happy with above changes. Take a look
> (I have one RAID5 LUN exported which consist 8x500GB, so about 3.5 TB big):
> 
> csi5 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 2940 Ultra2 SCSI adapter>
>         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 
> scsi 5:0:0:0: Direct-Access     VW       VRU1610          347G PQ: 0 ANSI: 5
> scsi5:A:0:0: Tagged Queuing enabled.  Depth 4
> scsi target5:0:0: Beginning Domain Validation
> scsi target5:0:0: wide asynchronous
> scsi target5:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
> scsi target5:0:0: Domain Validation skipping write tests
> scsi target5:0:0: Ending Domain Validation
> scsi: waiting for bus probes to complete ...
> sd 5:0:0:0: Attached scsi generic sg2 type 0
> (scsi5:A:0:0): No or incomplete CDB sent to device.
> (scsi5:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi5:A:0:0): Abort Tag Message Sent
> (scsi5:A:0:0): SCB 2 - Abort Tag Completed.
> (scsi5:A:0:0): No or incomplete CDB sent to device.
> (scsi5:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi5:A:0:0): Abort Tag Message Sent
> (scsi5:A:0:0): SCB 3 - Abort Tag Completed.
> (scsi5:A:0:0): No or incomplete CDB sent to device.
> (scsi5:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
> (scsi5:A:0:0): Abort Tag Message Sent

That's unfortunate ... it basically means that the untested >12 byte CDB
code path isn't working.

The slight problem is debugging this:  I don't have storage anywhere
approaching 2TB.  However, I might be able to rig the kernel to accept
16byte CDBs for <2TB ... however, I suspect I don't have any drives
which will accept them either.

James


