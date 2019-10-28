Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E49ECA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43EC5208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvIX3cpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbfJ1Utl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:49:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43889 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1Utl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:49:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id 3so7722474pfb.10;
        Mon, 28 Oct 2019 13:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=1Hum32HGcrAtxzDAgbdk3CWnZkz7ktiFh+DUwCg4ZRg=;
        b=PvIX3cpntw6AsPuxJ6BUXhCXcEa/4XIwybJ31Z+yIhgVmd/8pQB1DB6PiPWI9TO/xl
         GTGVUvfHphH7+JIbdP4OjVBV/8M46488EQLtKt5sfM2m8hRgSgtHwaORiPjhsc2FkkwT
         0cXVDm24R97jcZJLQE8xQBZDMdiOI2SSCmsoQ05cSIn8CeLUPWBS9TO9xJqH06xIx3ab
         F3VbDotwhdhqkuOZdQYyxxMrd8qTqMfuqtCjS1I03WBdahP5Det8xFTbQ0ZkhgG83nvo
         a4pIzZ7YE6g+pTBNSfEGBagurogbIGhdVcdLBeMR9RMJijXXkmK57uml3ZHbtHXGQbF/
         M8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=1Hum32HGcrAtxzDAgbdk3CWnZkz7ktiFh+DUwCg4ZRg=;
        b=FCF6vx4yibbdubfNbTmWugDcxIwWfrWeUbdrDcvzZio3BVpdL+rsw/6Z1N0WtFtgy0
         xYTi+x7ZSIQgMTyE616wOOvLzJ7svDvXxMDLkzhvHufeeuunrADvulUmdFbi6ta15+B2
         6aLQk2aiOxaKsNt9x7DVfExk2lc8oF0b1bsud71z4VU8u/C5PpS3g1LscR1DCoMMET20
         yAI4Ow9Xg3PRCySkbeum1U7oww6PW0CP2l+atn3qa5FXSzQM/u57L6jjNARQ6dmjRfv4
         +drOdzcVVxB0DUJ1hwYvi9R3MTYBJz+8F5dnMRoMkvItGl/XyW6oSTCoMlpsfzDZcZzo
         adTw==
X-Gm-Message-State: APjAAAXDh1lyr3/UzOqfhAcVzhK03SQ+mUT4TcpKahatZLDzQuKtNI9k
        LJW/V54VYkZr6poYA4H7qzE=
X-Google-Smtp-Source: APXvYqzRDZ8JMCrB1odziVyZcNBn1BBvbF/xH5FTw+p7zNdRZIBXwC16VzOHEpqhw7bFnOr4Xbz6+w==
X-Received: by 2002:a65:6203:: with SMTP id d3mr22775570pgv.272.1572295780516;
        Mon, 28 Oct 2019 13:49:40 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id u36sm13494485pgn.29.2019.10.28.13.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:49:39 -0700 (PDT)
Date:   Tue, 29 Oct 2019 02:19:32 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] isci: request.c: remove unneeded variable status
Message-ID: <20191028204931.GA29561@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

status variable is not modified within function.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/isci/request.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 343d24c7e788..6537fa880906 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1480,7 +1480,6 @@ static enum sci_status
 stp_request_pio_await_h2d_completion_tc_event(struct isci_request *ireq,
 					      u32 completion_code)
 {
-	enum sci_status status = SCI_SUCCESS;
 
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
@@ -1500,7 +1499,7 @@ stp_request_pio_await_h2d_completion_tc_event(struct isci_request *ireq,
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status
@@ -2103,7 +2102,6 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq,
 						       u32 completion_code)
 {
-	enum sci_status status = SCI_SUCCESS;
 
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
@@ -2148,13 +2146,12 @@ static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 completion_code,
 						  enum sci_base_request_states next)
 {
-	enum sci_status status = SCI_SUCCESS;
 
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
@@ -2174,7 +2171,7 @@ static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 compl
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status atapi_data_tc_completion_handler(struct isci_request *ireq,
-- 
2.20.1

