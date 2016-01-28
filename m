From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Fix a build issue reported by kbuild
 test robot
Date: Wed, 27 Jan 2016 22:02:42 -0800
Message-ID: <1453960962.2322.60.camel@HansenPartnership.com>
References: <1453966147-10568-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45328 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964940AbcA1GCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 01:02:44 -0500
In-Reply-To: <1453966147-10568-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de

On Wed, 2016-01-27 at 23:29 -0800, K. Y. Srinivasan wrote:
> tree:   https://na01.safelinks.protection.outlook.com/?url=https%3a%2
> f%2fgit.kernel.org%2fpub%2fscm%2flinux%2fkernel%2fgit%2ftorvalds%2fli
> nux.git&data=01%7c01%7ckys%40microsoft.com%7ce2e0622715844b79ad7108d3
> 2796ec3c%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=ubr4GbBaNS%2ftO
> z%2buJBk0CL9N0UNG9x2TidLgy6Yovg4%3d master
> head:   03c21cb775a313f1ff19be59c5d02df3e3526471
> commit: dac582417bc449b1f7f572d3f1dd9d23eec15cc9 storvsc: Properly
> support Fibre Channel devices
> date:   3 weeks ago
> config: x86_64-randconfig-s3-01281016 (attached as .config)
> reproduce:
>         git checkout dac582417bc449b1f7f572d3f1dd9d23eec15cc9
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `storvsc_remove':
> > > storvsc_drv.c:(.text+0x213af7): undefined reference to
> > > `fc_remove_host'
>    drivers/built-in.o: In function `storvsc_drv_init':
> > > storvsc_drv.c:(.init.text+0xcbcc): undefined reference to
> > > `fc_attach_transport'
> > > storvsc_drv.c:(.init.text+0xcc06): undefined reference to
> > > `fc_release_transport'
>    drivers/built-in.o: In function `storvsc_drv_exit':
> > > storvsc_drv.c:(.exit.text+0x123c): undefined reference to
> > > `fc_release_transport'
> 
> With this commit, the storvsc driver depends on FC atttributes. Make
> this
> dependency explicit.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/scsi/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 64eed87..24365c3 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -594,6 +594,7 @@ config XEN_SCSI_FRONTEND
>  config HYPERV_STORAGE
>  	tristate "Microsoft Hyper-V virtual storage driver"
>  	depends on SCSI && HYPERV
> +	depends on SCSI_FC_ATTRS
>  	default HYPERV
>  	help
>  	  Select this option to enable the Hyper-V virtual storage
> driver.

OK, so I thought Hannes requested that you not make the hyperv driver
depend on the FC attrs and you said you would ... has this changed?

James

