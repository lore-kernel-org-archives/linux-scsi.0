From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] scsi disk: report size without overflow
Date: Fri, 21 Oct 2005 13:46:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
References: <20051020205532.16b65fa7.rdunlap@xenotime.net>
 <1129915249.3440.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:37023 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S965160AbVJUUqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 16:46:52 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2005 13:46:49 -0700
In-Reply-To: <1129915249.3440.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, Dale Blount <linux-kernel@dale.us>

On Fri, 21 Oct 2005, James Bottomley wrote:

> On Thu, 2005-10-20 at 20:55 -0700, Randy.Dunlap wrote:
> > With CONFIG_LBD=n, 'sz' (32 bits) can overflow when capacity is
> > multiplied (even * 2), as seen in a report from Dale Blount
> > on lkml.  Also make sure that 'mb' will not overflow.
> >
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>
> Mathematically, it doesn't look like we need to use 64 bits at all;
> what's wrong with the attached?  It looks like the code once allowed 256
> byte sectors, but the if statement above now forbids them.

What if statement forbids 256-byte sectors?  I don't see it.

	if (sector_size != 512 &&
	    sector_size != 1024 &&
	    sector_size != 2048 &&
	    sector_size != 4096 &&
	    sector_size != 256) {
		printk(KERN_NOTICE "%s : unsupported sector size "
		       "%d.\n", diskname, sector_size);

allows sector_size of 256.

> I'm really not terribly sympathetic to anyone trying Terrabyte discs on
> a non-LBD 32 bit kernel.  The potential for overflow (and consequent
> data loss) is pretty huge.

Yes, I agree with that.

> James
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1253,14 +1253,13 @@ got_data:
>  		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
>  		 */
>  		int hard_sector = sector_size;
> -		sector_t sz = sdkp->capacity * (hard_sector/256);
> +		sector_t sz = sdkp->capacity * (hard_sector/512);
>  		request_queue_t *queue = sdp->request_queue;
> -		sector_t mb;
> +		sector_t mb = sz;
>
>  		blk_queue_hardsect_size(queue, hard_sector);
>  		/* avoid 64-bit division on 32-bit platforms */
> -		mb = sz >> 1;
> -		sector_div(sz, 1250);
> +		sector_div(sz, 625);
>  		mb -= sz - 974;
>  		sector_div(mb, 1950);
>
>
>
>

-- 
~Randy
