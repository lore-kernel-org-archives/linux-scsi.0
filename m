From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Wed, 16 Dec 2015 01:16:48 +0800
Message-ID: <20151215171647.GF19209@eguan.usersys.redhat.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
 <20151215112057.GC19209@eguan.usersys.redhat.com>
 <CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
 <20151215130631.GD19209@eguan.usersys.redhat.com>
 <20151215233841.522d4bf0@tom-T450>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34825 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbbLORQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 12:16:52 -0500
Received: by mail-ig0-f174.google.com with SMTP id to4so35475326igc.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 09:16:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151215233841.522d4bf0@tom-T450>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Tue, Dec 15, 2015 at 11:38:41PM +0800, Ming Lei wrote:
> On Tue, 15 Dec 2015 21:06:31 +0800
> Eryu Guan <guaneryu@gmail.com> wrote:
> 
> > On Tue, Dec 15, 2015 at 08:06:47PM +0800, Ming Lei wrote:
> > > On Tue, Dec 15, 2015 at 7:20 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> > > > On Fri, Dec 11, 2015 at 07:53:40PM +0800, Eryu Guan wrote:
> > > >> Hi,
> > > >>
> > > >> I saw this kernel BUG_ON on 4.4-rc4 kernel, and this can be reproduced
> > > >> easily on ppc64 host by:
> > > >
> > > > This is still reproducible with 4.4-rc5 kernel.
> > > 
> > > Could you capture the debug log after appyling the attached patch and
> > > the reproduction?
> > 
> > Thanks for looking into this! dmesg shows:
> > 
> > [  686.217682] bio_split: sectors 0, bio_sectors 128, bi_rw 0
> 
> I guess the following patch should fix the issue, and ca369d51b3
> uses OPTIMAL TRANSFER LENGTH to set limits->max_sectors, which
> may be less than one page size.
> 
> I don't understand the idea behind this change, Martin, could
> you explain it a bit?
> 
> ---
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3d22fc3..d66d362 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2889,10 +2889,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 */
>  	if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
> -		rw_max = q->limits.io_opt =
> +		q->limits.io_opt =
>  			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> -	else
> -		rw_max = BLK_DEF_MAX_SECTORS;
> +
> +	rw_max = min_t(unsigned, BLK_DEF_MAX_SECTORS,
> +		       q->limits.max_dev_sectors);
>  
>  	/* Combine with controller limits */
>  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));

I tested this patch and no BUG_ON this time, the debug messages are not
triggered either.

Thanks,
Eryu
