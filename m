Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5556DC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D2B320746
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgCMJPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:15:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:30207 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgCMJPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 05:15:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 02:15:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,548,1574150400"; 
   d="scan'208";a="289975041"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2020 02:15:35 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jCgPp-009E2m-CA; Fri, 13 Mar 2020 11:15:37 +0200
Date:   Fri, 13 Mar 2020 11:15:37 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Felipe Balbi <balbi@kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/5] treewide: Consolidate
 {get,put}_unaligned_[bl]e24() definitions
Message-ID: <20200313091537.GQ1922688@smile.fi.intel.com>
References: <20200313023718.21830-1-bvanassche@acm.org>
 <20200313023718.21830-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313023718.21830-4-bvanassche@acm.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 07:37:16PM -0700, Bart Van Assche wrote:
> Move the get_unaligned_be24(), get_unaligned_le24() and
> put_unaligned_le24() definitions from various drivers into
> include/linux/unaligned/generic.h. Add a put_unaligned_be24()
> implementation.

Thank you!
My comments below.

After addressing,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/nvme/host/rdma.c                     |  8 ----
>  drivers/nvme/target/rdma.c                   |  6 ---
>  drivers/usb/gadget/function/f_mass_storage.c |  1 +
>  drivers/usb/gadget/function/storage_common.h |  5 ---
>  include/linux/unaligned/generic.h            | 46 ++++++++++++++++++++
>  include/target/target_core_backend.h         |  6 ---
>  6 files changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 3e85c5cacefd..2845118e6e40 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -142,14 +142,6 @@ static void nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
>  static const struct blk_mq_ops nvme_rdma_mq_ops;
>  static const struct blk_mq_ops nvme_rdma_admin_mq_ops;
>  
> -/* XXX: really should move to a generic header sooner or later.. */
> -static inline void put_unaligned_le24(u32 val, u8 *p)
> -{
> -	*p++ = val;
> -	*p++ = val >> 8;
> -	*p++ = val >> 16;
> -}
> -
>  static inline int nvme_rdma_queue_idx(struct nvme_rdma_queue *queue)
>  {
>  	return queue - queue->ctrl->queues;
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index 37d262a65877..8fcede75e02a 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -143,12 +143,6 @@ static int num_pages(int len)
>  	return 1 + (((len - 1) & PAGE_MASK) >> PAGE_SHIFT);
>  }
>  
> -/* XXX: really should move to a generic header sooner or later.. */
> -static inline u32 get_unaligned_le24(const u8 *p)
> -{
> -	return (u32)p[0] | (u32)p[1] << 8 | (u32)p[2] << 16;
> -}
> -
>  static inline bool nvmet_rdma_need_data_in(struct nvmet_rdma_rsp *rsp)
>  {
>  	return nvme_is_write(rsp->req.cmd) &&
> diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
> index 7c96c4665178..950d2a85f098 100644
> --- a/drivers/usb/gadget/function/f_mass_storage.c
> +++ b/drivers/usb/gadget/function/f_mass_storage.c
> @@ -216,6 +216,7 @@
>  #include <linux/freezer.h>
>  #include <linux/module.h>
>  #include <linux/uaccess.h>
> +#include <asm/unaligned.h>
>  
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> diff --git a/drivers/usb/gadget/function/storage_common.h b/drivers/usb/gadget/function/storage_common.h
> index e5e3a2553aaa..bdeb1e233fc9 100644
> --- a/drivers/usb/gadget/function/storage_common.h
> +++ b/drivers/usb/gadget/function/storage_common.h
> @@ -172,11 +172,6 @@ enum data_direction {
>  	DATA_DIR_NONE
>  };
>  
> -static inline u32 get_unaligned_be24(u8 *buf)
> -{
> -	return 0xffffff & (u32) get_unaligned_be32(buf - 1);
> -}
> -
>  static inline struct fsg_lun *fsg_lun_from_dev(struct device *dev)
>  {
>  	return container_of(dev, struct fsg_lun, dev);
> diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
> index 57d3114656e5..5a0cefda7a13 100644
> --- a/include/linux/unaligned/generic.h
> +++ b/include/linux/unaligned/generic.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_UNALIGNED_GENERIC_H
>  #define _LINUX_UNALIGNED_GENERIC_H
>  
> +#include <linux/types.h>
> +
>  /*
>   * Cause a link-time error if we try an unaligned access other than
>   * 1,2,4 or 8 bytes long
> @@ -66,4 +68,48 @@ extern void __bad_unaligned_access_size(void);
>  	}								\
>  	(void)0; })
>  
> +static inline u32 __get_unaligned_be24(const u8 *p)
> +{
> +	return p[0] << 16 | p[1] << 8 | p[2];
> +}
> +
> +static inline u32 get_unaligned_be24(const void *p)
> +{
> +	return __get_unaligned_be24(p);
> +}
> +
> +static inline u32 __get_unaligned_le24(const u8 *p)
> +{
> +	return p[0] | p[1] << 8 | p[2] << 16;
> +}
> +
> +static inline u32 get_unaligned_le24(const void *p)
> +{
> +	return __get_unaligned_le24(p);
> +}
> +
> +static inline void __put_unaligned_be24(u32 val, u8 *p)

	const u32 val

> +{
> +	*p++ = val >> 16;
> +	*p++ = val >> 8;
> +	*p++ = val;
> +}
> +

> +static inline void put_unaligned_be24(u32 val, void *p)

Ditto.

> +{
> +	__put_unaligned_be24(val, p);
> +}
> +

> +static inline void __put_unaligned_le24(u32 val, u8 *p)

Ditto.

> +{
> +	*p++ = val;
> +	*p++ = val >> 8;
> +	*p++ = val >> 16;
> +}
> +

> +static inline void put_unaligned_le24(u32 val, void *p)

Ditto.

> +{
> +	__put_unaligned_le24(val, p);
> +}
> +
>  #endif /* _LINUX_UNALIGNED_GENERIC_H */
> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
> index 51b6f50eabee..1b752d8ea529 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -116,10 +116,4 @@ static inline bool target_dev_configured(struct se_device *se_dev)
>  	return !!(se_dev->dev_flags & DF_CONFIGURED);
>  }
>  
> -/* Only use get_unaligned_be24() if reading p - 1 is allowed. */
> -static inline uint32_t get_unaligned_be24(const uint8_t *const p)
> -{
> -	return get_unaligned_be32(p - 1) & 0xffffffU;
> -}
> -
>  #endif /* TARGET_CORE_BACKEND_H */

-- 
With Best Regards,
Andy Shevchenko


