From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH4/5] mpt fusion: Optimized SendEventNotification
	[Resendig updated patch]
Date: Sat, 10 Jan 2009 16:12:39 -0600
Message-ID: <1231625559.3642.54.camel@localhost.localdomain>
References: <20090108085912.GB4116@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58349 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbZAJWMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 17:12:43 -0500
In-Reply-To: <20090108085912.GB4116@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathya.prakash@lsi.com

On Thu, 2009-01-08 at 14:29 +0530, Kashyap, Desai wrote:
> -
> -       if (reset_alt_ioc_active && ioc->alt_ioc) {
> -               /* (re)Enable alt-IOC! (reply interrupt) */
> -               dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "alt_ioc reply irq re-enabled\n",
> -                   ioc->alt_ioc->name));
> -               CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
> -               ioc->alt_ioc->active = 1;
> +       if (rc == 0) {  /* alt ioc */
> +               if (reset_alt_ioc_active && ioc->alt_ioc) {
> +                       /* (re)Enable alt-IOC! (reply interrupt) */
> +                       dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "alt-ioc
> +                               reply irq re-enabled\n",
> +                               ioc->alt_ioc->name));

This isn't legal C: you can't split a string constant without a
backslash:

drivers/message/fusion/mptbase.c:2295:46: warning: missing terminating " character
drivers/message/fusion/mptbase.c:2296:27: warning: missing terminating " character
drivers/message/fusion/mptbase.c: In function 'mpt_do_ioc_recovery':
drivers/message/fusion/mptbase.c:2295: error: missing terminating " character
drivers/message/fusion/mptbase.c:2295: error: expected ')' before 'reply'
drivers/message/fusion/mptbase.c:2295: error: stray '\' in program
drivers/message/fusion/mptbase.c:2295: error: missing terminating " character
drivers/message/fusion/mptbase.c:2295: warning: too few arguments for format

James


