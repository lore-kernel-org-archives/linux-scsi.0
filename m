From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] qla2xxx: Restrict max_luns to 16-bit for older HBAs
Date: Wed, 14 May 2014 23:38:12 -0700
Message-ID: <20140515063812.GA16326@infradead.org>
References: <1386673515-87133-1-git-send-email-hare@suse.de>
 <1386673515-87133-4-git-send-email-hare@suse.de>
 <alpine.WNT.2.00.1312101325550.5984@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOGiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 02:38:14 -0400
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.1312101325550.5984@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Dec 10, 2013 at 01:26:21PM -0500, Chad Dupuis wrote:
> >+	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha)) {
> >+		/* HW supports only 16-bit LUNs */
> >+		if (ql2xmaxlun > 0xffff)
> >+			ql2xmaxlun = 0xffff;
> >+	}
> >	host->max_lun = ql2xmaxlun;

ql2xmaxlun is a global variable.  This should be changed to work on
host->max_lun instead.

