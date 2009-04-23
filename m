From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 4 of 8] sd: Physical block size and alignment support
Date: Thu, 23 Apr 2009 12:37:00 -0400
Message-ID: <20090423163700.GB8350@mars.virtualiron.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <fc4cc94aa1e2612b3489.1240464571@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:49949
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbZDWQjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 12:39:53 -0400
Content-Disposition: inline
In-Reply-To: <fc4cc94aa1e2612b3489.1240464571@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 01:29:31AM -0400, Martin K. Petersen wrote:
> Extract physical block size and lowest aligned LBA from READ
> CAPACITY(16) response and adjust queue parameters.
> 
> Report physical block size and alignment when applicable.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
.. snip ..
> -		if (sdkp->first_scan || old_capacity != sdkp->capacity)
> +		if (sdkp->first_scan || old_capacity != sdkp->capacity) {
>  			sd_printk(KERN_NOTICE, sdkp,
> -				  "%llu %d-byte hardware sectors: (%s/%s)\n",
> +				  "%llu %d-byte logical blocks: (%s/%s)\n",
>  				  (unsigned long long)sdkp->capacity,
>  				  sector_size, cap_str_10, cap_str_2);
> +
> +			if (sdkp->hw_sector_size != sector_size)
> +				sd_printk(KERN_NOTICE, sdkp,
> +					  "%u-byte physical blocks\n",
> +					  sdkp->hw_sector_size);

With the changes in the read_capacity_16 (where you set the
hw_sector_size) this won't be printed (at least on first probe).
Should this be printed irregardless of that?

Another question  - should the Documentation/*.txt have an entry about what a
'logical block', and 'physical block' is vs. 'hardware sector' ?
