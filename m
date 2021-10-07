Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AE7C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B1060E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbhJGUcS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:18 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:37725 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbhJGUcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:16 -0400
Received: by mail-pf1-f180.google.com with SMTP id q19so5823425pfl.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xrYKlXXqZ43nTFeMXbGnx2HnZXNL43Vi79i7MYS3Ns=;
        b=qMMWlH+mzLC8U8f/XeEoAVw3jZNBODeVxK0QPOQvxxTLE899EADm8RS6HlnmAnzUBI
         SD9/nw1o/JVgNYQEAIQZG0dcw5jtlmxcNglPhmcaDhZhFuv94TVW8df1p0FDjs/LAstS
         tGZWmu55nzIbMvpaGZ6TFqsV+FCWcde+wOnE/rwFmsXU8fN7B2jlA66JSNcvITwEJZ9O
         He/iBiFwfrcmOyJqHbd543R1cDWjfMnME1AWEfwxRIKl8qdB4ml0yoP7U6iP569V4Im2
         3rrOv9iyBI3uMASk8roEgKROivSRAzcNSuWlWzwvyBLfJ63mWMNiJweZISaufodujPIM
         DjDw==
X-Gm-Message-State: AOAM531qM2yLJMAl8fDGdmTEb+VUENa8vETak7uIgqwUKmPrpgv9IKEK
        MVVS36SUfK5SExF1ZNkv1cU=
X-Google-Smtp-Source: ABdhPJw9C9FkJQo7Mmeb+w2Nqq9KyC+kgZtMrrtopZJNNGB15tjWvZOZ+1ExgxC4ODJgyDOGqg/rAg==
X-Received: by 2002:a63:d354:: with SMTP id u20mr1349213pgi.382.1633638621990;
        Thu, 07 Oct 2021 13:30:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v3 26/88] csiostor: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:21 -0700
Message-Id: <20211007202923.2174984-27-bvanassche@acm.org>
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
 drivers/scsi/csiostor/csio_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..3978c3d7eed5 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1720,7 +1720,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 
 	/* Wake up waiting threads */
 	csio_scsi_cmnd(req) = NULL;
@@ -1748,7 +1748,7 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		}
 
 		cmnd->result = (((host_status) << 16) | scsi_status);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		csio_scsi_cmnd(req) = NULL;
 		CSIO_INC_STATS(csio_hw_to_scsim(hw), n_tot_success);
 	} else {
@@ -1876,7 +1876,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	return rv;
 
 err_done:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -1979,7 +1979,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		spin_unlock_irq(&hw->lock);
 
 		cmnd->result = (DID_ERROR << 16);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 
 		return FAILED;
 	}
