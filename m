From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [GIT PULL] tcm_vhost: Initial merge of vhost level target fabric
	driver
Date: Sat, 18 Aug 2012 23:04:32 +0300
Message-ID: <20120818200432.GA26215@redhat.com>
References: <1343697577.22538.661.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1343697577.22538.661.camel@haakon2.linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, target-devel <target-devel@vger.kernel.org>, Anthony Liguori <anthony@codemonkey.ws>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas,
I just noticed this problem in the interface:

+#include <linux/vhost.h>
+
+/*
+ * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
+ *
+ * ABI Rev 0: July 2012 version starting point for v3.6-rc merge
candidate +
+ *            RFC-v2 vhost-scsi userspace.  Add GET_ABI_VERSION ioctl
usage
+ */
+
+#define VHOST_SCSI_ABI_VERSION 0
+
+struct vhost_scsi_target {
+       int abi_version;
+       unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
+       unsigned short vhost_tpgt;
+};
+

Here TRANSPORT_IQN_LEN is 224, which is a multiple of 4.
Since vhost_tpgt is 2 bytes and abi_version is 4, the total size would
be 230.  But gcc needs struct size be aligned to first field size, which
is 4 bytes, so it pads the structure by extra 2 bytes to the total of
232.

This padding is very undesirable in an ABI:
- it can not be initialized easily
- it can not be checked easily
- it can leak information between kernel and userspace

Simplest solution is probably just to make the padding
explicit:

+struct vhost_scsi_target {
+       int abi_version;
+       unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
+       unsigned short vhost_tpgt;
+       unsigned short reserved;
+};
+

I think we should fix this buglet before it goes out to users.

-- 
MST
