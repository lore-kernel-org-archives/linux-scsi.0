From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 18:11:53 +0100
Message-ID: <20050829171152.GA7875@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11448 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750986AbVH2RL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:11:57 -0400
Content-Disposition: inline
In-Reply-To: <430F6C56.1090801@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Fri, Aug 26, 2005 at 03:24:06PM -0400, Jeff Garzik wrote:
> Luben Tuikov wrote:
> >Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
> >a pointer to struct scsi_domain_device.  If you want, you an send REPORT
> >LUNS and other things to it."
> 
> For the SG_IO ioctl, /dev/sg and request_queue usage, SCSI core must map 
> an address (currently HCIL) into a scsi_domain_device pointer.  These 
> upper layer kernel elements rely on this "SCSI address", and rely on the 
> fact that SCSI core can route from a block device straight to a SCSI 
> LLD, using nothing more than this "SCSI address."

What's a scsi_domain_device?  Anyway, we don't need any HCIL tuple for
all of the above.  SG_IO is done on a blockdevice node, /dev/sg is done
on a chardevice node.  Each of them are attached to a request_queue that's
known at the time their ->probe routine is setup - no need for HCIL here
_at all_.  There's actually only few userland interfaces that use HCIL
addressing:  the scanning through /sys/.../scan (or the old /proc/scsi/scsi
variant), using WWNs for FC and SAS here would be much nicer, but there's
a huge backwards-compatiblity issue - we'll probably have to support the
old variant forever.  Besides that there's probably only SCSI_IOCTL_GET_IDLUN,
which is superceeded by sysfs but probably still has tons of users in
hardware probing, managment utilities and all kinds of userland.

