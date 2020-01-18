Return-Path: <SRS0=DCIq=3H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3604FC32771
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jan 2020 04:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0894A2073A
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jan 2020 04:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAREVD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 23:21:03 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55557 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgAREVD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 23:21:03 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so4049536pjz.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 20:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TufKNWh8BOlKfj+9XUNI+RjX/HICIgHEcFX/cd19uv4=;
        b=VLIXERQFc3YXXN2utc5+epNMT/PWIjQ65YV13aPpH/1POAv1/3IPOneuTcd791xCGW
         7YOtypnxNdTJINAOZr67rpWMFfQ1V3XrJ2fX4XEcvMxzc99Pl4vsx4yrkGyq7oidUVEP
         pxVc68ROeRRzRESCiry5v9S4vkloIoc0gor7Y/MTWhKUAvEL1GID5QJ5LzNUXCH2roGI
         MkKI/0vTvu79CGEElpPeT6kZ/SsSe5o3RCbMfXTwHURFSbejySM5Fc+sJCDfC9IqnQDS
         rig/mD3SibmqkOf5mYOxW4FCJWq83yErMipr4NwixEaylpcucVcuhaVx0ogw6pNuwT4A
         gUhw==
X-Gm-Message-State: APjAAAWm83LgjCn312HnQq5brL0bNft7FzlaB3l1N2QujZAcGVxdlOUC
        ixQfSdBpE3JplJRXxqpVanryDt2sDLE=
X-Google-Smtp-Source: APXvYqz4fY/6EQUck0OzTOX5iPJ3qHBjJvhPO9YSZUjg6Vmzhe1rLZZFsoDQyarl7QYDm1grBP7KSQ==
X-Received: by 2002:a17:902:8e8a:: with SMTP id bg10mr2814273plb.98.1579321262594;
        Fri, 17 Jan 2020 20:21:02 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:748e:9135:9422:9c32])
        by smtp.gmail.com with ESMTPSA id s185sm31820275pfc.35.2020.01.17.20.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 20:21:01 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
Date:   Fri, 17 Jan 2020 20:20:56 -0800
Message-Id: <20200118042056.32232-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

FORWARD_NULL

qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}
qla_init.c: 5275 in qla2x00_configure_local_loop()
5269
5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
5271     			qla24xx_fcport_handle_login(vha, fcport);
5272     	}
5273
5274     cleanup_allocation:
>>>     CID 353340:    (FORWARD_NULL)
>>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
5275     	qla2x00_free_fcport(new_fcport);
5276
5277     	if (rval != QLA_SUCCESS) {
5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
5279     		    "Configure local loop error exit: rval=%x.\n", rval);
5280     	}

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Fixes: 3dae220595ba ("scsi: qla2xxx: Use common routine to free fcport struct")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c4e087217484..62df78258269 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5109,7 +5109,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
 	    &entries);
 	if (rval != QLA_SUCCESS)
-		goto cleanup_allocation;
+		goto err;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2011,
 	    "Entries in ID list (%d).\n", entries);
@@ -5139,7 +5139,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		ql_log(ql_log_warn, vha, 0x2012,
 		    "Memory allocation failed for fcport.\n");
 		rval = QLA_MEMORY_ALLOC_FAILED;
-		goto cleanup_allocation;
+		goto err;
 	}
 	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
 
@@ -5229,7 +5229,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 				ql_log(ql_log_warn, vha, 0xd031,
 				    "Failed to allocate memory for fcport.\n");
 				rval = QLA_MEMORY_ALLOC_FAILED;
-				goto cleanup_allocation;
+				goto err;
 			}
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
@@ -5272,15 +5272,14 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			qla24xx_fcport_handle_login(vha, fcport);
 	}
 
-cleanup_allocation:
 	qla2x00_free_fcport(new_fcport);
 
-	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_disc, vha, 0x2098,
-		    "Configure local loop error exit: rval=%x.\n", rval);
-	}
+	return rval;
 
-	return (rval);
+err:
+	ql_dbg(ql_dbg_disc, vha, 0x2098,
+	       "Configure local loop error exit: rval=%x.\n", rval);
+	return rval;
 }
 
 static void
