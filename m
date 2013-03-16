From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] csiostor: off by one error
Date: Sat, 16 Mar 2013 13:07:56 +0300
Message-ID: <20130316100755.GB10825@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3CPKJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Mar 2013 06:09:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>, "David S. Miller" <davem@davemloft.net>, Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org, kbuild@01.org

We need to store PROTO_ERR_IMPL_LOGO (26) things here, but the
first element isn't used so the array should have 27 elements.
This matches fwevt_to_rnevt[] which has 27 elements.

The patch solves a Smatch static checker warning on my system:
drivers/scsi/csiostor/csio_rnode.c:880 csio_rnode_fwevt_handler()
	error: buffer overflow '(rn)->stats.n_evt_fw' 26 <= 26

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This goes on top of d69630e8a4222 "csiostor: Header file
modifications for chip support and bug fixes." That patch is in
linux-next but I don't know which tree it came from.  It's not
the scsi for-next tree.

diff --git a/drivers/scsi/csiostor/csio_rnode.h b/drivers/scsi/csiostor/csio_rnode.h
index 6594009..4334342 100644
--- a/drivers/scsi/csiostor/csio_rnode.h
+++ b/drivers/scsi/csiostor/csio_rnode.h
@@ -63,7 +63,7 @@ struct csio_rnode_stats {
 	uint32_t	n_err_nomem;	/* error nomem */
 	uint32_t	n_evt_unexp;	/* unexpected event */
 	uint32_t	n_evt_drop;	/* unexpected event */
-	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO];	/* fw events */
+	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO + 1];	/* fw events */
 	enum csio_rn_ev	n_evt_sm[CSIO_RNFE_MAX_EVENT];	/* State m/c events */
 	uint32_t	n_lun_rst;	/* Number of resets of
 					 * of LUNs under this
diff --git a/drivers/scsi/csiostor/csio_lnode.h b/drivers/scsi/csiostor/csio_lnode.h
index 0f9c041..372a67d 100644
--- a/drivers/scsi/csiostor/csio_lnode.h
+++ b/drivers/scsi/csiostor/csio_lnode.h
@@ -114,7 +114,7 @@ struct csio_lnode_stats {
 	uint32_t	n_rnode_match;  /* matched rnode */
 	uint32_t	n_dev_loss_tmo; /* Device loss timeout */
 	uint32_t	n_fdmi_err;	/* fdmi err */
-	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO];	/* fw events */
+	uint32_t	n_evt_fw[PROTO_ERR_IMPL_LOGO + 1];	/* fw events */
 	enum csio_ln_ev	n_evt_sm[CSIO_LNE_MAX_EVENT];	/* State m/c events */
 	uint32_t	n_rnode_alloc;	/* rnode allocated */
 	uint32_t	n_rnode_free;	/* rnode freed */
