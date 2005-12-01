From: James.Smart@Emulex.Com
Subject: RE: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 1 Dec 2005 12:37:23 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B87@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7674 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932359AbVLARh3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 12:37:29 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org

> sure.. but if the defaults are 0... why couldn't mode 1 by 
> the default..
> isn't mode 1 with coalesing value 0 the same as mode 0.. and 
> if so.. why
> need a mode 0 in the first place ?

There's no gain - and in fact there is now a loss. Queuecommand
now eats up more cycles attempting to service i/o completions on
every invokation. Nothing gets helped on the interrupt side. We
would still have interrupts firing, thus the interrupt handler
being invoked to clear the interrupt.

We're going to consume more cycles for a) queuecommand calls that
don't have i/o completions available, and b) for handling spurious
interrupts.

-- james
