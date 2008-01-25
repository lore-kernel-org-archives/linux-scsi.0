From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 11:38:41 -0600
Message-ID: <1201282722.3119.44.camel@localhost.localdomain>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
	 <479727D5.8060901@garzik.org>
	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com>
	 <da824cf30801250924i5e8cd5c6pe07215a4298ab8a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48587 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbYAYRir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 12:38:47 -0500
In-Reply-To: <da824cf30801250924i5e8cd5c6pe07215a4298ab8a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Ke Wei <kewei.mv@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com


On Fri, 2008-01-25 at 09:24 -0800, Grant Grundler wrote:
> On Jan 25, 2008 8:43 AM, Ke Wei <kewei.mv@gmail.com> wrote:
> > The attached is Marvell 6440 SAS/SATA driver. I will try to send email
> > by git-send-email.
> 
> I know this isn't part of this patch:
>  #define mr32(reg)	readl(regs + MVS_##reg)
>  #define mw32(reg,val)	writel((val), regs + MVS_##reg)
> 
> But can "regs" be declared a parameter to the macro?
> And the one letter difference in the name is just asking for trouble.
> Better to call it "mmio_base" or something a bit longer that won't
> likely collide with other stuff.
> 
> +/* offset for D2H FIS in the Received FIS List Structure */
> +#define SATA_RECEIVED_D2H_FIS(reg_set) \
> +	(mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
> 
> Ditto.
> 
> +	MODE_AUTO_DET_PORT7 = (1U << 15),	/* port0 SAS/SATA autodetect */
> +	MODE_AUTO_DET_PORT6 = (1U << 14),
> +	MODE_AUTO_DET_PORT5 = (1U << 13),
> +	MODE_AUTO_DET_PORT4 = (1U << 12),
> +	MODE_AUTO_DET_PORT3 = (1U << 11),
> +	MODE_AUTO_DET_PORT2 = (1U << 10),
> +	MODE_AUTO_DET_PORT1 = (1U << 9),
> +	MODE_AUTO_DET_PORT0 = (1U << 8),
> 
> These really aren't needed.
> 
> #define MODE_AUTO_DET_EN   (0xff << 8)    /* enable auto detect on all
> 8 ports */
> 
> 
> Ditto for MODE_SAS_SATA.

Given that we don't have public docs for this driver, having register
bit definitions in the driver, even if they aren't used anywhere can be
incredibly helpful, so please don't remove them.  Even more useful would
be additional comments saying what they actually do ...

James


