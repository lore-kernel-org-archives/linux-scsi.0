From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 11:49:23 -0400
Message-ID: <435D0283.40505@adaptec.com>
References: <20051023013618.GA18201@havoc.gtf.org> <1130081372.3437.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19157 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751107AbVJXPta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 11:49:30 -0400
In-Reply-To: <1130081372.3437.33.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On 10/23/05 11:29, James Bottomley wrote:
> There's an unaddressed lifetime problem in all of this:  Originally the
> target object exists solely internally and has its lifetime managed by
> the mid-layer (it actually exists only as long as there are LUNs on it).

And this has always been wrong and I objected to this back when it
was introduced a few years ago.

> In your code cleanups, you keep the scsi_target_reap() function (which
> is what checks the children and tries to destroy the device if it
> doesn't find any) private (well, unexported).  So, on return from your
> new scsi_scan_target(), the target pointer might be invalid (already
> freed) if you didn't take a reference to starget->dev.  That's counter
> to the way lifetime management of objects usually works.
> 
> I think the choices are
> 
> 1. Make the target an explicit object (like it's peers scsi_device and
> scsi_host), so the layer creating it is responsible for managing it.

Which is exactly what I've been proposing: struct scsi_domain_device { };
similarly to how it is done in the SAS Transport Layer/Stack in the link
of my signature.

The new struct scsi_domain_device { } would be a logial (not imposed)
superclass around the transport's domain device representation.
The Transport Layer _registers_ a struct scsi_domain_device { };
and then SCSI Core scans for LUs and does LU bookkeeping.

LUs -> SCSI Core
SCSI Domain Targets -> Transport Layer around its own domain device
representation:

struct scsi_domain_device {
	void *domain_device;    /* opaque to SCSI Core */
	
	struct list_head LU_list;
	...
};

All of this functionality and infrastructure is present in the
SAS Stack and could be taken almost as is.

> This will get tricky, particularly as we'd need at least lun removal
> notifications so the creating layer can decide on destruction.

LU management is SCSI Core's task -- you'll get notified if
the _domain_ device went away, so that you can clean up your LU
representation.

See for example sas_discover_event(struct sas_port *, enum discover_event ev)
for event DISCE_PORT_GONE handled in the discover thread.
sas_unregister_domain_devices() eventually bubbles up to SCSI Core,
and dynamically allocated are handled by their release method (kobject
infrastructure).

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
