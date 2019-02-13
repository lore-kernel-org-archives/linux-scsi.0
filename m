From: ira.weiny@intel.com
Subject: [PATCH V2 7/7] IB/mthca: Use the new FOLL_LONGTERM flag to
 get_user_pages_fast()
Date: Wed, 13 Feb 2019 15:04:55 -0800
Message-ID: <20190213230455.5605-8-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190213230455.5605-1-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190213230455.5605-1-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, kvm@vger.kernel.org, linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, linux-mm@kvack.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Martin Brandenburg <martin@omnibond.com>, Rich Felker <dalias@libc.org>, David Hildenbrand <david@redhat.com>, David Airlie <airlied@linux.ie>, Jason Wang <jasowang@redhat.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Michal Hocko <mhocko@suse.com>, Rob Springer <rspringer@google.com>, Todd Poynor <toddpoynor@google.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>, Matt Porter <mporter@kernel.crashing.org>, Wu Hao <hao.wu@intel.com>, Alan Tull <atull@kernel.org>, John Hubbard <jhubbard@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Borislav Petkov <bp@alien8.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas
List-Id: linux-scsi@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Use the new FOLL_LONGTERM to get_user_pages_fast() to protect against
FS DAX pages being mapped.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/infiniband/hw/mthca/mthca_memfree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 112d2f38e0de..8ff0e90d7564 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -472,7 +472,8 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		goto out;
 	}
 
-	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1, FOLL_WRITE, pages);
+	ret = get_user_pages_fast(uaddr & PAGE_MASK, 1,
+				  FOLL_WRITE | FOLL_LONGTERM, pages);
 	if (ret < 0)
 		goto out;
 
-- 
2.20.1
