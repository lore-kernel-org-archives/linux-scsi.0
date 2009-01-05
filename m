From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4 of 4] sd: Correctly handle 6-byte commands with DIX
Date: Sun, 04 Jan 2009 21:35:06 -0500
Message-ID: <yq18wpq4h0l.fsf@sermon.lab.mkp.net>
References: <patchbomb.1231056270@sermon.lab.mkp.net>
	<8676e77c49d4bc933338.1231056274@sermon.lab.mkp.net>
	<20090104132855.GC2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:21958 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZAECfR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 21:35:17 -0500
In-Reply-To: <20090104132855.GC2002@parisc-linux.org> (Matthew Wilcox's message of "Sun\, 4 Jan 2009 06\:28\:55 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

>> + BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] ==
>>  	WRITE_6));

Matthew> This BUG_ON gave me a 'Huh?' moment.  I immediately wondered if
Matthew> it was user-triggerable.  The answer is "no, this is kosher".
Matthew> sd_dif_op() is only called from sd.c where it has chosen which
Matthew> READ_*/WRITE_* opcode to set up, and it would indeed be an
Matthew> internal bug for this combination of conditions to exist.

Yep, I recently had to track down a bug where we had accidentally (for
completely different reasons) switched to 6-byte commands.  The code in
the completion path that triggered this condition is now gone, thanks to
Alan.  But I left the BUG_ON in place because it was no fun track this
down.

-- 
Martin K. Petersen	Oracle Linux Engineering
