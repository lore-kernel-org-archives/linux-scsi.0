From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfa_fcs_lport.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:06:03 +0200
Message-ID: <1400429163-10747-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..542d5c6 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5826,12 +5826,13 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
 	bfa_port_speed_t max_speed = 0;
 	struct bfa_port_attr_s port_attr;
 	bfa_port_speed_t port_speed, rport_speed;
-	bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+	bfa_boolean_t trl_enabled;
 
 
 	if (port == NULL)
 		return 0;
 
+	trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
 	fcs = port->fcs;
 
 	/* Get Physical port's current speed */
-- 
1.7.10.4
