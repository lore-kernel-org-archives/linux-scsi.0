From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/4] Enable link power management for ata drivers
Date: Thu, 5 Jul 2007 15:37:18 -0700
Message-ID: <20070705153718.3aaf8ea5.akpm@linux-foundation.org>
References: <20070705194909.337398431@intel.com>
	<20070705130530.5873afeb.kristen.c.accardi@intel.com>
	<20070705153334.08402809.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758413AbXGEWiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 18:38:02 -0400
In-Reply-To: <20070705153334.08402809.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Thu, 5 Jul 2007 15:33:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 5 Jul 2007 13:05:30 -0700
> Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> 
> > +	ATA_DFLAG_IPM		= (1 << 6), /* device supports interface PM */
> >  	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> 
> I had to bump this to (1<<7), so we've run out.

err, no, we've more than run out because you AN patches took the last one.


I guess we can bump ATA_DFLAG_CFG_MASK up to 12, like this?

--- a/include/linux/libata.h~ata-ahci-alpm-enable-link-power-management-for-ata-drivers
+++ a/include/linux/libata.h
@@ -140,11 +140,12 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* device supports Async notification */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_IPM		= (1 << 8), /* device supports interface PM */
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),


