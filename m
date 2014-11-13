From: Christoph Hellwig <hch@lst.de>
Subject: split ->change_queue_depth
Date: Thu, 13 Nov 2014 18:58:59 +0100
Message-ID: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaKMR7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

Overloading ->change_queue_depth with the queue ramp up / down
functionality has been a bad idea.   It lead to a large amount
of code duplication, and driver keep getting the the API
wrong and end up accidentally enabling the queue depth tracking
while getting it wrong.

This serie instead adds a flag to enable queue tracking and
handles it entirely in core code.  This is a preparation for
various logic changes to the queue depth tracking code.

