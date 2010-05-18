From: Hannes Reinecke <hare@suse.de>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Tue, 18 May 2010 11:43:04 +0200
Message-ID: <4BF26128.2030400@suse.de>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>	 <4BECFA39.7040809@suse.de>	 <1273830134.27867.44.camel@haakon2.linux-iscsi.org> <1274130584.7348.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1274130584.7348.83.camel@haakon2.linux-iscsi.org>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger wrote:
> On Fri, 2010-05-14 at 02:42 -0700, Nicholas A. Bellinger wrote:
>> On Fri, 2010-05-14 at 09:22 +0200, Hannes Reinecke wrote:
>>> Nicholas A. Bellinger wrote:
>>>> Greetings Hannes and co,
>>>>
>> <SNIP>
>>> Let's see if I can find some time working on the megasas emulation.
>>> Maybe I find something.
>>> Last time I checked it was with a Windows7 build, but I didn't do
>>> any real tests there. Basically just checking if the system boots u=
p :-)
>>>
>> Nothing fancy just yet.  This is involving a normal NTFS filesystem
>> format on a small TCM/FILEIO LUN using scsi-generic and a userspace
>> FILEIO with scsi-disk.
>>
>> This involves the XP guest waiting until the very last READ_10 once =
the
>> format has completed (eg: all WRITE and VERIFY CDBs complete with GO=
OD
>> status AFAICT) before announcing that mkfs.ntfs failed without any
>> helpful exception message (due to missing metadata of some sort I wo=
uld
>> assume..?)
>>
>> So perhaps dumping QEMU and TCM_Loop SCSI payloads to determine if a=
ny
>> correct blocks from megasas_handle_io() are actually making it out t=
o
>> KVM host is going to be my next option.  ;)
>>
>=20
> Greetings Hannes,
>=20
> So I spent some more time with XP guests this weekend, and I noticed =
two
> things immediately when using hw/lsi53c895a.c instead of hw/megasas.c
> with the same two TCM_Loop SAS LUNs via SG_IO from last week:
>=20
> 1) With lsi53c895a, XP guests are able to boot successfully w/ out th=
e
> synchronous SG_IO hack that is currently required to get past the fir=
st
> 36-byte INQUIRY for megasas + XP SP2
>=20
> 2) With lsi53c895a, XP is able to successfully create and mount a NTF=
S
> filesystem, reboot, and read blocks appear to be functioning properly=
=2E
> FYI I have not run any 'write known pattern then read-back and compar=
e
> blocks' data integrity tests from with in the XP guests just yet, but=
 I
> am confident that TCM scatterlist -> se_mem_t mapping is working as
> expected on the KVM Host.
>=20
> Futhermore, after formatting a 5 GB TCM/FILEIO LUN with lsi53c895a, a=
nd
> then rebooting with megasas with the same two configured TCM_Loop SG_=
IO
> devices, it appears to be able to mount and read blocks successfully.
> Attempting to write new blocks on the mounted filesystem also appears=
 to
> work to some degree, but throughput slows down to a crawl during XP
> guest buffer cache flush, which is likely attributed to the use of my
> quick SYNC SG_IO hack.
>=20
> So it appears that there are two seperate issues here, and AFAICT the=
y
> both look to be XP and megasas specific.  For #2, it may be something
> about the format of the incoming scatterlists generated during XP's
> mkfs.ntfs that is causing some issues.  While watching output during =
fs
> creation, I noticed the following WRITE_10s with a starting 4088 byte
> scatterlist and a trailing 8 byte scatterlist:
>=20
> megasas: writel mmio 40: 2b0b003
> megasas: Found mapped frame 2 context 82b0b000 pa 2b0b000
> megasas: Enqueue frame context 82b0b000 tail 493 busy 1
> megasas: LD SCSI dev 2 lun 0 sdev 0xdc0230 xfer 16384
> scsi-generic: Using cur_addr: 0x000000000ff6c008 cur_len: 0x000000000=
0000ff8
> scsi-generic: Adding iovec for mem: 0x7f1783b96008 len: 0x00000000000=
00ff8
> scsi-generic: Using cur_addr: 0x000000000fd6e000 cur_len: 0x000000000=
0001000
> scsi-generic: Adding iovec for mem: 0x7f1783998000 len: 0x00000000000=
01000
> scsi-generic: Using cur_addr: 0x000000000fe2f000 cur_len: 0x000000000=
0001000
> scsi-generic: Adding iovec for mem: 0x7f1783a59000 len: 0x00000000000=
01000
> scsi-generic: Using cur_addr: 0x000000000fdf0000 cur_len: 0x000000000=
0001000
> scsi-generic: Adding iovec for mem: 0x7f1783a1a000 len: 0x00000000000=
01000
> scsi-generic: Using cur_addr: 0x000000000fded000 cur_len: 0x000000000=
0000008
> scsi-generic: Adding iovec for mem: 0x7f1783a17000 len: 0x00000000000=
00008
> scsi-generic: execute IOV: iovec_count: 5, dxferp: 0xd92420, dxfer_le=
n: 16384
> scsi-generic: -----------------------> Issuing SG_IO CDB len 10: 0x2a=
 00 00 00 fa be 00 00 20 00=20
> scsi-generic: scsi_write_complete() ret =3D 0
> scsi-generic: Command complete 0x0xd922c0 tag=3D0x82b0b000 status=3D0
> megasas: LD SCSI req 0xd922c0 cmd 0xda92c0 lun 0xdc0230 finished with=
 status 0 len 16384
> megasas: Complete frame context 82b0b000 tail 493 busy 0 doorbell 0
>=20
> Also, the final READ_10 that produces the 'could not create filesyste=
m'
> exception is for LBA 63 and XP looking for the first FS blocks after
> GPT.
>=20
> Could there be some breakage in megasas with a length < PAGE_SIZE for
> the scatterlist..?    As lsi53c895a seems to work OK for this case, i=
s
> there something about the logic of parsing the incoming struct
> scatterlists that is different between the two HBA drivers..?  AFAICT
> both are using Gerd's common code in hw/scsi-bus.c, unless there is
> something about megasas_map_sgl() that is causing issues with the
> above..?
>=20

The usual disclaimer here: I'm less than happy with the current SCSI di=
sk handling.
Currently we have the two options:
- Using 'scsi-disk', which will _emulate_ a SCSI disk internally, but a=
llow to use
  asynchronous I/O using normal read/write syscalls
- Using 'scsi-generic', which will allow you to pass-through any SCSI d=
evice, but
  disallow asynchronous I/O and requires you to use the SG_IO interface=
=2E
The latter also implies that the host will mark _all_ I/O commands as '=
block_pc',
so the code path within the kernel is quite different from those taken =
by I/Os
coming in via the 'scsi-disk' emulation.
Guess it's time to have a 'scsi-passthrough' device ...

Other than that: Think we have to investigate.
If you could send me a quite setup guide on how to configure TCM_Loop f=
or an
existing device I'd give it a go ...

Thanks,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
