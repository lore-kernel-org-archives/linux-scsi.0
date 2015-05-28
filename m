From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v6 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Thu, 28 May 2015 06:55:16 -0700
Message-ID: <1432821316.2199.14.camel@HansenPartnership.com>
References: <1432711182-17530-1-git-send-email-nmusini@cisco.com>
	 <1432711182-17530-10-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34071 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbbE1NzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2015 09:55:18 -0400
In-Reply-To: <1432711182-17530-10-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

In general, patch is much better: it passes all the static checker tests
for byte width and endianness issues.  However

On Wed, 2015-05-27 at 00:19 -0700, Narsimhulu Musini wrote:
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9c92f41..8baab3f 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -634,6 +634,23 @@ config FCOE_FNIC
>  	  <file:Documentation/scsi/scsi.txt>.
>  	  The module will be called fnic.
>  
> +config SCSI_SNIC
> +	tristate "Cisco SNIC Driver"
> +	depends on PCI && SCSI && X86_64

Please don't restrict the compilation architecture in the Kconfig
because that restricts the amount of build testing the driver gets.
Instead you can put a runtime warning in the driver if you insist.
Something like this

http://thread.gmane.org/gmane.linux.scsi/101846

Where you add a runtime taint is much better.

James


