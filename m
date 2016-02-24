From: Helge Deller <deller@gmx.de>
Subject: Re: [BUG] "block: make generic_make_request handle arbitrarily sized
 bios" breaks boot on parisc-linux
Date: Wed, 24 Feb 2016 22:36:38 +0100
Message-ID: <56CE2266.6010909@gmx.de>
References: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
 <CACVXFVOnff1sFfMH+zsoypuYwM4PokJkHeKhbxJYDDH6ZtVScg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <CACVXFVOnff1sFfMH+zsoypuYwM4PokJkHeKhbxJYDDH6ZtVScg@mail.gmail.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, John David Anglin <dave.anglin@bell.net>
Cc: linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-parisc List <linux-parisc@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming Lei,

On 24.02.2016 08:59, Ming Lei wrote:
> On Wed, Feb 24, 2016 at 10:28 AM, John David Anglin
> <dave.anglin@bell.net> wrote:
>> The following block change breaks boot on parisc-linux:
>>
>> commit 54efd50bfd873e2dbf784e0b21a8027ba4299a3e
>> Author: Kent Overstreet <kent.overstreet@gmail.com>
>> Date:   Thu Apr 23 22:37:18 2015 -0700
>>
>>    block: make generic_make_request handle arbitrarily sized bios
>>
>>    The way the block layer is currently written, it goes to great lengths
>>    to avoid having to split bios; upper layer code (such as bio_add_page())
>>    checks what the underlying device can handle and tries to always create
>>    bios that don't need to be split.
>>
>>    But this approach becomes unwieldy and eventually breaks down with
>>    stacked devices and devices with dynamic limits, and it adds a lot of
>>    complexity. If the block layer could split bios as needed, we could
>>    eliminate a lot of complexity elsewhere - particularly in stacked
>>    drivers. Code that creates bios can then create whatever size bios are
>>    convenient, and more importantly stacked drivers don't have to deal with
>>    both their own bio size limitations and the limitations of the
>>    (potentially multiple) devices underneath them.  In the future this will
>>    let us delete merge_bvec_fn and a bunch of other code.
>>
>>    We do this by adding calls to blk_queue_split() to the various
>>    make_request functions that need it - a few can already handle arbitrary
>>    size bios. Note that we add the call _after_ any call to
>>    blk_queue_bounce(); this means that blk_queue_split() and
>>    blk_recalc_rq_segments() don't need to be concerned with bouncing
>>    affecting segment merging.
>>
>>    Some make_request_fn() callbacks were simple enough to audit and verify
>>    they don't need blk_queue_split() calls. The skipped ones are:
>>
>>     * nfhd_make_request (arch/m68k/emu/nfblock.c)
>>     * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
>>     * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
>>     * brd_make_request (ramdisk - drivers/block/brd.c)
>>     * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
>>     * loop_make_request
>>     * null_queue_bio
>>     * bcache's make_request fns
>>
>>    Some others are almost certainly safe to remove now, but will be left
>>    for future patches.
>>
>>    Cc: Jens Axboe <axboe@kernel.dk>
>>    Cc: Christoph Hellwig <hch@infradead.org>
>>    Cc: Al Viro <viro@zeniv.linux.org.uk>
>>    Cc: Ming Lei <ming.lei@canonical.com>
>>    Cc: Neil Brown <neilb@suse.de>
>>    Cc: Alasdair Kergon <agk@redhat.com>
>>    Cc: Mike Snitzer <snitzer@redhat.com>
>>    Cc: dm-devel@redhat.com
>>    Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
>>    Cc: drbd-user@lists.linbit.com
>>    Cc: Jiri Kosina <jkosina@suse.cz>
>>    Cc: Geoff Levand <geoff@infradead.org>
>>    Cc: Jim Paris <jim@jtan.com>
>>    Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
>>    Cc: Minchan Kim <minchan@kernel.org>
>>    Cc: Nitin Gupta <ngupta@vflare.org>
>>    Cc: Oleg Drokin <oleg.drokin@intel.com>
>>    Cc: Andreas Dilger <andreas.dilger@intel.com>
>>    Acked-by: NeilBrown <neilb@suse.de> (for the 'md/md.c' bits)
>>    Acked-by: Mike Snitzer <snitzer@redhat.com>
>>    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>>    Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>>    [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
>>    Signed-off-by: Dongsu Park <dpark@posteo.net>
>>    Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
>>    Signed-off-by: Jens Axboe <axboe@fb.com>
>>
>> This thread on the linux-parisc has most of the discussion and analysis:
>> http://www.spinics.net/lists/linux-parisc/msg06710.html
>>
>> Essentially, the SCSI layer underestimates the number of sg segments needed and we run off the end of the sg list and crash.
>> This happens because the protect bit is ignored.  As a result 4.3 and later kernels fail to boot.  This includes the current Debian
>> kernel for hppa.
>>
>> Hopefully, the block group can help resolve this issue.  We can help with testing if needed.
>>
> 
> We fixed several similar bugs, but maybe there is another one, :-(

Thanks for your help!

> Could you apply the attached debug patch and post the log after the issue is
> triggered?

Sadly I was not yet able to produce the requested output for you.
It seems we have - probably triggered due to the block splitting itself - some kind of memory/stack
corruption in here as well. Note, the stack grows upwards(!) on parisc, so maybe local variables
get overwritten somehow...?

First I applied your patch as is. 
Here is the system log so far:

[   24.940000] cdrom: Uniform CD-ROM driver Revision: 3.20
[   25.000000] sd 3:0:6:0: [sdb] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
[   25.092000] sd 3:0:5:0: [sda] Write Protect is off
[   25.152000] sd 3:0:5:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   25.268000] sd 3:0:6:0: [sdb] Write Protect is off
[   25.328000] sd 3:0:6:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   25.452000]  sda: sda1 sda2 sda3 < sda5 sda6 >
[   25.508000]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
[   25.584000] scsi_id(112): unaligned access to 0x00000000facac009 at ip=0x000000004100390b
[   25.688000] sd 3:0:6:0: [sdb] Attached SCSI disk
[   25.752000] sd 3:0:5:0: [sda] Attached SCSI disk
[   25.840000] scsi_id(113): unaligned access to 0x00000000fa799009 at ip=0x000000004100390b
[   25.972000] random: nonblocking pool is initialized
[   26.064000] ------------[ cut here ]------------
[   26.120000] WARNING: at /build/linux-4.4/linux-4.4.2/block/blk-merge.c:484
[   26.200000] Modules linked in: sd_mod sr_mod cdrom ata_generic ohci_pci ehci_pci ohci_hcd ehci_hcd pata_ns87415 libata sym53c8xx scsi_transport_spi usbcore usb_common scsi_mod tulip
[   26.396000] CPU: 0 PID: 67 Comm: systemd-udevd Not tainted 4.4.0-1-parisc64-smp #7 Debian 4.4.2-2
[   26.504000] task: 00000000bbe96b18 ti: 00000000bbf00000 task.ti: 00000000bbf00000
[   26.592000]
[   26.608000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[   26.664000] PSW: 00001000000001001111111100001110 Not tainted
[   26.736000] r00-03  000000ff0804ff0e 00000000409e9280 00000000404f22a4 00000000bbf011e0

Here it stops. Usually you would see a stack backtrace now, but as I mentioned above
maybe the stack got corrupted and as such your tracing code is not being executed.

Then I moved the WARN_ON behind you tracing code. With that I got:

[   25.352000] cdrom: Uniform CD-ROM driver Revision: 3.20
[   25.444000]  sda: sda1 sda2 sda3 < sda5 sda6 >
[   25.496000]  sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 >
[   25.568000] sd 3:0:5:0: [sda] Attached SCSI disk
[   25.644000] scsi_id(112): unaligned access to 0x00000000fae80009 at ip=0x000000004100390b
[   25.752000] sd 3:0:6:0: [sdb] Attached SCSI disk
[   25.836000] scsi_id(113): unaligned access to 0x00000000fac76009 at ip=0x000000004100390b
[   25.988000] random: nonblocking pool is initialized
[   26.048000] ------------[ cut here ]------------
[   26.104000] kernel BUG at /build/linux-4.4/linux-4.4.2/include/linux/scatterlist.h:92!
[   26.196000] CPU: 0 PID: 68 Comm: systemd-udevd Not tainted 4.4.0-1-parisc64-smp #8 Debian 4.4.2-2
[   26.304000] task: 00000000bbeb40f8 ti: 00000000bbf08000 task.ti: 00000000bbf08000
[   26.392000] 
[   26.412000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[   26.468000] PSW: 00001000000001001111111100001110 Not tainted
[   26.536000] r00-03  000000ff0804ff0e 00000000bbf091e0 00000000404f228c 00000000bbf091e0
[   26.632000] r04-07  00000000409b3a80 0000000000005000 0000000000000000 0000000000001000
[   26.728000] r08-11  000000000000001b 00000000000001b0 00000000bfd6e0f0 00000000bbe15a60
[   26.824000] r12-15  0000000000000000 0000000000000000 0000000000000003 000000007fa95178

Again, no stack backtrace.

Maybe Dave has more luck, otherwise I'll continue to try to get some info.

Helge
