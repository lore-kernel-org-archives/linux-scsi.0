From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/6] block: Replace bi_integrity with bi_special
Date: Mon, 02 Jun 2014 13:35:42 -0700
Message-ID: <1401741342.32085.0.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43206 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaFBUfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:35:53 -0400
In-Reply-To: <1401335565-29865-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> For commands like REQ_COPY we need a way to pass extra information along
> with each bio. Like integrity metadata this information must be
> available at the bottom of the stack so bi_private does not suffice.
> 
> Rename the existing bi_integrity field to bi_special and make it a union
> so we can have different bio extensions for each class of command.
> 
> We previously used bi_integrity != NULL as a way to identify whether a
> bio had integrity metadata or not. Introduce a REQ_INTEGRITY to be the
> indicator now that bi_special can contain different things.
> 
> In addition, bio_integrity(bio) will now return a pointer to the
> integrity payload (when applicable).
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  Documentation/block/data-integrity.txt | 10 +++++-----
>  block/bio-integrity.c                  | 23 ++++++++++++-----------
>  drivers/scsi/sd_dif.c                  |  8 ++++----
>  include/linux/bio.h                    | 10 +++++++---
>  include/linux/blk_types.h              |  8 ++++++--
>  include/linux/blkdev.h                 |  7 ++-----
>  6 files changed, 36 insertions(+), 30 deletions(-)
> 

Looks fine.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

