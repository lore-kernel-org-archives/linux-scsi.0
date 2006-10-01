From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] async scsi scanning, version 13
Date: Sun, 1 Oct 2006 14:17:53 -0600
Message-ID: <20061001201753.GG16272@parisc-linux.org>
References: <20060928211920.GI5017@parisc-linux.org> <1159732857.3542.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:22149 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932301AbWJAURy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 16:17:54 -0400
Content-Disposition: inline
In-Reply-To: <1159732857.3542.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 01, 2006 at 03:00:57PM -0500, James Bottomley wrote:
> OK, my plan for this is to place it in SCSI misc as soon as we get
> 2.6.19-rc1.  That way we'll give it a thorough check out in -mm before
> it hits mainline.
> 
> By the way, a global change log (rather than changes relative to
> previous versions) would be appreciated.

Certainly ...

Add ability to scan scsi busses asynchronously

Since it often takes around 20-30 seconds to scan a scsi bus, it's
highly advantageous to do this in parallel with other things.  The bulk
of this patch is ensuring that devices don't change numbering, and that
all devices are discovered prior to trying to start init.  For those
who build SCSI as modules, there's a new scsi_wait_scan module that will
ensure all bus scans are finished.

This patch only handles drivers which call scsi_scan_host.  Fibre Channel,
SAS, SATA, USB and Firewire all need additional work.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

