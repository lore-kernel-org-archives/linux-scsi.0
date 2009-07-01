From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Wed, 1 Jul 2009 08:10:11 +0200
Message-ID: <20090701061011.GG3657@mother.pipebreaker.pl>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org> <20090629134602.GN5480@parisc-linux.org> <20090630094046.GE3657@mother.pipebreaker.pl> <1246376899.3816.60.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 193-34-3-65.chelmnet.pl ([193.34.3.65]:55185 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZGAGKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2009 02:10:09 -0400
Content-Disposition: inline
In-Reply-To: <1246376899.3816.60.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, tomek@pipebreaker.pl

On Tue, Jun 30, 2009 at 03:48:19PM +0000, James Bottomley wrote:
> On Tue, 2009-06-30 at 11:40 +0200, Tomasz Torcz wrote:
> >   I did a rebuild and driver is not happy with above changes. Take a look
> > (I have one RAID5 LUN exported which consist 8x500GB, so about 3.5 TB big):
> 
> Actually, looks like a simple thinko in the aic7xxx core code ... it
> should be indexing of the saved tag not the original tag.  Can you try
> this as a fresh patch?
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index e6f2bb7..56e431e 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -593,7 +593,7 @@ ahc_swap_with_next_hscb(struct ahc_softc *ahc, struct scb *scb)
>  	memcpy(q_hscb, scb->hscb, sizeof(*scb->hscb));
>  	if ((scb->flags & SCB_CDB32_PTR) != 0) {
>  		q_hscb->shared_data.cdb_ptr =
> -		    ahc_htole32(ahc_hscb_busaddr(ahc, q_hscb->tag)
> +		    ahc_htole32(ahc_hscb_busaddr(ahc, saved_tag)
>  			      + offsetof(struct hardware_scb, cdb32));
>  	}
>  	q_hscb->tag = saved_tag;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index fd2b978..2d069de 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1115,6 +1115,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
>  	host->max_lun = AHC_NUM_LUNS;
>  	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
>  	host->sg_tablesize = AHC_NSEG;
> +	host->max_cmd_len = 32;
>  	ahc_lock(ahc, &s);
>  	ahc_set_unit(ahc, ahc_linux_unit++);
>  	ahc_unlock(ahc, &s);


  Still not good:
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:1: Attached scsi generic sg3 type 0
sd 6:0:0:0: [sdc] Spinning up disk...
sd 6:0:0:1: [sdd] Spinning up disk........ready
sd 6:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
(scsi6:A:0:0): No or incomplete CDB sent to device.
(scsi6:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
(scsi6:A:0:0): Abort Tag Message Sent
(scsi6:A:0:0): SCB 2 - Abort Tag Completed.
(scsi6:A:0:0): No or incomplete CDB sent to device.
(scsi6:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
(scsi6:A:0:0): Abort Tag Message Sent
(scsi6:A:0:0): SCB 3 - Abort Tag Completed.


 ... and so on.
 Maybe this HBA is too old? Newest BIOS for it is from year 2000. I've checked
another controller, sym53c8xx driven, it shows 3,5TB briefly before reverting to 2TB,
so array itself is reporting OK.

-- 
Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)

