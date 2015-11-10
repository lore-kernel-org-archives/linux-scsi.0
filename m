From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: Re: [PATCH] wd719x: Remove use of macro DEFINE_PCI_DEVICE_TABLE
Date: Tue, 10 Nov 2015 08:26:38 +0530
Message-ID: <CAK-LDb+oKcWM-NVVD5fa=TJEWoxEWFrGzTz4MhxttFpUCDMcSw@mail.gmail.com>
References: <20150717054643.GA7209@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150717054643.GA7209@vaishali-Ideapad-Z570>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 17, 2015 at 11:16 AM, Vaishali Thakkar
<vthakkar1994@gmail.com> wrote:
> Macro DEFINE_PCI_DEVICE_TABLE is deprecated. So, here use
> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE with
> the goal of getting rid of this macro completely.
>
> The Coccinelle semantic patch that performs this transformation
> is as follows:
>
> @@
> identifier a;
> declarer name DEFINE_PCI_DEVICE_TABLE;
> initializer i;
> @@
> - DEFINE_PCI_DEVICE_TABLE(a)
> + const struct pci_device_id a[]
> = i;
>
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
> ---
> This patch is against linux-next branch
> ---
>  drivers/scsi/wd719x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 61346aa..4655d16 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci_dev *pdev)
>         scsi_host_put(sh);
>  }
>
> -static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
> +static const struct pci_device_id wd719x_pci_table[] = {
>         { PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
>         {}
>  };
> --
> 1.9.1
>

Hi James,

Can you please apply this patch? Actually this is the only case which is using
DEFINE_PCI_DEVICE_TABLE in the kernel and the use is blocking the removal
of everything related to this macro in the kernel. So, it would be
good if you can
apply this patch.

Inform me if it's not in your queue and I need to resend it.

Thanks

-- 
Vaishali
