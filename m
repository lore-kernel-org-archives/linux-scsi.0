From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_MMC_WR
Date: 06 Nov 2003 10:44:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068140646.23487.119.camel@patrh9>
References: <1067647915.2682.5.camel@patrh9>
	 <1068136355.23487.44.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:57268 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263788AbTKFRof
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 12:44:35 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 4F1B82A42
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2003 10:44:32 -0700 (MST)
In-Reply-To: <1068136355.23487.44.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Does the ->writeable bit exist for ide-cd devices, or only for sr
> devices?

I'm guessing only sr devices, since grep writeable fails in drivers/ide/
and in drivers/cdrom/.

> When cdrom.ko decides a device is not writable, how does cdrom.ko name
> that bit, else how does cdrom.ko call into ide-cd/sr to clear that bit?

Call back into sr from cdrom may occur via the cdrom_device_ops.

We define cdrom_ioctl CDROM_GET_CAPABILITY but no SET of capability,
though we do define CDROM_SET_OPTIONS.

Maybe we're telling me to add a call back to the cdrom_device_ops for
cdrom to notify ide-cd/sr that the capabilities have changed.  ide-cd
could ignore that notification, sr could set
scsi_cd->scsi_device->writeable accordingly.

> Have "the ->writeable bit actually be set if the device is writeable".

grep is failing to find code for me that fetches this bit.

Is this bit ever fetched?

http://lxr.linux.no/ident?v=2.6.0-test7&i=writeable
no hits.

http://lxr.linux.no/search?v=2.6.0-test7&string=writeable
over seventy hits.  Apparently none relevant, except to say scsi_scan
sets this bit for sd, clears this bit for sr, and sr sometimes sets and
fetches this bit until I patch sr to branch on CDC_MMC_WR instead.

Pat LaVarre


