From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Tue, 17 Jul 2012 18:05:48 +0300
Message-ID: <20120717150548.GA11587@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi folks,
> 
> The following is a RFC-v2 series of tcm_vhost target fabric driver code
> currently in-flight for-3.6 mainline code.
> 
> After last week's developments along with the help of some new folks, the
> changelog v1 -> v2 so far looks like:
> 
> *) Fix drivers/vhost/test.c to use VHOST_NET_FEATURES in patch #1 (Asias He)
> *) Fix tv_cmd completion -> release SGL memory leak (nab)
> *) Fix sparse warnings for static variable usage (Fengguang Wu)
> *) Fix sparse warnings for min() typing + printk format specs (Fengguang Wu)
> *) Convert to cmwq submission for I/O dispatch (nab + hch)
> 
> Also following Paolo's request, a patch for hw/virtio-scsi.c that sets
> scsi_host->max_target=0 that removes the need for virtio-scsi LLD to hardcode
> VirtIOSCSIConfig->max_id=1 in order to function with tcm_vhost.
> 
> Note this series has been pushed into target-pending.git/for-next-merge, and
> should be getting picked up for tomorrow's linux-next build.
> 
> Please let us know if you have any concerns and/or additional review feedback.
> 
> Thank you!


It still seems not 100% clear whether this driver will have major
userspace using it. And if not, it would be very hard to support a driver
when recent userspace does not use it in the end.

I think a good idea for 3.6 would be to make it depend on CONFIG_STAGING.
Then we don't commit to an ABI.
For this, you can add a separate Kconfig and source it from drivers/staging/Kconfig.
Maybe it needs to be in a separate directory drivers/vhost/staging/Kconfig.


> Nicholas Bellinger (2):
>   vhost: Add vhost_scsi specific defines
>   tcm_vhost: Initial merge for vhost level target fabric driver
> 
> Stefan Hajnoczi (2):
>   vhost: Separate vhost-net features from vhost features
>   vhost: make vhost work queue visible
> 
>  drivers/vhost/Kconfig     |    6 +
>  drivers/vhost/Makefile    |    1 +
>  drivers/vhost/net.c       |    4 +-
>  drivers/vhost/tcm_vhost.c | 1609 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/tcm_vhost.h |   74 ++
>  drivers/vhost/test.c      |    4 +-
>  drivers/vhost/vhost.c     |    5 +-
>  drivers/vhost/vhost.h     |    6 +-
>  include/linux/vhost.h     |    9 +
>  9 files changed, 1710 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/vhost/tcm_vhost.c
>  create mode 100644 drivers/vhost/tcm_vhost.h
> 
> -- 
> 1.7.2.5
