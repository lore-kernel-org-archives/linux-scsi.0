From: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] sym53c8xx_2: Keep transfer negotiations valid (2.6.27.5)
Date: Wed, 07 Jan 2009 15:19:57 +0200
Message-ID: <4964ABFD.9000807@nokia.com>
References: <49593940.9060102@cybernetics.com>	 <1230631843-16470-1-git-send-email-Aaro.Koskinen@nokia.com> <1230664572.18627.2.camel@localhost.localdomain> <4963B842.9080304@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29555 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbZAGNUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 08:20:44 -0500
In-Reply-To: <4963B842.9080304@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ext Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

Hello,

ext Tony Battersby wrote:
> On a device that negotiates asynchronous, this patch causes a WDTR
> exchange on every command (not just inquiry/request sense), even on
> devices that don't advertise wide support in the inquiry data.  This is
> unnecessary overhead, and may (in theory) cause problems for old devices
> that don't handle WDTR correctly.

Yes, this is overlooked in the patch. Also if there is no synch nego or 
WDTR is rejected, then check_nego flag will stay on forever.

> This patch forces either WDTR or PPR on every inquiry and request
> sense.  I think it would be better if the negotiation was skipped if the
> current agreement and the goal are both narrow/asynchronous; that way we
> don't try to negotiate at all for devices that don't support wide or sync.

[...]

> However, if the current agreement is 8-bit narrow and only the sync
> parameters need to be renegotiated, then I think it would be better to
> use SDTR only.  That way we don't rely on WDTR working in order to use
> SDTR successfully.

These are both valid points. I will update the patch.

A.
