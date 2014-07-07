From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
	requests
Date: Mon, 7 Jul 2014 11:24:28 +0200
Message-ID: <20140707092427.GA14476@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-7-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402958B8AD4C@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47184 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaGGJYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 05:24:32 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B8AD4C@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jul 07, 2014 at 12:01:53AM +0000, Elliott, Robert (Server Storage) wrote:
> >  	nr_sectors >>= ilog2(sdp->sector_size) - 9;
> > -	rq->timeout = SD_TIMEOUT;
> > -
> > -	memset(rq->cmd, 0, rq->cmd_len);
> 
> Is *cmd guaranteed to be zero at this point?

Yes, scsi_setup_fs_cmnd takes care of this before calling into the driver.

> With scsi-mq.2 I've seen UNMAP CDBs with garbage in CDB bytes 
> 2 to 5 (which causes a drive that checks reserved fields to
> reject the command), which suggests there is a case in which 
> that is not guaranteed.

Indeed, we only do it up to the actual CDB length, which is due to:

	sd: don't use rq->cmd_len before setting it up

I had to add this because blk-mq doesn't initialize cmd_len, unlike the
old path.

Either we need to merge this series as well to take care of all this,
or I should do a replacement for the above patch that just memsets up to
BLK_MAX_CDB.

> If so, then getting rid of the double memset is another 
> benefit, and removing it from scsi_setup_fs_cmnd would
> be good too.  Since that function is EXPORTED, does that
> prevent removing its memset?

We do need one of the memsets.  With this series I'm keeping the one
in scsi_setup_fs_cmnd so that it's done in one single place, which
seems preferable over having it duplicated in various spots.  At the
end of the series scsi_setup_fs_cmnd ceases to be exported.

