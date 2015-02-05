From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: scsi race condition
Date: Thu, 5 Feb 2015 13:32:02 -0000
Message-ID: <edc05b59e1ba5a71aa3c1a9047edfec6.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbbBENcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 08:32:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Cc: subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org

I've encountered a race condition which causes the UFS driver to receiv=
e
requests with an invalid tag (-1),
and wondering how to go about solving the case.
Consider the following scenario:

1. scsi_request_fn() -> scsi_dispatch_cmd() -> host->hostt->queuecomman=
d()
 (mapped to ufshcd_queuecommand)
2. queuecommand returns an error value, which will trigger call to
scsi_queue_insert().
3. scsi_queue_insert() will call blk_requeue_request() after taking the
queue spinlock.
4. However, let=92s assume that just before taking the queue lock a con=
text
switch occurs and it will be a while before we switch back to this poin=
t.
5. In the meantime, block layer timeout expires for this request and
scsi_times_out() is called which will schedule the request for error
handling.
6. The error handling thread, scsi_error_handler(), will first try to
abort the request by calling hostt->eh_abort_handler().
7. However, suppose that just before calling the abort handler, we
continue from where we left at #4,
blk_requeue_request() will end the active tag of the request, and set i=
t
to -1.
8. Now at the abort handler, the request has tag -1 which is invalid in
the UFS driver and will cause a reference to an invalid lrb.
9. An invalid tag may occur not only when the abort handler is called, =
but
also when the scsi error handling thread reuses the command to send
Test-Unit-Ready command which will also cause an invalid lrb reference =
in
the UFS driver.

I know that in order for this scenario to occur it means that the threa=
d
#4 above will need to be inactive for a very long time (depending on th=
e
block layer timeout which is 30 seconds), but I've seen this happen a f=
ew
times in cases where the system was under stress.

One approach to take is to overcome tag=3D-1 in the UFS driver, but it'=
s not
clear to me which error value should be returned for the abort handler
case and queuecommand ?
Another approach is to try to eliminate the race condition altogether. =
Any
suggestions on a particular way to fix this so request is not re-queued=
 in
case it is also under error handling?

Will appreciate any comments on this.

Thanks,
Gilad.

--=20
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora For=
um,
a Linux Foundation Collaborative Project

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
