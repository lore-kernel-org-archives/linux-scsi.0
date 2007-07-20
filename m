From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 8/9] qla2xxx: Add ISP25XX support.
Date: Thu, 19 Jul 2007 17:08:13 -0700
Message-ID: <20070720000813.GR4015@plap.qlogic.org>
References: <20070719220456.GK4015@plap.qlogic.org> <11848827643315-git-send-email-andrew.vasquez@qlogic.com> <1184885633.3464.114.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46250 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761540AbXGTAIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 20:08:19 -0400
Content-Disposition: inline
In-Reply-To: <1184885633.3464.114.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 19 Jul 2007, James Bottomley wrote:

> On Thu, 2007-07-19 at 15:06 -0700, Andrew Vasquez wrote:
> > +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
> > +		WRT_REG_DWORD(dmp_reg, 0xB0100000);
> > +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
> > +		fw->shadow_reg[1] = htonl(RD_REG_DWORD(dmp_reg));
> 
> Repeating this horrible cast over and over again is really eye watering.
> 
> If you can't simply extend the struct device_reg_24xx as device_reg_25xx
> or something which seems more logical, what about 
> 
> uint32_t __iomem *mailbox_reg_select = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
> uint32_t __iomem *mailbox_reg_value = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);

Ok, let me clean this up a bit...

--
av
