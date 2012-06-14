From: Cong Meng <mc@linux.vnet.ibm.com>
Subject: Re: IO performance test on the tcm-vhost scsi
Date: Thu, 14 Jun 2012 17:57:34 +0800
Message-ID: <1339667854.28851.14.camel@mengcong>
References: <1339582392.24309.15.camel@mengcong>
	 <1339614481.13709.354.camel@haakon2.linux-iscsi.org>
Reply-To: mc@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1339614481.13709.354.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: qemu-devel@nongnu.org, target-devel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, Anthony Liguori <anthony@codemonkey.ws>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-06-13 at 12:08 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-06-13 at 18:13 +0800, mengcong wrote:
> > Hi folks, I did an IO performance test on the tcm-vhost scsi. I want to share 
> > the test result data here.
> > 
> > 
> >                     seq-read        seq-write       rand-read     rand-write
> >                     8k     256k     8k     256k     8k   256k     8k   256k
> > ----------------------------------------------------------------------------
> > bare-metal          67951  69802    67064  67075    1758 29284    1969 26360
> > tcm-vhost-iblock    61501  66575    51775  67872    1011 22533    1851 28216
> > tcm-vhost-pscsi     66479  68191    50873  67547    1008 22523    1818 28304
> > virtio-blk          26284  66737    23373  65735    1724 28962    1805 27774
> > scsi-disk           36013  60289    46222  62527    1663 12992    1804 27670
> > 
> > unit: KB/s
> > seq-read/write = sequential read/write
> > rand-read/write = random read/write
> > 8k,256k are blocksize of the IO
> > 
> > In tcm-vhost-iblock test, the emulate_write_cache attr was enabled.
> > In virtio-blk test, cache=none,aio=native were set.
> > In scsi-disk test, cache=none,aio=native were set, and LSI HBA was used.
> > 
> > I also tried to do the test with a scsi-generic LUN (pass through the 
> > physical partition /dev/sgX device). But I couldn't setup it
> > successfully. It's a pity.
> > 
> > Benchmark tool: fio, with ioengine=aio,direct=1,iodepth=8 set for all tests.
> > kvm vm: 2 cpus and 2G ram
> > 
> 
> These initial performance results look quite promising for virtio-scsi.
> 
> I'd be really interested to see how a raw flash block device backend
> that locally can do ~100K 4k mixed R/W random IOPs compares with
> virtio-scsi guest performance as the random small block fio workload
> increases..
flash block == Solid state disk? I have no one on hand. 
> 
> Also note there is a bottleneck wrt to random small block I/O
> performance (per LUN) on the Linux/SCSI initiator side that is effecting
> things here.  We've run into this limitation numerous times with using
> SCSI LLDs as backend TCM devices, and I usually recommend using iblock
> export with raw block flash backends for achieving the best small block
> random I/O performance results.  A number of high performance flash
> storage folks do something similar with raw block access (Jen's CC'ed)
> 
> As per Stefan's earlier question, how does virtio-scsi to QEMU SCSI
> userspace compare with these results..?  Is there a reason why these
> where not included in the initial results..?
> 
This should be a mistake I made. I will do this pattern later.

> Thanks Meng!
> 
> --nab
> 
