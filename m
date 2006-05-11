From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Thu, 11 May 2006 11:17:36 -0500
Message-ID: <20060511161736.GB8124@beardog.cca.cpqcorp.net>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net> <20060509124138.43e4bac0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:51677 "EHLO palrel10.hp.com")
	by vger.kernel.org with ESMTP id S1030308AbWEKQRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 12:17:39 -0400
Content-Disposition: inline
In-Reply-To: <20060509124138.43e4bac0.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, aeb@cwi.nl

On Tue, May 09, 2006 at 12:41:38PM -0700, Andrew Morton wrote:
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> >
> > Patch 1/1
> > Sometimes partitions claim to be larger than the reported capacity of a
> > disk device. This patch makes the kernel ignore those partitions.
> > 
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> > Signed-off-by: Stephen Cameron <steve.cameron@hp.com>
> > 
> > Please consider this for inclusion.
> > 
> > 
> >  fs/partitions/check.c |    5 +++++
> >  1 files changed, 5 insertions(+)
> > 
> > --- linux-2.6.14/fs/partitions/check.c~partition_vs_capacity	2006-01-06 09:32:14.000000000 -0600
> > +++ linux-2.6.14-root/fs/partitions/check.c	2006-01-06 11:24:50.000000000 -0600
> > @@ -382,6 +382,11 @@ int rescan_partitions(struct gendisk *di
> >  		sector_t from = state->parts[p].from;
> >  		if (!size)
> >  			continue;
> > +		if (from+size-1 > get_capacity(disk)) {
> > +			printk(" %s: p%d exceeds device capacity, ignoring.\n", 
> > +				disk->disk_name, p);
> > +			continue;
> > +		}
> >  		add_partition(disk, p, from, size);
> >  #ifdef CONFIG_BLK_DEV_MD
> >  		if (state->parts[p].flags)
> 
> Shouldn't that be
> 
> 	if (from+size > get_capacity(disk)) {
> 
> ?
> 
Since the partition size is 0-based this is correct:

	if (from+size-1 > get_capacity(disk)) {

mikem
