From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
Date: Tue, 4 Dec 2007 14:46:51 +0100
Message-ID: <200712041446.52249.bzolnier@gmail.com>
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com> <200712012342.52134.bzolnier@gmail.com> <20071203.175212.52162634.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:48749 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbXLDNzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 08:55:20 -0500
Received: by ug-out-1314.google.com with SMTP id z38so77824ugc
        for <linux-scsi@vger.kernel.org>; Tue, 04 Dec 2007 05:55:17 -0800 (PST)
In-Reply-To: <20071203.175212.52162634.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com


Hi,

On Monday 03 December 2007, Kiyoshi Ueda wrote:

[...]

> Thank you for the comments.
> I rebased my patch on top of 2.6.24-rc3-mm2 + the patch to remove
> post_transform_command().
> 
> As a result, one callback function for DMA mode has been removed.
> What do you think about the patch below?
> 
> 
> 
> Subject: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
> 
> 
> This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request
> interfaces.
> 
> In PIO mode, ide-cd (cdrom_newpc_intr()) needs to defer
> end_that_request_last() until the device clears DRQ_STAT and raises
> an interrupt after end_that_request_first().
> So blk_end_request() has to return without completing request
> even if no leftover in the request.
> 
> ide-cd uses blk_end_request_callback() and a dummy callback function,
> which just returns value '1', to tell blk_end_request_callback()
> about that.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Looks good, thanks!

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
