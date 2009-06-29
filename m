From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 08:56:29 -0600
Message-ID: <20090629145629.GP5480@parisc-linux.org>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <1246285984.3838.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57796 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848AbZF2O40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 10:56:26 -0400
Content-Disposition: inline
In-Reply-To: <1246285984.3838.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-scsi@vger.kernel.org

On Mon, Jun 29, 2009 at 09:33:03AM -0500, James Bottomley wrote:
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1241,6 +1241,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
>  	host->max_lun = AHD_NUM_LUNS;
>  	host->max_channel = 0;
>  	host->sg_tablesize = AHD_NSEG;
> +	host->max_cmd_len = 32;

James and I are discussing this off-list, but 32 is clearly not correct
for aic79xx as the tag number will overwrite the command (or possibly
vice versa).  We're just picking over the various options at the moment.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
