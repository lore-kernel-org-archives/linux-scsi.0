From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: sg: remove disk while doing IO -> WARNING: at
 block/blk-core.c:1080 __blk_put_request
Date: Mon, 5 Jul 2010 17:43:07 +0900
Message-ID: <20100705174252X.fujita.tomonori@lab.ntt.co.jp>
References: <AC1B83CE65082B4DBDDB681ED2F6B2EF866C90@EXHQ.corp.stratus.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51758 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab0GEInY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2010 04:43:24 -0400
In-Reply-To: <AC1B83CE65082B4DBDDB681ED2F6B2EF866C90@EXHQ.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nate.Dailey@stratus.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, dgilbert@interlog.com

On Wed, 30 Jun 2010 08:31:56 -0400
"Dailey, Nate" <Nate.Dailey@stratus.com> wrote:

Thanks for the report.

> I'm not sure what needs to be done to fix this (does sg_finish_rem_req
> just need to null out req->bio, or is some cleanup actually missing?),
> but I'm happy to test out a fix if anyone has any suggestions.

Surely, we leak bio. I reproduced this.

Can you try the following patch?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: fix bio leak with a detached device

After blk_rq_map_user is successful, if we find that a device is
unavailable (was detached), we must call blk_end_request_all to free
bio(s) before blk_rq_unmap_user and blk_put_request.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..d454909 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -729,6 +729,8 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		return k;	/* probably out of space --> ENOMEM */
 	}
 	if (sdp->detached) {
+		if (srp->bio)
+			blk_end_request_all(srp->rq, -EIO);
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
-- 
1.6.5

