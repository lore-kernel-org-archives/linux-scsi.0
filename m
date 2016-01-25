From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Allow activation of scsi-mq per-driver
Date: Mon, 25 Jan 2016 02:05:25 -0800
Message-ID: <20160125100525.GA24369@infradead.org>
References: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbcAYKF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 05:05:29 -0500
Content-Disposition: inline
In-Reply-To: <1453470088-43959-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Fri, Jan 22, 2016 at 02:41:28PM +0100, Johannes Thumshirn wrote:
> Allow the activation of the scsi-mq feature on a per-driver bassis as opposed
> to the current stack global (de)activation.
> 
> This allows us to have setups which can combine "slow" rotational media and
> fast media on two different HBA types.

It's still the wrong thing to do.  One of your co-workers has been
working on slicing for blk-mq to better support slower adapters.

Anything that prolongs the misery of keeping the old request code around
is a bad idea.

> The following is from a host with rotational disks behind a HP SAS Adapter and
> a fibre channel array behind a Emulex FC Adapter. The hpsa driver does not
> support scsi-mq yet (and has rotational disks attached to it), but the lpfc
> does. This patch allows an optimal combination of the scsi-mq enabled lpfc
> driver and the hpsa driver which still uses a single queue scsi layer and thus
> can make use of IO schedulers.

And this is another reason why this is bad.  There are very slow dumb
FC array arounds as well as really fast ones.  And there are really slow
SATA disks behind SAS controllers as well as really fast SSDs.

The host is simply the wrong place to decide these things.
