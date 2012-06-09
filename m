From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Fri, 8 Jun 2012 17:10:31 -0700
Message-ID: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3079ba3af095eb04c1fef149
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--20cf3079ba3af095eb04c1fef149
Content-Type: text/plain; charset=ISO-8859-1

Since the queue->lock case is taken care of in the following patch:

(http://www.spinics.net/lists/linux-scsi/msg59845.html [PATCH 1/4]
block: Fix race on request_queue.end_io invocations)

Updated the patch with just the end_io assignment before dead queue check.


-------------
blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
done() routine is not made. That will result in blk_execute_rq() stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to
done() routine before we check for dead queue.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
CC: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>

-------------
diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..f8b00c7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -53,6 +53,9 @@ void blk_execute_rq_nowait(struct request_queue *q,
struct gendisk *bd_disk,
        WARN_ON(irqs_disabled());
        spin_lock_irq(q->queue_lock);

+       rq->rq_disk = bd_disk;
+       rq->end_io = done;
+
        if (unlikely(blk_queue_dead(q))) {
                spin_unlock_irq(q->queue_lock);
                rq->errors = -ENXIO;
@@ -61,8 +64,6 @@ void blk_execute_rq_nowait(struct request_queue *q,
struct gendisk *bd_disk,
                return;
        }

--20cf3079ba3af095eb04c1fef149
Content-Type: application/octet-stream;
	name="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Disposition: attachment;
	filename="blk-exec-assign-endio-before-queue-dead-check.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h35nsn5w0

Ci0tLS0tLS0tLS0tLS0KYmxrLWV4ZWMuYzogSW4gYmxrX2V4ZWN1dGVfcnFfbm93YWl0KCksIGlm
IHRoZSBxdWV1ZSBpcyBkZWFkLCBjYWxsIHRvCmRvbmUoKSByb3V0aW5lIGlzIG5vdCBtYWRlLiBU
aGF0IHdpbGwgcmVzdWx0IGluIGJsa19leGVjdXRlX3JxKCkgc3R1Y2sKaW4gd2FpdF9mb3JfY29t
cGxldGlvbigpLiBBdm9pZCB0aGlzIGJ5IGluaXRpYWxpemluZyBycS0+ZW5kX2lvIHRvCmRvbmUo
KSByb3V0aW5lIGJlZm9yZSB3ZSBjaGVjayBmb3IgZGVhZCBxdWV1ZS4KClNpZ25lZC1vZmYtYnk6
IE11dGh1a3VtYXIgUmF0dHkgPG11dGh1ckBnbWFpbC5jb20+CkNDOiBUZWp1biBIZW8gPHRqQGtl
cm5lbC5vcmc+CkNDOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkNDOiBKYW1lcyBCb3R0
b21sZXkgPEphbWVzLkJvdHRvbWxleUBoYW5zZW5wYXJ0bmVyc2hpcC5jb20+CgotLS0tLS0tLS0t
LS0tCmRpZmYgLS1naXQgYS9ibG9jay9ibGstZXhlYy5jIGIvYmxvY2svYmxrLWV4ZWMuYwppbmRl
eCBmYjJjYmQ1Li5mOGIwMGM3IDEwMDY0NAotLS0gYS9ibG9jay9ibGstZXhlYy5jCisrKyBiL2Js
b2NrL2Jsay1leGVjLmMKQEAgLTUzLDYgKzUzLDkgQEAgdm9pZCBibGtfZXhlY3V0ZV9ycV9ub3dh
aXQoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBnZW5kaXNrICpiZF9kaXNrLAogCVdB
Uk5fT04oaXJxc19kaXNhYmxlZCgpKTsKIAlzcGluX2xvY2tfaXJxKHEtPnF1ZXVlX2xvY2spOwog
CisJcnEtPnJxX2Rpc2sgPSBiZF9kaXNrOworCXJxLT5lbmRfaW8gPSBkb25lOworCiAJaWYgKHVu
bGlrZWx5KGJsa19xdWV1ZV9kZWFkKHEpKSkgewogCQlzcGluX3VubG9ja19pcnEocS0+cXVldWVf
bG9jayk7CiAJCXJxLT5lcnJvcnMgPSAtRU5YSU87CkBAIC02MSw4ICs2NCw2IEBAIHZvaWQgYmxr
X2V4ZWN1dGVfcnFfbm93YWl0KHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgZ2VuZGlz
ayAqYmRfZGlzaywKIAkJcmV0dXJuOwogCX0KIAotCXJxLT5ycV9kaXNrID0gYmRfZGlzazsKLQly
cS0+ZW5kX2lvID0gZG9uZTsKIAlfX2Vsdl9hZGRfcmVxdWVzdChxLCBycSwgd2hlcmUpOwogCV9f
YmxrX3J1bl9xdWV1ZShxKTsKIAkvKiB0aGUgcXVldWUgaXMgc3RvcHBlZCBzbyBpdCB3b24ndCBi
ZSBydW4gKi8KLS0tLS0tLS0tLS0tLQoK
--20cf3079ba3af095eb04c1fef149--
