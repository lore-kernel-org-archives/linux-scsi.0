From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Thu, 24 Feb 2005 23:00:01 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
References: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:48992 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261800AbVBXU7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 15:59:02 -0500
In-Reply-To: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

On Wed, 23 Feb 2005, Gerhard Schneider wrote:

> 
> Kernel: 2.6.10-rc4 w/ 3 tape patches from Kai Makisara
> 
> SCSI: 53C1030 controller, tape drive is on one channel of the
> controller.
> 
> Tape: Overland Changer w/ Seagate LTO-1 drive
> Typical transfer speed: 12MB/s
> 
> After adding a Megaraid Zero Channel Raid Controller to that
> computer the transfer speed of the tape changed to 2.6 MB/s
> 
> Disks on the other channel of the 53C1030 are NOT affected
> (disk performance OK).
> 
> stinit.def has NOT been changed.
> 
> No error messages.
> I didn't find any changable parameters for the Megaraid adapter
> for TAPE drives.
> 
> What did I do wrong? How to provide you with additional data?
> 
Sounds strange but the following things come into my mind:
- Check from the dmesg output and/or system logs what SCSI transfer 
settings the tape drive and the SCSI adapter negotiate. The speed should 
not change when you add the Megaraid controller. If you don't find the 
value before adding it, you can check that the current value is at least 
40 MB/s (probably more).
- Enable debugging in the st driver (change DEBUG to 1 in st.c, recompile, 
reload the module). In the normal case st should not print many debugging 
message (some when the device is opened at some when it is closed).
- Back out the tape patches and see if that improves the situation (these 
patches should not have any effect on speed and they did not in my tests 
but changes may contain bugs that show up in other environments ...)

-- 
Kai
