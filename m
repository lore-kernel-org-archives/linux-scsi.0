From: James.Smart@Emulex.Com
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 10:32:42 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F282@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19621 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262141AbUKRPdF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 10:33:05 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

 
> What do you need the host level probe for?

Well my argument is basically efficiency - 1 scan on everything vs the driver managing (what could be 100+) events to scan individual targets.  However I agree that if you have the logic to scan on a per-port basis, you really don't need the host-level probe. I'd still lean toward the host-level fix anyway, as it is an exported symbol, and it's a very subtle nuance that it can't be called multiple times.

I want to check something: If you truly were probing on a per-port basis, there's no need to ever call scsi_scan_host(), which means there potentially would never be a scan where rescan=0, or that sequential probing of channels/targets occur. Is this an issue ?

-- James

Note: I'll update the patch pending the comments to this email. It'll include the whitespace, any negotiated change, as well as the EXPORT_SYMBOL(scsi_rescan_device) addition for Mark Salyzyn.
