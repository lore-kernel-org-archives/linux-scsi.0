From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 14:58:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D09845.9030201@adaptec.com>
References: <3356669BBE90C448AD4645C843E2BF28034F94EE@xbl.ma.emulex.com> <1087405441.2067.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15235 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264452AbUFPS6Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 14:58:16 -0400
In-Reply-To: <1087405441.2067.25.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Smart, James" <James.Smart@Emulex.Com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>  > So why increment the retries counter at all ?
> 
> So drivers can't return EH_RESET_TIMER forever. This really ties the

EH_RESET_TIMER means "This command had nothing to do with why
its timer timed out and is expected to complete shortly."

Do we want to increment its retry counter for this,
as it isn't really a retry.

> handling into the behaviour the user has requested.  The only wrinkle
> was the no retry streaming commands.  The assumption is that a retry

They also fall in the same category -- the application client cannot
retry them, but the LLDD knows best and it may perform some magic
for which SCSI Core shouldn't account for.

> doesn't actually happen under eh_timed_out, but only an attempt to
> collect an existing command which may be delayed because of transport or
> other problems the host knows about.

Can we get a finalised patch so we can test it?
James, is the one you posted what you'll have in?

-- 
Luben


