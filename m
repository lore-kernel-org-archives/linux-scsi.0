From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: Re: [PATCH] wd719x: Remove use of macro DEFINE_PCI_DEVICE_TABLE
Date: Thu, 1 Oct 2015 10:21:58 +0530
Message-ID: <CAK-LDbKX4+s6jd8tyJbDrE-Jdo0mLvi-JgmtuuNieezVhi+ytQ@mail.gmail.com>
References: <20150717054643.GA7209@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34716 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbJAEwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 00:52:00 -0400
In-Reply-To: <20150717054643.GA7209@vaishali-Ideapad-Z570>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Ping!

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



-- 
Vaishali
