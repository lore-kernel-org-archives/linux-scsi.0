From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: 13 Oct 2004 16:37:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097703463.2027.248.camel@mulgrave>
References: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com>	<416D3536.5030501@us.
	ibm.com>	<20041013140439.GI16153@parcelfarce.linux.theplanet.co.uk>
		<416D3ABE.6030107@us.ibm.com> <1097682323.2204.142.camel@mulgrave>
	<416D8815.4010808@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62624 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269860AbUJMVhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 17:37:50 -0400
In-Reply-To: <416D8815.4010808@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dwmw2@infradead.org

On Wed, 2004-10-13 at 14:55, Brian King wrote:
> James Bottomley wrote:
> > How does the attached work for you?
> 
> Not very well. It looks like it blows up in create_buffers() with this patch.
> Since the block size (522) is not a multiple of the host page size, we end up
> decrementing offset to a negative number in create_buffers, which then hits a BUG()
> in set_bh_page. It looks to me like the block layer assumes the device block size
> is a multiple of PAGE_SIZE, in more than one place. Here is the latest backtrace:

OK it seems that we get to bogus block size confusion before we see the
device's zero size.  The least nasty fix seems to be to set a power of
two blocksize as well as zeroing the capacity for this problem.

How does the attached fare?

James

===== drivers/scsi/sd.c 1.160 vs edited =====
--- 1.160/drivers/scsi/sd.c	2004-09-19 11:55:03 -05:00
+++ edited/drivers/scsi/sd.c	2004-10-13 16:29:37 -05:00
@@ -1125,6 +1125,13 @@
 		 * For this reason, we leave the thing in the table.
 		 */
 		sdkp->capacity = 0;
+		/*
+		 * set a bogus sector size so the normal read/write
+		 * logic in the block layer will eventually refuse any
+		 * request on this device without tripping over power
+		 * of two sector size assumptions
+		 */
+		sector_size = 512;
 	}
 	{
 		/*
===== drivers/scsi/scsicam.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsicam.c	2004-06-19 09:45:02 -05:00
+++ edited/drivers/scsi/scsicam.c	2004-10-13 10:38:25 -05:00
@@ -29,10 +29,11 @@
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
 	if (res) {
 		struct block_device *bdev = dev->bd_contains;
-		struct buffer_head *bh = __bread(bdev, 0, block_size(bdev));
-		if (bh) {
-			memcpy(res, bh->b_data + 0x1be, 66);
-			brelse(bh);
+		Sector sect;
+		void *data = read_dev_sector(bdev, 0, &sect);
+		if (data) {
+			memcpy(res, data + 0x1be, 66);
+			put_dev_sector(sect);
 		} else {
 			kfree(res);
 			res = NULL;

