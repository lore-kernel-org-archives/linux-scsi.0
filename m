From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: Need help with handling failed ATA pass-through command and
 sense data
Date: Thu, 18 May 2017 11:34:18 -0400
Message-ID: <1495121658.3629.21.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.1705181018490.1619-100000@iolanthe.rowland.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932298AbdERPeU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 11:34:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.1705181018490.1619-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, GeekGirl1 <my.e.mail1@verizon.net>

On Thu, 2017-05-18 at 10:35 -0400, Alan Stern wrote:
> This is in reference to
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=1351305
> 
> The problem is that some program (probably udisks2) periodically sends
> the following ATA pass-through command to a USB-ATA bridge attached to
> a Western Digital drive:
> 
> 	85062000 00000000 00000000 0000e500

According to T10 SAT-4 this is an ATA PASS-THROUGH(16) command, with
PROTOCOL=3 (non-data), CK_COND=1, COMMAND=E5h (the ATA command).

> 
> I don't know what this command does (some sort of reset?).  The command
> fails and the device returns the following sense data:
> 
> 	72000000 0000000e 090c0000 00ff0000 00000000 0050
> 
> I don't know how to decode this -- I don't have copies of the relevant
> documents.  Can anybody decode this for me?

This is a current descriptor format sense data wih a single
ATA Status Return sense data descriptor (beginning at 8 bytes into
the sense data buffer 090c...)  The relevant fields are COUNT=255 LBA=0
and STATUS=50h (which I suspect is what is the interesting part).

> 
> Anyway, the SCSI core treats it as a Hardware Error and puts warning
> messages in the kernel log:
> 
> [17244.280612] sd 7:0:0:0: [sdd] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
> [17244.280614] sd 7:0:0:0: [sdd] tag#0 Sense Key : Hardware Error [current] [descriptor] 
> [17244.280616] sd 7:0:0:0: [sdd] tag#0 Add. Sense: No additional sense information
> [17244.280618] sd 7:0:0:0: [sdd] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> 
> Is this really the right thing to do?  Could it be that we are failing 
> to interpret this sense data correctly?

With the 72000000 0000000e 090c0000 00ff0000 00000000 0050 sense data
buffer above scsi_sense_key_string() should have returned "No Sense" as
the array value is 0.  Even if we somehow managed to fail to correctly
interpret descriptor format sense vs. fixed format sense.

> 
> Other commands provoke similar responses from the device, but without 
> obnoxious log messages.  For example, the command:
> 
> 	85082e00 00000100 00000000 0000ec00
> 
> fails with the following sense data:
> 
> 	72000000 0000000e 090c0000 00000000 00000000 0050
> 
> and no output to the log.  I don't know why the behavior is different.  
> There are other similar examples, with and without log messages.

It seems more likely that somehow there is a path where the wrong or
uninitialized sshdr structure is being passed to the logging routine.

-Ewan

> 
> Any help would be appreciated.
> 
> Alan Stern
> 
