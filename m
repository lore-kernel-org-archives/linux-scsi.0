From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi with ide-hd?
Date: Fri, 06 Dec 2002 21:28:47 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DF07BDF.8070907@torque.net>
References: <3DF06AD0.5070507@rzg.mpg.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Soddemann <Thomas.Soddemann@rzg.mpg.de>
Cc: linux-scsi@vger.kernel.org

Thomas Soddemann wrote:
> Hi,
> 
> does anybody know whether there is there a possibility to use ide-scsi 
> in connection with an IDE HD?

No, "ide" disks use the ATA standards (reference: www.t13.org)
while ide tapes, floppies and cdroms tend to use the ATA
Packet Interface (ATAPI) which is essentially a SCSI
command set over an ide transport. The command set used by
cdwriters is MMC (reference: www.t10.org ).

> If so, where can I get more information from? By looking at the source 
> of ide-scsi I get the impression, that only IDE devices work, which have 
> a kind of SCSI origin.

SCSI standards (www.t10.org) are essentially split into two layers:
   - command sets (e.g. primary (SPC),  block (SBC),
     multi-media? (MMC) )
   - transports (e.g. parallel (SPI), fibre channel (FCP),
     ieee1394 (sbp) )

The definitions of some important transports (e.g. ATAPI
and USB mass storage) are found at their respective sites
(i.e. not on www.t10.org ).

> The intention is to use IDE HDs via the ide-scsi driver in connection 
> with a special file system (GPFS), since it does not (at least not 
> officially) support IDE drives. 

The ide-scsi driver looks like it is going away in the
2.5 series **. Cdrecord controlled cd/dvd writers via the
sg driver which used the ide-scsi driver to access
ATAPI devices. The SG_IO ioctl inside the sg driver
been ported to the block level so now cdrecord
can control both ATAPI writers directly via their
block devices (e.g. /dev/hdd) and "real" SCSI (or
pseudos like USB and 1394) via their block devices
(e.g. /dev/sdc0).

Unfortunately none of this helps you with an ATA _disk_.

> Single node harddisk performance is not 
> really an issue, since GPFS is a parallel filesystem, and it will be 
> used with GBit Ethernet, in our case.


** Are there ATAPI tape drives using the ide-scsi driver?


Doug Gilbert


