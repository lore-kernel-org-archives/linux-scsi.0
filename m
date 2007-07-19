From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 8/9] qla2xxx: Add ISP25XX support.
Date: Thu, 19 Jul 2007 17:53:53 -0500
Message-ID: <1184885633.3464.114.camel@localhost.localdomain>
References: <20070719220456.GK4015@plap.qlogic.org>
	 <11848827643315-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60582 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753609AbXGSWx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:53:56 -0400
In-Reply-To: <11848827643315-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2007-07-19 at 15:06 -0700, Andrew Vasquez wrote:
> +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
> +		WRT_REG_DWORD(dmp_reg, 0xB0100000);
> +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
> +		fw->shadow_reg[1] = htonl(RD_REG_DWORD(dmp_reg));

Repeating this horrible cast over and over again is really eye watering.

If you can't simply extend the struct device_reg_24xx as device_reg_25xx
or something which seems more logical, what about 

uint32_t __iomem *mailbox_reg_select = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
uint32_t __iomem *mailbox_reg_value = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);

?

James


