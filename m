From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] set supported_mode for lots of llds
Date: Sun, 16 Sep 2007 13:05:57 +0900
Message-ID: <20070915073326R.tomof@acm.org>
References: <20070914223247M.tomof@acm.org>
	<46EC9DDE.2090102@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:43665 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXIPEGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Sep 2007 00:06:16 -0400
In-Reply-To: <46EC9DDE.2090102@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Sat, 15 Sep 2007 23:07:10 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > The majority of llds don't set supported_mode in scsi_host_template so
> > we get:
> > 
> > luce:/sys/class/scsi_host/host0$ cat supported_mode
> > unknown
> > 
> > It's harmless but it would be better to get:
> > 
> > luce:/sys/class/scsi_host/host0$ cat supported_mode
> > Initiator
> 
> Given that this is the /vast/ majority, just set it once as a default 
> value, and let target drivers change the mode if different.

I thought that it's a bit hacky but it should work.


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] set supported_mode to MODE_INITIATOR by default

This sets supported_mode to MODE_INITIATOR if a lld doesn't set
supported_mode in scsi_host_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/hosts.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index adc9559..694015d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -342,6 +342,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+
+	if (!sht->supported_mode)
+		sht->supported_mode = MODE_INITIATOR;
+
 	shost->active_mode = sht->supported_mode;
 
 	if (sht->max_host_blocked)
-- 
1.5.2.4

