From: Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH] scsi: sg: Re-fix off by one in sg_fill_request_table()
Date: Sun, 15 Oct 2017 18:16:33 +0100
Message-ID: <20171015171633.rphqeyc46uy4l5tx@xylophone.i.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
introduced an off-by-one error in sg_ioctl(), which was fixed by
commit bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()").

Unfortunately commit 4759df905a47 ("scsi: sg: factor out
sg_fill_request_table()") moved that code, and reintroduced the
bug (perhaps due to a botched rebase).  Fix it again.

Fixes: 4759df905a47 ("scsi: sg: factor out sg_fill_request_table()")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0419c2298eab..aa28874e8fb9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -837,7 +837,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
 
 	val = 0;
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
-		if (val > SG_MAX_QUEUE)
+		if (val >= SG_MAX_QUEUE)
 			break;
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =
-- 
2.15.0.rc0
