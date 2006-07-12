From: Eric Moore <eric.moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 11:05:07 -0600
Message-ID: <20060712170507.GA10308@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64720 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932125AbWGLRSQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 13:18:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, dougg@torque.net

--  Wednesday, July 12, 2006 9:32 AM, James Bottomley wrote:

> If I understand what this does correctly, you snoop the 
> inquiry field in
> slave configure and then send a vendor specific opcode that the tape
> understands (in the event that it reports TLR in its PSLU page)?
> 
> Really, no, this isn't appropriate for code in a driver, 
> since I assume
> enabling TLR via this command on these things should be independent of
> the particular SAS HBA, so it should probably be a transport specific
> blacklist.
> 

Response from co-worker that implemented this:

--

The reason HP switched from using a standard Mode Page setting to using a vendor unique CDB is due to SCSI protocol problems.

The primary issue is that with standard Mode Sense and Mode Select commands, these commands are blocked when either the device has reservations against it or if the device is busy.  TLR needs to be enabled when the device is discovered, which is done using an Inquiry command.  But, let's look at this example:

The tape cartridge was read previously then the drive turned off (so the tape device is removed from the SAS domain and all device objects are deleted).  Later on, the tape drive is turned back on.  It will be discovered and an event sent to the host driver.  This will kick off an enumeration (Inquiry commands).  With the Inquiry, we detect that this is an HP SAS tape drive and TLR needs to be enabled.  The host driver then sends a Mode Sense to read the SAS protocol page so we can enable TLR.  However, the tape cartridge is rewinding.  The Inquriy commands completed because they are "immediate" commands that the drive can service at any time.  But, the Mode Sense (and Mode Select) commands are blocked (pended) while the tape drive is busy.  I can take more than 5 minutes for a tape cartridge to rewind and become ready, at which time the Mode Sense would be completed.  It isn't that the 
 Mode Sense is returned with Busy, it is pended so it remains outstanding and no other commands can be sent to the drive.

A similar problem occurs with reservations.  The Inquiry will always complete no matter who has reservations on the drive.  But, a Mode Sense (and Mode Select) will fail if another initiator has reservations.

I found the long Busy problem (just because the drive takes up to and even longer than 30 seconds to come Ready after a power on, no matter where the tape is).  I was trying to piggy-back on the OS Inquiry command (which has a timeout of 4 seconds) and this was failing.  I modified my driver to perform the Mode Sense outside of the OS Inquiry command, but HP came back with the above scenarios (tape rewind and reservations) and that's when they wanted to switch to a vendor-unique CDB (much easier for them F/W wise).

The usage of Mode Sense and Mode Select will still work with the HP tape drives, if you can find a way around the above issues.  But I would suggest discussing any solution with the HP-Bristol tape drive folks.

