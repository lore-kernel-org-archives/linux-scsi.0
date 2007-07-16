From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 16:43:32 +0200
Message-ID: <20070716144331.GY5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <18075.31515.974905.507754@stoffel.org> <yq1d4ysv35d.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:14122 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759759AbXGPOoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 10:44:13 -0400
Content-Disposition: inline
In-Reply-To: <yq1d4ysv35d.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jul 16 2007, Martin K. Petersen wrote:
> >>>>> "John" == John Stoffel <john@stoffel.org> writes:
> 
> John> Will this help out tape drive performance at all?  I looked
> John> through the patches quickly, esp the AIC7xxx stuff since that's
> John> what I use, but nothing jumped out at me...
> 
> Yes.  Most modern tape drives want a block size of 1MB or higher.
> With the old stack we'd be stuck at 512KB because the sg limitations
> caused us to come just short of 1MB...

Indeed. John, note that the driver changes aren't related to enabling
some hardware feature. Drivers just need to be converted to use the sg
walker helpers instead of doing it manually, then they'll also gain
larger IO support. The SCSI drivers are currently being transitioned to
that seperately, my patchset just contains patches for remaining drivers
(which include non-SCSI ones as well).

The hardware has to support a big number of segments of course, looking
at aic7xxx it seems to be limited at 128. From the comment that looks
like it can be increased though, see AHD_NSEG in
drivers/scsi/aic7xxx/aic79xx_osm.h:

/*
 * Number of SG segments we require.  So long as the S/G segments for
 * a particular transaction are allocated in a physically contiguous
 * manner and are allocated below 4GB, the number of S/G segments is
 * unrestricted.
 */
#define AHD_NSEG 128

-- 
Jens Axboe

