From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: fix compile-time divide-by-zero in scsi_ioctl
Date: Wed, 27 Sep 2006 14:27:10 -0600
Message-ID: <20060927202710.GV5017@parisc-linux.org>
References: <20060926154848.CFDC63DAF7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59791 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1030765AbWI0U1L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 16:27:11 -0400
Content-Disposition: inline
In-Reply-To: <20060926154848.CFDC63DAF7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 26, 2006 at 08:48:48AM -0700, David Brownell wrote:
> This fixes a compiler-reported divide-by-zero when HZ < 100.

Shouldn't we instead be using jiffies_to_clock_t?  Thus:

Index: at91/block/scsi_ioctl.c
===================================================================
--- at91.orig/block/scsi_ioctl.c	2006-07-30 01:17:34.000000000 -0700
+++ at91/block/scsi_ioctl.c	2006-07-30 01:44:17.000000000 -0700
@@ -63,7 +63,7 @@ static int scsi_get_bus(request_queue_t 
 
 static int sg_get_timeout(request_queue_t *q)
 {
-	return q->sg_timeout / (HZ / USER_HZ);
+	return jiffies_to_clock_t(q->sg_timeout);
 }
 
 static int sg_set_timeout(request_queue_t *q, int __user *p)
