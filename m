From: Roland Dreier <roland@kernel.org>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 09:30:43 -0700
Message-ID: <CAL1RGDW41oxoES=c+g9oLdx4mriBiEtxRpv=OD7yEJ6XKdU_fQ@mail.gmail.com>
References: <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org> <1309962249.3282.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:40024 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751150Ab1GFQbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 12:31:04 -0400
Received: by qyk32 with SMTP id 32so2331210qyk.7
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2011 09:31:03 -0700 (PDT)
In-Reply-To: <1309962249.3282.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, Jul 6, 2011 at 7:24 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Problem
> most likely missing block guards on blk_execute_req() ... no check for
> QUEUE_DEAD.

blk_execute_req() doesn't exist.  Do you mean __blk_run_queue()?

It does seem bailing out before calling q->request_fn() would fix the
immediate problem, but I'm not sure if that's the right fix.

Jens, have you been following this?  Any opinion?

Thanks,
  Roland
