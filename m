From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into
	Windows XP guests
Date: Sat, 29 May 2010 21:25:34 -0700
Message-ID: <1275193534.15413.44.camel@haakon2.linux-iscsi.org>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
	<4BECFA39.7040809@suse.de>
	<1273830134.27867.44.camel@haakon2.linux-iscsi.org>
	<1274130584.7348.83.camel@haakon2.linux-iscsi.org>
	<4BF26128.2030400@suse.de>
	<1274181508.7348.181.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1274181508.7348.181.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <http://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <http://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@suse.de>, Gerd Hoffmann <kraxel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-05-18 at 04:18 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2010-05-18 at 11:43 +0200, Hannes Reinecke wrote:
> > Nicholas A. Bellinger wrote:
> > > On Fri, 2010-05-14 at 02:42 -0700, Nicholas A. Bellinger wrote:
> > > Greetings Hannes,
> > > 
> > > So I spent some more time with XP guests this weekend, and I noticed two
> > > things immediately when using hw/lsi53c895a.c instead of hw/megasas.c
> > > with the same two TCM_Loop SAS LUNs via SG_IO from last week:
> > > 
> > > 1) With lsi53c895a, XP guests are able to boot successfully w/ out the
> > > synchronous SG_IO hack that is currently required to get past the first
> > > 36-byte INQUIRY for megasas + XP SP2
> > > 
> > > 2) With lsi53c895a, XP is able to successfully create and mount a NTFS
> > > filesystem, reboot, and read blocks appear to be functioning properly.
> > > FYI I have not run any 'write known pattern then read-back and compare
> > > blocks' data integrity tests from with in the XP guests just yet, but I
> > > am confident that TCM scatterlist -> se_mem_t mapping is working as
> > > expected on the KVM Host.
> > > 
> > > Futhermore, after formatting a 5 GB TCM/FILEIO LUN with lsi53c895a, and
> > > then rebooting with megasas with the same two configured TCM_Loop SG_IO
> > > devices, it appears to be able to mount and read blocks successfully.
> > > Attempting to write new blocks on the mounted filesystem also appears to
> > > work to some degree, but throughput slows down to a crawl during XP
> > > guest buffer cache flush, which is likely attributed to the use of my
> > > quick SYNC SG_IO hack.
> > > 
> > > So it appears that there are two seperate issues here, and AFAICT they
> > > both look to be XP and megasas specific.  For #2, it may be something
> > > about the format of the incoming scatterlists generated during XP's
> > > mkfs.ntfs that is causing some issues.  While watching output during fs
> > > creation, I noticed the following WRITE_10s with a starting 4088 byte
> > > scatterlist and a trailing 8 byte scatterlist:
> > > 
> > > megasas: writel mmio 40: 2b0b003
> > > megasas: Found mapped frame 2 context 82b0b000 pa 2b0b000
> > > megasas: Enqueue frame context 82b0b000 tail 493 busy 1
> > > megasas: LD SCSI dev 2 lun 0 sdev 0xdc0230 xfer 16384
> > > scsi-generic: Using cur_addr: 0x000000000ff6c008 cur_len: 0x0000000000000ff8
> > > scsi-generic: Adding iovec for mem: 0x7f1783b96008 len: 0x0000000000000ff8
> > > scsi-generic: Using cur_addr: 0x000000000fd6e000 cur_len: 0x0000000000001000
> > > scsi-generic: Adding iovec for mem: 0x7f1783998000 len: 0x0000000000001000
> > > scsi-generic: Using cur_addr: 0x000000000fe2f000 cur_len: 0x0000000000001000
> > > scsi-generic: Adding iovec for mem: 0x7f1783a59000 len: 0x0000000000001000
> > > scsi-generic: Using cur_addr: 0x000000000fdf0000 cur_len: 0x0000000000001000
> > > scsi-generic: Adding iovec for mem: 0x7f1783a1a000 len: 0x0000000000001000
> > > scsi-generic: Using cur_addr: 0x000000000fded000 cur_len: 0x0000000000000008
> > > scsi-generic: Adding iovec for mem: 0x7f1783a17000 len: 0x0000000000000008
> > > scsi-generic: execute IOV: iovec_count: 5, dxferp: 0xd92420, dxfer_len: 16384
> > > scsi-generic: -----------------------> Issuing SG_IO CDB len 10: 0x2a 00 00 00 fa be 00 00 20 00 
> > > scsi-generic: scsi_write_complete() ret = 0
> > > scsi-generic: Command complete 0x0xd922c0 tag=0x82b0b000 status=0
> > > megasas: LD SCSI req 0xd922c0 cmd 0xda92c0 lun 0xdc0230 finished with status 0 len 16384
> > > megasas: Complete frame context 82b0b000 tail 493 busy 0 doorbell 0
> > > 
> > > Also, the final READ_10 that produces the 'could not create filesystem'
> > > exception is for LBA 63 and XP looking for the first FS blocks after
> > > GPT.
> > > 
> > > Could there be some breakage in megasas with a length < PAGE_SIZE for
> > > the scatterlist..?    As lsi53c895a seems to work OK for this case, is
> > > there something about the logic of parsing the incoming struct
> > > scatterlists that is different between the two HBA drivers..?  AFAICT
> > > both are using Gerd's common code in hw/scsi-bus.c, unless there is
> > > something about megasas_map_sgl() that is causing issues with the
> > > above..?
> > > 
> > 
> > The usual disclaimer here: I'm less than happy with the current SCSI disk handling.
> > Currently we have the two options:
> > - Using 'scsi-disk', which will _emulate_ a SCSI disk internally, but allow to use
> >   asynchronous I/O using normal read/write syscalls
> > - Using 'scsi-generic', which will allow you to pass-through any SCSI device, but
> >   disallow asynchronous I/O and requires you to use the SG_IO interface.
> 
> Well, this is only true so far for the SYNC SG_IO patch with KVM XP
> guests.  The asynchronous I/O still works as expected for Linux KVM
> guests for 10 Gb/sec sec throughput.
> 
> > The latter also implies that the host will mark _all_ I/O commands as 'block_pc',
> > so the code path within the kernel is quite different from those taken by I/Os
> > coming in via the 'scsi-disk' emulation.
> > Guess it's time to have a 'scsi-passthrough' device ...
> 
> Currently with QEMU-KVM hw/scsi-generic.c and STGT usr/bs_sg.c we are
> expecting driver/scsi/sg.c:sg_start_req() to the passed return
> hp->iov_count..
> 

Greetings Hannes and Gerd,

Just a quick update on this one..  After giving MEGASAS with shot with
Windows 7 x64, I am able to successfully format, mount and copy blocks
to a TCM/FILEIO LUN backstore and TCM_Loop SAS target port with SG_IO:

http://www.linux-iscsi.org/index.php/Image:TCM-KVM-Megasas-8708EM2-Windows7-x64.png

The 8708EM2 driver for the emulated LSI DFI PowerPC RAID Core was
automatically configured and did not require any extra setup once
megasas emulation was enabled from the QEMU CLI.  Seriously, a very
splended job Dr. Hannes.  8-)

Also it's worth mentioning that I am still running C: on QEMU IDE
emulation, as I could not quite figure out how to boot for a megasas LD
with option-rom.  What QEMU CLI ops where requried to make this work
again..?

Anyways, the issue remains in the megasas friendly qemu-kvm.git tree and
still appears to be specific to hw/megasas.c LDs for a v2.6.34 KVM
x86_64 host into 32-bit XP guests with both scsi-disk and scsi-generic
QEMU backstores.  I am thinking about having a look with the
i386-softmmu target and see if that makes any difference..  What do you
think..?

Best,

--nab
