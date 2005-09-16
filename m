From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6.14-rc1 1/3] Add disk hotswap support to libata RESEND
 #3
Date: Thu, 15 Sep 2005 23:08:24 -0400
Message-ID: <432A3728.6040501@pobox.com>
References: <355e5e5e05091422061a3a9f28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:35291 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030547AbVIPDI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 23:08:28 -0400
In-Reply-To: <355e5e5e05091422061a3a9f28@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkosewsk@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> Patch 1/3 for libata hotswapping.  Properly masks out interrupts for
> Promise SATAII150 Tx2Plus/Tx4 controllers.  More comments in patch
> header.
> 
> Luke Kosewski
> 
> 
> ------------------------------------------------------------------------
> 
> 15.09.05    Luke Kosewski   <lkosewsk@nit.ca>
> 
> 	* A patch to the sata_promise driver in libata for it to correctly mask
> 	  out hotplug interrupts on SATAII150 Tx4/Tx2 Plus controllers.
> 	* This is resend #3.  It no longer applies to a -mm tree, but to
> 	  2.6.14-rc1.  Therefore, the entry for board_2057x no longer has
> 	  ATA_FLAG_SATA commented out.

You need to add a ->host_stop() hook that frees pdc_host_priv, otherwise 
you have a memory leak on module remove/controller unplug.

Once fixed, this patch could go in immediately, it looks like.

	Jeff



