From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] wd7000.c - proper fix for boards without sg support
Date: Mon, 05 Nov 2007 18:35:06 +0200
Message-ID: <472F463A.9090806@panasas.com>
References: <47276EB9.7070603@panasas.com> <1194118892.4230.1.camel@localhost.localdomain> <472EDDC9.6020109@panasas.com> <472EE0A4.8080007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9431 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756161AbXKEQfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 11:35:12 -0500
In-Reply-To: <472EE0A4.8080007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Nov 05 2007 at 11:21 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>   - code used to set sg_tablesize to zero for board revision
>     less than 6. This is no longer supported, therefore I
>     use sg_tablesize=1 and open code the sg handling for that case.
>   - Get rid of use of SG_NONE which will be removed soon.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/wd7000.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
> index 03cd44f..b4304ae 100644
> --- a/drivers/scsi/wd7000.c
> +++ b/drivers/scsi/wd7000.c
> @@ -1108,13 +1108,10 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
<snip>

I see it is already applied so you might want to use this one instead

---
>From f7df6bc1477777256b015636a2ba8b1c8677bc4e Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 5 Nov 2007 18:31:51 +0200
Subject: [PATCH] wd7000.c sg breakage do to last commit

  Last merge of this driver reverted an SG fix.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/wd7000.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 4ae2e5c..77f5847 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1127,7 +1127,8 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 		scb->op = 0;
 		if (nseg) {
 			struct scatterlist *sg = scsi_sglist(SCpnt);
-			any2scsi(scb->dataptr, isa_page_to_bus(sg->page) + sg->offset);
+			any2scsi(scb->dataptr,
+			         isa_page_to_bus(sg_page(sg)) + sg->offset);
 		}
 		any2scsi(scb->maxlen, scsi_bufflen(SCpnt));
 	}
-- 
1.5.3.1

