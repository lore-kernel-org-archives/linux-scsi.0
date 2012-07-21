From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v4 0/3] tcm_vhost+cmwq fabric driver code for-3.6
Date: Sat, 21 Jul 2012 06:55:35 +0000
Message-ID: <1342853738-27682-1-git-send-email-nab@linux-iscsi.org>
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
To: target-devel <target-devel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MST, Greg-KH & Co,

The following is -v4 of the in-flight TCM vhost fabric driver for-3.6 code.
This series has been rebased into target-pending.git/for-next-merge this
evening, and the changelog over the last days from v3 -> v4 has been:
    
*) Rename vhost_vring_target -> vhost_scsi_target (mst + nab)
*) Use TRANSPORT_IQN_LEN in vhost_scsi_target->vhost_wwpn[] def (nab)
*) Move back to drivers/vhost/, and just use drivers/vhost/Kconfig.tcm (mst)
*) Move TCM_VHOST related ioctl defines from include/linux/vhost.h ->
   drivers/vhost/tcm_vhost.h as requested by MST (nab)
*) Move Kbuild.tcm include back from drivers/staging -> drivers/vhost/, and
   just use 'if STAGING' around 'source drivers/vhost/Kbuild.tcm'

This series uses Greg-KH's last recommendation from the linux-next thread
to just KISS + use the STAGING bit for this driver short of moving wholesale
into drivers/staging/tcm_vhost/.

As mentioned in the same thread, MST would like to see this in staging so we
don't have to commit to a ABI for QEMU userspace just yet.  Can we agree that
the STAGING bit usage here is enough to mark this code as staging for users..? 
Pretty please..?

The reason that -v4 currently avoids a drivers/staging/tcm_vhost/ move is to
prevent the staging tree needing to merge vhost + target-pending/for-next for
tcm_vhost build requirements.  It is easier to merge via target-pending w/ the
necessary ACKs for the drivers/vhost/ bits, but I'm fine with posting a -v5
series ASAP to move this code into drivers/staging/tcm_vhost + let staging
handle the necessary vhost + target merge dependencies.

I'll let the staging folks (Greg-KH..?) decided if they are OK with the
extra tree merges here before nominating them.  ;)

So aside from the 'marked as staging' directory location back <-> forth,
please consider ACK'ing the main bits for an initial merge.

Thank you!

Nicholas Bellinger (1):
  tcm_vhost: Initial merge for vhost level target fabric driver

Stefan Hajnoczi (2):
  vhost: Separate vhost-net features from vhost features
  vhost: make vhost work queue visible

 drivers/vhost/Kconfig     |    3 +
 drivers/vhost/Kconfig.tcm |    6 +
 drivers/vhost/Makefile    |    2 +
 drivers/vhost/net.c       |    4 +-
 drivers/vhost/tcm_vhost.c | 1611 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/tcm_vhost.h |   90 +++
 drivers/vhost/test.c      |    4 +-
 drivers/vhost/vhost.c     |    5 +-
 drivers/vhost/vhost.h     |    6 +-
 9 files changed, 1723 insertions(+), 8 deletions(-)
 create mode 100644 drivers/vhost/Kconfig.tcm
 create mode 100644 drivers/vhost/tcm_vhost.c
 create mode 100644 drivers/vhost/tcm_vhost.h

-- 
1.7.2.5
