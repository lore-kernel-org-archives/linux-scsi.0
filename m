From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 3 Aug 2015 11:04:28 -0400
Message-ID: <20150803150428.GE32599@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:36579 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbbHCPEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:04:31 -0400
Content-Disposition: inline
In-Reply-To: <55BF18ED.3000002@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>

Hello,

On Mon, Aug 03, 2015 at 09:31:57AM +0200, Hannes Reinecke wrote:
> The whole point of the autosense feature is that you do _not_
> have to fall back to the original trial-and-error libata EH,
> but know exactly what the problem is. Plus any retry will be giving
> us (in most cases) exactly the same sense code.

Can you please give some examples?  As lacking as ATA error reporting
is, it still can tell whether retry is necessary or not in most cases.

> _And_ the SCSI layer is actually able to understand the sense code,
> allowing him to make a better judgment on what to do with that error.
>
> So any retry in the libata layer will only slow things down,
> leading to the same results eventually.

Have you tested actual error handling?  I doubt this would work as you
expect it to.  libata EH takes over the entire error handling and when
it determines that the command has failed and retrying won't do any
good, it tells SCSI EH to not retry either.

Ugh... so this is from NCQ autosense thing.  Now ATA devices reports
sense data too which trumps AC_ERR_DEV so libata EH decides to retry
even when the device indicates unrecoverable error.  Urgh... we
shouldn't be taking completely different error handling paths because
a device chooses to report error conditions slightly differently.
Please map them so that they behave in a consistent manner.  I'm gonna
plug autosense for now.

Thanks.

-- 
tejun
