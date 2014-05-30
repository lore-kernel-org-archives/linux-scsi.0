From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 0/9] fix for the race issue between scsi timer and in-flight
 scmd
Date: Fri, 30 May 2014 10:26:07 +0200
Message-ID: <5388409F.8070004@redhat.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaE3I0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2014 04:26:15 -0400
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Liu Ping Fan <kernelfans@gmail.com>, linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

Il 30/05/2014 10:15, Liu Ping Fan ha scritto:
> When running io stress test on large latency scsi-disk, e.g guest with virtscsi
> on a nfs image. It can trigger the BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
> in blk_start_request().
> Since there is a race between latency "finishing" scmd and the re-allocated scmd.
> I.e a request is still referred by a scmd, but we had turn it back to
> slab.
>
> This series introduces the ref on scmd to exclude this issue, and the following is ref rules.
>
>   inc ref rules is like the following:
>     When setup a scmd, inited as 1. When add a timer inc 1.
>
>   dec ref rules is like the following:
>     -for the normal ref
>        scsi_done() will drop the ref when fail to acquire REQ_ATOM_COMPLETE immediately
>        or drop the ref by scsi_end_request()
>        or drop by return SUCCESS_REMOVE
>     -for a timer ref
>        when deleting timer, if !list_empty(timeout_list), then there is a timer ref, and
>        drop it.
>
>
> patch1-2: fix the current potential bug
> patch3~6: prepare for the mechanism for the ref
> patch7:   the ref rules core
> patch8-9:  e.g and test-issue for the new mechanism. Since lack of many virtscsi background,
>            patch8 may be poor and need to be improved :)
>
>
> Note: all the patches are based on rhel7, whose kernel version is linux-3.10.
>       I will rebase them onto the latest commit if my method is practical.

This series is not necessary, this is a bug in the virtscsi driver.  I 
have a ten line patch to fix it, but I haven't yet tested it properly.

Paolo
