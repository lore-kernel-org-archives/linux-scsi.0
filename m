From: Mike Miller <mike.miller@hp.com>
Subject: Re: [PATCH V2 5/6] scsi/hpsa: Disable ASPM
Date: Fri, 11 Nov 2011 10:16:19 -0600
Message-ID: <4EBD4A53.10709@hp.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com> <1321028064-644-6-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321028064-644-6-git-send-email-mjg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, ISS StorageDev <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/11/2011 10:14 AM, Matthew Garrett wrote:
> The Windows driver .inf disables ASPM on hpsa devices. Do the same.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Cc: scameron@beardog.cce.hp.com
> Cc: iss_storagedev@hp.com
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/hpsa.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e76107b..865d452 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -23,6 +23,7 @@
>   #include<linux/interrupt.h>
>   #include<linux/types.h>
>   #include<linux/pci.h>
> +#include<linux/pci-aspm.h>
>   #include<linux/kernel.h>
>   #include<linux/slab.h>
>   #include<linux/delay.h>
> @@ -3922,6 +3923,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
>   		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
>   		return -ENODEV;
>   	}
> +
> +	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
> +			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
> +
>   	err = pci_enable_device(h->pdev);
>   	if (err) {
>   		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");

Acked-by: Mike Miller <mike.miller@hp.com>
