From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] scsi: disable VPD page check on error
Date: Wed, 22 Jun 2016 15:23:49 +0200
Message-ID: <20160622132349.GB6118@lst.de>
References: <1466405868-87720-1-git-send-email-hare@suse.de> <1466405868-87720-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51988 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbcFVNX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:23:59 -0400
Content-Disposition: inline
In-Reply-To: <1466405868-87720-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Jun 20, 2016 at 08:57:47AM +0200, Hannes Reinecke wrote:
> If we encounter an error during initial VPD page scan we should be
> setting the 'skip_vpd_pages' bit to avoid further accesses.
> Any errors during rescan should be ignored, as we might encounter
> temporary I/O errors during rescan.

Looks fine in general, but why disable this for a rescan?  Doing
the check there as well at least doesn't seem harmful, and for the
unlikely case of a botched firmware upgrade it might even be useful.
