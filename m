From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: mptspi dv problems
Date: Thu, 28 Sep 2006 14:50:53 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70350168@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3298 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750849AbWI1Uu6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 16:50:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Mark Haverkamp wrote:

> 
> The recent dv changes to scsi_transport_spi.c have fixed the problems
> that I had with my U160 drives being set to async/narrow but there are
> still problems with my U320 drive causing indefinite dv on my system.


> mptscsih: ioc0: attempting task abort! (sc=f734bc80)
>         command: cdb[0]=0x12: 12 00 00 00 60 00
> mptbase: Initiating ioc0 recovery
> 


jejb - The problem is the task abort occurs as a result of the
factor 0x8 max speed inquiry test timing out to the end device.  The
task
abort results in a host reset.  The host reset results in
domain validation running again.  The thread running the host reset
returns 
control back to the device that failed the max speed inquiry test
and exits dv; meanwhile the worker thread is still running and
requesting domain validation on all devices, to include the one that
failed.  When get back to the failed device, the previous dv run had
already completed, and we are running dv all over again the same
device, which will timeout the inquiry test.

I had already provided a patch that will fix this problem on the mailing
list. 
The idea is we don't issue domain validation again if were in host
reset and when some device is in the middle of domain validation.
Instead
we send previous nego parameters out to devices that have been already
configured.

This needs to be fixed one way or another.  If mid layer didn't issue 
host reset when command timed out, such as a target reset, we wouldn't
encounter this.   

Eric Moore 


