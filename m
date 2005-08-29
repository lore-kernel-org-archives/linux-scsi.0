From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 18:25:18 +0100
Message-ID: <20050829172518.GD7875@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com> <20050829171152.GA7875@infradead.org> <431343F2.5060805@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31906 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751145AbVH2RZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:25:21 -0400
Content-Disposition: inline
In-Reply-To: <431343F2.5060805@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, Aug 29, 2005 at 01:20:50PM -0400, Luben Tuikov wrote:
> > What's a scsi_domain_device?  Anyway, we don't need any HCIL tuple for
> > all of the above.  SG_IO is done on a blockdevice node, /dev/sg is done
> > on a chardevice node.  Each of them are attached to a request_queue that's
> > known at the time their ->probe routine is setup - no need for HCIL here
> > _at all_.  There's actually only few userland interfaces that use HCIL
> > addressing:  the scanning through /sys/.../scan (or the old /proc/scsi/scsi
> > variant), using WWNs for FC and SAS here would be much nicer, but there's
> 
> WWNs *must not* be visible _at_all_ to anyone above the SAS layer, in the
> kernel.  That is, the transport addressing method *must not* be visible to
> SCSI Core or anyone above it, in the kernel.

Please read the sentence again.  I said accept them in the scan attribute,
that does _NOT_ mean adding knowledge to the scsi layer.  In fact if you
through the linux-scsi archives about the problems those attributes had
with the FC transport class I suggested moving the parsing of these
attributes into the transport class, which would be the preferred method
to implement this.

