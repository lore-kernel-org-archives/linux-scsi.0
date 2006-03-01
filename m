From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 01 Mar 2006 10:17:44 -0600
Message-ID: <1141229864.3276.34.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
	 <20060301152929.GZ4816@suse.de>
	 <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
	 <4405C538.4050709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49802 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751142AbWCAQSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 11:18:04 -0500
In-Reply-To: <4405C538.4050709@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jens Axboe <axboe@suse.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, 2006-03-01 at 11:00 -0500, Douglas Gilbert wrote:
> So the maximum data carrying size of a scatter gather list
> is not deterministic? Is the worst case (page_size * SG_ALL)?

Correct, essentially.  The size is bounded by the number of elements,
but there's no fixed size for those elements unless clustering is
disabled, in which case PAGE_SIZE is the fixed size.  However, in most
machines fragmentation effects will cause a certain amount of
unpredictability in the true size of the request.  And, obviously, for
IOMMU machines, the block layer limits are about the only factor.

However, having users rely on unpredictable effects like physical
merging or the presence of an iommu isn't really best practice, so
practially, the user must assume PAGE_SIZE * SG_ALL (assming the actual
HBA uses SG_ALL, which not all do)

James


