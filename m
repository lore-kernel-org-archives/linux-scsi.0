From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 10:47:41 -0500
Message-ID: <20101117154741.GA16768@infradead.org>
References: <20101117062958.GA2894@havoc.gtf.org>
 <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
 <4CE38D70.4010507@garzik.org>
 <1290007719.4736.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab0KQPrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 10:47:53 -0500
Content-Disposition: inline
In-Reply-To: <1290007719.4736.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>

> Right ... I couldn't persuade anyone else to do it, so I'll probably end
> up coding it.  It looks like the serial number zero check might be
> bogus.  If so I'll remove it, then push the serial number acquisition
> down only into the locked queuecommand of only those drivers that
> actually use it (which were listed in the quoted email, and which might
> have a big impetus to remove it if the use is trivial).  Then we can
> begin unwinding the locking.

In dc395x, eata_pio, in2000, lpfc, megaraid_legacy, megaraid_mbox,
megaraid_sas, mesh, ncr53c8xx, qla1280, qla4xxx, wd33c93 and i2o_scsi
use it in printks only, and all this can be safely removed.

Except for EH that only leaves dpt_i2o, eata, mpt2sas, u14-34f, mptscsi
as non-trivial users.  If you sort out the EH side I'll volunteer to
kill the printks and add private serial numbers to the five drivers
mentioned above.
