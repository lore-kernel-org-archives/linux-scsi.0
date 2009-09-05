From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Sat, 5 Sep 2009 17:45:51 +0100
Message-ID: <20090905164551.GH8710@arachsys.com>
References: <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com> <20090821092326.GF32115@arachsys.com> <1250863216.3844.1.camel@mulgrave.site> <20090821145141.GR32115@arachsys.com> <1250869674.7363.89.camel@mulgrave.site> <20090822115535.GB1976@arachsys.com> <1250952965.18902.2.camel@mulgrave.site> <20090822155037.GB28586@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:50698 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZIEQuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2009 12:50:17 -0400
Content-Disposition: inline
In-Reply-To: <20090822155037.GB28586@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > Actually, if that works, I'll have the above backported as well.
> 
> Hi James. That's much better; thanks! I certainly can't provoke any problems
> with it in a VM, although I couldn't really reproduce the problem with the
> original kernel in a test environment either. I'll push it to our clusters
> and see how things go over the next week or so.

We've been running with this for a couple of weeks now, and I haven't seen the
crash repeat itself. That said, I applied this on top to see if I could detect
the race:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1936,6 +1936,8 @@
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 	          sdp->removable ? "removable " : "");
+	if (atomic_read(&sdkp->dev.kobj.kref.refcount) < 2)
+		sd_printk(KERN_WARNING, sdkp, "Attempted to release device before sd_probe_async complete\n");
 	put_device(&sdkp->dev);
 }

and it hasn't triggered at all, so I wonder whether we've just not hit the bug again.

Best wishes,

Chris.
