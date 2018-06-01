From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V4] scsi: hpsa: drop shutdown callback
Date: Fri, 1 Jun 2018 20:58:09 +0000
Message-ID: <a46c373b432946ec89fce71d6ef7b5cc@microsemi.com>
References: <1527860768-11367-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1527860768-11367-1-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Sinan Kaya <okaya@codeaurora.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "ryan@finnie.org" <ryan@finnie.org>, "timur@codeaurora.org" <timur@codeaurora.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:HEWLETT-PACKARD SMART ARRAY RAID
 DRIVER (hpsa)" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsemi.com>, open list <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Sinan Kaya [mailto:okaya@codeaurora.org]
> Sent: Friday, June 01, 2018 8:46 AM
> To: linux-pci@vger.kernel.org; ryan@finnie.org; timur@codeaurora.org
> Cc: linux-arm-msm@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> Sinan Kaya <okaya@codeaurora.org>; stable@vger.kernel.org; Don Brace
> <don.brace@microsemi.com>; James E.J. Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> esc.storagedev <esc.storagedev@microsemi.com>; open list:HEWLETT-
> PACKARD SMART ARRAY RAID DRIVER (hpsa) <linux-scsi@vger.kernel.org>; open
> list <linux-kernel@vger.kernel.org>
> Subject: [PATCH V4] scsi: hpsa: drop shutdown callback
> 
> EXTERNAL EMAIL
> 
> 
> 'Commit cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during
> shutdown")' has been added to kernel to shutdown pending PCIe port
> service interrupts during reboot so that a newly started kexec kernel
> wouldn't observe pending interrupts.
> 
> pcie_port_device_remove() is disabling the root port and switches by
> calling pci_disable_device() after all PCIe service drivers are shutdown.
> 
> This has been found to cause crashes on HP DL360 Gen9 machines during
> reboot due to hpsa driver not clearing the bus master bit during the
> shutdown procedure by calling pci_disable_device().
> 
> Disable device as part of the shutdown sequence.
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>

Looks good. Thanks for your patch
Thanks for changing the patch name also.

Tested-by: Don Brace <don.brace@microsemi.com>
Acked-by: Don Brace <don.brace@microsemi.com>

> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199779
> Fixes: cc27b735ad3a ("PCI/portdrv: Turn off PCIe services during shutdown")
> Cc: stable@vger.kernel.org
> Reported-by: Ryan Finnie <ryan@finnie.org>
> ---
>  drivers/scsi/hpsa.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 3a9eca1..b92f86a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8869,7 +8869,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info
> *h)
>         kfree(options);
>  }
> 
> -static void hpsa_shutdown(struct pci_dev *pdev)
> +static void __hpsa_shutdown(struct pci_dev *pdev)
>  {
>         struct ctlr_info *h;
> 
> @@ -8884,6 +8884,12 @@ static void hpsa_shutdown(struct pci_dev *pdev)
>         hpsa_disable_interrupt_mode(h);         /* pci_init 2 */
>  }
> 
> +static void hpsa_shutdown(struct pci_dev *pdev)
> +{
> +       __hpsa_shutdown(pdev);
> +       pci_disable_device(pdev);
> +}
> +
>  static void hpsa_free_device_info(struct ctlr_info *h)
>  {
>         int i;
> @@ -8927,7 +8933,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
>                 scsi_remove_host(h->scsi_host);         /* init_one 8 */
>         /* includes hpsa_free_irqs - init_one 4 */
>         /* includes hpsa_disable_interrupt_mode - pci_init 2 */
> -       hpsa_shutdown(pdev);
> +       __hpsa_shutdown(pdev);
> 
>         hpsa_free_device_info(h);               /* scan */
> 
> --
> 2.7.4
