From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] qla1280 compile fix for CONFIG_HOTPLUG in 2.6
Date: 12 Jan 2004 10:11:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073920276.2186.11.camel@mulgrave>
References: <16386.38762.670634.620111@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51692 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266188AbUALPLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 10:11:25 -0500
In-Reply-To: <16386.38762.670634.620111@gargle.gargle.HOWL>
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-01-12 at 07:47, Jes Sorensen wrote:
> -#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600)
> +#if defined(CONFIG_SCSI_QLOGIC_1280_MODULE) || (LINUX_VERSION_CODE < 0x020600) || defined(CONFIG_HOTPLUG)

I'm not very keen on this.  It's mated with the

	.remove = __devexit_p(qla1280_remove_one)

so you're second guessing the __devexit_p() semantics with #ifdefs

In what scenario does the __devexit declaration of the function fail? 
In the 2.6 kernel, which the #ifdef's are looking for, it should be
placed into a discard section and thus be taken out at link time.

James




