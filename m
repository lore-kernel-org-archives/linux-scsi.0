From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] virtio-scsi fixes for 3.6
Date: Thu, 26 Jul 2012 15:28:06 +0200
Message-ID: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
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
Cc: JBottomley@parallels.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

James,

patch 1 fixes scanning of LUNs whose number is greater than 255.  QEMU
passes a max_lun of 16383 (because it uses SAM numbering) but in Linux
it must become 32768 (because LUNs above 255 are "relocated" to 16640).
Patch 2 is a resubmission of the patch for online resizing of virtio-scsi
LUNs, which needs to be rebased.

LUNs above 255 now work for all of scanning, hotplug, hotunplug and
resize.

Thanks,

Paolo

Paolo Bonzini (2):
  virtio-scsi: fix LUNs greater than 255
  virtio-scsi: support online resizing of disks

 drivers/scsi/virtio_scsi.c  |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/virtio_scsi.h |    2 ++
 2 files changed, 37 insertions(+), 2 deletions(-)
