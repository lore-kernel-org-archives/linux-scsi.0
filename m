From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/5] virtio-scsi multiqueue
Date: Tue, 12 Feb 2013 14:06:26 +0100
Message-ID: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, JBottomley@parallels.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).  The patches build on top of the new virtio APIs
at http://permalink.gmane.org/gmane.linux.kernel.virtualization/18431;
the new API simplifies the locking of the virtio-scsi driver nicely,
thus it makes sense to require them as a prerequisite.

Changes from the previous post, which can be found at
http://permalink.gmane.org/gmane.linux.kernel.virtualization/17869:

- patches 1 and 2 ("virtio: add functions for piecewise addition of
  buffers", "virtio-scsi: use functions for piecewise composition of
  buffers") split into their own series

- new cleanup patch "virtio-scsi: push vq lock/unlock into virtscsi_vq_done"

- reorganized code to move ACCESS_ONCE in a clearer place

- included Wanlong Gao's CPU hotplug patches

Ok for 3.9?  It would probably be easier to get it in via Rusty's tree
because of the prerequisites.  James, can I get your Acked-by?

Paolo

Paolo Bonzini (4):
  virtio-scsi: redo allocation of target data
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: push vq lock/unlock into virtscsi_vq_done
  virtio-scsi: introduce multiqueue support

Wanlong Gao (1):
  virtio-scsi: reset virtqueue affinity when doing cpu hotplug

 drivers/scsi/virtio_scsi.c |  360 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 292 insertions(+), 68 deletions(-)
