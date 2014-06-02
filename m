From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/6] block: Implement support for copy offload operations
Date: Mon, 02 Jun 2014 13:38:04 -0700
Message-ID: <1401741484.32085.1.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48617 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFBUiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:38:05 -0400
In-Reply-To: <1401335565-29865-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> Many modern SCSI devices support copy offloading operations in which one
> can copy a block range from one LUN to another without the need for data
> to be copied sent to the host and back. This is particularly useful for
> things like cloning LUNs or virtual machine images.
> 
> Implement support for REQ_COPY commands in the block layer:
> 
>  - Add max_copy_sectors queue limits and handle stacking
> 
>  - Expose this parameter in sysfs in bytes (copy_max_bytes)
> 
>  - Add special casing for REQ_COPY in merging and mapping functions
> 
>  - Introduce a bio_copy descriptor hanging off of bio->bi_special. This
>    descriptor contains the source bdev and source sector for the copy
>    operation. Target bdev/sector/size are described by the bio proper.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  Documentation/ABI/testing/sysfs-block |  9 +++++++++
>  block/blk-core.c                      |  5 +++++
>  block/blk-merge.c                     |  7 ++-----
>  block/blk-settings.c                  | 15 +++++++++++++++
>  block/blk-sysfs.c                     | 10 ++++++++++
>  include/linux/bio.h                   | 15 +++++++++++++--
>  include/linux/blk_types.h             | 15 ++++++++++++---
>  include/linux/blkdev.h                | 13 +++++++++++++
>  8 files changed, 79 insertions(+), 10 deletions(-)

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

