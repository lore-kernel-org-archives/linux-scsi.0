From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 12 Sep 2003 15:53:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063403610.3634.41.camel@patehci2>
References: <3F5E434D.6080801@unixsol.org>
	 <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <20030910170227.C3367@beaverton.ibm.com> <1063392194.3677.7.camel@patehci2>
	 <20030912135628.B21598@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:63956 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261923AbTILVwd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 17:52:33 -0400
In-Reply-To: <20030912135628.B21598@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> I don't get your point ...
> 
> Code used for different upper level scsi
> devices should not be duplicated, ...

Re whether a pdt x05 dvd/cd device is writable, I think I see
duplication among ide-cd, ide-scsi, and sr.  I hear ide-scsi is dying,
but that ide-cd and sr plan to continue competing.

For example:

sr.c get_capabilities decides CDC_DVD_RAM and cd->device->writeable by
fetching & parsing as raw hex the 2Ah Capabilities mode page via
scsi_lib.c scsi_mode_sense of page x2a, sending op MODE_SENSE = x1a or
MODE_SENSE_10 = x5a.

ide-cd.c ide_cdrom_probe_capabilities decides CDC_DVD_RAM (also stored
as CDROM_CONFIG_FLAGS(drive)->dvd_ram) by fetching & parsing as a
asm/byteorder.h packed struct the 2Ah Capabilities mode page via
ide_cdrom_get_capabilities via cdrom_mode_sense of page
GPMODE_CAPABILITIES_PAGE = x2a, always sending op GPCMD_MODE_SENSE_10 =
x5a.

Neither yet proceeds to try op 46h GET_CONFIGURATION to discover the
other six writable mmc profiles.

> talking about the transport (LLDD),
> not the actual scsi device or upper level drivers ...

Thank you for your patience, sorry at first I did not understand how
narrowly we mean "transport" here.

> use_10_for_ms ...
> set to 0 in scsi_scan.c ...
> set to 1 by drivers/usb/storage/scsiglue.c ...
>
> transport X as a bridge to another transport Y,
> flags ... maybe what commands we can send ...
> relative to transport X,
> when they might be inappropriate for transport Y ...
> Examples ...

Clear to me now (and cool) thank you.

> I don't know ide or cd enough ...
> except ...there is common cd code (struct cdrom_device_ops).

Aye, helpful.

Pat LaVarre



