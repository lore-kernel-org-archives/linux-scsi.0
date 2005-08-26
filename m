From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: regression w/ qla2300 - oopses..
Date: Fri, 26 Aug 2005 17:13:56 -0500
Message-ID: <1125094436.5079.122.camel@mulgrave>
References: <20050826212934.GO22165@mea-ext.zmailer.org>
	 <1125092648.5079.110.camel@mulgrave>
	 <20050826145239.6032a509.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30697 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751591AbVHZWOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 18:14:11 -0400
In-Reply-To: <20050826145239.6032a509.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: matti.aarnio@zmailer.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Fri, 2005-08-26 at 14:52 -0700, Andrew Morton wrote:
> Is there not some nasty little hack we can do to make the crash go away in
> the interim?

Well, it's nasty.  The problem is that klist_next() refers to the
previous element to get the next one.  However, this previous element
has just been removed and freed.  We could try to open code the
necessary gets and puts in next_device().

Could someone check the attached, I think it's the correct open coding?

James

diff --git a/drivers/base/core.c b/drivers/base/core.c
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -369,8 +369,20 @@ void device_unregister(struct device * d
 
 static struct device * next_device(struct klist_iter * i)
 {
+	struct device *dev;
+	struct device *odev = i->i_cur ?
+		container_of(i->i_cur, struct device, knode_parent) : NULL;
 	struct klist_node * n = klist_next(i);
-	return n ? container_of(n, struct device, knode_parent) : NULL;
+
+	if (odev)
+		put_device(odev);
+
+	dev = n ? container_of(n, struct device, knode_parent) : NULL;
+
+	if (dev)
+		get_device(dev);
+	
+	return dev;
 }
 
 /**


