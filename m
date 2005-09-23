From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Fri, 23 Sep 2005 10:22:47 -0400
Message-ID: <43340FB7.3080708@adaptec.com>
References: <7744a2840509221206254d2109@mail.gmail.com> <43334AFF.8010901@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43334AFF.8010901@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/22/05 20:23, Douglas Gilbert wrote:
> However an improved "sdparm -i" is not what you seem to be
> asking for. Most of the above information is derived from
> the response to the IDENTIFY [PACKET] DEVICE ATA command.
> There seems to be two options for providing this:
>   1) libata to implement ioctls like HDIO_GET_IDENTITY
>   2) libata to implement SCSI ATA Translation [SAT]
>      facilities such as:
>        a) the ATA Information VPD page
>        b) SCSI ATA pass through commands
>        c) MODE SELECT SCSI command
> 
> Option 1) is the simplest but it requires that the SAT layer
> is on the host computer [as it is in the case of libata].
> Hopefully external USB and Firewire storage enclosures will
> be enhanced to support the [draft] SAT standard and in
> that case the SAT layer will be in the enclosure. SATA
> disks [and S-ATAPI devices] in a SAS fabric may either
> tunnel through the SAS fabric [via SAS Tunnelling Protocol
> [STP]] or have a SAT layer in the fabric [typically in the
> enclosure holding the disks].

There will be no SAT layer in a SAS fabric.  STP is just
that, a _tunneling_ protocol.  Thus, either in Option 1,
or Option 2 if you want to present the device to
SCSI Core as a SCSI Device you need SAT somewhere below
SCSI Core (on the host).

In general, lower (hardware) layers want to do the
_absolute_ minimum as far as their function is concerned.

Thus, for example, you can expect an incomplete
USB/IEEE1394 SAT layer on the device.

> Only the STP route allows for option 1) .

Option 2 as well: you'll just treat the device as
SCSI and SAT will emulate as much as possible.

	Luben

