From: Barto <mister.freeman@laposte.net>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Mon, 24 Nov 2014 16:12:42 +0100
Message-ID: <54734AEA.7010102@laposte.net>
References: <20141120060933.GA21432@infradead.org> <546E2880.5070303@laposte.net> <20141120175316.GA19590@infradead.org> <546E32A5.4040202@laposte.net> <20141124091835.GA21579@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20141124091835.GA21579@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Christoph,

to be clear :

my JMicron pcie card JMB363/368 has 2 sata ports and one IDE port,
JMicron supports AHCI on these 2 sata ports,

my gigabyte motherboard has 4 sata ports and one IDE port, my gigabyte
motherboard doesn't support AHCI on these 4 sata ports ( my bios seems
to treats sata devices like IDE devices, a kind of "IDE emulation mode"=
 ),

the bug doesn't occur if the Sata DVD burner is not mixed with a hard
disk on the  Sata ports ( motherboard sata ports ),

the configuration who triggers the bug is mixing a slow device ( sata
dvd burner ) with a fast device ( sata harddisk ) on the sata ports of
the motherboard ( who doesn't support AHCI ),

the bug doesn't occur if the sata dvd burner is connected on a JMicron
pcie card because there is no other sata harddisks connected on this
JMicron, I connect only a IDE hardidsk on this JMicron pcie card and
also this Sata dvd burner in order to avoid the bug ( it's a workaround=
 ),

2 pata_jmicron =3D the IDE port in this JMicron pcie card ( master and =
slave )
4 ata_piix =3D 4 sata ports from the gigabyte motherboard, this ports
doesn't support AHCI
2 ahci =3D 2 sata ports in this JMicron pcie card

but another user has the same problem but with an IDE DVD burner ( mixe=
d
with an IDE hardidsk ) :

https://bugzilla.kernel.org/show_bug.cgi?id=3D87581#c18

this user has tested your patch and it solves the bug


Le 24/11/2014 10:18, Christoph Hellwig a =E9crit :
> On Thu, Nov 20, 2014 at 07:27:49PM +0100, Barto wrote:
>> but the sata DVD burner is now connected on a Jmicron sata PCIe card=
 (
>> with this configuration the bug doesn't occur ), I don't know if thi=
s
>> change can modify the result of your command,
>>
>> here is the result of another command :
>>
>> $ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
>> pata_jmicron
>> pata_jmicron
>> ata_piix
>> ata_piix
>> ata_piix
>> ata_piix
>> ahci
>> ahci
>=20
> Interesting.  So the jmicron card also has a queue depth of just one,
> but the error still occurs?  I've added the linux-ide list, maybe
> someone there has an idea how piix vs jmicron could have such differe=
nt
> behaviors for queueing or error handling.
>=20
>=20
