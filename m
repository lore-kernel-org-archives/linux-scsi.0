From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 3 Aug 2015 11:18:26 -0400
Message-ID: <20150803151826.GG32599@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36052 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbHCPSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:18:39 -0400
Content-Disposition: inline
In-Reply-To: <20150803150428.GE32599@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>

Adding a bit.

On Mon, Aug 03, 2015 at 11:04:28AM -0400, Tejun Heo wrote:
> Ugh... so this is from NCQ autosense thing.  Now ATA devices reports
> sense data too which trumps AC_ERR_DEV so libata EH decides to retry
> even when the device indicates unrecoverable error.  Urgh... we
> shouldn't be taking completely different error handling paths because
> a device chooses to report error conditions slightly differently.
> Please map them so that they behave in a consistent manner.  I'm gonna
> plug autosense for now.

Also, is there anything substantial we gain from NCQ autosense?  Why
do we want this in the first place?  ATA error reporting is
rudimentary but it more or less works and I'm not sure whether we'd
want to overhaul its basic behaviors at this stage.

Thanks.

-- 
tejun
