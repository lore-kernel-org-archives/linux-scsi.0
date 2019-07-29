From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: ibmvfc: Mark expected switch fall-throughs
Date: Sun, 28 Jul 2019 19:26:08 -0500
Message-ID: <20190729002608.GA25263@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_npiv_login_done':
drivers/scsi/ibmvscsi/ibmvfc.c:4022:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   ibmvfc_retry_host_init(vhost);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/ibmvscsi/ibmvfc.c:4023:2: note: here
  case IBMVFC_MAD_DRIVER_FAILED:
  ^~~~
drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_bsg_request':
drivers/scsi/ibmvscsi/ibmvfc.c:1830:11: warning: this statement may fall through [-Wimplicit-fallthrough=]
   port_id = (bsg_request->rqst_data.h_els.port_id[0] << 16) |
   ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    (bsg_request->rqst_data.h_els.port_id[1] << 8) |
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bsg_request->rqst_data.h_els.port_id[2];
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/ibmvscsi/ibmvfc.c:1833:2: note: here
  case FC_BSG_RPT_ELS:
  ^~~~
drivers/scsi/ibmvscsi/ibmvfc.c:1838:11: warning: this statement may fall through [-Wimplicit-fallthrough=]
   port_id = (bsg_request->rqst_data.h_ct.port_id[0] << 16) |
   ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    (bsg_request->rqst_data.h_ct.port_id[1] << 8) |
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bsg_request->rqst_data.h_ct.port_id[2];
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/ibmvscsi/ibmvfc.c:1841:2: note: here
  case FC_BSG_RPT_CT:
  ^~~~

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8cdbac076a1b..df897df5cafe 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1830,6 +1830,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 		port_id = (bsg_request->rqst_data.h_els.port_id[0] << 16) |
 			(bsg_request->rqst_data.h_els.port_id[1] << 8) |
 			bsg_request->rqst_data.h_els.port_id[2];
+		/* fall through */
 	case FC_BSG_RPT_ELS:
 		fc_flags = IBMVFC_FC_ELS;
 		break;
@@ -1838,6 +1839,7 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 		port_id = (bsg_request->rqst_data.h_ct.port_id[0] << 16) |
 			(bsg_request->rqst_data.h_ct.port_id[1] << 8) |
 			bsg_request->rqst_data.h_ct.port_id[2];
+		/* fall through */
 	case FC_BSG_RPT_CT:
 		fc_flags = IBMVFC_FC_CT_IU;
 		break;
@@ -4020,6 +4022,7 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 		return;
 	case IBMVFC_MAD_CRQ_ERROR:
 		ibmvfc_retry_host_init(vhost);
+		/* fall through */
 	case IBMVFC_MAD_DRIVER_FAILED:
 		ibmvfc_free_event(evt);
 		return;
-- 
2.22.0
