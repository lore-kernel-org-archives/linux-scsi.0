From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Thu, 11 May 2006 16:47:09 -0500
Message-ID: <20060511214709.GA26045@beardog.cca.cpqcorp.net>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net> <20060509124138.43e4bac0.akpm@osdl.org> <20060509224848.GA29754@apps.cwi.nl> <20060511040014.66ea16fc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:22738 "EHLO palrel10.hp.com")
	by vger.kernel.org with ESMTP id S1750785AbWEKVrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 17:47:10 -0400
Content-Disposition: inline
In-Reply-To: <20060511040014.66ea16fc.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 04:00:14AM -0700, Andrew Morton wrote:
> Andries Brouwer <Andries.Brouwer@cwi.nl> wrote:
> >
> > On Tue, May 09, 2006 at 12:41:38PM -0700, Andrew Morton wrote:
> > 
> > > > +		if (from+size-1 > get_capacity(disk)) {
> > > > +			printk(" %s: p%d exceeds device capacity, ignoring.\n", 
> > > > +				disk->disk_name, p);
> > > > +			continue;
> > > > +		}
> > > >  		add_partition(disk, p, from, size);
> > 
> > > Shouldn't that be
> > > 
> > > 	if (from+size > get_capacity(disk)) {
> > > 
> > > ?
> > 
> > Ha, you are awake.
> 
> Opinions differ.
> 
> > Yes, it should.
> > And no "ignoring". And no "continue". E.g.:
> > 
> > 	printk(" %s: warning: p%d exceeds device capacity.\n", ...);
> > 
> 
> So you're saying that after detecting this inconsistency we should proceed
> to use the partition anyway?
> 
> For what reason?

Using the partition will result in io errors when accessing beyond the end
of the device. Most users don't appreciate that. It makes them nervous
about the hw.

mikem
