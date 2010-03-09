From: Sarang Radke <sarang.radke@qlogic.com>
Subject: [RFC PATCH] scsi_transport_fc: Make sure commands are completed
 when rport is offline
Date: Tue, 9 Mar 2010 05:27:51 -0600
Message-ID: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:12716 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0CIL14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 06:27:56 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

A panic is seen when an ELS BSG request is send for rport which is onli=
ne, but goes offline before the request is processed.

Here are the details of the issue and the fix.

=2E The request handler routine fc_bsg_handler checks if the rport is n=
ot online and tries to end the request by calling blk_end_request.
=2E blk_end_request does not finish the request because it calls bidi_e=
nd_bidi_request with bidi_bytes =3D 0.
=2E After 60 sec. the timeout handler, fc_bsg_job_timeout is invoked fo=
r this unfinished command.
=2E A panic is seen in fc_bsg_job_timeout because req->special is NULL.
=2E req->special =A0would have been set by function fc_req_to_bsgjob, i=
f the rport was online.
=2E The patch uses blk_end_request_all instead of blk_end_request which=
 finishes the bidi request and timeout never happens.


-Thanks,
Sarang

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
---
 drivers/scsi/scsi_transport_fc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_trans=
port_fc.c
index 79660ee..304e710 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3852,7 +3852,7 @@ fc_bsg_request_handler(struct request_queue *q, s=
truct Scsi_Host *shost,
                if (rport && (rport->port_state !=3D FC_PORTSTATE_ONLIN=
E)) {
                        req->errors =3D -ENXIO;
                        spin_unlock_irq(q->queue_lock);
-                       blk_end_request(req, -ENXIO, blk_rq_bytes(req))=
;
+                       blk_end_request_all(req, -ENXIO);
                        spin_lock_irq(q->queue_lock);
                        continue;
                }
--
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
