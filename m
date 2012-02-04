From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/4] [SCSI] ufshcd: UFS Host controller driver
Date: Sat, 4 Feb 2012 12:28:27 +0530
Message-ID: <CALMYJDvihhEojJMuohHDz3jXV7V3ty2BbgcJOxfXgckKyMas7w@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
 <1328158649-4137-2-git-send-email-vinholikatti@gmail.com> <201202031519.02296.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37692 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2BDG6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2012 01:58:49 -0500
In-Reply-To: <201202031519.02296.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, venkat@linaro.org, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com

On Fri, Feb 3, 2012 at 8:49 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 02 February 2012, Vinayak Holikatti wrote:
>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>
>> This patch adds support for Universal Flash Storage(UFS)
>> host controllers. The UFS host controller driver
>> includes host controller initialization method.
>>
>> The Initialization process involves following steps:
>> =A0- Initiate UFS Host Controller initialization process by writing
>> =A0 =A0to Host controller enable register
>> =A0- Configure UFS Host controller registers with host memory space
>> =A0 =A0datastructure offsets.
>> =A0- Unipro link startup procedure
>> =A0- Check for connected device
>> =A0- Configure UFS host controller to process requests
>> =A0- Enable required interrupts
>> =A0- Configure interrupt aggregation
>>
>> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
>> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Saugata Das <saugata.das@linaro.org>
>> Reviewed-by: Vishak G <vishak.g@samsung.com>
>> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
>
> Thanks for posting this here. Note that while I did review the patche=
s
> in private email, I did not reply with a "Reviewed-by" tag, so you sh=
ould
> not add it yourself.

Sure, we'll keep in mind.

>In particular, I had made some additional comments
> about the ufshcd_memory_alloc() function that have not been addressed=
=2E
>
> Getting the code changed will certainly not be a problem, but please
> be careful with assigning those tags in the future.
>
> The only major thing that I see missing is a review from James or
> someone else who is familiar with other scsi device drivers. Saugata
> and I have (in private) commented on a a number of more general issue=
s
> and the comments were addressed before this patch set got sent out.
>
> Unless there are important concerns from the SCSI side, I believe thi=
s
> is going to be ready to get merged very soon, after the usual nitpick=
ing
> is done ;-)
>
> Speaking of nitpicking:
>
>>--- /dev/null
>>+++ b/drivers/scsi/ufs/Kconfig
>>+
>>+#ifndef NULL
>>+#define NULL 0
>>+#endif =A0/* NULL */
>
> Please remove this #define, NULL is defined in <linux/stddef.h>
>
>>+#define BYTES_TO_DWORDS(p) =A0 =A0 (p >> 2)
>>+#define UFSHCD_MMIO_BASE =A0 =A0 =A0 (hba->mmio_base)
>
> Better remove these macros, too: The are clearly longer than the
> expanded text, and less clear.
>

Ok, we'll do so.

