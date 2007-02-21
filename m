From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: Re: initio.h header user confusion
Date: Wed, 21 Feb 2007 17:33:03 +0000 (GMT)
Message-ID: <Pine.LNX.4.63.0702211721210.5167@thor.lan>
References: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
 <1172077022.3335.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:56164 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030576AbXBURcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 12:32:19 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1097352uga
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 09:32:18 -0800 (PST)
In-Reply-To: <1172077022.3335.24.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 21 Feb 2007, James Bottomley wrote:

> On Wed, 2007-02-21 at 16:12 +0000, Srdjan Todorovic wrote:
> > I'm working on a set of patches for the initio scsi driver and I found
> > some strangeness with its header file, initio.h. I noticed that
> > sun3_scsi.c and sun3_scsi_vme.c include the header, and it uses defines
> > such as SCSI_ABORT_SNOOZE (defined in initio.h).
> 
> It's a remnant of the old 2.4 error handler and should be excised.
> 
> In early 2.4 or perhaps even 2.2 the error handler ran in interrupt
> context, so there was no way of waiting for an abort to complete, hence
> this return value (it told the eh to wait a while for the abort).
> 
> In 2.6 all eh routines run in the context of the host eh thread, so you
> can use standard msleep() etc. calls to wait for aborts to timeout or
> complete.
> 
> James

Thanks for a good short explanation on the scsi error handling.

I poked around a bit more and all but one cases of SCSI_RESET_* are
in #if 0 blocks. The one case is tul_reset_scsi() which returns a
SCSI_RESET_SUCCESS value, which is discarded by the caller anyway.

SCSI_ABORT_* is only used in tul_abort_srb(). This doesn't use the
new error handler threads.

As Matthew Wilcox suggested in a previous email in this thread,
I don't have the expertise to fix this (though I do have the hardware).
I'd like to read up on scsi eh just the same, and might have a go
at fixing this at some point.

Thanks

Srdjan
