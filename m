From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 5 Aug 2008 10:54:27 -0600
Message-ID: <20080805165426.GA2055@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <20080801161149.GA26461@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080801161149.GA26461@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2008 at 10:11:49AM -0600, Matthew Wilcox wrote:
> Are they SCSI?  I just got round to trying 4k sector sizes in ata_ram
> (after adding file backed capability) and found that libata currently
> silently ignores the identify bits that report sector size.  I'll work
> on fixing that this afternoon if nobody beats me to it.

OK, I have patches.  I'll send them to linux-ide.  If anyone wants to
try them, I pushed out two trees; one for libata:

http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-large-sectors

and one for ata_ram supporting:
 - large sectors
 - file backing
http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram

I hope that will help some more people do testing.

Here's the dmesg from running:

$ sudo modprobe ata_ram sector_size=4096 capacity=262144 nr_ports=2

(note that you'll need at least 2.5GB of ram in your machine to try this,
or Linux gets really unhappy.  You can, of course, reduce the capacity.
Would there be interest in a lazily allocated option for ata_ram?)

[ 1134.017240] scsi7 : ata_ram
[ 1134.017420] scsi8 : ata_ram
[ 1134.017489] ata8: SATA max UDMA/133 ata_ram_0
[ 1134.017495] ata9: SATA max UDMA/133 ata_ram_1
[ 1134.017557] ata8.00: ATA-8: Linux RAM Drive, 0.01, max UDMA7
[ 1134.017563] ata8.00: 262144 sectors, multi 0: LBA 
[ 1134.017602] ata8.00: configured for UDMA/133
[ 1134.017631] ata9.00: ATA-8: Linux RAM Drive, 0.01, max UDMA7
[ 1134.017636] ata9.00: 262144 sectors, multi 0: LBA 
[ 1134.017668] ata9.00: configured for UDMA/133
[ 1134.035741] scsi 7:0:0:0: Direct-Access     ATA      Linux RAM Drive  0.01 PQ: 0 ANSI: 5
[ 1134.035904] sd 7:0:0:0: [sdb] 262144 4096-byte hardware sectors (1074 MB)
[ 1134.035926] sd 7:0:0:0: [sdb] Write Protect is off
[ 1134.035932] sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 1134.035961] sd 7:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1134.036039] sd 7:0:0:0: [sdb] 262144 4096-byte hardware sectors (1074 MB)
[ 1134.036061] sd 7:0:0:0: [sdb] Write Protect is off
[ 1134.036066] sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 1134.036095] sd 7:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1134.036119]  sdb: unknown partition table
[ 1134.036276] sd 7:0:0:0: [sdb] Attached SCSI disk
[ 1134.036463] sd 7:0:0:0: Attached scsi generic sg2 type 0
[ 1134.036607] scsi 8:0:0:0: Direct-Access     ATA      Linux RAM Drive  0.01 PQ: 0 ANSI: 5
[ 1134.036749] sd 8:0:0:0: [sdc] 262144 4096-byte hardware sectors (1074 MB)
[ 1134.036768] sd 8:0:0:0: [sdc] Write Protect is off
[ 1134.036774] sd 8:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1134.036803] sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1134.036869] sd 8:0:0:0: [sdc] 262144 4096-byte hardware sectors (1074 MB)
[ 1134.036888] sd 8:0:0:0: [sdc] Write Protect is off
[ 1134.036895] sd 8:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 1134.036924] sd 8:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1134.036944]  sdc: unknown partition table
[ 1134.037082] sd 8:0:0:0: [sdc] Attached SCSI disk
[ 1134.037182] sd 8:0:0:0: Attached scsi generic sg3 type 0

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
