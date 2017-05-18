From: Alan Stern <stern@rowland.harvard.edu>
Subject: Need help with handling failed ATA pass-through command and sense
 data
Date: Thu, 18 May 2017 10:35:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1705181018490.1619-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53126 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1756500AbdEROfu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 10:35:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: GeekGirl1 <my.e.mail1@verizon.net>

This is in reference to

	https://bugzilla.redhat.com/show_bug.cgi?id=1351305

The problem is that some program (probably udisks2) periodically sends
the following ATA pass-through command to a USB-ATA bridge attached to
a Western Digital drive:

	85062000 00000000 00000000 0000e500

I don't know what this command does (some sort of reset?).  The command
fails and the device returns the following sense data:

	72000000 0000000e 090c0000 00ff0000 00000000 0050

I don't know how to decode this -- I don't have copies of the relevant
documents.  Can anybody decode this for me?

Anyway, the SCSI core treats it as a Hardware Error and puts warning
messages in the kernel log:

[17244.280612] sd 7:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
[17244.280614] sd 7:0:0:0: [sdd] tag#0 Sense Key : Hardware Error [current] [descriptor] 
[17244.280616] sd 7:0:0:0: [sdd] tag#0 Add. Sense: No additional sense information
[17244.280618] sd 7:0:0:0: [sdd] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00

Is this really the right thing to do?  Could it be that we are failing 
to interpret this sense data correctly?

Other commands provoke similar responses from the device, but without 
obnoxious log messages.  For example, the command:

	85082e00 00000100 00000000 0000ec00

fails with the following sense data:

	72000000 0000000e 090c0000 00000000 00000000 0050

and no output to the log.  I don't know why the behavior is different.  
There are other similar examples, with and without log messages.

Any help would be appreciated.

Alan Stern
