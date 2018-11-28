From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 38/41] scsi: sym53c8xx_2: sym_hipd: mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:34:04 -0600
Message-ID: <81f959a632339d224fd0dd894746d1081bf249f3.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114996 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 0a2a54517b15..054fb0599263 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3072,6 +3072,7 @@ static void sym_sir_bad_scsi_status(struct sym_hcb *np, int num, struct sym_ccb
 			sym_print_addr(cp->cmd, "%s\n",
 			        s_status == S_BUSY ? "BUSY" : "QUEUE FULL\n");
 		}
+		/* fall through */
 	default:	/* S_INT, S_INT_COND_MET, S_CONFLICT */
 		sym_complete_error (np, cp);
 		break;
@@ -4632,6 +4633,7 @@ static void sym_int_sir(struct sym_hcb *np)
 	 *  Negotiation failed.
 	 *  Target does not want answer message.
 	 */
+	/* fall through */
 	case SIR_NEGO_PROTO:
 		sym_nego_default(np, tp, cp);
 		goto out;
-- 
2.17.1
