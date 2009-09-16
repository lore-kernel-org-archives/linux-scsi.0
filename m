From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Wed, 16 Sep 2009 17:38:52 +0000
Message-ID: <1253122732.4842.33.camel@mulgrave.site>
References: <1252053394-24886-1-git-send-email-martin.petersen@oracle.com>
	 <1252053394-24886-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZIPRi4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2009 13:38:56 -0400
In-Reply-To: <1252053394-24886-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Fri, 2009-09-04 at 04:36 -0400, Martin K. Petersen wrote:
> DIF Type 2 drives require 32-byte commands.  Add a suitable flag to
> struct scsi_device that will cause scsi_setup_fs_cmnd() to allocate a
> bigger command buffer.

This does look better than the previous version.

However, I'm afraid the lifetime rules don't look to be correct.

The fundamental problem you have is that the request lives longer than
the cmnd.  You populate req->cmnd but never reset it to the original
when you free the 32 byte command.

Fundamentally, since you know you're always going to be using a 32 byte
command, it looks like the consistent place to do the allocation is in
the block layer.  If we go that route, I'd recommend using a variable
for the length so ATA can use it also for transmitting task files. I've
cc'd Jens to see what he thinks of this.

If we just want to hack it up in the SCSI layer, it seems to me you
don't need to muck with req->cmd.  Just populate cmd->cmnd from the pool
and use the signature (req->cmd != cmd->cmnd) to know you did (thus
dispensing with the flag and keeping req->cmd consistent).

James


