From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Sun, 23 Oct 2005 10:29:32 -0500
Message-ID: <1130081372.3437.33.camel@mulgrave>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30364 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750746AbVJWP3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 11:29:35 -0400
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2005-10-22 at 21:36 -0400, Jeff Garzik wrote:
> This patch series makes a tiny bit of progress on the marginalize-SPI
> todo list.
> 
> Patches:
> 1) s/scsi_scan_target/spi_scan_target/
> 2) remove unused scsi_scan_single_target()
> 3) add scsi_scan_target()
> 4) kill all uses of spi_scan_target()
> 5) kill spi_scan_target(), __spi_scan_target()
> 6) misc cleanups

There's an unaddressed lifetime problem in all of this:  Originally the
target object exists solely internally and has its lifetime managed by
the mid-layer (it actually exists only as long as there are LUNs on it).

In your code cleanups, you keep the scsi_target_reap() function (which
is what checks the children and tries to destroy the device if it
doesn't find any) private (well, unexported).  So, on return from your
new scsi_scan_target(), the target pointer might be invalid (already
freed) if you didn't take a reference to starget->dev.  That's counter
to the way lifetime management of objects usually works.

I think the choices are

1. Make the target an explicit object (like it's peers scsi_device and
scsi_host), so the layer creating it is responsible for managing it.
This will get tricky, particularly as we'd need at least lun removal
notifications so the creating layer can decide on destruction.
2. Move scsi_scan_target() into scsi_priv.h to imply only transport
classes should be using it (where there'll be much more scrutiny on
getting the unusual rules right).

James


