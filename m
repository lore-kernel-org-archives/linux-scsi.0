From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patches for SCSI scanning
Date: 20 Apr 2004 09:38:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082471881.1804.34.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
	<1082330192.1969.37.camel@mulgrave>
	<20040420115419.GG4356@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:37323 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263019AbUDTOiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 10:38:07 -0400
In-Reply-To: <20040420115419.GG4356@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, 2004-04-20 at 06:54, Kurt Garloff wrote:
> What about the others:
> * Patch 2: Drop REPORT_LUN config option and introduce 
>   noreportlun and reportlun2 parameters (the latter allowing SCSI-2
>   devs to be scanned with REPORT_LUNS).

Agree, but should be a blacklist flag to force the use of report luns in
the scan.

> * Patch 3: Allow host adapters to avoid REPORT_LUNS.

This should be a black list flag too, but first explain why we need it. 
The only devices we do REPORT_LUNS for are SCSI 3 ones.  Which SCSI 3
device is so badly implemented as to respond incorrectly?  I mean these
are recent devices, so the implementors should have learned from past
mistakes, right ?

> * Patch 4: allow_ghost_devices parameter

Blacklist flag again (oh and "Yuk!!!" by the way).

> * Patch 5: inq_timeout parameter

OK, just remove the arch gating of the default (ppc64 will have to have
a permanent boot/module flag).

> If we introduce two more BLIST flags (BLIST_NOREPORTLUN and
> BLIST_REPORTLUN2), we can get rid of patch 2 and 3, if we add another one
> (BLIST_LUN0ONLINE), we can get rid off 4.
> 
> We have 16 bits left, so it should be possible.
> 
> If there's consensus to go that way, I can code it up, no problem.
> Only patch 5 will remain then ...

Yes, I'm fine with that (as long as the arch specific code from patch 5
goes).

> Sidenote: We should drop SCSI_FORCELUN and CONFIG_SCSI_MULTI_LUN, otherwise 
> people will misconfigure their kernel (such as the HP guy) and start to want 
> every multi-lun device listed.

Yes, sounds reasonable.  We can do it all with the boot flags now.

James


