From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] sd: Handle ZBC drives correctly
Date: Tue, 22 Jul 2014 09:19:17 -0700
Message-ID: <20140722161917.GA763@infradead.org>
References: <1405931241-92015-1-git-send-email-hare@suse.de>
 <1405931241-92015-5-git-send-email-hare@suse.de>
 <20140721112904.GB15455@infradead.org>
 <53CCFEBE.8080400@suse.de>
 <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaGVQTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 12:19:19 -0400
Content-Disposition: inline
In-Reply-To: <8A51900D08212F40B3DE22453052F69839C47278@wdscexmb02>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Utz <John.Utz@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomely <jbottomley@parallels.com>

Hi John,

I can't really comment much on the ATA side as I'm not overly uptodate
on the ZAC spec.

But a device with the 0x14 device type must have sequential required
zones, which will generate new sense codes when writes outside the
write pointer happens.  I'm very concerned about

 a) how the SCSI midlayer handles those sense codes

and

 b) how we can communicate them to the user of the device, e.g. the
    filesystem or user application

Just attaching the device by default without a good solution for these
seems dangerous to me.

