Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C0EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C723C617E4
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348111AbhI3Fh7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348087AbhI3Fh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 01:37:58 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DC4C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 22:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=2TG9PbdXpjSo/4p82HGobgsp7HaziTdmUWb/aeGHLhg=; b=Mzl2Gc09j+77GIevC1Q8+KI0Cj
        PIHQ+eeZ2qYodKktOz4bYw4vSKK2QLJFJq+eL1fU95LYDTftRKNbTXDsE5XJFdvovqpMVRMJb8n3T
        3xoeknM04znCXfYnumnhotbMX6Of/IG+bkBAFAaV3zeeVsKKOZ7s++sVHu/gKx1NmJ8eHMfS9XjdZ
        lKwV7hqdGLIb/CrEZcJM2aQT9HcqX/ZRY5IhYLd05e3+OKsbg7DBPinG2dvlTPP8R3EUf7wBjx8q4
        6WmBE/PDV5tNbWeXIB3yAyKvBtnxnpJ6X9Tak+9vh3+j7UJ0ynveefrTh/tSF8iuLmO8J8na19WDV
        4UksvbFA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVojv-00D1xt-AT; Thu, 30 Sep 2021 05:36:15 +0000
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <481d8f10-f755-29f0-58f3-9838890b0dc6@infradead.org>
Date:   Wed, 29 Sep 2021 22:36:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210930034752.248781-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 9/29/21 8:47 PM, Yanling Song wrote:
> This initial commit contains Ramaxel's spraid module.
> 

Does "spraid" mean anything?  <something>  RAID ?

> Signed-off-by: Yanling Song <songyl@ramaxel.com>
> ---
>   Documentation/scsi/spraid.rst                 |   28 +
>   .../userspace-api/ioctl/ioctl-number.rst      |    2 +
>   MAINTAINERS                                   |    7 +
>   drivers/scsi/Kconfig                          |    1 +
>   drivers/scsi/Makefile                         |    1 +
>   drivers/scsi/spraid/Kconfig                   |   11 +
>   drivers/scsi/spraid/Makefile                  |    7 +
>   drivers/scsi/spraid/spraid.h                  |  656 +++
>   drivers/scsi/spraid/spraid_main.c             | 3617 +++++++++++++++++
>   9 files changed, 4330 insertions(+)
>   create mode 100644 Documentation/scsi/spraid.rst
>   create mode 100644 drivers/scsi/spraid/Kconfig
>   create mode 100644 drivers/scsi/spraid/Makefile
>   create mode 100644 drivers/scsi/spraid/spraid.h
>   create mode 100644 drivers/scsi/spraid/spraid_main.c
> 

> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 2e8134059c87..d93dbb680b16 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -169,6 +169,8 @@ Code  Seq#    Include File                                           Comments
>   'M'   00-0F  drivers/video/fsl-diu-fb.h                              conflict!
>   'N'   00-1F  drivers/usb/scanner.h
>   'N'   40-7F  drivers/block/nvme.c
> +'N'   41-42  drivers/scsi/spraid_main.c								 conflict!
> +'N'   80     drivers/scsi/spraid_main.c
>   'O'   00-06  mtd/ubi-user.h                                          UBI
>   'P'   all    linux/soundcard.h                                       conflict!
>   'P'   60-6F  sound/sscape_ioctl.h                                    conflict!

It looks like the above won't apply cleanly: the surrounding lines should not
be indented any.

> diff --git a/drivers/scsi/spraid/Kconfig b/drivers/scsi/spraid/Kconfig
> new file mode 100644
> index 000000000000..83962efaab07
> --- /dev/null
> +++ b/drivers/scsi/spraid/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Ramaxel driver configuration
> +#
> +
> +config RAMAXEL_SPRAID
> +	tristate "Ramaxel spraid Adapter"
> +	depends on PCI && SCSI
> +	depends on ARM64 || X86_64
> +	default m

Not "default m" unless it is needed to boot a system.

> +	help
> +	  This driver supports Ramaxel spraid driver.


thanks.
-- 
~Randy
