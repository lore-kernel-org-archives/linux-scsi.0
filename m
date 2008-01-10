From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Date: Thu, 10 Jan 2008 20:29:50 +0100
Message-ID: <20080110192950.GG747@one.firstfloor.org>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <20080110190748.GA20152@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:40133 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYAJT1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 14:27:13 -0500
Content-Disposition: inline
In-Reply-To: <20080110190748.GA20152@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

On Thu, Jan 10, 2008 at 08:07:48PM +0100, Andre Noll wrote:
> On 19:59, Andi Kleen wrote:
> 
> > But perhaps for such a long ioctl handler it would be better to move
> > the lock/unlock_kernel()s into the individual case ...: statements;
> > then it could be eliminated step by step.
> 
> Sure, I can do that if James likes the idea. Since not all case
> statements need the BKL, we could add it only to those for which it
> isn't clear that it is unnecessary.
> 
> And this would actually improve something.

I still think it would be a good strategy to first add it to all
(in a essentially nop semantics patch) and then later eliminate
it from the cases that obviously don't need it. 

But yes eliminating it from all is the long term goal.

-Andi
