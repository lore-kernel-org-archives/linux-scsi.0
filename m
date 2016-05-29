From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Sun, 29 May 2016 11:06:49 -0700
Message-ID: <20160529180649.GA6486@infradead.org>
References: <1464407471-3712-1-git-send-email-fangwei1@huawei.com>
 <20160529065452.GA21677@infradead.org>
 <1464536473.2287.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbcE2SG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2016 14:06:59 -0400
Content-Disposition: inline
In-Reply-To: <1464536473.2287.6.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Wei Fang <fangwei1@huawei.com>, tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, May 29, 2016 at 08:41:13AM -0700, James Bottomley wrote:
> Actually, it doesn't look fine at all.  The same mechanism that's
> supposed to protect the host_failed decrement is also supposed to
> protect the list_move_tail().  If there's a problem with the former
> then we're also in danger of corrupting the list.

No, that's not the case.  eh_entry is used for two things:

 a) shost->eh_cmd_q, which is used to queue up command for the EH
    thread, and is locked using the host lock.
 b) various on-stack lists in the EH thread

scsi_eh_finish_cmd is only called for case b) as all EH thread
implementations move the commands from eh_cmd_q to a local list
as the very first thing.

host_fail on the other hand is incremented under the host_lock
in scsi_eh_scmd_add, but decremented without any lock from the
EH thread.
