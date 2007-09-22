From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery improvements, and
	synchronizing internal commands
Date: Sat, 22 Sep 2007 11:22:32 -0500
Message-ID: <1190478152.3347.25.camel@localhost.localdomain>
References: <20070918015952.GA22742@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43225 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754726AbXIVQWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2007 12:22:36 -0400
In-Reply-To: <20070918015952.GA22742@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-09-17 at 19:59 -0600, Eric Moore wrote:
> 1) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.
> 2) set vtarget->deleted flag when devices have been removed.
> 3) mdr@sgi.com - fix's provided from SGI after testing with single threaded internal commands

OK, I thought I'd wait here for the breakout, but in the meantime I
tried to compile the first five patches, but they don't:

  CC [M]  drivers/message/fusion/mptscsih.o
drivers/message/fusion/mptscsih.c: In function 'mptscsih_qcmd':
drivers/message/fusion/mptscsih.c:1357: error: 'MPT_SCSI_HOST' has no
member named 'resetPending'
drivers/message/fusion/mptscsih.c: In function 'mptscsih_TMHandler':
drivers/message/fusion/mptscsih.c:1554: error: 'MPT_ADAPTER' has no
member named 'diagLock'
...

The series can't be applied in this form, because if git bisect steps
into the middle of this, the compile will break (and hence the
bisection) and a lot of people will say a lot of nasty things.

A patch series really needs to be one patch per logical change (with
other peoples' patches broken out) in a form that is separately
compilable for each patch.  Additionally, with a separate change log and
summary (i.e. not four patches all saying "mpt fusion: error recovery
improvements, and synchronizing internal commands").

I'll back all of this out; can you resend the series conforming to the
above request?

Thanks,

James



