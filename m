From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 16:23:02 +0200
Message-ID: <20050628142300.GX4410@suse.de>
References: <20050626153941.456543d6.akpm@osdl.org> <1119829031.5038.15.camel@mulgrave> <20050627044647.GA4104@nikolas.hn.org> <1119882142.5175.11.camel@mulgrave> <20050628020858.GA4111@nikolas.hn.org> <1119931541.5573.3.camel@mulgrave> <20050628110209.GA5392@nikolas.hn.org> <20050628120953.GJ4410@suse.de> <1119968301.4997.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:3003 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261806AbVF1OVp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 10:21:45 -0400
Content-Disposition: inline
In-Reply-To: <1119968301.4997.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Nick Orlov <bugfixer@list.ru>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Tue, Jun 28 2005, James Bottomley wrote:
> On Tue, 2005-06-28 at 14:09 +0200, Jens Axboe wrote:
> > > Hard to say. Kernel panics right after the small pause during detection.
> > > And scroll back does not work. I don't really know what it prints before.
> > 
> > Try this variant, fixes the mapping type and kunmap_atomic().
> 
> Actually, I suspect the problem is the BUG_ON(len < 7).  The mode sense
> routines have to be really careful for USB, so we request 4 bytes at
> first to get the true mode length, hence I think this trips.

Sounds plausible, the other bugs wouldn't show up unless Nick is using
highmem (or has it enabled, at least).

-- 
Jens Axboe

