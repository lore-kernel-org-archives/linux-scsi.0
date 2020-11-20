Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258F2C83020
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB27F22464
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cafZiBwx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbgKTSj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:39:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731186AbgKTSj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:26 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6DAA21D91;
        Fri, 20 Nov 2020 18:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897565;
        bh=ChNqrzeATqgo/481vkA2fcsrZK4G/jW5MZF5OiqvwzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cafZiBwxdBkXRI9Zz3wbm0e7r42R1AJo7W1nuy7ovAmCckHcqBDMIH073WUZNY/FN
         KEheg0bNTa1BMMXprscZ3Q6DkVIm8qlybSCet+OI11YU31WK1kQy36zcPpVezyLEo/
         0n1JakR8U6s5pCbNorjjzw7KDqUT/WkJZ1VscXpg=
Date:   Fri, 20 Nov 2020 12:39:31 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 123/141] scsi: lpfc: Fix fall-through warnings for Clang
Message-ID: <fff8d6f1d33b9e2c94dbe024a4f8df22866d3bf8.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6f9d648a9b9c..d6394281fad1 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3535,6 +3535,7 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 				mb->mbxCommand);
 			return -EPERM;
 		}
+		break;
 	case MBX_WRITE_NV:
 	case MBX_WRITE_VPARMS:
 	case MBX_LOAD_SM:
-- 
2.27.0

