From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/5] [SCSI] scsi_dh_alua: fix deadlock in stpg_endio
Date: Wed,  5 Jan 2011 16:00:21 -0500
Message-ID: <1294261224-12599-3-git-send-email-snitzer@redhat.com>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Joseph Gruher <joseph.r.gruher@intel.com>, Mike Snitzer <snitzer@redhat.com>, Ilgu Hong <ilgu.hong@promise.com>, linux-scsi@vger.kernel.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Joseph Gruher <joseph.r.gruher@intel.com>

The use of blk_execute_rq_nowait() implies __blk_put_request() is needed
in stpg_endio() rather than blk_put_request() -- blk_finish_request() is
called with queue lock already held.

Signed-off-by: Joseph Gruher <joseph.r.gruher@intel.com>
Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@kernel.org
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index afb1d05..ba3c649 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -285,7 +285,8 @@ static void stpg_endio(struct request *req, int error)
 			    print_alua_state(h->state));
 	}
 done:
-	blk_put_request(req);
+	req->end_io_data = NULL;
+	__blk_put_request(req->q, req);
 	if (h->callback_fn) {
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;
-- 
1.7.3.4
