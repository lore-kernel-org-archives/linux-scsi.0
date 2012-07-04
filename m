From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Wed, 4 Jul 2012 17:02:59 +0300
Message-ID: <20120704140259.GB26485@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
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

On Wed, Jul 04, 2012 at 04:24:00AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi folks,
> 
> This series contains patches required to update tcm_vhost <-> virtio-scsi
> connected hosts <-> guests to run on v3.5-rc2 mainline code.  This series is
> available on top of target-pending/auto-next here:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git tcm_vhost
> 
> This includes the necessary vhost changes from Stefan to to get tcm_vhost
> functioning, along a virtio-scsi LUN scanning change to address a client bug
> with tcm_vhost I ran into..  Also, tcm_vhost driver has been merged into a single
> source + header file that is now living under /drivers/vhost/, along with latest
> tcm_vhost changes from Zhi's tcm_vhost tree.
> 
> Here are a couple of screenshots of the code in action using raw IBLOCK
> backends provided by FusionIO ioDrive Duo:
> 
>    http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-3.png
>    http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-4.png
> 
> So the next steps on my end will be converting tcm_vhost to submit backend I/O from
> cmwq context, along with fio benchmark numbers between tcm_vhost/virtio-scsi and
> virtio-scsi-raw using raw IBLOCK iomemory_vsl flash.

OK so this is an RFC, not for merge yet?

> 
> Please have a look vhost + virtio-scsi folks (mst + paolo CC'ed) and let us
> know if you have any concerns.
> 
> Thanks!
> 
> --nab
> Nicholas Bellinger (4):
>   vhost: Add vhost_scsi specific defines
>   tcm_vhost: Initial merge for vhost level target fabric driver
>   virtio-scsi: Add vdrv->scan for post VIRTIO_CONFIG_S_DRIVER_OK LUN
>     scanning
>   virtio-scsi: Set shost->max_id=1 for tcm_vhost WWPNs
> 
> Stefan Hajnoczi (2):
>   vhost: Separate vhost-net features from vhost features
>   vhost: make vhost work queue visible
> 
>  drivers/scsi/virtio_scsi.c |   20 +-
>  drivers/vhost/Kconfig      |    6 +
>  drivers/vhost/Makefile     |    1 +
>  drivers/vhost/net.c        |    4 +-
>  drivers/vhost/tcm_vhost.c  | 1592 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/tcm_vhost.h  |   70 ++
>  drivers/vhost/vhost.c      |    5 +-
>  drivers/vhost/vhost.h      |    6 +-
>  drivers/virtio/virtio.c    |    5 +-
>  include/linux/vhost.h      |    9 +
>  include/linux/virtio.h     |    1 +
>  11 files changed, 1708 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/vhost/tcm_vhost.c
>  create mode 100644 drivers/vhost/tcm_vhost.h
> 
> -- 
> 1.7.2.5
