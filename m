From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH] [SCSI] bfa: fix missing { } braces
Date: Tue, 4 Aug 2015 09:57:11 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF5901037771@avmb2.qlogic.org>
References: <1438612527-3707-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438612527-3707-1-git-send-email-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Colin,
  We will fix the indentation in the next set of patches that we submit upstream.

Thanks,
Anil

-----Original Message-----
From: Colin King [mailto:colin.king@canonical.com] 
Sent: 03 August 2015 20:05
To: Anil Gurumurthy; Sudarsana Kalluru; James E.J. Bottomley; linux-scsi
Cc: linux-kernel
Subject: [PATCH] [SCSI] bfa: fix missing { } braces

From: Colin Ian King <colin.king@canonical.com>

Static analysis by smatch indicated that there was a curly braces issue:

drivers/scsi/bfa/bfa_ioc.c:3668 bfa_cb_sfp_state_query()
        warn: curly braces intended?
drivers/scsi/bfa/bfa_ioc.c:3671 bfa_cb_sfp_state_query()
        warn: inconsistent indenting
drivers/scsi/bfa/bfa_ioc.c:3676 bfa_cb_sfp_state_query()
        warn: curly braces intended?

The fix matches the intended logic based on the original indentation layout of the code.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c index 315d6d6..59c3492 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3662,7 +3662,7 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
 	bfa_trc(sfp, sfp->portspeed);
 	if (sfp->media) {
 		bfa_sfp_media_get(sfp);
-		if (sfp->state_query_cbfn)
+		if (sfp->state_query_cbfn) {
 			sfp->state_query_cbfn(sfp->state_query_cbarg,
 					sfp->status);
 			sfp->media = NULL;
@@ -3670,14 +3670,16 @@ bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
 
 		if (sfp->portspeed) {
 			sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
-			if (sfp->state_query_cbfn)
+			if (sfp->state_query_cbfn) {
 				sfp->state_query_cbfn(sfp->state_query_cbarg,
 						sfp->status);
 				sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
+			}
 		}
 
 		sfp->state_query_lock = 0;
 		sfp->state_query_cbfn = NULL;
+	}
 }
 
 /*
--
2.5.0