>>+struct ufs_hba {
>>+ =A0 =A0 =A0 /* Virtual memory reference */
>>+ =A0 =A0 =A0 void *ucdl_virt_addr;
>>+ =A0 =A0 =A0 void *utrdl_virt_addr;
>>+ =A0 =A0 =A0 void *utmrdl_virt_addr;
>>+ =A0 =A0 =A0 void *utrdl_virt_addr_aligned;
>>+ =A0 =A0 =A0 void *utmrdl_virt_addr_aligned;
>>+ =A0 =A0 =A0 void *ucdl_virt_addr_aligned;
>>+
>>+ =A0 =A0 =A0 size_t ucdl_size;
>>+ =A0 =A0 =A0 size_t utrdl_size;
>>+ =A0 =A0 =A0 size_t utmrdl_size;
>>+
>>+ =A0 =A0 =A0 /* DMA memory reference */
>>+ =A0 =A0 =A0 dma_addr_t ucdl_dma_addr;
>>+ =A0 =A0 =A0 dma_addr_t utrdl_dma_addr;
>>+ =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr;
>>+ =A0 =A0 =A0 dma_addr_t utrdl_dma_addr_aligned;
>>+ =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr_aligned;
>>+ =A0 =A0 =A0 dma_addr_t ucdl_dma_addr_aligned;
>
> You can remove most of these members by simplifying the allocation:
>
> - remove the _aligned variables and use WARN_ON to test that
> =A0the allocated buffers are aligned (they always are)
> - remove the sizes because they are computed from the number of
> =A0descriptors
> - if possible, remove the _dma_addr members by referencing them only
> =A0in the ufshcd_host_memory_configure() function that can get merged
> =A0into ufshcd_memory_alloc()
> - while you're here, change the type of the *_virt_addr to
> =A0struct utp_task_req_desc/utp_transfer_req_desc/utp_transfer_req_cm=
d_desc
> =A0and remove the _virt_addr postfix.
>

I tried,
if( !ucdl_dma_addr  || WARN_ON(ucdl_dma_addr & PAGE_SIZE))
        pr_err("Memory allocation failed\n");
but I was getting "memory allocation failed error".

Since we need ucdl 128 byte aligned,  utrdl and utmrdl 1kb aligned,
Currently I'm testing with the following code,

if( !ucdl_dma_addr  || WARN_ON(ucdl_dma_addr & (128 - 1))
        pr_err("Memory allocation failed\n");

if( !utrdl_dma_addr  || WARN_ON(utrdl_dma_addr & (1024 - 1))
        pr_err("Memory allocation failed\n");

and
if( !utmrdl_dma_addr  || WARN_ON(utmrdl_dma_addr & (1024 - 1))
        pr_err("Memory allocation failed\n");

also I'll make changes to the other things you pointed out.

>>+ =A0 =A0 =A0 if (NULL =3D=3D hba->ucdl_virt_addr) {
>
> Here and in many other places, it's better to use the common kernel s=
tyle
>
> =A0 =A0 =A0 =A0if (!hba->ucdl_virt_addr) {
>
> to check the validity of an object.
>

ok, we'll do so.

>>+static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>>+{
>>+ =A0 =A0 =A0 u32 reg;
>>+
>>+ =A0 =A0 =A0 /* check if device present */
>>+ =A0 =A0 =A0 reg =3D readl((UFSHCD_MMIO_BASE + REG_CONTROLLER_STATUS=
));
>>+ =A0 =A0 =A0 if (ufshcd_is_device_present(reg)) {
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "cc: Device no=
t present\n");
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>+ =A0 =A0 =A0 }
>>+
>>+ =A0 =A0 =A0 /*
>>+ =A0 =A0 =A0 =A0* UCRDY, UTMRLDY and UTRLRDY bits must be 1
>>+ =A0 =A0 =A0 =A0* DEI, HEI bits must be 0
>>+ =A0 =A0 =A0 =A0*/
>>+ =A0 =A0 =A0 if (!(ufshcd_get_lists_status(reg))) {
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE +
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_R=
UN_STOP));
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_B=
IT,
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE +
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LI=
ST_RUN_STOP));
>>+ =A0 =A0 =A0 } else {
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Host controller not re=
ady to process requests");
>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>+ =A0 =A0 =A0 }
>
> I guess ENXIO or EIO would be more fitting here than EINVAL, because =
you
> are not referring to incorrect user input.
>

ok, we'll update accordingly.

>>+#ifdef CONFIG_PM
>>+/**
>>+ * ufshcd_suspend - suspend power management function
>>+ * @pdev: pointer to PCI device handle
>>+ * @state: power state
>>+ *
>>+ * Returns -ENOSYS
>>+ */
>>+static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
>>+{
>>+ =A0 =A0 =A0 return -ENOSYS;
>>+}
>>+
>>+/**
>>+ * ufshcd_resume - resume power management function
>>+ * @pdev: pointer to PCI device handle
>>+ *
>>+ * Returns -ENOSYS
>>+ */
>>+static int ufshcd_resume(struct pci_dev *pdev)
>>+{
>>+ =A0 =A0 =A0 return -ENOSYS;
>>+}
>>+#endif /* CONFIG_PM */
>
> These look wrong. Are you planning to fill them in a later patch? If =
not,
> it's probably better to just remove these functions.
>

Yes, We'll implement power management in the next patch.
linux/Documentation/SubmittingDrivers suggested to define
=2Esuspend and .resume methods returning -ENOSYS, if not yet implemente=
d.
So it was added.

Thanks for your comments. Please let us know if you have any comments
on the other patches as well.

> =A0 =A0 =A0 =A0Arnd

--=20
~Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
