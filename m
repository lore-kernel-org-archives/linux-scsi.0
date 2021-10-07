Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2A4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B4061108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242408AbhJGUcu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:50 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:52970 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242227AbhJGUct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:49 -0400
Received: by mail-pj1-f45.google.com with SMTP id oa4so5095760pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cx5mLSqSRMTPAqHdKvTeRQWD317TuE1XEtb+GD/tb58=;
        b=nayXDGjK2jWuxazLZ76qEmVjHtyciax+FSzUIGR+kv1Mp4SOsQMqbYmm9MjfpdFZVZ
         h5OSue96ItVMHZOE0iJCy/mVJ38VX6kV4K6EIOzhwDiOdBXxp2Kd1gZMSmp2tGAgv0FL
         6/nUba/qNMNakDjQZUtYf6J8NVfdpZ5nDWDgaOLXg9+8zFlK/Mx46L+CYWmTzwJO53Ng
         DhW+UNPggeQzL5oo/PTfJbzRSSt/lWKlWLpf3xiiI0z9YjFtMMub+d4Lt64qONTwSBDa
         JD+iENZl+m45Cb2LkoTsfrXXCI0jyMtZB236ZFDKjCEc6bzsL7kqtG4hQ18tUniU17zI
         I/+Q==
X-Gm-Message-State: AOAM5330pmbTmoK0kwLCLiasqldVDNbWiNhci8e8u8IW4gOsVyI6WWTU
        ZOXd4UpItnIPn/aoPic58zc=
X-Google-Smtp-Source: ABdhPJyIYkyJ7k5nr/xfov2Tbb1f/8B381iFmrkhqlj8LXr2CVS7LQt4VSYCQqLtxkSF9IzraWrcOA==
X-Received: by 2002:a17:90a:4dc6:: with SMTP id r6mr7807014pjl.5.1633638654675;
        Thu, 07 Oct 2021 13:30:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 47/88] mac53c94: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:42 -0700
Message-Id: <20211007202923.2174984-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mac53c94.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index ec9840d322e5..9731855805f5 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -83,7 +83,6 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cm
 	}
 #endif
 
-	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
 	state = (struct fsc_state *) cmd->device->host->hostdata;
@@ -348,7 +347,7 @@ static void cmd_done(struct fsc_state *state, int result)
 	cmd = state->current_req;
 	if (cmd) {
 		cmd->result = result;
-		(*cmd->scsi_done)(cmd);
+		scsi_done(cmd);
 		state->current_req = NULL;
 	}
 	state->phase = idle;
