From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 18:16:29 +0100
Message-ID: <20050829171629.GB7875@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5312 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751123AbVH2RQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:16:30 -0400
Content-Disposition: inline
In-Reply-To: <430F398A.30200@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Fri, Aug 26, 2005 at 11:47:22AM -0400, Luben Tuikov wrote:
> Do you think it would be beneficial to revisit struct
> scsi_target to something like struct scsi_domain_device and
> have a kobject in it.  Then the FC/SAS/iSCSI/USB layer upon finding
> a domain device, they call a suitable function which allocates them
> struct scsi_domain_device, which sets the "release" method for the
> kobject embedded.  Then they call SCSI Core to register the domain device.
> (All in all, the transport layer may also do kobject_get.)
> SCSI Core does kobject_register (thus kobject_get) and starts
> doing LU discovery for the device (all through the pointer to struct
> scsi_domain_device), and thus the LUs are discovered and struct
> scsi_device is created for each one.

No need to do silly renaming, but yes, moving creating of scsi_target
structures to the transport does make sense.  It's kinda implicit
in the todo list I posted.  I also don't really see the point of
the embedded kobject.

> Yeah, that sounds cool.  In effect, all you'll have is a struct list_head
> of LUs, and that list_head would live in the struct scsi_domain_device.

We actually already have a list in the scsi_target that chains of the
scsi_device, .devices in scsi_target and .same_target_siblings in scsi_device.
We just need to use it everywhere.

> >  (4) eventually move the traditional scsi_scan_target and other functions
> >      that lookup a scsi_target based on ->id into the spi transport class
> 
> Even simpler: the transport layer, calls SCSI Core, saying: "Hey here is
> a pointer to struct scsi_domain_device.  If you want, you an send REPORT
> LUNS and other things to it."

Yes. that's what I ment with my item (3) (sorry, I hate all this
techno-babble, simple language is much easier to understand normally)

