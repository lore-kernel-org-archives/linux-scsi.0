From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 3/4] zfcp: dead code removal
Date: Thu, 22 Aug 2013 17:49:33 +0200
Message-ID: <1377186574-26954-4-git-send-email-maier@linux.vnet.ibm.com>
References: <1377099366.2011.23.camel@dabdike.int.hansenpartnership.com>
 <1377186574-26954-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:35027 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3HVPuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 11:50:05 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 22 Aug 2013 16:44:49 +0100
In-Reply-To: <1377186574-26954-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

Get rid of unused function zfcp_fsf_get_req and corresponding
prototype definition.

Commit a54ca0f62f953898b05549391ac2a8a4dad6482b in v2.6.28
"[SCSI] zfcp: Redesign of the debug tracing for HBA records."
accidentally introduced this code which was dead in the first place.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h |    2 --
 drivers/s390/scsi/zfcp_fsf.c |    9 ---------
 2 files changed, 11 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -126,8 +126,6 @@ extern int zfcp_qdio_sbals_from_sg(struc
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
 extern void zfcp_qdio_siosl(struct zfcp_adapter *);
-extern struct zfcp_fsf_req *zfcp_fsf_get_req(struct zfcp_qdio *,
-					     struct qdio_buffer *);
 
 /* zfcp_scsi.c */
 extern struct scsi_transport_template *zfcp_scsi_transport_template;
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2388,12 +2388,3 @@ void zfcp_fsf_reqid_check(struct zfcp_qd
 			break;
 	}
 }
-
-struct zfcp_fsf_req *zfcp_fsf_get_req(struct zfcp_qdio *qdio,
-				      struct qdio_buffer *sbal)
-{
-	struct qdio_buffer_element *sbale = &sbal->element[0];
-	u64 req_id = (unsigned long) sbale->addr;
-
-	return zfcp_reqlist_find(qdio->adapter->req_list, req_id);
-}

