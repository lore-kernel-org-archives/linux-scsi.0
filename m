From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid_sas: Enable shared host tag map
Date: Tue, 25 Nov 2014 20:33:28 +0530
Message-ID: <cd290ec39c368c11217bcb4510c9ac71@mail.gmail.com>
References: <1416843235-35947-1-git-send-email-hare@suse.de>
 <20141124153558.GA27364@lst.de> <547353F2.1040005@suse.de> <20141125143140.GA32570@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:41365 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaKYPDh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 10:03:37 -0500
Received: by mail-la0-f49.google.com with SMTP id hs14so679629lab.8
        for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2014 07:03:29 -0800 (PST)
In-Reply-To: <20141125143140.GA32570@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, Webb Scales <webbnh@hp.com>, Don Brace <don.brace@pmcs.com>, Jens Axboe <axboe@kernel.dk>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Tuesday, November 25, 2014 8:02 PM
> To: Hannes Reinecke
> Cc: James Bottomley; Sumit Saxena; Kashyap Desai; linux-
> scsi@vger.kernel.org; Webb Scales; Don Brace; Jens Axboe
> Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
>
> On Mon, Nov 24, 2014 at 04:51:14PM +0100, Hannes Reinecke wrote:
> > It is useful as is, as we'll be getting prefixed logging output :-)
>
> Use the blk-mq code path if you care :)
>
> > Which I didn't do yet as the driver is using a larger tag map than
> > that one announced to the block layer.
> > This is to facilitate internal command submission, which should always
> > work independent on any tag starvation issues from the upper layers.
>
> This is an "issue" for a lot of drivers.  blk-mq provides a
reserved_tags pool
> for that, which reserves a number of tags for internal use, those must
be
> allocated using blk_mq_alloc_request with the reserved argument set to
> true.
>
> The lockless hpsa patches expose this to SCSI, which I'm generally fine
with,
> but we need to find a way to transparently make this work for the old
code
> path, too.  This might be as simple as embedding a second blk_queue_tag
> structure into the Scsi_Host, adding a constant prefix to the tag and
providing
> some wrappes in scsi that allow allocating a struct request (or rather
> scsi_cmnd) for internal use.

Just trying to understand your above comment. I see host template has new
field called
"reserved_tags" which is normally used by mid layer to reserved block tag
pool for driver's internal use.
What if driver is OK to manage internal pool without any blk tag
dependency and do not expose actual max can queue of what FW can support.
For example, in megaraid_sas driver FW expose max_fw_cmd = 1024 and driver
keep some reserve (let's say 24 commands for internal use) and it just
expose 1000 command for blk tags.  This will work for blk-mq and legacy
blk driver. Let driver to manage whatever internal reserved it kept for
and do not add any dependency with blk tag from above layer for those
reserved pool.

` Kashyap
