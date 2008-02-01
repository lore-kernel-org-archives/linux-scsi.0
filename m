From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Update SCSI documentation for 512 byte sector requirement with
	max_sectors
Date: Thu, 31 Jan 2008 20:38:25 -0800
Message-ID: <1201840705.11265.197.camel@haakon2.linux-iscsi.org>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
	 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
	 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
	 <1201793647.3131.8.camel@localhost.localdomain>
	 <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
	 <1201796764.3131.15.camel@localhost.localdomain>
	 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
	 <1201802031.3131.29.camel@localhost.localdomain>
	 <1201805075.11265.178.camel@haakon2.linux-iscsi.org>
	 <1201808524.3131.46.camel@localhost.localdomain>
	 <1201831111.11265.192.camel@haakon2.linux-iscsi.org>
	 <20080131184622.9d8a5ccd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30275 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751316AbYBAEiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 23:38:55 -0500
In-Reply-To: <20080131184622.9d8a5ccd.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 2008-01-31 at 18:46 -0800, Randy Dunlap wrote:
> > Agreed, here is the patch to make this clear within SCSI.  Randy, does
> > this look OK..?
> > 
> > Thanks,
> > 
> > --nab
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > 
> > diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> > index 6f70f2b..570f271 100644
> > --- a/Documentation/scsi/scsi_mid_low_api.txt
> > +++ b/Documentation/scsi/scsi_mid_low_api.txt
> > @@ -1244,13 +1244,12 @@ of interest:
> >      this_id      - scsi id of host (scsi initiator) or -1 if not known
> >      sg_tablesize - maximum scatter gather elements allowed by host.
> >                     0 implies scatter gather not supported by host
> > -    max_sectors  - maximum number of sectors (usually 512 bytes) allowed
> > -                   in a single SCSI command. The default value of 0 leads
> > -                   to a setting of SCSI_DEFAULT_MAX_SECTORS (defined in
> > -                   scsi_host.h) which is currently set to 1024. So for a
> > -                   disk the maximum transfer size is 512 KB when max_sectors
> > -                   is not defined. Note that this size may not be sufficient
> > -                   for disk firmware uploads.
> > +    max_sectors  - maximum number of 512 bytes sectors allowed in a single
> > +                   SCSI command. The default value of 0 leads to a setting
> > +                   of SCSI_DEFAULT_MAX_SECTORS (defined in scsi_host.h) which
> > +                   is currently set to 1024. So for a disk the maximum transfer
> > +                   size is 512 KB when max_sectors is not defined. Note that
> > +                   this size may not be sufficient for disk firmware uploads.
> >      cmd_per_lun  - maximum number of commands that can be queued on devices
> >                     controlled by the host. Overridden by LLD calls to
> >                     scsi_adjust_queue_depth().
> > diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> > index 5c58d59..84098e3 100644
> > --- a/include/scsi/scsi_host.h
> > +++ b/include/scsi/scsi_host.h
> > @@ -372,7 +372,10 @@ struct scsi_host_template {
> >         unsigned short sg_tablesize;
> >  
> >         /*
> > -        * If the host adapter has limitations beside segment count
> > +        * If the host adapter has limitations beside segment count.
> > +        * Note that this value MUST be calculated in 512 byte sectors,
> > +        * even if the attached struct scsi_device->sector_size is expected
> > +        * to use non 512 byte sectors.
> 
> How about:
> 	   * to use a sector size other than 512 bytes.
> 

Sounds good.

> and
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> 
> >          */
> >         unsigned short max_sectors;
> 

Thanks!

--nab

