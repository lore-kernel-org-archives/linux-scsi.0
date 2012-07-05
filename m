From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 19:57:37 +0000
Message-ID: <4FF5F1B1.8030702@acm.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF5D494.2090707@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4FF5D494.2090707@acm.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 07/05/12 17:53, Bart Van Assche wrote:

> On 07/05/12 01:52, Nicholas A. Bellinger wrote:
>> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
>> ------------------------------------------------------------------------------------
>> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
>> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> 
> These numbers are interesting. To me these numbers mean that there is a
> huge performance bottleneck in the virtio-scsi-raw storage path. Why is
> the virtio-scsi-raw bandwidth only one third of the bare-metal raw block
> bandwidth ?


(replying to my own e-mail)

Or maybe the above numbers mean that in the virtio-scsi-raw test I/O was
serialized (I/O depth 1) while the other two tests use a large I/O depth
(64) ? It can't be a coincidence that the virtio-scsi-raw results are
close to the bare-metal results for I/O depth 1.

Another question: which functionality does tcm_vhost provide that is not
yet provided by the SCSI emulation code in qemu + tcm_loop ?

Bart.
