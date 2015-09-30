From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Wed, 30 Sep 2015 17:14:49 +0200
Message-ID: <20150930151449.GC26299@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35640 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbbI3POv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 11:14:51 -0400
Content-Disposition: inline
In-Reply-To: <1443202278.2188.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Fri, Sep 25, 2015 at 10:31:18AM -0700, James Bottomley wrote:
> So the warning seems to be because scsi_dh_find_driver() is not quite
> consistent.  For everything except alua, it scans the dh driver list to
> see what might attach to the device.  It returns "alua" if the TPGS
> field is anything other than zero, regardless of whether the alua driver
> is loaded.  We could fix the problem by returning NULL if the alua
> driver isn't present ... would that have any other adverse consequences?

It's not inconsistent - to autoload a driver we cant't require it to
be loaded.  For alua we check the TPGS bit per the standard, and for
the non-standard drivers we use a whitelist in scsi_dh.c now.

The problem is that async probing deadlocks vs a synchronous
request_module, as Tejun figured out based on the thrad in
http://thread.gmane.org/gmane.linux.kernel/1420814

Tejun, if I understand the thread and your patch right there really
isn't any good altenative to a synchronous request_module, and you
thus disabled autoloading elevator modules, right?

For SCSI device handlers we could do this by switching from scsi_dh_lookup
to __scsi_dh_lookup in scsi_dh_add_device, but autoloading the device
handlers is a really useful feature that I'd love to keep if possible.

Given that before 4.3-rc we could not autoload them the switch to
__scsi_dh_lookup migt be the required band aid for now until we can
come up with something better.

Paul, can you try the trivial one liner below?

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..fbc9502 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -391,7 +391,7 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 	if (!sdev)
 		return -ENODEV;
 
-	scsi_dh = scsi_dh_lookup(name);
+	scsi_dh = __scsi_dh_lookup(name);
 	if (!scsi_dh) {
 		err = -EINVAL;
 		goto out_put_device;
