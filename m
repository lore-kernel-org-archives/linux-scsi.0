From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 15:43:19 +0000
Message-ID: <20041118154319.GA24002@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F282@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:58887 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262471AbUKRPnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 10:43:21 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F282@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> I want to check something: If you truly were probing on a per-port basis, there's no need to ever call scsi_scan_host(), which means there potentially would never be a scan where rescan=0, or that sequential probing of channels/targets occur. Is this an issue ?

Don't think so.  Maybe we should allow a !rescan variant of the per-target
probe if you really see performance problems without, but not calling
scsi_scan_host is just fine.  In fact that's the reason why I separated
it out from scsi_add_host.  The sequential bus scan is fundamentally a SPI
thing and other transports are probably better off not using it at all, e.g.
IEEE1394 SBP2 and iscsi already don't call it at all.

