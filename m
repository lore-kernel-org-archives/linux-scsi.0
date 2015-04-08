From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: smp_processor_id warning in megasas driver on 3.19.3
Date: Wed, 8 Apr 2015 11:26:35 -0700
Message-ID: <CALCETrUbOrUnu8zp_yfQj_vG7EZeo7rSw8XJXcmhNxD-gQRxRw@mail.gmail.com>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
 <1428517069.2224.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34024 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbbDHS05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 14:26:57 -0400
Received: by lbcga7 with SMTP id ga7so23997422lbc.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2015 11:26:56 -0700 (PDT)
In-Reply-To: <1428517069.2224.36.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Apr 8, 2015 at 11:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2015-04-08 at 10:59 -0700, Andy Lutomirski wrote:
>> This is a regression somewhere between 3.15 and 3.19.3.  Let me know
>> if more diagnostics would be helpful.
>
> It's not a regression.  Likely someone turned on additional warnings.
> So the problem is that the warning is incorrect: the use of
> smp_processor_id() isn't pre-empt unsafe.  The driver is using it as a
> hint as to which queue it should be using, so it doesn't matter if
> pre-empt schedules the driver thread away from that CPU.

The warning goes a long way back.  For example, this change from 2005
seems to have refactored it:

commit 39c715b71740c4a78ba4769fb54826929bac03cb
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jun 21 17:14:34 2005 -0700

    [PATCH] smp_processor_id() cleanup


>
> I presume the warning is because whoever added it thinks that you should
> be using the get/put cpu API, which would be wholly inappropriate here
> because we don't want to bind the thread, we just want a hint about the
> queue.

Would raw_smp_processor_id be a good compromise?  I'm testing a patch
right now and, if it works, I can send it and cc stable.

--Andy
