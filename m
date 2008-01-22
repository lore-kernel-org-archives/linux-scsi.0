From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 17:19:30 -0600
Message-ID: <1201043970.30007.6.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	 <1201022985.3210.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801221813540.8693@blonde.site>
	 <1201031028.3210.61.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222009070.16267@blonde.site>
	 <1201039931.3210.96.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222241460.30816@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801222241460.30816@blonde.site>
Sender: linux-ide-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-01-22 at 22:59 +0000, Hugh Dickins wrote:
> On Tue, 22 Jan 2008, James Bottomley wrote:
> > 
> > libsas looks to be OK because it specifically kmallocs a 512 byte buffer
> > which should (for off slab data) be 512 byte aligned.
> 
> I don't remember the various SLAB and SLOB and SLUB rules offhand:
> I'm not sure it's safe to rely on such alignment on all of them ....
> 
> > libata actually
> > has an issue because the usual location for IDENTIFY_DEVICE data is
> > inside a struct ata_device, which is highly unlikely to be correctly
> > aligned.  Fortunately, I think we can only get the bug if we actually
> > cross a page boundary for non contiguous pages in the identify data,
> > which a kernel allocation will never do, so libata should be safe as
> > well.
> 
> .... but this would trump it: yes, we don't need 512-byte alignment
> for this, and it is okay to cross a page boundary, just so long as
> the start of the next page really belongs to our buffer not somebody
> else's.
> 
> There doesn't seem much likelihood of anyone vmalloc'ing the buffer
> in which that IDENTIFY_DEVICE gets done.  Though this discussion
> does make me wonder whether ata_pio_sector ought to have a BUG_ON
> (and yes, a BUG_ON rather than a WARN_ON) against the possibility.

Oh ... never say never.  One of the things the shift we did in SCSI to
the block submission api and elimination of the single map path actually
enables you to send kernel vmalloc areas straight into the storage APIs
(which was previously absolutely forbidden) ... fortunately no-one has
yet.

However, I think you're right we could do with a check in the PIO path
to make sure each sector is physically contiguous ... unfortunately, an
easy alignment check would trip on the IDENTIFY and other kernel
commands, sigh.

James


