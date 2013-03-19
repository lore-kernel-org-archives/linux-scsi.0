From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V5 0/5] virtio-scsi multiqueue
Date: Tue, 19 Mar 2013 17:57:32 +0800
Message-ID: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com, virtualization@lists.linux-foundation.org, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).

This version rebased on Rusty's virtio ring rework patches.
We hope this can go into virtio-next together with the virtio ring
rework pathes.

V5: improving the grammar of 1/5 (Paolo)
    move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)

V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)

V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2


It would probably be easier to get it in via Rusty's tree
because of the prerequisites.  James, can we get your Acked-by?

Paolo Bonzini (4):
  virtio-scsi: redo allocation of target data
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: push vq lock/unlock into virtscsi_vq_done
  virtio-scsi: introduce multiqueue support

Wanlong Gao (1):
  virtio-scsi: reset virtqueue affinity when doing cpu hotplug

 drivers/scsi/virtio_scsi.c | 359 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 290 insertions(+), 69 deletions(-)

-- 
1.8.2.rc2
