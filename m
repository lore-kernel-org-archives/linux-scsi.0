From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 18 Feb 2010 14:16:13 +0530
Message-ID: <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:33384 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0BRIqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2010 03:46:15 -0500
In-Reply-To: <1266418952.2787.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

On Wed, Feb 17, 2010 at 8:32 PM, James Bottomley
<James.Bottomley@suse.de> wrote:

> I have no idea what the MS driver is, so it's impossible to answer
> specifically.

MS means mass storage driver only.

> As long as the driver supports chaining, you increase it
> in /sys/block/dev>/queue/max_sectors_kb.  For compatibility reasons this
> stays clamped at 512 unless a user specifically raises it.

The max_sectors value is defined in struct scsi_host_template
usb_stor_host_template structure in scsiglue.c file
(drivers/usb/storage).  If I change the max_sectors value in this
scsiglue.c file it reflects in the
/sys/block/<dev>/queue/max_sectors_kb and
/sys/block/<dev>/queue/max_hw_sectors_kb. However, when I set the
max_sectors to 1024 it reflected as 512 in
/sys/block/<dev>/queue/max_sectors_kb and
/sys/block/<dev>/queue/max_hw_sectors_kb. If I change the max_sectors
to 1536 or 2048 in scsiglue.c file, still it reflected as 512 in
/sys/block/<dev>/queue/max_sectors_kb and 768 or 1024 in
/sys/block/<dev>/queue/max_hw_sectors_kb.

I have changed the value in /sys/block/<dev>/queue/max_sectors_kb to
1024 with the following command.

echo 1024 > /sys/block/<dev>/queue/max_sectors_kb.

The file shows 1024, but still, I received only 512 KB data transfer
buffers (transfer length in srb) from SCSI layer in my mass storage
driver.

Here, my question is, how can my mass storage driver receives the 1024
KB data transfer buffers (transfer length in srb) from SCSI layer.
Please let me know.

Thanks in advance.

Thanks and Regards,
RD
