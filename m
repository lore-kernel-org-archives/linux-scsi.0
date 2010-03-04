From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 00/32] bfa: update bfa driver to version 2.1.2.1
 (resubmit)
Date: Thu, 04 Mar 2010 16:55:05 +0530
Message-ID: <1267701905.31654.152.camel@mulgrave.site>
References: <1267666892-20243-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab0CDLZS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Mar 2010 06:25:18 -0500
In-Reply-To: <1267666892-20243-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com, huangj@brocade.com

On Wed, 2010-03-03 at 17:41 -0800, kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
> 
> Hi James,
> 
> We are resubmitting brocade bfa 2.1.2.1 driver patch.
> 
> I have made the patches bisectable, now each patch depends only on things
> 
> in its predecessor and is compilable.
> 
> 
> About this submission, we completely reworked the patch set by hand merging
> 
> previous checkins so that each patch addresses a specific issue.
> 
> We hope this patch set meets the upstream standard and gets included in
> 
> your scsi-misc tree. In the following weeks, we will submit more patches
> 
> to clean up the driver and reduce the number of files to be on par
> 
> with most of the upstream drivers.

So it's a lot better, thanks! Unfortunately, it's still a modular
compile failure bisection problem:

MODPOST 904 modules
ERROR: "bfa_ioc_set_ct_hwif" [drivers/scsi/bfa/bfa.ko] undefined!
ERROR: "bfa_ioc_set_cb_hwif" [drivers/scsi/bfa/bfa.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

The reason for this is patch 10, which splits bfa_ioc_cb.c  and .._ct.c
from bfa_ioc.c but doesn't actually add the new files into the Makefile.

I'll apply patches 2-9 ... can you make sure 10-32 compile individually.
I dropped patch 1, because I'm guessing you don't actually want the
version number bumping on an incomplete patch set, so you'll need to
change the version at the end of the new series.

Thanks,

James


