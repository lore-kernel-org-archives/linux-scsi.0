From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Error handling in LibATA
Date: Wed, 11 Jan 2006 09:22:13 +1000
Message-ID: <43C441A5.6000205@torque.net>
References: <BAY101-F102837A76FADACF6F37DBBDF250@phx.gbl>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY101-F102837A76FADACF6F37DBBDF250@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

John Treubig wrote:
> I've been working on a problem with Promise 20269 PATA adapter under
> LibATA that if the drive has a write error or time-out, the application
> that is accessing the drive using SG should see some sort of error.  My
> first problem was my system hung.  After patching the IDE-IO.C, with a
> recognized patch, I have been able to keep my system from hanging.  Now
> the only problem is the application gets no notification that the drive
> has been rendered inaccessible.  (Test case is to run a system with my
> app going, and then pull the power from the drive.  System log shows the
> errors, but nothing gets back to the app).  The app does get
> notifications if I perform the same type of test on a drive attached to
> the motherboard secondary IDE adapter, so we know the app is correctly
> implemented.
> 
> I've traced the errors down to the fact that the errors are caught in
> libata-core.c (ata_qc_timeout).  I'd like to put a call in libata-core.c
> that would cause an error to be reflected back to the application.  Can
> you suggest the function or method that would do this?

John,
SG_IO ioctl users would normally expect to see DRIVER_TIMEOUT
(plus a suggest mask) in sg_io_hdr::driver_status when a
mid level timeout goes off. So that needs to be "wired"
in libata (along with some other transport errors I suspect).

Here is an example of a timeout using the scsi_debug driver:
# modprobe scsi_debug ptype=9 delay=200000
# lsscsi -g
[0:0:0:0]    comms   Linux    scsi_debug       0004  -         /dev/sg0
# sg_start /dev/sg0
start stop unit: transport: Driver_status=0x06 [DRIVER_TIMEOUT, SUGGEST_OK]
START STOP UNIT command failed


Doug Gilbert
