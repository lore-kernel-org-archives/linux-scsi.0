From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 13:37:30 -0700 (PDT)
Message-ID: <20070515.133730.120446537.davem@davemloft.net>
References: <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
	<20070515115748.GA12461@infradead.org>
	<1179248245.3685.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53774
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755200AbXEOUhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2007 16:37:25 -0400
In-Reply-To: <1179248245.3685.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: hch@infradead.org, stefanr@s5r6.in-berlin.de, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Tue, 15 May 2007 12:57:25 -0400

> It might make sense to put it in lib ... however, I don't think many
> architectures have the problems we have ... specifically certain boxes
> can have >1 IOMMU, then you really have to know *which* iommu you're
> programming.

Sparc64 boxes will have this at some point, but what I'm
going to do is simply fill in the dev_archdata properly at
device scan time.

Instead of doing a bus walk up the parent every IOMMU request, why not
cache those results in the dev_archdata?  That seems to make the most
sense.

If there is some probing complexity, catch not-setup dev_archdata at
the IOMMU request, and slow path into a resolver of some sort.
