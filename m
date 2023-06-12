Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A136FC7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 10:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbjFLKy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbjFLKyM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 06:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFD811D8C;
        Mon, 12 Jun 2023 03:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE62F612A1;
        Mon, 12 Jun 2023 10:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA44BC4339B;
        Mon, 12 Jun 2023 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686566377;
        bh=ePm379yY4XF2I6pU3RaBrQaVCGybMBc2EXUpeiAv+4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub2eTSCgAMlvA5ggYJWNEnS1csnNMbfsyQGbWFl/PETUMU1239EcjIJixl83jSDX1
         5tCXmnu9DfFWUur5ETdaavjatanX/hSCQXCg57jVBAlCYk2AhiLyan3NSb+cijwSS7
         F02cxniIFsyoXqhS1Tld01KC9itc3Qy+oiPRfs50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Holger Kiehl <Holger.Kiehl@dwd.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 001/132] scsi: megaraid_sas: Add flexible array member for SGLs
Date:   Mon, 12 Jun 2023 12:25:35 +0200
Message-ID: <20230612101710.358894732@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit a9a3629592ab7442a2e9d40281420b51c453ea9b upstream.

struct MPI2_RAID_SCSI_IO_REQUEST ends with a single SGL, but expects to
copy multiple. Add a flexible array member so the compiler can reason about
the size of the memcpy(). This will avoid the run-time false positive
warning:

  memcpy: detected field-spanning write (size 128) of single field "&r1_cmd->io_request->SGL" at drivers/scsi/megaraid/megaraid_sas_fusion.c:3326 (size 16)

This change results in no binary output differences.

Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Link: https://lore.kernel.org/all/88de8faa-56c4-693d-2d3-67152ee72057@diagnostix.dwd.de/
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Link: https://lore.kernel.org/r/20230106053153.never.999-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3323,7 +3323,7 @@ static void megasas_prepare_secondRaid1_
 	/* copy the io request frame as well as 8 SGEs data for r1 command*/
 	memcpy(r1_cmd->io_request, cmd->io_request,
 	       (sizeof(struct MPI2_RAID_SCSI_IO_REQUEST)));
-	memcpy(&r1_cmd->io_request->SGL, &cmd->io_request->SGL,
+	memcpy(r1_cmd->io_request->SGLs, cmd->io_request->SGLs,
 	       (fusion->max_sge_in_main_msg * sizeof(union MPI2_SGE_IO_UNION)));
 	/*sense buffer is different for r1 command*/
 	r1_cmd->io_request->SenseBufferLowAddress =
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -526,7 +526,10 @@ struct MPI2_RAID_SCSI_IO_REQUEST {
 	__le32			Control;                        /* 0x3C */
 	union MPI2_SCSI_IO_CDB_UNION  CDB;			/* 0x40 */
 	union RAID_CONTEXT_UNION RaidContext;  /* 0x60 */
-	union MPI2_SGE_IO_UNION       SGL;			/* 0x80 */
+	union {
+		union MPI2_SGE_IO_UNION       SGL;		/* 0x80 */
+		DECLARE_FLEX_ARRAY(union MPI2_SGE_IO_UNION, SGLs);
+	};
 };
 
 /*


