From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Fri, 3 Oct 2014 01:47:09 -0700
Message-ID: <20141003084709.GA21274@infradead.org>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
 <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
 <20141002112627.GC17628@infradead.org>
 <542D467E.2020400@redhat.com>
 <20141002130654.GA17051@infradead.org>
 <542D4E58.5000809@redhat.com>
 <20141002131259.GA930@infradead.org>
 <542D5096.9010503@redhat.com>
 <1412256350.6343.18.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJCIrM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 04:47:12 -0400
Content-Disposition: inline
In-Reply-To: <1412256350.6343.18.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 09:25:50AM -0400, James Bottomley wrote:
> OK, so 3.17 should be on sunday giving three days or so to sort this
> out.  If you're happy with blk-mq being disabled so the bug never
> triggers unless the user activates it, doing nothing is my preferred
> outcome ... but that also means no need to backport to stable.  
> 
> If you want a it fixed in 3.17, then we need a patch from you now.
> Ultimately you have to judge the necessity for us, since it's your
> driver.

scsi-mq might be new and not default, but I wouldn't really consider it
"experimental" in the sense that people should expect crashes if they
attach a usb device.

Please consider applying the patch below for 3.17, as there is a cxgb
patch pending anyway:

---
>From 8a42ea1369701960a821b7fa9a3da5c68e7e4366 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 3 Oct 2014 10:45:10 +0200
Subject: uas: disable use of blk-mq I/O path
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The uas driver uses the block layer tag for USB3 stream IDs.  With
blk-mq we can get larger tag numbers that the queue depth, which breaks
this assumption.  A fix is under way for 3.18, but sits on top of
large changes so can't easily be backported.   Set the disable_blk_mq
path so that a uas device can't easily crash the system when using
blk-mq for SCSI.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3f42785..9bfa725 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -970,6 +970,13 @@ static struct scsi_host_template uas_host_template = {
 	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
 	.ordered_tag = 1,
+
+	/*
+	 * The uas drivers expects tags not to be bigger than the maximum
+	 * per-device queue depth, which is not true with the blk-mq tag
+	 * allocator.
+	 */
+	.disable_blk_mq = true,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-- 
1.9.1

