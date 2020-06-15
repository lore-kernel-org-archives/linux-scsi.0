Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F85C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 21:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA892071A
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592257320;
	bh=8Zbuy1b0z/Ednd8/WbrXrRkx2o1CKrlUkbyp6gQ/7Fo=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=2JidHxBxpw40B5uo64C4RzA501eqouT92cP+O1A0oTFAv+MIXdp1oX0JzuOURgcwf
	 Xzsb8NWdZjM6mnP4lJsg7OGKBR+2XwLa3q44DN0iso7TKh7q04eTpQWDdaALzlzzlR
	 pbalDf+XC6QuSV+1iQVNoReAnhlHAu/1MfZ5qEqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgFOVmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 17:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgFOVmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jun 2020 17:42:00 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC2520714;
        Mon, 15 Jun 2020 21:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592257319;
        bh=8Zbuy1b0z/Ednd8/WbrXrRkx2o1CKrlUkbyp6gQ/7Fo=;
        h=Date:From:To:Cc:Subject:From;
        b=llznlCQ80AmMdNQCbgR0iYH5upWqniXPugvwHCNh/4x9NWv9AeA0RiGWrgYCGd+Hi
         oNnvUxOnbMuZT8GGXixo2nvDB2rhthEFoS8hyrk7QR3QJmovfRMaqtzFfkSXk5NBXq
         iKUJqDqk4SUL/FRJkDX1VYVr2WK6N5j9z25/14a4=
Date:   Mon, 15 Jun 2020 16:47:18 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: megaraid_sas: Use array_size() helper
Message-ID: <20200615214718.GA6970@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The get_order() function has no 2-factor argument form, so multiplication
factors need to be wrapped in array_size().

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 319f241da4b6..6de44ed4cde7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5180,8 +5180,8 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
-	fusion->log_to_span_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
-					      sizeof(LD_SPAN_INFO));
+	fusion->log_to_span_pages = get_order(array_size(MAX_LOGICAL_DRIVES_EXT,
+					      sizeof(LD_SPAN_INFO)));
 	fusion->log_to_span =
 		(PLD_SPAN_INFO)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						fusion->log_to_span_pages);
@@ -5196,8 +5196,8 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		}
 	}
 
-	fusion->load_balance_info_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
-		sizeof(struct LD_LOAD_BALANCE_INFO));
+	fusion->load_balance_info_pages = get_order(array_size(MAX_LOGICAL_DRIVES_EXT,
+		sizeof(struct LD_LOAD_BALANCE_INFO)));
 	fusion->load_balance_info =
 		(struct LD_LOAD_BALANCE_INFO *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 		fusion->load_balance_info_pages);
-- 
2.27.0

