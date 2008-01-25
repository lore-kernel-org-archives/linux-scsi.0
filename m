From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Fri, 25 Jan 2008 17:12:50 -0500
Message-ID: <479A5EE2.1010908@garzik.org>
References: <20080122151857.GA8680@ubuntu.domain>	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>	 <4796BB5A.9090003@garzik.org>	 <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>	 <479727D5.8060901@garzik.org>	 <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com> <da824cf30801250924i5e8cd5c6pe07215a4298ab8a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54930 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYAYWMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 17:12:54 -0500
In-Reply-To: <da824cf30801250924i5e8cd5c6pe07215a4298ab8a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

Grant Grundler wrote:
> On Jan 25, 2008 8:43 AM, Ke Wei <kewei.mv@gmail.com> wrote:
>> The attached is Marvell 6440 SAS/SATA driver. I will try to send email
>> by git-send-email.
> 
> I know this isn't part of this patch:
>  #define mr32(reg)	readl(regs + MVS_##reg)
>  #define mw32(reg,val)	writel((val), regs + MVS_##reg)
> 
> But can "regs" be declared a parameter to the macro?

This is a common technique in drivers (especially net drivers), 
eliminating the redundant-across-the-entire-driver argument passed to 
each register read or write.  The result is infinitely more readable and 
compact.

	val = mr32(IRQ_STAT);

immediately communicates all the necessary information you need.


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

Like James noted, without public docs, we don't want to be removing any 
hardware definitions.


> Have to stop for now...but I'm wonder how this driver ever worked
> given the number of HW register bits that were changed (assuming
> they were wrong before this patch). And this driver looks _alot_
> better than the previous Marvell drivers I've looked at. Please keep
> up the good work! :)

Before this patch, the driver did not work.  As I do with all other 
drivers I write, I write the entire driver from the datasheet before 
testing anything.

	Jeff



