From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 14/15] qla2xxx: Correct issue where driver improperly issued SNS commands in N2N topologies.
Date: Wed, 17 May 2006 15:09:56 -0700
Message-ID: <11479037913659-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:62139 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751229AbWEQWJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:57 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Semantic changes in ISP24xx firmware behaviour inadvertently
caused the driver to believe an F-port topology was present in an
N_port-to-N_port configuration.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

19a3e27bbb451ab7b98472ec04445bbb4aa383ea
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

19a3e27bbb451ab7b98472ec04445bbb4aa383ea
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 011e879..aef093d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1778,6 +1778,9 @@ qla2x00_configure_loop(scsi_qla_host_t *
 		set_bit(RSCN_UPDATE, &flags);
 		clear_bit(LOCAL_LOOP_UPDATE, &flags);
 
+	} else if (ha->current_topology == ISP_CFG_N) {
+		clear_bit(RSCN_UPDATE, &flags);
+
 	} else if (!ha->flags.online ||
 	    (test_bit(ABORT_ISP_ACTIVE, &flags))) {
 
-- 
1.3.3.g63df


