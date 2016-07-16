From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] xen-scsiback: One function call less in
 scsiback_device_action() after error detection
Date: Sat, 16 Jul 2016 22:23:47 +0200
Message-ID: <87e55a72-71ad-d0a1-b936-12565bbc6508@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59e51c7d-f7bb-c55f-d2fe-06dccfef6a99@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Jul 2016 21:42:42 +0200

The kfree() function was called in one case by the
scsiback_device_action() function during error handling
even if the passed variable "tmr" contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/xen/xen-scsiback.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 4a48c06..7612bc9 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -606,7 +606,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	tmr = kzalloc(sizeof(struct scsiback_tmr), GFP_KERNEL);
 	if (!tmr) {
 		target_put_sess_cmd(se_cmd);
-		goto err;
+		goto do_resp;
 	}
 
 	init_waitqueue_head(&tmr->tmr_wait);
@@ -616,7 +616,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 			       unpacked_lun, tmr, act, GFP_KERNEL,
 			       tag, TARGET_SCF_ACK_KREF);
 	if (rc)
-		goto err;
+		goto free_tmr;
 
 	wait_event(tmr->tmr_wait, atomic_read(&tmr->tmr_complete));
 
@@ -626,8 +626,9 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
 	transport_generic_free_cmd(&pending_req->se_cmd, 1);
 	return;
-err:
+free_tmr:
 	kfree(tmr);
+do_resp:
 	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
 }
 
-- 
2.9.1
