From: Jens Axboe <axboe@suse.de>
Subject: Re: extracting resid from struct scsi_cmnd
Date: Sun, 28 Nov 2004 10:12:05 +0100
Message-ID: <20041128091201.GA10485@suse.de>
References: <20041127124222.GA1200@abulafia> <20041127154849.GA24460@suse.de> <41A9319F.9070206@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:9622 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261416AbUK1JOI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 04:14:08 -0500
Content-Disposition: inline
In-Reply-To: <41A9319F.9070206@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 28 2004, Douglas Gilbert wrote:
> Jens,
> While on the subject of extracting info from struct scsi_cmnd
> I have noticed that scsi_cmnd::resid doesn't make it into
> sg_io_hdr::resid in the block layer SG_IO implementation.
> "rq->data_len" is put there instead and it invariably has a
> value of 0.
> 
> "struct request" does not have a 'resid' field which is defined
> as the number of bytes requested to be transferred less the actual
> number transferred.

->data_len is that value, after execution of the request. If rq->data_len
== 0 for a SCSI request that with residual bytes, then that's a bug.

-- 
Jens Axboe

