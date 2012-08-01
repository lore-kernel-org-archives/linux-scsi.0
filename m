From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC-v5] tcm_vhost: Initial merge for vhost level target fabric
	driver
Date: Wed, 01 Aug 2012 08:42:36 +0200
Message-ID: <5018CFDC.4020703@redhat.com>
References: <1343346200-19850-1-git-send-email-nab@linux-iscsi.org>
	<CAG7+5M35QAK=ggAJRZtga0PWw5VZFi-mraKEAkWiq16U3ysxjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CAG7+5M35QAK=ggAJRZtga0PWw5VZFi-mraKEAkWiq16U3ysxjg@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Eric Northup <digitaleric@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Il 31/07/2012 22:52, Eric Northup ha scritto:
> It seems to me like this is not the way that virtio devices are supposed
> to behave - if a guest splits a virtio_scsi_cmd_req or _resp across a
> page boundary, then this code won't work.

Buffers can cover several pages.  Of course, data buffers have to be at
least sector aligned, but this restriction does not apply to
request/response descriptors.

> Quoting the 'Message Framing' part of the virtio spec:
> 
> "In particular, no implementation should use the descriptor boundaries
> to determine the size of any header in a request. "

True,  but this has never matched reality.

Paolo
