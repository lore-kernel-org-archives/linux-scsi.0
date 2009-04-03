From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/15] Open-FCoE updates (fixes and a feature) for
	2.6.30 merge window
Date: Fri, 03 Apr 2009 22:14:00 +0000
Message-ID: <1238796840.3359.95.camel@mulgrave.int.hansenpartnership.com>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49896 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756495AbZDCWOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 18:14:04 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-04-03 at 14:57 -0700, Robert Love wrote:
> The following series implements some bug fixes to libfc
> and the addition of dynamic logging capabilities for libfc,
> libfcoe and fcoe.

Realistically, this is pretty much too late for 2.6.30.  It needs at
least a cursory review and incubation in linux-next (which doesn't build
over the weekend anyway) which can't happen before Linus declares -rc1
estimated to be on Tuesday.

> The bug fixes are mostly related to the rogue rport
> tracking that libfc does before getting a "real"
> rport from the FC transport. Also there are locking
> and state verification fixes.
> 
> The dynamic logging code was originally mailed to
> linux-scsi during the 2.6.29 rc phase, but was
> incorrectly mixed in with fixes. This is a refresh
> of that patch set. Since that original patch set
> libfcoe and fcoe have been better distinguished as
> separate modules, so this patch set was modified to
> reflect that change.
> 
> ---
> 
> Abhijeet Joglekar (6):
>       libfc: whenever queueing delete ev for rport, set state to NONE
>       libfc: Change state to NONE in fc_lport_destroy
>       libfc: During fabric logoff, flush the rport Q after logging off dns port
>       libfc: Track rogue remote ports
>       libfc: Do not retry if the new state is not the same as old state
>       libfc: Hold disc mutex while processing gpn ft resp
> 
> Robert Love (9):
>       libfc: Remove unused FC_DBG macro
>       libfc: Convert debug statements in fc_exch.c to use new libfc debug macros.
>       libfc: Convert debug statements in fc_fcp.c to use new libfc debug macros.
>       libfc: Convert debug statements in fc_rport.c to use new libfc debug macros.
>       libfc: Convert debug statements in fc_disc.c to use new libfc debug macros.
>       libfc: Convert debug statements in fc_lport.c to use new libfc debug macros.
>       libfc: Add runtime debugging with debug_logging module parameter
>       libfcoe: Add runtime debugging with module param debug_logging
>       fcoe: Add runtime debug logging with module parameter debug_logging

Couldn't these just have been a single patch?  Or one patch for the
macro conversion and one for the module parameters.  There's no need at
all to do one patch per file when converting.

James


