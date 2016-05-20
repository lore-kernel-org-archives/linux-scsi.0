From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands
Date: Thu, 19 May 2016 22:06:39 -0400
Message-ID: <yq11t4xbhzk.fsf@sermon.lab.mkp.net>
References: <1463166246.2291.84.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbcETCHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 22:07:32 -0400
In-Reply-To: <1463166246.2291.84.camel@HansenPartnership.com> (James
	Bottomley's message of "Fri, 13 May 2016 12:04:06 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jinpu Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> When SCSI was written, all commands coming from the filesystem
James> (REQ_TYPE_FS commands) had data.  This meant that our signal for
James> needing to complete the command was the number of bytes completed
James> being equal to the number of bytes in the request.
James> Unfortunately, with the advent of flush barriers, we can now get
James> zero length REQ_TYPE_FS commands, which confuse this logic
James> because they satisfy the condition every time.  This means they
James> never get retried even for retryable conditions, like UNIT
James> ATTENTION because we complete them early assuming they're done.
James> Fix this by special casing the early completion condition to
James> recognise zero length commands with errors and let them drop
James> through to the retry code.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
