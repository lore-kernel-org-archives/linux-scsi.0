From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 12:22:33 +0200
Message-ID: <4FF56AE9.9060201@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Il 05/07/2012 03:52, Nicholas A. Bellinger ha scritto:
> 
> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> ------------------------------------------------------------------------------------
> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K

This is impressive, but I think it's still not enough to justify the
inclusion of tcm_vhost.  In my opinion, vhost-blk/vhost-scsi are mostly
worthwhile as drivers for improvements to QEMU performance.  We want to
add more fast paths to QEMU that let us move SCSI and virtio processing
to separate threads, we have proof of concepts that this can be done,
and we can use vhost-blk/vhost-scsi to find bottlenecks more effectively.

In fact, virtio-scsi-qemu and virtio-scsi-vhost are effectively two
completely different devices that happen to speak the same SCSI
transport.  Not only virtio-scsi-vhost must be configured outside QEMU
and doesn't support -device; it (obviously) presents different
inquiry/vpd/mode data than virtio-scsi-qemu, so that it is not possible
to migrate one to the other.

I don't think vhost-scsi is particularly useful for virtualization,
honestly.  However, if it is useful for development, testing or
benchmarking of lio itself (does this make any sense? :)) that could be
by itself a good reason to include it.

Paolo
