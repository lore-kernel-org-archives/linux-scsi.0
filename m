From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: IO performance test on the tcm-vhost scsi
Date: Wed, 13 Jun 2012 12:08:01 -0700
Message-ID: <1339614481.13709.354.camel@haakon2.linux-iscsi.org>
References: <1339582392.24309.15.camel@mengcong>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1339582392.24309.15.camel@mengcong>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: mc@linux.vnet.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, stefanha@linux.vnet.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>, linuxram@us.ibm.com, qemu-devel@nongnu.org, target-devel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-06-13 at 18:13 +0800, mengcong wrote:
> Hi folks, I did an IO performance test on the tcm-vhost scsi. I want to share 
> the test result data here.
> 
> 
>                     seq-read        seq-write       rand-read     rand-write
>                     8k     256k     8k     256k     8k   256k     8k   256k
> ----------------------------------------------------------------------------
> bare-metal          67951  69802    67064  67075    1758 29284    1969 26360
> tcm-vhost-iblock    61501  66575    51775  67872    1011 22533    1851 28216
> tcm-vhost-pscsi     66479  68191    50873  67547    1008 22523    1818 28304
> virtio-blk          26284  66737    23373  65735    1724 28962    1805 27774
> scsi-disk           36013  60289    46222  62527    1663 12992    1804 27670
> 
> unit: KB/s
> seq-read/write = sequential read/write
> rand-read/write = random read/write
> 8k,256k are blocksize of the IO
> 
> In tcm-vhost-iblock test, the emulate_write_cache attr was enabled.
> In virtio-blk test, cache=none,aio=native were set.
> In scsi-disk test, cache=none,aio=native were set, and LSI HBA was used.
> 
> I also tried to do the test with a scsi-generic LUN (pass through the 
> physical partition /dev/sgX device). But I couldn't setup it
> successfully. It's a pity.
> 
> Benchmark tool: fio, with ioengine=aio,direct=1,iodepth=8 set for all tests.
> kvm vm: 2 cpus and 2G ram
> 

These initial performance results look quite promising for virtio-scsi.

I'd be really interested to see how a raw flash block device backend
that locally can do ~100K 4k mixed R/W random IOPs compares with
virtio-scsi guest performance as the random small block fio workload
increases..

Also note there is a bottleneck wrt to random small block I/O
performance (per LUN) on the Linux/SCSI initiator side that is effecting
things here.  We've run into this limitation numerous times with using
SCSI LLDs as backend TCM devices, and I usually recommend using iblock
export with raw block flash backends for achieving the best small block
random I/O performance results.  A number of high performance flash
storage folks do something similar with raw block access (Jen's CC'ed)

As per Stefan's earlier question, how does virtio-scsi to QEMU SCSI
userspace compare with these results..?  Is there a reason why these
where not included in the initial results..?

Thanks Meng!

--nab
