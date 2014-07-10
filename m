From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 79901] New: Extremely slow boot on Promise VTrak E610f due
 to sd_mod RSOC usage
Date: Thu, 10 Jul 2014 06:54:15 -0700
Message-ID: <20140710135415.GA1621@infradead.org>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaGJNyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 09:54:16 -0400
Content-Disposition: inline
In-Reply-To: <bug-79901-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rraptorr@nails.eu.org
Cc: linux-scsi@vger.kernel.org

Sounds like we need to skip REPORT SUPPORTED OPERATION CODES on this
array.

For this it needs a new BLIST_NORSOC flag added to
include/scsi/scsi_devinfo.h which sets sdev->no_report_opcodes in
scsi_add_lun, and an entry for your array in the big black list array in
drivers/scsi/scsi_devinfo.c.  Does this sound easy enough that you could
prepare a patch for it?

