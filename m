From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] scsi: introduce shost_priv helper
Date: Thu, 31 May 2007 20:12:26 +0200
Message-ID: <20070531181226.GA3245@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41475 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796AbXEaSMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2007 14:12:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, davem@davemloft.net
Cc: linux-scsi@vger.kernel.org

Currently accessing the scsi host private data is rather messy because
it comes as an unsigned long that always needs a cast first.  This patch
introduces a helper that does the cast called shost_priv.  It's similar
in spirit to netdev_priv for network drivers.

This is the first patch introducing the macro, and the second patch
in the series will convert esp and it's subdrivers as an example.
Further conversion will wait until the helper is in the tree to make
patch juggling easier.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/scsi/scsi_host.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_host.h	2007-05-31 20:02:01.000000000 +0200
+++ linux-2.6/include/scsi/scsi_host.h	2007-05-31 20:03:47.000000000 +0200
@@ -677,6 +677,10 @@ struct Scsi_Host {
 #define shost_printk(prefix, shost, fmt, a...)	\
 	dev_printk(prefix, &(shost)->shost_gendev, fmt, ##a)
 
+static inline void *shost_priv(struct Scsi_Host *shost)
+{
+	return (void *)shost->hostdata;
+}
 
 int scsi_is_host_device(const struct device *);
 
