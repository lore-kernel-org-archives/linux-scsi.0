From: Kenn Humborg <kenn@linux.ie>
Subject: Re: Possible use of uninitialized variable in sd.c
Date: Tue, 1 Mar 2005 23:25:10 +0000
Message-ID: <20050301232509.GA21680@excalibur.research.wombat.ie>
References: <20050225210629.GA23018@excalibur.research.wombat.ie> <1109366810.5014.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail2.mail.iol.ie ([193.95.141.54]:63426 "EHLO
	mail2.mail.iol.ie") by vger.kernel.org with ESMTP id S262115AbVCAXYv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 18:24:51 -0500
Content-Disposition: inline
In-Reply-To: <1109366810.5014.15.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 25, 2005 at 01:26:50PM -0800, Mark Haverkamp wrote:
> I wonder if it wouldn't be better to just check the error return before
> the index value.

It's all the same to me.

In drivers/scsi/sd.c:sd_probe:

	int index;
	...
	spin_lock(&sd_index_lock);
	error = idr_get_new(&sd_index_idr, NULL, &index);
	spin_unlock(&sd_index_lock);

	if (index >= SD_MAX_DISKS)
		error = -EBUSY;
	if (error)
		goto out_put;

Note that if idr_get_new() fails, index remains uninitialized.  If it
happens to be >= SD_MAX_DISKS, the error returned from idr_get_new will
be clobbered.  Patch initializes checks error code from idr_get_new
before accessing index.

Signed-off-by: Kenn Humborg <kenn@linux.ie>

--- src/drivers/scsi/sd.c-2.6.10	2005-02-25 21:02:17.000000000 +0000
+++ src/drivers/scsi/sd.c	2005-03-01 23:21:04.539648136 +0000
@@ -1438,7 +1438,7 @@
 	error = idr_get_new(&sd_index_idr, NULL, &index);
 	spin_unlock(&sd_index_lock);
 
-	if (index >= SD_MAX_DISKS)
+	if (!error && (index >= SD_MAX_DISKS))
 		error = -EBUSY;
 	if (error)
 		goto out_put;



