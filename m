From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Thu, 31 Mar 2011 02:32:28 -0400
Message-ID: <20110331063227.GC32336@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
 <20110327223256.GB7487@infradead.org>
 <1301448150.31206.15.camel@dwillia2-linux>
 <20110330072348.GA17919@infradead.org>
 <AANLkTikg4MdRriURN22ztCS7vEpXnQT79pybnCDnyQKo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626Ab1CaGc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 02:32:29 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikg4MdRriURN22ztCS7vEpXnQT79pybnCDnyQKo@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>

On Wed, Mar 30, 2011 at 05:20:24PM -0700, Dan Williams wrote:
> I think we were already on this path, but now just need to formally
> acknowledge and accelerate in this direction.  Let me outline where I
> think we are and a rough outline of how to get to the removal of the
> wrapper.
> 
> 1/ Complete the removal of all OS agnostic indirections in the core.
> We have done quite a bit here to call kernel and lldd facilities
> directly, but still need to get rid of intel_{sas|sata|scsi}.h and
> duplicated utilities before this step is complete.
> 
> 2/ Make the core data structures member position independent (so we
> can start adding / removing fields at will).  That means getting rid
> of unnecessary casting (already started), the base_ structures (you
> started this) and the _{get|set}_association macros.
> 
> 3/ Unify the data structures so they have the same lifetimes.  Where
> the lldd has a member that duplicates a core member teach it to use
> the core version.  Quick example isci_phy.aif and
> scic_sds_phy.sas.identify_address_frame_buffer.
> 
> 4/ Remove the lldd/core data structure distinction.
> 
> Probably missing some sub-steps between three and four, but that is
> the general idea.

Yes, that's about the required stepts.  In general I'd try to do as much
as possible of the data structures before the procedural part, as that's
the design that really matters.
