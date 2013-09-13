From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] Hyper-V TRIM support
Date: Fri, 13 Sep 2013 07:57:58 -0700
Message-ID: <1379084278.2181.3.camel@dabdike.int.hansenpartnership.com>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55028 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757874Ab3IMO6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 10:58:00 -0400
In-Reply-To: <1379077109-29606-1-git-send-email-apw@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 13:58 +0100, Andy Whitcroft wrote:
> tl;dr -- enable TRIM support for Hyper-V emulated disks.
> 
> The Hyper-V hypervisor can support TRIM for its devices, advertising this
> via the appropriate VPD pages.  However the emulated disks only claim
> to be SPC-2 devices.  According to the specs VPD pages (in general) did
> exist at SPC-2 but the specific pages we interogate for the TRIM support
> did not until SPC-3 therefore the kernel avoids reading the relevant pages
> for SPC-2 devices and prevents TRIM from being offered for these devices.
> Additionally at SPC-2 we prefer ReadCapacity10 over ReadCapacity16 and
> unless we use RC16 we will not identify the device as TRIM capable also
> preventing TRIM being offered.
> 
> As the VPD page zero does list which pages are valid for each device, it
> could be argued that we could simply attempt to use these pages for all
> devices which claim to be SPC-2 and above.  While this seems valid the
> code documents a number of devices which take badly to having even VPD
> page 0 interogated even when supposedly supported.  Therefore it seems
> appropriate to add a scsi device flag to allow a device to request SPC-3
> VPD pages be used when only at SPC-2.
> 
> Similarly for the ReadCapacity selection it seems dangerous to invert
> the order for all SPC-2 devices.  So it seems appropriate to add a scsi
> device flag to request we try RC16 before RC10 (mirroring the existing
> flag for the opposite).
> 
> The following four patches add the two scsi device flags and select those
> flags for the Hyper-V emulated disks.
> 
> Patches against v3.11.
> 
> Comments?

This is an awful lot of contortions (which don't seem to have any other
users on the horizon) to support a device that's not standards
compliant.  What about this, it's simple, it does the right thing and
it's contained in the driver of the problem device.

James

---

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 83ec1aa..bd86a4b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1438,6 +1438,12 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * hyper-v is stupid and lies about its capabilities
+	 * If we pretend to be SPC-3, we send RC16 which activates trim
+	 */
+	sdevice->scsi_level = SCSI_SPC_3;
+
 	return 0;
 }
 


