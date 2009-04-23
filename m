From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 8 of 8] libata: Report disk alignment and physical block size
Date: Thu, 23 Apr 2009 07:46:17 -0600
Message-ID: <20090423134617.GO1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <29bae7aef942a1709bb6.1240464575@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60862 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZDWNqT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 09:46:19 -0400
Content-Disposition: inline
In-Reply-To: <29bae7aef942a1709bb6.1240464575@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org


OK, comparing the two ...

On Thu, Apr 23, 2009 at 01:29:35AM -0400, Martin K. Petersen wrote:
>  static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
>  {
> +	struct ata_device *dev = args->dev;
>  	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */

You can drop the 'args->' here and save a pointer dereference.

> +	u8 log_per_phys = 0;
> +	u16 lowest_aligned_lba = 0;
> +	u16 word_106 = dev->id[106];
> +	u16 word_209 = dev->id[209];
> +
> +	if ((word_106 & 0xc000) == 0x4000) {
> +		/* Number and offset of logical sectors per physical sector */
> +		if (word_106 & (1 << 13))
> +			log_per_phys = word_106 & 0xf;
> +		if ((word_209 & 0xc000) == 0x4000)
> +			lowest_aligned_lba =
> +				((1 << log_per_phys) - (word_209 & 0x3fff))
> +				% (1 << log_per_phys);

I found it clearer to do:
			u16 first = word_209 & 0x3fff;
			if (first)
				lowest_aligned = (1 << log_per_phys) - first;

but you may disagree.

> +		rbuf[14] = (lowest_aligned_lba >> 8) & 0x3f;

Hm, yes, it could overflow ... 1 << 0xf -1 is 32767 (0x7fff) which would
be larger than could fit in SCSI's RC16 and ends up inadvertently setting
Thin Provisioning Read Zeroes, which we really don't want.  I suppose
reporting 0x3fff is better than reporting anything else in this field.
All highly theoretical, since you'd have to have 16MB physical sectors
with 512 byte logical sectors to get to this situation.

So I have no objections to this one going in, and please add:

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
