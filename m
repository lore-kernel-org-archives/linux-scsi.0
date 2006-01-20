From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH: dc395x] "fix" virt_addr calculation on AUTO_REQSENSE
Date: Fri, 20 Jan 2006 22:28:21 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0601202218060.6227@poirot.grange>
References: <Pine.LNX.4.60.0601200056360.8099@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:62160 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751146AbWATV15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 16:27:57 -0500
In-Reply-To: <Pine.LNX.4.60.0601200056360.8099@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, 20 Jan 2006, Guennadi Liakhovetski wrote:

> The patch below "fixes" calculation of the virt_addr for the AUTO_REQSENSE 
> case. I put "fixes" in quotes because the real fix would be to completely 
> remove it, but that's beyond the scope of this patch.

Just wanted to comment a bit what the actual problem is. As this bug 
triggers you get "sg_update_list: sg_to_virt failed" KERN_ERR from the 
driver. And virt_addr is set to NULL. Which is in most cases not a 
problem, because it is only used in PIO tranfers. And we currently don't 
know of any dc395x users triggering PIO. But if there were one, and the 
very sense request where this bug triggered got transferred in PIO mode, 
it would Oops. For the rest, you just get your logs filled with the 
"harmless" message. E.g., I had something like

dc395x: sg_update_list: sg_to_virt failed
last message repeated 600 times

:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
