From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] sr cd->device->writeable without purpose
Date: 07 Nov 2003 15:17:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068243429.7669.9.camel@patrh9>
References: <1068163343.2285.55.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:65503 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261842AbTKGWRn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 17:17:43 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id BBCFC2D4E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2003 15:17:40 -0700 (MST)
In-Reply-To: <1068163343.2285.55.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kindly offline I hear:

> I think the sr cd->device->writeable bit becomes vestigial - has no
> remaining purpose - once we branch on CDC_MMC_WR instead of
> cd->device->writeable to decide to pass thru or reject writes.

That might or might not be true.  However,

> This patch differs from that simpler CDC_MMC_WR patch by updating sr
> cd->device->writeable bit whenever cdrom corrects the sr guess of
> CDC_MMC_WR via op x46 GPCMD_GET_CONFIGURATION.

Ouch, rather silly of me.  In that patch, me the newbie, I foolishly:

a) grew cdrom_device_ops to call back into sr ...
b) just before cdrom_get_configuration returns to cdrom_get_cdc, ...
c) just before cdrom_get_cdc returns to register_cdrom, ...
d) just before register_cdrom returns to sr.sr_probe.

That is, I can run the same sr code at almost precisely the same time if
only I place that code immediately after the call to register_cdrom in
sr.sr_probe.

D'oh.

Pat LaVarre


