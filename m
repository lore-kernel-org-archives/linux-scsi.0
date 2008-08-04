From: Douglas Gilbert <dougg@torque.net>
Subject: USB storage devices and SAT
Date: Mon, 04 Aug 2008 03:10:04 +0200
Message-ID: <489656EC.5000602@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:42097 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYHDBKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 21:10:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

USB storage devices that support SAT (the T10 SCSI to ATA
translation standard) are beginning to appear.

SAT enables tools like smartmontools to access SMART data
on a ATA disk in a USB enclosure. We have run into
a problem. It seems that the usb storage subsystem is wedded
to the idea of sense data that is no longer than 18 bytes. **
That doesn't play well with SAT which uses descriptor format
sense data that is made up of an 8 byte header plus zero or
more descriptors. SAT uses a 14 byte "ATA return" (sense)
descriptor to yield the ATA registers. That means the sense
data length is 22 bytes when an ATA return descriptor is
required.

Alan Stern has already noted to another smartmontools developer
that such a change is likely to break some USB storage devices.
Perhaps the maximum sense buffer size could be optionally
specified per usb storage device. Alternatively the usb mass
storage logic could make some dynamic decisions itself.
For example if the (disk) device responds successfully to either
SCSI ATA PASS_THROUGH (12 or 16 byte) command then it will
be capable of (at least) 22 byte sense data. A T10 vendor
identification field in a standard INQUIRY response of
"ATA     " is another indication of a device that supports
SAT.


** the 18 byte sense data limit comes from SCSI-2 (circa 1992).
That was upped to 252 bytes around 10 years ago. Some SCSI disk
vendors have been using the extra bytes (above 18) for some
time. Then in SPC-3 (standard in 2005) descriptor format sense
data was introduced and SAT uses it. There are other uses: any
SCSI (virtual) disk that needs more than 32 bits to represent all
its LBAs should use descriptor format for MEDIUM ERRORs. The
reason is that MEDIUM ERRORs should include the LBA of the first
failure and the "info" field in the older "fixed" sense format
is only 4 bytes.

Doug Gilbert
