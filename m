From: Jeremy Higdon <jeremy@sgi.com>
Subject: [patch 1/1] sd_dif: problem with verify of type 1 protection information (PI)
Date: Thu, 18 Apr 2013 02:55:23 -0700
Message-ID: <20130418095523.GA73004@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:57813 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966743Ab3DRJzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Apr 2013 05:55:25 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54C588F8052
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2013 02:55:24 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mdr@sgi.com

It appears to me that there is a problem with handling of type 1 protection information.

It is considering a logical block reference tag of 0xffffffff to be an error,
but it is actually valid any time ((lba & 0xffffffff) == 0xffffffff) [for
example, 2TiB-1, 4TiB-1, 6TiB-1, etc.].

I'm going by what's written in 4.18.3 of SBC3, where there doesn't appear
to be any invalid value for the reference tag.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>


 sd_dif.c |    8 --------
 1 file changed, 8 deletions(-)


--- a/drivers/scsi/sd_dif.c	2013-04-14 17:45:16.000000000 -0700
+++ b/drivers/scsi/sd_dif.c	2013-04-18 02:36:27.000000000 -0700
@@ -93,14 +93,6 @@ static int sd_dif_type1_verify(struct bl
 		if (sdt->app_tag == 0xffff)
 			return 0;
 
-		/* Bad ref tag received from disk */
-		if (sdt->ref_tag == 0xffffffff) {
-			printk(KERN_ERR
-			       "%s: bad phys ref tag on sector %lu\n",
-			       bix->disk_name, (unsigned long)sector);
-			return -EIO;
-		}
-
 		if (be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
 			printk(KERN_ERR
 			       "%s: ref tag error on sector %lu (rcvd %u)\n",
