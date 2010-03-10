From: Sarang Radke <sarang.radke@qlogic.com>
Subject: RE: [RFC PATCH] scsi_transport_fc: Make sure commands are completed
 when rport is offline
Date: Wed, 10 Mar 2010 04:03:04 -0600
Message-ID: <1FB7DC5E34DADB499463B6EA89DF40A4638369F9EB@MNEXMB1.qlogic.org>
References: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
 <4B965E15.8040103@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26687 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0CJKDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 05:03:09 -0500
In-Reply-To: <4B965E15.8040103@emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@Emulex.Com>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

James S./Fujita,

Thanks for the comments. The description of scenario was the one with which I noted the issue. But yes, the same would be true for any rport which is offline.

I am resending the patch with the suggested modifications.

-Thanks,
Sarang

>From 84a1f847c71382f67f97ea956b2283cf6d737340 Mon Sep 17 00:00:00 2001
From: Sarang Radke <sarang.radke@qlogic.com>
Date: Tue, 9 Mar 2010 12:20:29 -0500
Subject: [PATCH] Make sure commands are completed for offline rport

blk_end_request doesn't complete a bidi request
successfully

The unfinished request eventually triggers a panic in
timeout handling routine fc_bsg_job_timeout as
req->special is NULL

Use blk_end_request_all to end the request unconditionally

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
---
 drivers/scsi/scsi_transport_fc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 79660ee..5819457 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3852,7 +3852,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
                if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
                        req->errors = -ENXIO;
                        spin_unlock_irq(q->queue_lock);
-                       blk_end_request(req, -ENXIO, blk_rq_bytes(req));
+                       blk_end_request_all(req, -ENXIO);
                        spin_lock_irq(q->queue_lock);
                        continue;
                }
@@ -3862,7 +3862,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
                ret = fc_req_to_bsgjob(shost, rport, req);
                if (ret) {
                        req->errors = ret;
-                       blk_end_request(req, ret, blk_rq_bytes(req));
+                       blk_end_request_all(req, ret);
                        spin_lock_irq(q->queue_lock);
                        continue;
                }
--
1.5.6


-----Original Message-----
From: James Smart [mailto:james.smart@Emulex.Com] 
Sent: Tuesday, March 09, 2010 8:11 PM
To: Sarang Radke
Cc: fujita.tomonori@lab.ntt.co.jp; James.Bottomley@suse.de; linux-scsi@vger.kernel.org; Andrew Vasquez; Lalit Chandivade; Giridhar Malavali; Ravi Anand
Subject: Re: [RFC PATCH] scsi_transport_fc: Make sure commands are completed when rport is offline

I'm guessing your opening line describing the scenario wasn't correct. To 
match the patch, the request had to be issued when the rport is offline.
True ?

I think the change is fine, but the same change needs to be done a few lines 
lower when fc_req_to_bsgjob fails and blk_end_request() is called. Can you 
update the patch for this ?

-- james s


Sarang Radke wrote:
> A panic is seen when an ELS BSG request is send for rport which is online, but goes offline before the request is processed.
> 
> Here are the details of the issue and the fix.
> 
> . The request handler routine fc_bsg_handler checks if the rport is not online and tries to end the request by calling blk_end_request.
> . blk_end_request does not finish the request because it calls bidi_end_bidi_request with bidi_bytes = 0.
> . After 60 sec. the timeout handler, fc_bsg_job_timeout is invoked for this unfinished command.
> . A panic is seen in fc_bsg_job_timeout because req->special is NULL.
> . req->special  would have been set by function fc_req_to_bsgjob, if the rport was online.
> . The patch uses blk_end_request_all instead of blk_end_request which finishes the bidi request and timeout never happens.
> 
