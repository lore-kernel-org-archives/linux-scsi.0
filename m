From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] mpt2sas: driver fails to recover from injected PCIe
 bus errors
Date: Tue, 27 Jul 2010 11:17:47 -0500
Message-ID: <1280247467.2833.77.camel@mulgrave.site>
References: <20100708204431.GA1419@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42891 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab0G0QRw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 12:17:52 -0400
In-Reply-To: <20100708204431.GA1419@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-07-08 at 14:44 -0600, Eric Moore wrote:
> fixes surrounding PCIe enhanced error handling:
> 
> (1) We need to reject all request generated internaly inside the driver as well
> as request arriving from the scsi mid layer when PCIe EEH is active. The fix is
> to add a per adapter flag called pci_error_recovery which is checked thru out
> the driver when request are generated.
> 
> (2) We don't need to call the pci_driver->remove directly from the PCIe
> callbacks becuase its already called from the PCIe EEH code. In its place we are
> shutting down the watchdog timer, and flushing back all pending IO.
> 
> (3) We need to save and restore the pci state across PCIe EEH handling.
> 
> Signed-off-by: Eric Moore <eric.moore@lsi.com>
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> old mode 100644
> new mode 100755

Will you watch this type of thing, please?  This changes all the file
modes to executable.  Linus particularly watches for this and will go
into a kill frenzy if he sees it.

I've fixed it up this time.

James


