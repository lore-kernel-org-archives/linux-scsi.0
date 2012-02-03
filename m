From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] [SCSI] ufshcd: UFS Host controller driver
Date: Fri, 3 Feb 2012 15:19:01 +0000
Message-ID: <201202031519.02296.arnd@arndb.de>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com> <1328158649-4137-2-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328158649-4137-2-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 02 February 2012, Vinayak Holikatti wrote:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
> 
> This patch adds support for Universal Flash Storage(UFS)
> host controllers. The UFS host controller driver
> includes host controller initialization method.
> 
> The Initialization process involves following steps:
>  - Initiate UFS Host Controller initialization process by writing
>    to Host controller enable register
>  - Configure UFS Host controller registers with host memory space
>    datastructure offsets.
>  - Unipro link startup procedure
>  - Check for connected device
>  - Configure UFS host controller to process requests
>  - Enable required interrupts
>  - Configure interrupt aggregation
> 
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Saugata Das <saugata.das@linaro.org>
> Reviewed-by: Vishak G <vishak.g@samsung.com>
> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>

Thanks for posting this here. Note that while I did review the patches
in private email, I did not reply with a "Reviewed-by" tag, so you should
not add it yourself. In particular, I had made some additional comments
about the ufshcd_memory_alloc() function that have not been addressed.

Getting the code changed will certainly not be a problem, but please
be careful with assigning those tags in the future.

The only major thing that I see missing is a review from James or
someone else who is familiar with other scsi device drivers. Saugata
and I have (in private) commented on a a number of more general issues
and the comments were addressed before this patch set got sent out.

Unless there are important concerns from the SCSI side, I believe this
is going to be ready to get merged very soon, after the usual nitpicking
is done ;-)

Speaking of nitpicking:

>--- /dev/null
>+++ b/drivers/scsi/ufs/Kconfig
>+
>+#ifndef NULL
>+#define NULL 0
>+#endif  /* NULL */

Please remove this #define, NULL is defined in <linux/stddef.h>

>+#define BYTES_TO_DWORDS(p)     (p >> 2)
>+#define UFSHCD_MMIO_BASE       (hba->mmio_base)

Better remove these macros, too: The are clearly longer than the
expanded text, and less clear.

>+struct ufs_hba {
>+       /* Virtual memory reference */
>+       void *ucdl_virt_addr;
>+       void *utrdl_virt_addr;
>+       void *utmrdl_virt_addr;
>+       void *utrdl_virt_addr_aligned;
>+       void *utmrdl_virt_addr_aligned;
>+       void *ucdl_virt_addr_aligned;
>+
>+       size_t ucdl_size;
>+       size_t utrdl_size;
>+       size_t utmrdl_size;
>+
>+       /* DMA memory reference */
>+       dma_addr_t ucdl_dma_addr;
>+       dma_addr_t utrdl_dma_addr;
>+       dma_addr_t utmrdl_dma_addr;
>+       dma_addr_t utrdl_dma_addr_aligned;
>+       dma_addr_t utmrdl_dma_addr_aligned;
>+       dma_addr_t ucdl_dma_addr_aligned;

You can remove most of these members by simplifying the allocation:

- remove the _aligned variables and use WARN_ON to test that
  the allocated buffers are aligned (they always are)
- remove the sizes because they are computed from the number of
  descriptors
- if possible, remove the _dma_addr members by referencing them only
  in the ufshcd_host_memory_configure() function that can get merged
  into ufshcd_memory_alloc()
- while you're here, change the type of the *_virt_addr to
  struct utp_task_req_desc/utp_transfer_req_desc/utp_transfer_req_cmd_desc
  and remove the _virt_addr postfix.

>+       if (NULL == hba->ucdl_virt_addr) {

Here and in many other places, it's better to use the common kernel style

	if (!hba->ucdl_virt_addr) {

to check the validity of an object.

>+static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>+{
>+       u32 reg;
>+
>+       /* check if device present */
>+       reg = readl((UFSHCD_MMIO_BASE + REG_CONTROLLER_STATUS));
>+       if (ufshcd_is_device_present(reg)) {
>+               dev_err(&hba->pdev->dev, "cc: Device not present\n");
>+               return -EINVAL;
>+       }
>+
>+       /*
>+        * UCRDY, UTMRLDY and UTRLRDY bits must be 1
>+        * DEI, HEI bits must be 0
>+        */
>+       if (!(ufshcd_get_lists_status(reg))) {
>+               writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
>+                      (UFSHCD_MMIO_BASE +
>+                       REG_UTP_TASK_REQ_LIST_RUN_STOP));
>+               writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
>+                      (UFSHCD_MMIO_BASE +
>+                       REG_UTP_TRANSFER_REQ_LIST_RUN_STOP));
>+       } else {
>+               dev_err(&hba->pdev->dev,
>+                       "Host controller not ready to process requests");
>+               return -EINVAL;
>+       }

I guess ENXIO or EIO would be more fitting here than EINVAL, because you
are not referring to incorrect user input.

>+#ifdef CONFIG_PM
>+/**
>+ * ufshcd_suspend - suspend power management function
>+ * @pdev: pointer to PCI device handle
>+ * @state: power state
>+ *
>+ * Returns -ENOSYS
>+ */
>+static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
>+{
>+       return -ENOSYS;
>+}
>+
>+/**
>+ * ufshcd_resume - resume power management function
>+ * @pdev: pointer to PCI device handle
>+ *
>+ * Returns -ENOSYS
>+ */
>+static int ufshcd_resume(struct pci_dev *pdev)
>+{
>+       return -ENOSYS;
>+}
>+#endif /* CONFIG_PM */

These look wrong. Are you planning to fill them in a later patch? If not,
it's probably better to just remove these functions.

	Arnd
