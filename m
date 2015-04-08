From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: smp_processor_id warning in megasas driver on 3.19.3
Date: Wed, 08 Apr 2015 11:17:49 -0700
Message-ID: <1428517069.2224.36.camel@HansenPartnership.com>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53537 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbbDHSRw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 14:17:52 -0400
In-Reply-To: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, 2015-04-08 at 10:59 -0700, Andy Lutomirski wrote:
> This is a regression somewhere between 3.15 and 3.19.3.  Let me know
> if more diagnostics would be helpful.

It's not a regression.  Likely someone turned on additional warnings.
So the problem is that the warning is incorrect: the use of
smp_processor_id() isn't pre-empt unsafe.  The driver is using it as a
hint as to which queue it should be using, so it doesn't matter if
pre-empt schedules the driver thread away from that CPU.

I presume the warning is because whoever added it thinks that you should
be using the get/put cpu API, which would be wholly inappropriate here
because we don't want to bind the thread, we just want a hint about the
queue.

James


