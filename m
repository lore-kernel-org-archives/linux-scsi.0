From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Mon, 21 Jul 2014 04:29:04 -0700
Message-ID: <20140721112904.GB15455@infradead.org>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaGUL3F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2014 07:29:05 -0400
Content-Disposition: inline
In-Reply-To: <1405931241-92015-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, James Bottomely <jbottomley@parallels.com>

On Mon, Jul 21, 2014 at 10:27:21AM +0200, Hannes Reinecke wrote:
> ZBC drives are close to disk devices, so update sd.c to handle
> ZBC drives correctly.

While the other patches all look fine with me I strongly disagree with
this one.  Devices reporting the ZBC device type must have sequential
required zones, so they are _not_ anywhere close to disk devices,
and writes to them will cause errors that we aren't evenable able to
handle yet.

If it makes some sort of experiment easier for you we can add a way to
force ZBC devices to use sd.c conditionally.  Do you have a test device
that this works with?

