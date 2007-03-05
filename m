From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Mon, 5 Mar 2007 13:02:50 +0000
Message-ID: <20070305130250.GB1312@infradead.org>
References: <A67893E24596534CB03DD02157A7FBF701879048@NAMAIL2.ad.lsil.com> <45E894C5.90101@cs.wisc.edu> <45E89E4E.7080003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414AbXCENC5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2007 08:02:57 -0500
Content-Disposition: inline
In-Reply-To: <45E89E4E.7080003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Fri, Mar 02, 2007 at 03:59:42PM -0600, Mike Christie wrote:
> If scsi_execute_async is going to be limited to what is in mainline
> until I can kill it, then we may not want to merge Boaz's patch and just
> have people convert the code to use blk_get_request, blk_rq_map_kern or
> blk_rq_map_user and blk_execute_rq_nowait.

scsi_execute_async should go away as soon as we're able to fix it's
users and it should not grow additional users.  a struct scatterlist is the
wrong representation for data going down the block layer.
