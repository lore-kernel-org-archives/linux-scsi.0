Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2991C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCDAew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCDAeQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:16 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAE3D33A
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:56 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so7857617pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfUNV5XAjPKJxQkNcgHdjbQdBWQvUazYP8mFmRY6Fik=;
        b=Z0Lt2NHweJ7mX7szMR8hYZrle57mdOvP0sx2NK8mrUIKWrepud4hr711PlwcYioIIj
         b5N1HeBPZua944a2GhxxLPbrG78wqnwMiel/+7vzxXjc0wnDtDxfPBxLTjCEkMbj8eZ5
         C5k3OSxzI7jl/Xsvg0tbq8dnjLYPDGqwcQvzUIDsgCiFbHgHYbVp/nYUp9lWSGO39ZpC
         MauDVqeEkbiulRPLgFjbpr9TQYzd0y7pLjvj+aBgpPQ8Ya6KaGsQeFBzE05cubB5/Qsy
         UsuRt/gO2cvCxP2/Dbp1KLR4HW0wniGuDs9UuStdE2lFt2d1nOrWw0nlZzdIC0501Fai
         RZdw==
X-Gm-Message-State: AO0yUKVyFWw5kemljW/hhcyWI8c5viW4TVRhX8d6Cl8WMxOMqvT04lwd
        Cw9IpLz6Wpo/8QdRlbkWluMwfQj2oPF+Xg==
X-Google-Smtp-Source: AK7set8zViMRivIsyr7ZaifsqIEBabhxD9sMDlTrS1mTvOwRQdb/kouVBm8MrNnRax8cN5VPZpt+sg==
X-Received: by 2002:a17:902:b786:b0:19d:ab83:ec70 with SMTP id e6-20020a170902b78600b0019dab83ec70mr3079288pls.45.1677890025557;
        Fri, 03 Mar 2023 16:33:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 53/81] scsi: mpi3mr: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:35 -0800
Message-Id: <20230304003103.2572793-54-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6eaeba41072c..207a607d8997 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4757,7 +4757,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	return retval;
 }
 
-static struct scsi_host_template mpi3mr_driver_template = {
+static const struct scsi_host_template mpi3mr_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "MPI3 Storage Controller",
 	.proc_name			= MPI3MR_DRIVER_NAME,
