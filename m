From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 0/4] scsi: 64-bit LUN support
Date: Thu, 21 Feb 2013 16:15:01 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net>
References: <1361261883-41467-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31664 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3BUQRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2013 11:17:01 -0500
In-Reply-To: <1361261883-41467-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>

Regarding changes like this:
-			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
+			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%llu] "
 			"FCP_ResponseInfo=%08xh\n", ioc->name,
 			sc->device->host->host_no, sc->device->channel,
 			sc->device->id, sc->device->lun,

It might be preferable to print the LUN values in hex rather than decimal, particularly if they are large values.  SAM-5 includes some guidance for displaying LUNs, shown below. 

One important goal is to match the format, if any, that the user must use in a configuration file or command line argument, so cutting-and-pasting the LUN value works.  So, the answer might differ for prints from different drivers.  If a driver expects decimal input values, then print decimal.

SAM-5 excerpt:
4.7.2 Logical unit representation format
When an application client displays or otherwise makes a 64-bit LUN value visible, the application client should
display it in hexadecimal format with byte 0 first (i.e., on the left) and byte 7 last (i.e., on the right), regardless of
the internal representation of the LUN value (e.g., a single level LUN with an ADDRESS METHOD field set to 01b
(i.e., flat space addressing) and a FLAT SPACE LUN field set to 0001h should be displayed as 40 01 00 00 00 00 00
00h, not 00 00 00 00 00 00 01 40h). A separator (e.g., space, dash, or colon) may be included between each
byte, each two bytes (e.g., 4001-0000-0000-0000h), or each four bytes (e.g., 40010000 00000000h).

[The trailing h is just the T10 documentation convention... a 0x prefix is fine too]
[The next three paragraph allow stripping off unnecessary trailing zeros:]

When displaying a single level LUN structure using the peripheral device addressing method (see table 11) or a
single level LUN structure using the flat space addressing method (see table 12), an application client may
display the value as a single 2-byte value representing only the first level LUN (e.g., 40 01h). A separator (e.g.,
space, dash, or colon) may be included between each byte.

When displaying a single level LUN structure using the extended flat space addressing method (see table 13), an
application client may display the value as a single 4-byte value representing only the first level LUN (e.g., D2 00
00 01h). A separator (e.g., space, dash, or colon) may be included between each byte, or between each two
bytes (e.g., D200 0001h).

When displaying a single level LUN structure using the long extended flat space addressing method (see table
14), an application client may display the value as a single 6-byte value representing only the first level LUN
(e.g., E2 00 00 01 00 01h). A separator (e.g. space, dash, or colon) may be included between each byte, or
between each two bytes (e.g., E200 0001 0001h).

When displaying a 16-bit LUN value, an application client should display the value as a single 2-byte value (e.g.,
40 01h). A separator (e.g., space, dash, or colon) may be included between each byte.


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, 19 February, 2013 2:18 AM
> To: linux-scsi@vger.kernel.org
> Cc: James Bottomley; Jeremy Linton; Elliott, Robert (Server Storage); Bart Van
> Assche; Hannes Reinecke
> Subject: [PATCH 0/4] scsi: 64-bit LUN support
> 
> This patchset updates the SCSI midlayer to use 64-bit LUNs internally.
> It eliminates the need to limit the number of LUNs artificially to
> avoid aliasing issues; the SCSI midlayer can now accept any LUN presented
> to it.
> 
> The LLDD specific settings for 'max_lun' have been left untouched;
> it should be raised to '~0' if the HBA supports 64-bit LUNs internally.
> However, it is up to the driver maintainer to raise that limit.


