From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Fri, 23 Sep 2005 10:23:27 +1000
Message-ID: <43334AFF.8010901@torque.net>
References: <7744a2840509221206254d2109@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <7744a2840509221206254d2109@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Richard Bollinger <rabollinger@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Richard Bollinger wrote:
> Is there a program for SATA drives which reveals the depth of
> information that "hdparm -i" does for IDE drives?  sdparm reveals
> almost nothing in comparison:
> 
> # sdparm -i /dev/sda
>     /dev/sda: ATA       WDC WD3200JD-00K  08.0
> Device identification VPD page:
>   Addressed logical unit:
>     id_type: vendor specific [0x0],  code_set: ASCII
>  00     4c 69 6e 75 78 20 41 54  41 2d 53 43 53 49 20 73    Linux ATA-SCSI s
>  10     69 6d 75 6c 61 74 6f 72                             imulator

Richard,
libata needs to improve the information it provides for
the Device Identification VPD page [0x83]. For example
as defined in section 10.3.4.2 in the just released sat-r06 .
Something approaching a world wide unique identifier is
needed.

> # hdparm -i /dev/hda
> 
> /dev/hda:
> 
>  Model=WDC WD800BB-00JHC0, FwRev=05.01C05, SerialNo=WD-MAM96054404
>  Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs mtGapReq }
>  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=66
>  BuffType=unknown, BuffSize=2048kB, MaxMultSect=16, MultSect=off
>  CurCHS=16383/16/63, CurSects=-66060037, LBA=yes, LBAsects=156301488
>  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
>  PIO modes: pio0 pio3 pio4
>  DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
>  AdvancedPM=no
>  Drive Supports : Reserved : ATA-1 ATA-2 ATA-3 ATA-4 ATA-5 ATA-6

However an improved "sdparm -i" is not what you seem to be
asking for. Most of the above information is derived from
the response to the IDENTIFY [PACKET] DEVICE ATA command.
There seems to be two options for providing this:
  1) libata to implement ioctls like HDIO_GET_IDENTITY
  2) libata to implement SCSI ATA Translation [SAT]
     facilities such as:
       a) the ATA Information VPD page
       b) SCSI ATA pass through commands
       c) MODE SELECT SCSI command

Option 1) is the simplest but it requires that the SAT layer
is on the host computer [as it is in the case of libata].
Hopefully external USB and Firewire storage enclosures will
be enhanced to support the [draft] SAT standard and in
that case the SAT layer will be in the enclosure. SATA
disks [and S-ATAPI devices] in a SAS fabric may either
tunnel through the SAS fabric [via SAS Tunnelling Protocol
[STP]] or have a SAT layer in the fabric [typically in the
enclosure holding the disks]. Only the STP route allows for
option 1) .

I have published some patches for 2 a) and 2 c) and someone
else has published some patches for 2 b). I am unaware
if any have been accepted into libata yet.

Option 2) still needs an application client to output
information like "hdparm -i". "sdparm --page=ai" will
do this at a lower level if 2) a is implemented in
libata. Another approach is to make the hdparm application
libata aware and issue [shock horror] SCSI commands :-)

hdparm has a "-Istdin" command line option which accepts
the raw (binary) IDENTIFY x DEVICE response. So
implementing option 2 a), using sg_inq, dd and finally
hdparm could do it. That is a bit convoluted.

Doug Gilbert





