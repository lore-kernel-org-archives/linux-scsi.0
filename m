From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/3] SCSI/libiscsi: Reduce locking contention in fast
 path
Date: Sun, 10 Nov 2013 23:55:12 -0600
Message-ID: <52807140.10400@cs.wisc.edu>
References: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38687 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3KKF41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 00:56:27 -0500
In-Reply-To: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, MChristie@fusionio.com, shlomop@mellanox.com

On 10/27/13 8:23 AM, Or Gerlitz wrote:
> Hi James,
>
> This series is about reducing locking contention in the IO submission/response processing
> fast path of libiscsi and the various iscsi transports usage of libiscsi code.
>
> We replace the session lock with two locks, a forward lock and a backwards lock
> named frwd_lock and back_lock respectively.
>
> The forward lock protects resources that change while sending a request to the
> target, such as cmdsn, queued_cmdsn, and allocating task from the commands'
> pool with kfifo_out.
>
> The backward lock protects resources that change while processing a response or
> in error path, such as cmdsn_exp, cmdsn_max, and returning tasks to the commands'
> pool with kfifo_in.
>
> The 1st patch in the series is a restructuring patch for iscsi_tcp r2t response
> logic, the 2nd is the main patch and the 3rd is cleanup asked by Mike who reviewed
> the whole series when we posted in over the open-iscsi mailing list.
>
> Under a "steady state" fast-path situation, that is when one or more processes/threads
> submit IO to an iscsi device and a single kernel upcall (e.g softirq) is dealing
> with processing  of responses without errors, this patch eliminates the contention
> between the queuecommand()/request response/scsi_done() associated with iscsi sessions.
>
> Or and Shlomo.
>
> Shlomo Pongratz (3):
>    SCSI/libiscsi: Restructure iscsi_tcp r2t response logic
>    SCSI/libiscsi: Reduce locking contention in fast path
>    SCSI/libiscsi: Remove unneeded code
>

Hi James,

I saw your git pull mail said it was the first round of patches. If you 
are going to do a second round could you take the patches in this thread?

I had replied to the first mail in the thread with a signed-off line:

http://marc.info/?l=linux-scsi&m=138309757219394&w=2

It should have been a reviewed-by, so here is the proper tag.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>




