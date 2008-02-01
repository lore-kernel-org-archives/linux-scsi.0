From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Update SCSI documentation for 512 byte sector requirement with
 max_sectors
Date: Thu, 31 Jan 2008 18:46:22 -0800
Message-ID: <20080131184622.9d8a5ccd.randy.dunlap@oracle.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:11864 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYBACxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 21:53:52 -0500
In-Reply-To: <1201831111.11265.192.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

On Thu, 31 Jan 2008 17:58:30 -0800 Nicholas A. Bellinger wrote:

> On Thu, 2008-01-31 at 13:42 -0600, James Bottomley wrote:
> > On Thu, 2008-01-31 at 10:44 -0800, Nicholas A. Bellinger wrote:
> > > > In short, and to repeat: almost every internal size counter to block is
> > > > in units of 512 byte sectors ... that includes capacity, maximum etc ...
> > > > 
> > > 
> > > Ok, after reading your followup with Geert I see that this looks like a
> > > bug in ps3rom.c assuming 2048 byte sectors to calculate .max_sectors
> > > (which was originally set to 32 as I mentioned).  Using the setting
> > > BOUNCE_SIZE << 9 where BOUNCE_SIZE is the request size in bytes looks
> > > like this will solve the issue.  My misunderstanding was
> > > that .max_sectors was allowed to be calcuated in non 512 byte sectors,
> > > so please disregard my patch.
> > > 
> > > Geert, .max_sectors for ps3rom.c using 512 byte sectors ends up being
> > > 128, yes.?
> > > 
> > > James, could we put something in the SCSI docs stating that .max_sectors
> > > MUST be calculated against 512 byte sectors..?
> > 
> > If that "we" is royal, then certainly you're welcome to submit a patch
> > (just get Randy's ack).  However, do take a look at the existing docs
> > first.  Certainly the block layer seems to make this very clear:
> > 
> > /**
> >  * blk_queue_max_sectors - set max sectors for a request for this queue
> >  * @q:  the request queue for the device
> >  * @max_sectors:  max sectors in the usual 512b unit
> >                               ^^^^^^^^^^^^^^^^^^^^^^
> >  *
> >  * Description:
> >  *    Enables a low level driver to set an upper limit on the size of
> >  *    received requests.
> >  **/
> > 
> 
> Agreed, here is the patch to make this clear within SCSI.  Randy, does
> this look OK..?
> 
> Thanks,
> 
> --nab
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> index 6f70f2b..570f271 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -1244,13 +1244,12 @@ of interest:
>      this_id      - scsi id of host (scsi initiator) or -1 if not known
>      sg_tablesize - maximum scatter gather elements allowed by host.
>                     0 implies scatter gather not supported by host
> -    max_sectors  - maximum number of sectors (usually 512 bytes) allowed
> -                   in a single SCSI command. The default value of 0 leads
> -                   to a setting of SCSI_DEFAULT_MAX_SECTORS (defined in
> -                   scsi_host.h) which is currently set to 1024. So for a
> -                   disk the maximum transfer size is 512 KB when max_sectors
> -                   is not defined. Note that this size may not be sufficient
> -                   for disk firmware uploads.
> +    max_sectors  - maximum number of 512 bytes sectors allowed in a single
> +                   SCSI command. The default value of 0 leads to a setting
> +                   of SCSI_DEFAULT_MAX_SECTORS (defined in scsi_host.h) which
> +                   is currently set to 1024. So for a disk the maximum transfer
> +                   size is 512 KB when max_sectors is not defined. Note that
> +                   this size may not be sufficient for disk firmware uploads.
>      cmd_per_lun  - maximum number of commands that can be queued on devices
>                     controlled by the host. Overridden by LLD calls to
>                     scsi_adjust_queue_depth().
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 5c58d59..84098e3 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -372,7 +372,10 @@ struct scsi_host_template {
>         unsigned short sg_tablesize;
>  
>         /*
> -        * If the host adapter has limitations beside segment count
> +        * If the host adapter has limitations beside segment count.
> +        * Note that this value MUST be calculated in 512 byte sectors,
> +        * even if the attached struct scsi_device->sector_size is expected
> +        * to use non 512 byte sectors.

How about:
	   * to use a sector size other than 512 bytes.

and
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


>          */
>         unsigned short max_sectors;

---
~Randy
