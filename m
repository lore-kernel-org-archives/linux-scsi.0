From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Tue, 06 Jan 2009 15:00:02 -0500
Message-ID: <4963B842.9080304@cybernetics.com>
References: <49593940.9060102@cybernetics.com>	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com> <1230664572.18627.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1949 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZAFUAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 15:00:04 -0500
In-Reply-To: <1230664572.18627.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Aaro Koskinen <Aaro.Koskinen@nokia.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On a device that negotiates asynchronous, this patch causes a WDTR
exchange on every command (not just inquiry/request sense), even on
devices that don't advertise wide support in the inquiry data.  This is
unnecessary overhead, and may (in theory) cause problems for old devices
that don't handle WDTR correctly.  The original code avoided this by
setting nego = 0 in sym_prepare_nego() if the current agreement matched
the goal.  However, it was pointed out that the original code was buggy
because the sym_sir_bad_scsi_status()/S_CHECK_COND branch does not start
a new negotiation (to me it looks like the original code actually does
work if the negotiation will be PPR but not if the negotiation will be
WDTR/SDTR).

This patch forces either WDTR or PPR on every inquiry and request
sense.  I think it would be better if the negotiation was skipped if the
current agreement and the goal are both narrow/asynchronous; that way we
don't try to negotiate at all for devices that don't support wide or sync.

If the current agreement is 16-bit wide with a nonzero sync offset, and
only the sync parameters need to be renegotiated (e.g. during DV), the
original code will use just SDTR without WDTR, and this patch will use
WDTR followed by SDTR.  I agree that this is probably a good change. 
However, if the current agreement is 8-bit narrow and only the sync
parameters need to be renegotiated, then I think it would be better to
use SDTR only.  That way we don't rely on WDTR working in order to use
SDTR successfully.

To summarize, I think the following would be the best policy:

on every inquiry and request sense:
1) if both the current and goal are narrow/async, then don't negotiate
2) if the current and goal are both 8-bit narrow but with nonzero
offset, then use SDTR only
3) if either the current or goal are 16-bit wide, then use WDTR+SDTR or PPR

on commands other than inquiry and request sense:
4) if the current and goal are the same, then don't negotiate
5) if the current and goal are both 8-bit narrow but with nonzero
offset, then use SDTR only
6) if either the current or goal are 16-bit wide, then use WDTR+SDTR or PPR

If you tell sym_prepare_nego() whether or not the command is inquiry or
request sense, then it should be fairly straightforward to implement
this policy.

Tony

