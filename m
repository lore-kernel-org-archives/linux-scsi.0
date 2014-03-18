From: Christoph Hellwig <hch@infradead.org>
Subject: BLIST_SINGLELUN
Date: Tue, 18 Mar 2014 07:28:04 -0700
Message-ID: <20140318142804.GA25309@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbaCRO2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 10:28:05 -0400
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WPuzs-0007nl-Vp
	for linux-scsi@vger.kernel.org; Tue, 18 Mar 2014 14:28:04 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Does anyone still have a device listed in the blacklist with
BLIST_SINGLELUN?

>From reading the source code I'm not sure the code actually works as
expected currently, or did for a long time.

While scsi_target_queue_ready makes sure to only queue commands to the
right lun as long as starget_sdev_user is set, scsi_single_lun_run
clears starget_sdev_user as soon as the any command completes on a
target marked with the flag, allowing the following situation:

 - cmd 1 lun 0		submitted
 - cmd 2 lun 0		submitted
 - cmd 1 lun 0		completed
 - cmd 9 lun 1		submitted

and thus having commands for two luns in flight at the same time
if we hit the narrow enough race of entering the scsi_request_fn
for lun 1 before scsi_single_lun_run does so for lun 0.
