Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94371C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F3220732
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598028513;
	bh=DJoz7hEuLH4KSUPlB0Pz1whDMhaU6YO7qiXnioDukxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JHpSskigyBRgqnmwZp+BLtGwvZNWvbKJIhvebZasq4A0DTyIt9J/nWPTQ3GjlsrF0
	 mpKPczxOEGDz8I4juHoPniLeqGQWtqujyGi4msFWsKQMu+KcXGk6qDzs2Ri7nLf/ct
	 TDwmdQq8MVo+Xhy3zlRon564QTGalQ4I1+aC3rQ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgHUQsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgHUQUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 12:20:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BECE22CB3;
        Fri, 21 Aug 2020 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026758;
        bh=DJoz7hEuLH4KSUPlB0Pz1whDMhaU6YO7qiXnioDukxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcRrcouCrQPR46iX9swwql/ZLOnA1uiEdeN41Wdx6Hx7Clgv3oulUu/RYjFhlaG9+
         K3ze6Xc02QxrQgbMQRat6ljkdJv5cDv14k9/R7fLSgdASnGkuUPA2Imj91nqWVz4yK
         EeYUx6ts488UUTDXruJFKITDXfp61CkHzQ6OUBZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/30] scsi: lpfc: Fix shost refcount mismatch when deleting vport
Date:   Fri, 21 Aug 2020 12:18:43 -0400
Message-Id: <20200821161857.348955-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161857.348955-1-sashal@kernel.org>
References: <20200821161857.348955-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Dick Kennedy <dick.kennedy@broadcom.com>

[ Upstream commit 03dbfe0668e6692917ac278883e0586cd7f7d753 ]

When vports are deleted, it is observed that there is memory/kthread
leakage as the vport isn't fully being released.

There is a shost reference taken in scsi_add_host_dma that is not released
during scsi_remove_host. It was noticed that other drivers resolve this by
doing a scsi_host_put after calling scsi_remove_host.

The vport_delete routine is taking two references one that corresponds to
an access to the scsi_host in the vport_delete routine and another that is
released after the adapter mailbox command completes that destroys the VPI
that corresponds to the vport.

Remove one of the references taken such that the second reference that is
put will complete the missing scsi_add_host_dma reference and the shost
will be terminated.

Link: https://lore.kernel.org/r/20200630215001.70793-8-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_vport.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index c714482bf4c55..9c738e201f462 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -644,27 +644,16 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		    vport->port_state < LPFC_VPORT_READY)
 			return -EAGAIN;
 	}
+
 	/*
-	 * This is a bit of a mess.  We want to ensure the shost doesn't get
-	 * torn down until we're done with the embedded lpfc_vport structure.
-	 *
-	 * Beyond holding a reference for this function, we also need a
-	 * reference for outstanding I/O requests we schedule during delete
-	 * processing.  But once we scsi_remove_host() we can no longer obtain
-	 * a reference through scsi_host_get().
-	 *
-	 * So we take two references here.  We release one reference at the
-	 * bottom of the function -- after delinking the vport.  And we
-	 * release the other at the completion of the unreg_vpi that get's
-	 * initiated after we've disposed of all other resources associated
-	 * with the port.
+	 * Take early refcount for outstanding I/O requests we schedule during
+	 * delete processing for unreg_vpi.  Always keep this before
+	 * scsi_remove_host() as we can no longer obtain a reference through
+	 * scsi_host_get() after scsi_host_remove as shost is set to SHOST_DEL.
 	 */
 	if (!scsi_host_get(shost))
 		return VPORT_INVAL;
-	if (!scsi_host_get(shost)) {
-		scsi_host_put(shost);
-		return VPORT_INVAL;
-	}
+
 	lpfc_free_sysfs_attr(vport);
 
 	lpfc_debugfs_terminate(vport);
@@ -811,8 +800,9 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		if (!(vport->vpi_state & LPFC_VPI_REGISTERED) ||
 				lpfc_mbx_unreg_vpi(vport))
 			scsi_host_put(shost);
-	} else
+	} else {
 		scsi_host_put(shost);
+	}
 
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;
-- 
2.25.1

