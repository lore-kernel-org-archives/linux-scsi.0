From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 13:39:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210133932.A3870@infradead.org>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:17419 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265896AbUBJNjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 08:39:39 -0500
Content-Disposition: inline
In-Reply-To: <20040210112658.GC4010@tpkurt.garloff.de>; from garloff@suse.de on Tue, Feb 10, 2004 at 12:26:58PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>

On Tue, Feb 10, 2004 at 12:26:58PM +0100, Kurt Garloff wrote:
> +/* sd_index_bits array size / disks
> + * 			32  /    256
> + * 		      4096  /  32768
> + * 		     32768  / 262144
> + */
> +#ifdef CONFIG_EMBEDDED
> +# define SD_DISKS	256
> +#else
> +# define SD_DISKS	32768	// we can raise this to 262144 if needed
> +#endif

Umm, using CONFIG_EMBEDDED doesn't mean no config option - it just mean
another config option which no-one would think of changing the number of
support scsi disks.

Really, any solution that requires huge static allocations is wrong.  The
bitmap either needs to be replaced with a saner algorithm or dynamic
allocation and reallocation on growth.

>  }
>  
> +static int inv_sd_major(int major)
> +{
> +	switch (major) {
> +	case SCSI_DISK0_MAJOR:
> +		return 0;
> +	case SCSI_DISK1_MAJOR ... SCSI_DISK7_MAJOR:
> +		return major + 1 - SCSI_DISK1_MAJOR;
> +	case SCSI_DISK8_MAJOR ... SCSI_DISK15_MAJOR:
> +		return major + 8 - SCSI_DISK8_MAJOR;
> +	default:
> +		BUG();
> +		return 0;	/* shut up gcc */
> +	}
> +}
> +
> +unsigned int dev_to_sd_nr(unsigned int dev) {
> +	return  ((dev >> 4) & 15) | (inv_sd_major(dev >> 20) << 4) |
> +		(dev & 0x3ff00);
> +}
> +unsigned int dev_to_sd_part(unsigned int dev) {
> +	return  (dev & 15) | ((dev >> 14) & 0x30);
> +}
> +

Maybe I missed something but this seems completely unused?

Also please follow the coding style guidelines, that is opening brace
for functions on the next line and non-exported functions always static.

