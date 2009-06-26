From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Fix warning in 2.6.31-rc1 triggered by FC pass-through code
Date: Fri, 26 Jun 2009 16:30:42 +0200
Message-ID: <20090626143042.117419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:52818 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936AbZFZOfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 10:35:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

The FC pass-through code triggers a warning in the block layer
because __blk_run_queue is called with interrupts enabled, but this
function requires being called with disabled interrupts. This patch
fixes this by disabling interrupts in fc_bsg_goose_queue.

--
Christof Schmitt
