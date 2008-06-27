From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/9] scsi_dh: add generic SPC-3 alua handler
Date: Fri, 27 Jun 2008 09:38:16 -0500
Message-ID: <1214577496.3394.12.camel@localhost.localdomain>
References: <20080624100504.7D8C210B5DE@craiglockhart-ipmi.suse.de>
	 <486424BA.8040301@cs.wisc.edu>  <4864FA31.9020401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34486 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027AbYF0OiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2008 10:38:19 -0400
In-Reply-To: <4864FA31.9020401@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Fri, 2008-06-27 at 16:33 +0200, Hannes Reinecke wrote:
> I cannot see how this _could_ fail, as this function is provided by
> the module, so the very existence of the function depends on the
> module. But maybe it's better to check, even so.
> 
> I'll send an updated patch.

Just because you're in the actual module it's not safe to assume
try_module_get() will succeed.  The modules have a state variable
(->state) if the user tries to remove the module, this state check will
fail in try_module_get() and it will actually return a failure.

James


