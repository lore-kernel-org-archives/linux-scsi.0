From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Tue, 18 May 2010 04:18:28 -0700
Message-ID: <1274181508.7348.181.camel@haakon2.linux-iscsi.org>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
	 <4BECFA39.7040809@suse.de>
	 <1273830134.27867.44.camel@haakon2.linux-iscsi.org>
	 <1274130584.7348.83.camel@haakon2.linux-iscsi.org>
	 <4BF26128.2030400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:24370 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752219Ab0ERLSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2010 07:18:34 -0400
In-Reply-To: <4BF26128.2030400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>, Gerd Hoffmann <kraxel@redhat.com>

On Tue, 2010-05-18 at 11:43 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > On Fri, 2010-05-14 at 02:42 -0700, Nicholas A. Bellinger wrote:
> >> On Fri, 2010-05-14 at 09:22 +0200, Hannes Reinecke wrote:
> >>> Nicholas A. Bellinger wrote:
> >>>> Greetings Hannes and co,
> >>>>
> >> <SNIP>
> >>> Let's see if I can find some time working on the megasas emulation.
> >>> Maybe I find something.
> >>> Last time I checked it was with a Windows7 build, but I didn't do
> >>> any real tests there. Basically just checking if the system boots up :-)
> >>>
> >> Nothing fancy just yet.  This is involving a normal NTFS filesystem
> >> format on a small TCM/FILEIO LUN using scsi-generic and a userspace
> >> FILEIO with scsi-disk.
> >>
> >> This involves the XP guest waiting until the very last READ_10 once the
> >> format has completed (eg: all WRITE and VERIFY CDBs complete with GOOD
> >> status AFAICT) before announcing that mkfs.ntfs failed without any
> >> helpful exception message (due to missing metadata of some sort I would
> >> assume..?)
> >>
> >> So perhaps dumping QEMU and TCM_Loop SCSI payloads to determine if any
> >> correct blocks from megasas_handle_io() are actually making it out to
> >> KVM host is going to be my next option.  ;)
> >>
> > 
> > Greetings Hannes,
> > 
> > So I spent some more time with XP guests this weekend, and I noticed two
> > things immediately when using hw/lsi53c895a.c instead of hw/megasas.c
> > with the same two TCM_Loop SAS LUNs via SG_IO from last week:
> > 
> > 1) With lsi53c895a, XP guests are able to boot successfully w/ out the
> > synchronous SG_IO hack that is currently required to get past the first
> > 36-byte INQUIRY for megasas + XP SP2
> > 
> > 2) With lsi53c895a, XP is able to successfully create and mount a NTFS
> > filesystem, reboot, and read blocks appear to be functioning properly.
> > FYI I have not run any 'write known pattern then read-back and compare
> > blocks' data integrity tests from with in the XP guests just yet, but I
> > am confident that TCM scatterlist -> se_mem_t mapping is working as
> > expected on the KVM Host.
> > 
> > Futhermore, after formatting a 5 GB TCM/FILEIO LUN with lsi53c895a, and
> > then rebooting with megasas with the same two configured TCM_Loop SG_IO
> > devices, it appears to be able to mount and read blocks successfully.
> > Attempting to write new blocks on the mounted filesystem also appears to
> > work to some degree, but throughput slows down to a crawl during XP
> > guest buffer cache flush, which is likely attributed to the use of my
> > quick SYNC SG_IO hack.
> > 
> > So it appears that there are two seperate issues here, and AFAICT they
> > both look to be XP and megasas specific.  For #2, it may be something
> > about the format of the incoming scatterlists generated during XP's
> > mkfs.ntfs that is causing some issues.  While watching output during fs
> > creation, I noticed the following WRITE_10s with a starting 4088 byte
> > scatterlist and a trailing 8 byte scatterlist:
> > 
> > megasas: writel mmio 40: 2b0b003
> > megasas: Found mapped frame 2 context 82b0b000 pa 2b0b000
> > megasas: Enqueue frame context 82b0b000 tail 493 busy 1
> > megasas: LD SCSI dev 2 lun 0 sdev 0xdc0230 xfer 16384
> > scsi-generic: Using cur_addr: 0x000000000ff6c008 cur_len: 0x0000000000000ff8
> > scsi-generic: Adding iovec for mem: 0x7f1783b96008 len: 0x0000000000000ff8
> > scsi-generic: Using cur_addr: 0x000000000fd6e000 cur_len: 0x0000000000001000
> > scsi-generic: Adding iovec for mem: 0x7f1783998000 len: 0x0000000000001000
> > scsi-generic: Using cur_addr: 0x000000000fe2f000 cur_len: 0x0000000000001000
> > scsi-generic: Adding iovec for mem: 0x7f1783a59000 len: 0x0000000000001000
> > scsi-generic: Using cur_addr: 0x000000000fdf0000 cur_len: 0x0000000000001000
> > scsi-generic: Adding iovec for mem: 0x7f1783a1a000 len: 0x0000000000001000
> > scsi-generic: Using cur_addr: 0x000000000fded000 cur_len: 0x0000000000000008
> > scsi-generic: Adding iovec for mem: 0x7f1783a17000 len: 0x0000000000000008
> > scsi-generic: execute IOV: iovec_count: 5, dxferp: 0xd92420, dxfer_len: 16384
> > scsi-generic: -----------------------> Issuing SG_IO CDB len 10: 0x2a 00 00 00 fa be 00 00 20 00 
> > scsi-generic: scsi_write_complete() ret = 0
> > scsi-generic: Command complete 0x0xd922c0 tag=0x82b0b000 status=0
> > megasas: LD SCSI req 0xd922c0 cmd 0xda92c0 lun 0xdc0230 finished with status 0 len 16384
> > megasas: Complete frame context 82b0b000 tail 493 busy 0 doorbell 0
> > 
> > Also, the final READ_10 that produces the 'could not create filesystem'
> > exception is for LBA 63 and XP looking for the first FS blocks after
> > GPT.
> > 
> > Could there be some breakage in megasas with a length < PAGE_SIZE for
> > the scatterlist..?    As lsi53c895a seems to work OK for this case, is
> > there something about the logic of parsing the incoming struct
> > scatterlists that is different between the two HBA drivers..?  AFAICT
> > both are using Gerd's common code in hw/scsi-bus.c, unless there is
> > something about megasas_map_sgl() that is causing issues with the
> > above..?
> > 
> 
> The usual disclaimer here: I'm less than happy with the current SCSI disk handling.
> Currently we have the two options:
> - Using 'scsi-disk', which will _emulate_ a SCSI disk internally, but allow to use
>   asynchronous I/O using normal read/write syscalls
> - Using 'scsi-generic', which will allow you to pass-through any SCSI device, but
>   disallow asynchronous I/O and requires you to use the SG_IO interface.

Well, this is only true so far for the SYNC SG_IO patch with KVM XP
guests.  The asynchronous I/O still works as expected for Linux KVM
guests for 10 Gb/sec sec throughput.

> The latter also implies that the host will mark _all_ I/O commands as 'block_pc',
> so the code path within the kernel is quite different from those taken by I/Os
> coming in via the 'scsi-disk' emulation.
> Guess it's time to have a 'scsi-passthrough' device ...

Currently with QEMU-KVM hw/scsi-generic.c and STGT usr/bs_sg.c we are
expecting driver/scsi/sg.c:sg_start_req() to the passed return
hp->iov_count..

> 
> Other than that: Think we have to investigate.
> If you could send me a quite setup guide on how to configure TCM_Loop for an
> existing device I'd give it a go ...
> 

Sure, the setup for a TCM/IBLOCK device with the TCM_Loop fabric module
is:

tcm_node --block <$HBA/$DEV> <$UDEV_PATH>

and then setup the TCM_Loop virtual SAS endpoint LUN=0 with TCM/LIO 4.0
with a nexus and LUN=0 with:

tcm_loop --createnexus 1
tcm_loop --addlun <$SAS_TARGET_PORT> 1 0 $HBA/$DEV

Best,

--nab

