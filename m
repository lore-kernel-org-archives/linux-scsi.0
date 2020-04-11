Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD4FC2BB86
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5534720CC7
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586646942;
	bh=Ddv9SF++LpKiw+2zYXDKW5JRkO4JX8S6DIl7nFsv+Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JSWP2qKiNo4CLc1Qqv8saX6PkJvj6rkHX9lucEKtIeqN0Ir+FFAyLgQEKwf2nQllG
	 wvy/gTXTGG67mPIQ6IrQH/nYmH6pntCHlt/8CBjXy3z7OK5ZfwqY5iT0MLCwEG3tyz
	 v6VHNo2sP3IA2dMZtdmMdBv0N/y4MSq/y9iD/Z44=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgDKXPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbgDKXPC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:15:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B7F215A4;
        Sat, 11 Apr 2020 23:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646902;
        bh=Ddv9SF++LpKiw+2zYXDKW5JRkO4JX8S6DIl7nFsv+Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z16b8RWIIaPkfXbp/xv1aAJIW2m+JisZkHkRbTEtwMgSGTlOBdQsolC2SwMSh/RZa
         d7Rwlk17X+bge0lDnp2QHqb9hnurSZ81m92oU9ylWHFgfmIua2QziJSt2YstTl/Pm9
         V0bSInNzcLqBIbiDr0poTIwepn8VIgY/uf+UAb6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/16] scsi: lpfc: Fix RQ buffer leakage when no IOCBs available
Date:   Sat, 11 Apr 2020 19:14:42 -0400
Message-Id: <20200411231447.27182-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231447.27182-1-sashal@kernel.org>
References: <20200411231447.27182-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 39c4f1a965a9244c3ba60695e8ff8da065ec6ac4 ]

The driver is occasionally seeing the following SLI Port error, requiring
reset and reinit:

 Port Status Event: ... error 1=0x52004a01, error 2=0x218

The failure means an RQ timeout. That is, the adapter had received
asynchronous receive frames, ran out of buffer slots to place the frames,
and the driver did not replenish the buffer slots before a timeout
occurred. The driver should not be so slow in replenishing buffers that a
timeout can occur.

When the driver received all the frames of a sequence, it allocates an IOCB
to put the frames in. In a situation where there was no IOCB available for
the frame of a sequence, the RQ buffer corresponding to the first frame of
the sequence was not returned to the FW. Eventually, with enough traffic
encountering the situation, the timeout occurred.

Fix by releasing the buffer back to firmware whenever there is no IOCB for
the first frame.

[mkp: typo]

Link: https://lore.kernel.org/r/20200128002312.16346-2-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 065fdc17bbfbb..0b2c6e0f0de59 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15443,6 +15443,10 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			list_add_tail(&iocbq->list, &first_iocbq->list);
 		}
 	}
+	/* Free the sequence's header buffer */
+	if (!first_iocbq)
+		lpfc_in_buf_free(vport->phba, &seq_dmabuf->dbuf);
+
 	return first_iocbq;
 }
 
-- 
2.20.1

