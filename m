From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH V2 0/7] Add FOLL_LONGTERM to GUP fast and use it
Date: Fri, 15 Feb 2019 10:29:36 -0800
Message-ID: <20190215182935.GC26988@iweiny-DESK2.sc.intel.com>
Reply-To: 20190211201643.7599-1-ira.weiny@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, kvm@vger.kernel.org, linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, linux-mm@kvack.org, ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

> NOTE: This series depends on my clean up patch to remove the write parameter
> from gup_fast_permitted()[1]
> 
> HFI1, qib, and mthca, use get_user_pages_fast() due to it performance
> advantages.  These pages can be held for a significant time.  But
> get_user_pages_fast() does not protect against mapping of FS DAX pages.
> 
> Introduce FOLL_LONGTERM and use this flag in get_user_pages_fast() which
> retains the performance while also adding the FS DAX checks.  XDP has also
> shown interest in using this functionality.[2]
> 
> In addition we change get_user_pages() to use the new FOLL_LONGTERM flag and
> remove the specialized get_user_pages_longterm call.
> 
> [1] https://lkml.org/lkml/2019/2/11/237
> [2] https://lkml.org/lkml/2019/2/11/1789

Any comments on this series?  I've touched a lot of subsystems which I think
require review.

Thanks,
Ira

> 
> Ira Weiny (7):
>   mm/gup: Replace get_user_pages_longterm() with FOLL_LONGTERM
>   mm/gup: Change write parameter to flags in fast walk
>   mm/gup: Change GUP fast to use flags rather than a write 'bool'
>   mm/gup: Add FOLL_LONGTERM capability to GUP fast
>   IB/hfi1: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
>   IB/qib: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
>   IB/mthca: Use the new FOLL_LONGTERM flag to get_user_pages_fast()
> 
>  arch/mips/mm/gup.c                          |  11 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c         |   4 +-
>  arch/powerpc/kvm/e500_mmu.c                 |   2 +-
>  arch/powerpc/mm/mmu_context_iommu.c         |   4 +-
>  arch/s390/kvm/interrupt.c                   |   2 +-
>  arch/s390/mm/gup.c                          |  12 +-
>  arch/sh/mm/gup.c                            |  11 +-
>  arch/sparc/mm/gup.c                         |   9 +-
>  arch/x86/kvm/paging_tmpl.h                  |   2 +-
>  arch/x86/kvm/svm.c                          |   2 +-
>  drivers/fpga/dfl-afu-dma-region.c           |   2 +-
>  drivers/gpu/drm/via/via_dmablit.c           |   3 +-
>  drivers/infiniband/core/umem.c              |   5 +-
>  drivers/infiniband/hw/hfi1/user_pages.c     |   5 +-
>  drivers/infiniband/hw/mthca/mthca_memfree.c |   3 +-
>  drivers/infiniband/hw/qib/qib_user_pages.c  |   8 +-
>  drivers/infiniband/hw/qib/qib_user_sdma.c   |   2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.c    |   9 +-
>  drivers/media/v4l2-core/videobuf-dma-sg.c   |   6 +-
>  drivers/misc/genwqe/card_utils.c            |   2 +-
>  drivers/misc/vmw_vmci/vmci_host.c           |   2 +-
>  drivers/misc/vmw_vmci/vmci_queue_pair.c     |   6 +-
>  drivers/platform/goldfish/goldfish_pipe.c   |   3 +-
>  drivers/rapidio/devices/rio_mport_cdev.c    |   4 +-
>  drivers/sbus/char/oradax.c                  |   2 +-
>  drivers/scsi/st.c                           |   3 +-
>  drivers/staging/gasket/gasket_page_table.c  |   4 +-
>  drivers/tee/tee_shm.c                       |   2 +-
>  drivers/vfio/vfio_iommu_spapr_tce.c         |   3 +-
>  drivers/vfio/vfio_iommu_type1.c             |   3 +-
>  drivers/vhost/vhost.c                       |   2 +-
>  drivers/video/fbdev/pvr2fb.c                |   2 +-
>  drivers/virt/fsl_hypervisor.c               |   2 +-
>  drivers/xen/gntdev.c                        |   2 +-
>  fs/orangefs/orangefs-bufmap.c               |   2 +-
>  include/linux/mm.h                          |  17 +-
>  kernel/futex.c                              |   2 +-
>  lib/iov_iter.c                              |   7 +-
>  mm/gup.c                                    | 220 ++++++++++++--------
>  mm/gup_benchmark.c                          |   5 +-
>  mm/util.c                                   |   8 +-
>  net/ceph/pagevec.c                          |   2 +-
>  net/rds/info.c                              |   2 +-
>  net/rds/rdma.c                              |   3 +-
>  44 files changed, 232 insertions(+), 180 deletions(-)
> 
> -- 
> 2.20.1
> 
