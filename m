From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Tue, 27 Nov 2012 17:34:43 +0100
Message-ID: <50B4EBA3.7070400@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:43071 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2K0Qeq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 11:34:46 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, roland@purestorage.com

On 11/26/12 05:44, David Dillow wrote:
> Here is a first, UNTESTED, pass at preparing a merge of Bart's SRP HA
> work to upstream. It is not complete, as I have not yet added the
> transport layer error handling and related patches. It is also currently
> missing the patch to maintain a single connection for an I_T nexus.
>
> I swapped Ishai's code to recreate QP/CQs for each connection, as that
> adds recovery from fatal hardware errors, and reduces the code needed to
> avoid stale completions. Similarly, Vu's patch slightly reduces reconnect
> times.
>
> Target blocking/unblocking hasn't been added from Bart's patch that
> removes the SRP_TARGET_CONNECTING state; I think it is probably the right
> thing to do, but want to think it over a bit more.
>
> Similarly, I'm looking for a clean way to start the reconnection effort
> as soon as we get an error through the CQ -- we know that any pending
> commands are lost to us at that point, so we should be able to kick them
> back upstream quickly. This should allow multipath to reissue them on one
> of the remaining good paths.
>
> This series compiles, but is otherwise UNTESTED. I'll be working on that
> over the next few days, with an eye on getting as much of Bart's work
> into 3.8 as possible.

Thanks Dave for doing all this work. A reworked and retested patch 
series that should address all comments that have been posted so far can 
be found here: http://github.com/bvanassche/linux/srp-ha. I can repost 
the entire patch series if you want. The changes compared to the 
previous time this patch series was posted are:
* Integrated Ishai's and Vu's patches for recreating the QP and the CQs.
* Took advantage of SCSI core changes that make scsi_remove_host() wait
   until device removal and error handling finished (will post these
   shortly).

Bart.
