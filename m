From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.23 and Aic79xx v1.3.0Alpha3 in bitkeeper
Date: Mon, 16 Dec 2002 18:56:59 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216185659.A10346@infradead.org>
References: <200212161746.gBGHkjE03623@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200212161746.gBGHkjE03623@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Dec 16, 2002 at 11:46:45AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Mon, Dec 16, 2002 at 11:46:45AM -0600, James Bottomley wrote:
> I've moved the previous aic7xxx repository to scsi-aic7xxx-old-2.5 and set up 
> a brand new one in its place.  This one should have the import of Justin's 
> actual patch sets, so should be easier for us all to manage.
> 
> The new repository is at
> 
> http://linux-scsi.bkbits.net/scsi-aic7xxx-2.5

>From a first look it seems almost fine.  There's a small problem in
the ->biosparam implementations, and at least a part of that is
probably my fault.

In aic7xxx there is a ahd_linux_biosparam prototype instead of
ahc_linux_biosparam and the actual implementation doesn't use the
sector_div wrapper I sent justing yet, so it probably fails on system
that are configured with 64bit block numbers.  Also my cleanups to
get the ifdef mess down in ->biosparam don't seem to be there, maybe
my style doesn't match Justins (?).

I've seen Justin moved aic_sector_div into the common aiclib.c file,
which seems to be a good idea to me, and I think there's more in the
*_osm.c headers that should go this way.  I think it should become
an module of it's own at least for the kernel tree, even if Adaptec
wants to keep it included in their tarballs.

Now I'll actually try to compile it..
