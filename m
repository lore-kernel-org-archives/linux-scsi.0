From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: virtio-scsi <-> vhost multi lun/adapter
	performance results with 3.6-rc0
Date: Sat, 11 Aug 2012 13:52:04 +0100
Message-ID: <CAJSP0QXX=4etJ_uGYFzXQ0eEE0M+Ude7ha0aH5SaX1oEUvQoLA@mail.gmail.com>
References: <1344641012.22564.294.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1344641012.22564.294.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, target-devel <target-devel@vger.kernel.org>, hare@suse.de, Anthony Liguori <anthony@codemonkey.ws>, Paolo Bonzini <pbonzini@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 11, 2012 at 12:23 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Using a KVM guest with 32x vCPUs and 4G memory, the results for 4x
> random I/O now look like:
>
> workload         | jobs | 25% write / 75% read | 75% write / 25% read
> -----------------|------|----------------------|---------------------
> 1x rd_mcp LUN    |   8  |     ~155K IOPs       |      ~145K IOPs
> 16x rd_mcp LUNs  |  16  |     ~315K IOPs       |      ~305K IOPs
> 32x rd_mcp LUNs  |  16  |     ~425K IOPs       |      ~410K IOPs
>
> The full fio randrw results for the six test cases are attached below.
> Also, using a workload of fio numjobs > 16 currently makes performance
> start to fall off pretty sharply regardless of the number of vCPUs..
>
> So running a similar workload with loopback SCSI ports on bare-metal
> produces ~1M random IOPs with 12x LUNs + numjobs=32.  At numjobs=16 here
> with vhost the 16x LUN configuration ends up being in the range of ~310K
> IOPs for the current sweet spot..

This makes me wonder what a comparison against baremetal looks like
and the perf top, mpstat, and kvm_stat results on the host.

Stefan
