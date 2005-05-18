From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 15:14:59 +0100
Message-ID: <20050518141459.GA22916@infradead.org>
References: <428B0E4D.50505@suse.de> <20050518140140.GA22570@infradead.org> <428B4BB0.9040306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34021 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262197AbVEROPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 10:15:07 -0400
Content-Disposition: inline
In-Reply-To: <428B4BB0.9040306@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, May 18, 2005 at 04:05:36PM +0200, Hannes Reinecke wrote:
> > If scsi_probe_and_add_lun returns SCSI_SCAN_TARGET_PRESENT sdev isn't valid at
> > this point.  You should probably default to SCSI_2 for that case.
> > 
> How so? This is exactly the behaviour I've removed. sdev is valid even
> for SCSI_SCAN_TARGET_PRESENT.
> If not please show me.

Indeed, you replaced the check at the end of scsi_probe_and_add_lun.  I don't
think it makes a lot of sense to leave around the stale scsi_dev for PQ3, though.

Doing a REPORT_LUNS for SCSI_SCAN_TARGET_PRESENT does OTOH make a lot of sense,
there's nothing in the spec against it.  So what about dropping that device
after we're done with REPORT_LUNS?

