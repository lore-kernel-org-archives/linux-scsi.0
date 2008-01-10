From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to
	unlocked_ioctl
Date: Thu, 10 Jan 2008 13:03:48 -0600
Message-ID: <1199991828.3141.82.camel@localhost.localdomain>
References: <20080110180529.GA32640@skl-net.de>
	 <1199991298.3141.75.camel@localhost.localdomain>
	 <20080110185944.GA1690@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756253AbYAJTD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 14:03:56 -0500
In-Reply-To: <20080110185944.GA1690@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Andre Noll <maan@systemlinux.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>


On Thu, 2008-01-10 at 19:59 +0100, Andi Kleen wrote:
> > Really, all this is doing is open coding what the ioctl handler is doing
> > anyway, isn't it? in which case, why bother to change it at all?
> 
> Because once it's open coded it is visible and can then be eliminated.
> Does SCSI need the BKL at all?

No, of course not ... it hasn't for ages, otherwise linux performance
would be in the tank.  If we require the BKL at all in the ioctl path it
will be to protect the non-SCSI structures we have to use.  Is there any
guide to which structures in the kernel still require the BKL?

> But perhaps for such a long ioctl handler it would be better to move
> the lock/unlock_kernel()s into the individual case ...: statements;
> then it could be eliminated step by step.

James


