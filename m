From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 16:53:25 -0800
Message-ID: <20050216005325.GC6859@plap.qlogic.org>
References: <7526e305050215152950f5a69e@mail.gmail.com> <1108513997.5539.76.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:24690 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261349AbVBPAxA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 19:53:00 -0500
Content-Disposition: inline
In-Reply-To: <1108513997.5539.76.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joe Scsi <joe.scsi@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 15 Feb 2005, James Bottomley wrote:

> On Tue, 2005-02-15 at 15:29 -0800, Joe Scsi wrote:
> > I see the internal changes to scsi_scan.c that this refers to, but
> > I'm not totally clear on what a driver should do to allocate a target
> > and scan it when it finds out about a new target port.
> 
> A driver doesn't allocate a target.  In this code, a target device is
> purely a LUN container and is managed by the mid-layer.  The driver
> requests the scan of a target by parent device, channel and id.  This
> request for a scan creates and parents the target object, but reaps it
> again if no actual LUNs are discovered.
> 

Yes, but the parent needs to know if the starget is actually created.
With the fc_rports snapshot I've been working with, I've coded up the
following:

+	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
+	    SCAN_WILD_CARD, 0);
+
+	dev = container_of(rport->dev.children.next, struct device, node);
+	rport->starget = to_scsi_target(dev);
+	if (unlikely(!rport->starget))
		dev_printk(KERN_ERR, &rport->dev, TGT_ALLOC_FAILURE_MSG,
				__FUNCTION__, shost->host_no);

so when the rport gets dropped (i.e. fc_remote_port_delete()), a
scsi_remove_target() call can be issued.  I'm not entirely thrilled
with the structure-member poking (any other suggestions on how to get
the child, welcomed), but it does work.

Also, the patch neglected to add scsi_scan_target() to an appropriate
header file.  Attached patch will cure -- I've added it to
scsi_host.h, may wish to add to scsi_device.h.

--
AV

diff -Nurdp -X ../8.x/dontdiff-bk scsi-rport-orig/include/scsi/scsi_host.h scsi-rport/include/scsi/scsi_host.h
--- scsi-rport-orig/include/scsi/scsi_host.h	2005-02-15 17:10:42.000000000 -0800
+++ scsi-rport/include/scsi/scsi_host.h	2005-02-15 15:45:21.000000000 -0800
@@ -575,6 +575,8 @@ extern void scsi_remove_host(struct Scsi
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern void scsi_scan_target(struct device *, unsigned int, unsigned int,
+	unsigned int, int);
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
