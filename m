From: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
Date: Thu, 13 Nov 2008 15:18:15 +0100
Message-ID: <b637ec0b0811130618o2f76e34bh17055f2f165d89a5@mail.gmail.com>
References: <1226585472-12559-1-git-send-email-bwalle@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754182AbYKMOS1@vger.kernel.org>
In-Reply-To: <1226585472-12559-1-git-send-email-bwalle@suse.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Bernhard Walle <bwalle@suse.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

So I'm not the only one :-)
Please see this thread:

http://lkml.org/lkml/2008/10/22/355



On Thu, Nov 13, 2008 at 3:11 PM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch adds a proper help for SCSI_WAIT_SCAN and allows the module to be
> deselected. I see no reason to force it being build. It also makes it
> impossible to compile-in the module.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  drivers/scsi/Kconfig |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 403ecad..42b8355 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -257,10 +257,15 @@ config SCSI_SCAN_ASYNC
>          or async on the kernel's command line.
>
>  config SCSI_WAIT_SCAN
> -       tristate
> +       tristate "Module to wait until all the async scans are complete"
>        default m
> -       depends on SCSI
> -       depends on MODULES
> +       depends on SCSI && m
> +    help
> +      This is a simple module to wait until all the async scans are
> +      complete.  The idea is to use it in initrd/initramfs scripts.  You
> +      modprobe it after all the modprobes of the root SCSI drivers and it
> +      will wait until they have all finished scanning their busses before
> +      allowing the boot to proceed
>
>  menu "SCSI Transports"
>        depends on SCSI
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
