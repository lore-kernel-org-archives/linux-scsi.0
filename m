From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 17:30:08 -0400
Message-ID: <59ad55d30705111430o3142dd6m37c05475a1b3c6dd@mail.gmail.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <4644DE1F.8050107@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:10397 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbXEKVaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:30:09 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1190112wra
        for <linux-scsi@vger.kernel.org>; Fri, 11 May 2007 14:30:08 -0700 (PDT)
In-Reply-To: <4644DE1F.8050107@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 5/11/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> James Bottomley wrote:
...
> > It strikes me that in all of this, we could also consider doing the DMA
> > mapping inside the mid layer (instead of in every driver).  This is
> > essentially what libata is already doing ... leading to confusion in
> > SCSI drivers that use libata for SATA.
> >
> > So what do people think about this?
>
> The old SBP-2 driver needs the virtual addresses of S/G elements if
> compiled with a certain config option.  This option is meant for use
> with FireWire controllers which do not implement OHCI-1394, or to run
> the IEEE 1394 stack in a more secure mode.   However, sbp2 seems to be
> broken in multiple ways with this option at the moment, and I don't plan
> to fix it anytime soon.
>
> So in short, moving the DMA mapping into mid layer should also be fine
> with the old and the new SBP-2 driver.

Well, if we want to make a more secure mode for fw-sbp2.c where it,
like the old driver, manually copies the payload data from the general
async receive buffer to the destination, we'll still need the virtual
address.  How does the usb storage driver handle this?

Kristian
