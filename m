From: Christoph Hellwig <hch@lst.de>
Subject: Re: command emulation fix
Date: Thu, 19 Jan 2017 21:40:16 +0100
Message-ID: <20170119204016.GA6610@lst.de>
References: <1484412602-11801-1-git-send-email-hch@lst.de> <20170115230723.GB14446@mtj.duckdns.org> <20170116152120.GA16072@lst.de> <20170118191750.GA9171@mtj.duckdns.org> <20170119143551.GA31203@lst.de> <20170119202316.GA25390@mtj.duckdns.org> <20170119202725.GB6403@lst.de> <20170119203458.GC25390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58758 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754251AbdASUkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 15:40:17 -0500
Content-Disposition: inline
In-Reply-To: <20170119203458.GC25390@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 03:34:58PM -0500, Tejun Heo wrote:
> So, unless we allocate one mempool per port, we're gonna have to
> synchronize around its use anyway.  mempool can't guarantee allocation
> to multiple users at the same time.  If this is something which
> affects scalability, I'm completley fine with making it per-port (or
> device).  Each ata_port carries 512 byte buffer anyway.  Maybe we can
> reuse that?

I'll play around with these things a bit more.  For the slow
path ops I think I can get away without any dynamic allocation
at all - just use small on-stack buffers.

For DSM / Write Same we rewrite into the buffer the SCSI layer
provided us.  This is a bit of an issue anyway as this might
modify user data that is not expected to be rewritten or even
mapped read-only.  Maybe we need to kill off that emulation
entirely and just have ATA DSM using the ATA_16 CDB as another
provisioning option in sd.c.  While that is a bit of a layering
violation it would solve a lot of problems with the way TRIM
is currently implemented.
