Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A958C3E8C5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB03521973
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 21:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgK0Vsb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 16:48:31 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:55986 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732404AbgK0VsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2020 16:48:06 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 5492629698;
        Fri, 27 Nov 2020 16:48:02 -0500 (EST)
Date:   Sat, 28 Nov 2020 08:48:00 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>
cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
In-Reply-To: <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet>
Message-ID: <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
References: <20201126132952.2287996-1-bigeasy@linutronix.de> <20201126132952.2287996-13-bigeasy@linutronix.de> <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet> <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Sat, 28 Nov 2020, Finn Thain wrote:

> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index d654a6cc4162..739def70cffb 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
>  		cpu_relax();
>  	} while (n--);
>  
> -	if (irqs_disabled() || in_interrupt())
> +	/* We can't sleep when local irqs are disabled and callers ensure
> +	 * that local irqs are disabled whenever we can't sleep.
> +	 */
> +	if (irqs_disabled())
>  		return -ETIMEDOUT;
>  
>  	/* Repeatedly sleep for 1 ms until deadline */
> 

Michael, Andreas, would you please confirm that this is workable on Atari? 
The driver could sleep when IPL == 2 because arch_irqs_disabled_flags() 
would return false (on Atari). I'm wondering whether that would deadlock.
