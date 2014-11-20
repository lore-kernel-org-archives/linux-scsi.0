From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 20 Nov 2014 19:27:49 +0100
Message-ID: <546E32A5.4040202@laposte.net>
References: <20141120060933.GA21432@infradead.org> <546E2880.5070303@laposte.net> <20141120175316.GA19590@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141120175316.GA19590@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here is the result of the command :

$ for i in /sys/class/scsi_host/*; do cat $i/can_queue; done
1
1
1
1
1
1
31
31

but the sata DVD burner is now connected on a Jmicron sata PCIe card (
with this configuration the bug doesn't occur ), I don't know if this
change can modify the result of your command,

here is the result of another command :

$ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
pata_jmicron
pata_jmicron
ata_piix
ata_piix
ata_piix
ata_piix
ahci
ahci

$ dmesg | grep ahci
[    0.883351] ahci 0000:03:00.0: version 3.0
[    0.883505] ahci 0000:03:00.0: AHCI 0001.0100 32 slots 2 ports 3 Gbp=
s
0x3 impl SATA mode
[    0.883508] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio
slum part
[    0.884329] scsi host6: ahci
[    0.884502] scsi host7: ahci

Le 20/11/2014 18:53, Christoph Hellwig a =E9crit :
> On Thu, Nov 20, 2014 at 06:44:32PM +0100, Barto wrote:
>> I notice that my motherboard doesn't support "AHCI" mode, my motherb=
oard
>> uses an ICH7 sata controler, ICH7 doesn't support AHCI if I check th=
e
>> technical specifications of this controler,
>>
>> it seems that my bios treats SATA devices like IDE devices ( IDE
>> emulation mode ), for example I can read in the bios these lines "ID=
E 0
>> channel master : "the name of Sata harddisk 1", "IDE 3 channel maste=
r :
>> "the name of Sata harddisk 2",
>>
>> perhaps the bug only occurs when the AHCI mode is not used ?
>=20
> Looks like it.  I suspect you device only supports a single outstandi=
ng
> command without AHCI, can you confirm this by doing:
>=20
> for i in /sys/class/scsi_host/*; do cat $i/can_queue; done
>=20
>=20
