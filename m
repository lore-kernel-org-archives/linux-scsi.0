From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptspi : min_period, max_offset, max_width,incorrectly
	set, resulting domain validation failing
Date: Tue, 19 Sep 2006 17:12:20 -0400
Message-ID: <1158700340.4170.36.camel@mulgrave.il.steeleye.com>
References: <20060919184137.GA12200@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:65003 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750976AbWISVMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 17:12:23 -0400
In-Reply-To: <20060919184137.GA12200@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-19 at 12:41 -0600, Eric Moore wrote:
> No, I don't see spi transport layer properly setting min_period
> per what inquiry says it can support.  I have a device capable of doing
> FAST40, however MPT Bios says it can do U320 (factor 0x8). Spi transport
> tries factor=0x8 on it and the max speed inquiry test fail's.

It doesn't set it at all ... min and max are set by the driver to
reflect what the user bios settings are.  All the SPI transport
guarantees is that it will not go over/under the settings ... it doesn't
guarantee it will get up to them.

The issue sounds like a bug in the generic DV ... it's supposed to
respect the DT setting, but it currently does this by looking at the bus
signalling ... it should be respecting the inquiry data as well.

Does this fix it?

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 29a9a53..f66a440 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -850,7 +852,8 @@ spi_dv_device_internal(struct scsi_devic
 	if (i->f->get_signalling)
 		i->f->get_signalling(shost);
 	if (spi_signalling(shost) == SPI_SIGNAL_SE ||
-	    spi_signalling(shost) == SPI_SIGNAL_HVD)
+	    spi_signalling(shost) == SPI_SIGNAL_HVD ||
+	    !scsi_device_dt(sdev))
 		DV_SET(dt, 0);
 	/* Do the read only INQUIRY tests */
 	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,


