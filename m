From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated
 SCSI hosts
Date: Mon, 24 Mar 2003 11:05:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7E59D5.2020200@torque.net>
References: <20030322233136.D17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222337260.5588-100000@home.transmeta.com> <20030323101314.E17056@one-eyed-alien.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Dharm wrote:
> On Sat, Mar 22, 2003 at 11:39:05PM -0800, Linus Torvalds wrote:
> 
>>How about making the SCSI stuff pass a "common" flag (or "required") down
>>with the command? Then, a emulated thing could just decide to punt all 
>>commands with an immediate failure if they aren't marked "required".
>>
>>That still _allows_ the driver to implement it if it wants to, unlike your 
>>previous approach.
> 
> 
> That seems reasonable... but we need to define a standard way to
> reject/fail non-common commands.  Special sense data?  Special result
> code?  It doesn't really matter to me, but we need to pick something.
> 
> Do you have a preference?

Matt,
Evidentally your driver (and/or sbp2) synthesizes INQUIRY
responses in some cases. So if you think a SCSI command
is risky then why not follow the standard and synthesize
the scsi status and auto-sense buffer. Here is a modern
rendition from a (draft) standard:

"If a device server receives a CDB containing an operation
code that is invalid or not supported, it shall return
CHECK CONDITION status with the sense key set to ILLEGAL
REQUEST and an additional sense code of INVALID COMMAND
OPERATION CODE." [SPC-3, T10/1416-D Revision 10 2002/11/10]

If it is a field within a command that is in doubt (e.g.
the enable Vital Product Data (EVPD) bit in an INQUIRY)
then the additional sense code becomes INVALID FIELD IN
CDB.

In the case of a disk the commands that must be
supported are:
    - 36 byte INQUIRY (EVPD=0, CmdDt=0)
    - READ CAPACITY
    - READ (10 byte)
    - WRITE (10 byte)

For SCSI mid level scan code and the sd
disk initialization code a flag could be added to
struct scsi_cmnd to indicate that "I can live without
knowing the answer to this command".

I always wanted the emulated flag generalized (e.g.
indicating SPI, ATAPI, iSCSI, FC, SAS, SBP-2,
USB_mass_storage). Knowledge of the SCSI transport
protocol is important for device discovery,
identification and asynchronous notification sources.
As a boolean flag, "emulated" has outlived its usefulness.
With sysfs we can now find which hardware system a
SCSI low level driver belongs  to (e.g. SCSI Parallel
Interface (SPI) adapters are either PCI or ISA).

Doug Gilbert




