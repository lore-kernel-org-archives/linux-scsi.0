From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [Update] suspending I/Os to a device
Date: Sun, 5 Sep 2004 12:17:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905121701.A29446@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F1A5@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:43014 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266252AbUIELRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2004 07:17:13 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1A5@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Sat, Sep 04, 2004 at 07:15:35PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, andmike@us.ibm.com

> As for the hostdata - I don't see any api violation. Hostdata is whatever context the driver wants when it receives commands for a lun. In a general sense - yes, this is typically a lun structure. However, it doesn't have to be. The only real rule is that it is a valid context for the lun during the duration between slave_alloc & free. In our case, the adapter interface doesn't track luns - it tracks remote nports (aka targets). Thus the context is a more general target structure.

Umm, I didn't mean to imply that there was an API violation.  Of course you
can store per-target data in sdev->hostadata - in fact that's the only
sensible thing to do right now.

But to get lifetime rules for that right you'd have to refcount the object
in there, not just keeep it around until host removal like lpfc (and for
example fusion aswell) do right now.  The best way is to re-use the
refcounting in scsi_target for that instead of duplicating that in every
driver.

