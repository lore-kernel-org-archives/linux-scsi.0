From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH] scsi: bnx2i depends on PCI.
Date: Mon, 15 Jun 2009 11:23:00 -0700
Message-ID: <1245090180.12000.16.camel@HP1>
References: <20090615181123.GB30693@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4280 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765576AbZFOSac (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 14:30:32 -0400
In-Reply-To: <20090615181123.GB30693@linux-sh.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>


On Mon, 2009-06-15 at 11:11 -0700, Paul Mundt wrote:
> This fixes up the CONFIG_PCI=n case, primarily triggered on
> allmodconfig/allyesconfig builds:
> 
> drivers/scsi/bnx2i/bnx2i_iscsi.c:760: error: implicit declaration of function 'pci_dev_get'
> make[4]: *** [drivers/scsi/bnx2i/bnx2i_iscsi.o] Error 1
> make[3]: *** [drivers/scsi/bnx2i] Error 2
> 
> The entire driver is PCI dependent, so just reflect it in the Kconfig.
> 

A similar patch is already in James' tree:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=babdb788f7ec1a782a52240a5f6dae568f32565f

> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Michael Chan <mchan@broadcom.com>
> 
> ---
> 
>  drivers/scsi/bnx2i/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
> index 820d428..0d63146 100644
> --- a/drivers/scsi/bnx2i/Kconfig
> +++ b/drivers/scsi/bnx2i/Kconfig
> @@ -1,5 +1,6 @@
>  config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
> +	depends on PCI
>  	select SCSI_ISCSI_ATTRS
>  	select CNIC
>  	---help---
> 


