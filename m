From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] use the cmd_type of a leading request for
	scsi_init_sgtable
Date: Fri, 25 Jan 2008 20:05:55 -0600
Message-ID: <1201313155.3119.100.camel@localhost.localdomain>
References: <20080126095738U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39805 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758872AbYAZCGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 21:06:09 -0500
In-Reply-To: <20080126095738U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp

On Sat, 2008-01-26 at 09:57 +0900, FUJITA Tomonori wrote:
> This is against the scsi-bidi tree.
> 
> We need to use the cmd_type of a leading request for scsi_init_sgtable
> to set up scsi_data_buffer:length of a bidi request properly.
> 
> An alternative approach is setting the cmd_type of a leading request
> and its bidi request (*1). But the block layer and scsi-ml don't
> expect that the leading request and its sub-requests have the
> different command types.
> 
> Note that scsi_debug's XDWRITEREAD_10 support is fine without this
> patch since req->nr_sectors works for it but req->nr_sectors doesn't
> work for everyone.
> 
> (*1)
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12669.html
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] use the cmd_type of a leading request for scsi_init_sgtable
> 
> We need to use the cmd_type of a leading request for scsi_init_sgtable
> to set up scsi_data_buffer:length of its bidi request properly.

This seems to be a very convoluted work around for the fact that we
forgot to set the cmd_type on the subordinate request.

Wouldn't this be a better fix?

James

---

diff --git a/block/bsg.c b/block/bsg.c
index 69b0a9d..8917c51 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -279,6 +279,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 			goto out;
 		}
 		rq->next_rq = next_rq;
+		next_rq->cmd_type = rq->cmd_type;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
 		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);


