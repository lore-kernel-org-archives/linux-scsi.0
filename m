From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v3 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 15:57:27 +0300
Message-ID: <20120718125727.GA5589@redhat.com>
References: <1342573172-17421-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1342573172-17421-1-git-send-email-nab@linux-iscsi.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2012 at 12:59:28AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi folks,
> 
> The following is the RFC-v3 series of tcm_vhost target fabric driver code
> currently in-flight for-3.6 mainline code.
> 
> With the merge window opening soon, the tcm_vhost code has started seeing
> time in linux-next.  The v2 -> v3 changelog from the last week is currently
> looking like:
> 
>  *) Unlock on error in tcm_vhost_drop_nexus() (DanC)
>  *) Fix strlen() doesn't count the terminator (DanC)
>  *) Call kfree() on an error path (DanC)
>  *) Convert tcm_vhost_write_pending to use target_execute_cmd (hch + nab)
>  *) Fix another strlen() off by one in tcm_vhost_make_tport (DanC)
>  *) Add option under drivers/staging/Kconfig, and move to drivers/vhost/tcm/
>     as requested by MST (nab)

I actually only wanted to have a separate Kconfig (in a separate
directory or Kconfig.tcm), so you do not need to move code back to move
driver out of staging.  But if you prefer this, I'm fine with it too for
now.

> Thanks to Dan Carpenter for his smatch fixes this past round.
> 
> Also as requested by MST, the code has been moved to a seperate tcm/ subdirectory
> under drivers/vhost/ so that it can be included under staging's config options
> until we can settle on the necessary userspace bits for QEMU and kvm-tool.
> 
> The updated series will be going out shortly to target-pending/for-next-merge.
> 
> Please have another look and let us know if you have any concerned.
> 
> Thanks!
> 
> Nicholas Bellinger (2):
>   vhost: Add vhost_scsi specific defines
>   tcm_vhost: Initial merge for vhost level target fabric driver
> 
> Stefan Hajnoczi (2):
>   vhost: Separate vhost-net features from vhost features
>   vhost: make vhost work queue visible
> 
>  drivers/staging/Kconfig       |    2 +
>  drivers/vhost/Makefile        |    2 +
>  drivers/vhost/net.c           |    4 +-
>  drivers/vhost/tcm/Kconfig     |    6 +
>  drivers/vhost/tcm/Makefile    |    1 +
>  drivers/vhost/tcm/tcm_vhost.c | 1611 +++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/tcm/tcm_vhost.h |   74 ++
>  drivers/vhost/test.c          |    4 +-
>  drivers/vhost/vhost.c         |    5 +-
>  drivers/vhost/vhost.h         |    6 +-
>  include/linux/vhost.h         |    9 +
>  11 files changed, 1716 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/vhost/tcm/Kconfig
>  create mode 100644 drivers/vhost/tcm/Makefile
>  create mode 100644 drivers/vhost/tcm/tcm_vhost.c
>  create mode 100644 drivers/vhost/tcm/tcm_vhost.h
> 
> -- 
> 1.7.2.5
