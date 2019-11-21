Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0449AC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 17:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBD22206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 17:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAJ8Bc9b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKUR4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:56:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32948 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUR4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 12:56:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so5601515wrr.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2019 09:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GEzoZ1oSPFXtUIC55vSd6kEd6DXXzKK6wZJNa2hGXfw=;
        b=TAJ8Bc9bpn4MY6AkRn+tL0Ipyi6NtheQ7pVhiWW+5C20pKEPo/zAhgsU4WB/i8vgtG
         96SJb26pi1m+I2R/lO5sQvK/luBMP4sneO9sU/OuGRM0bRxUaPhEQAf9vey/b6NIkm4S
         LtHg+0TXisycrKBSUKfccFrKj2WqcSsyq7fDjw1tC3fPgXmfff/8Ipic2veS4Y6bEtNe
         Xchrdiy1MIb6IfW52pwh8gXGP9Q1sO0wJSW7UpWKCJxkQz+dlsBPLS/WvGilOOVziVIi
         zcx8ZZa1UjUTn9ApXu44GcRlUlvZVJAmrTecCSvlmoS37F2qPzmVG5/uWd06lKRdSV69
         s/3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GEzoZ1oSPFXtUIC55vSd6kEd6DXXzKK6wZJNa2hGXfw=;
        b=g8aV6jnfG2XrYr961ebVaOJ0nd0eKl9V9oD0665MBn/EQls7bsqizrcNscJ4zQVWlK
         7mQz98vitju92hawFaga42ni9GN374lQW25BRefyOlAT1rcIzM1PZZ4d2asZ3MnMkIHV
         PJ6sfAe937PHCChtlQpJji8jRxy4weowVIfyd0tXsKoZAPlyZxgMLlZE/ocP1I2yUGhj
         FIjI8RtMIXOf2aXWtlj5KHA9ARLAMvC8M1DVGuAw9eyPGf8MbqzTD3LnspE+OdLy0CfL
         SnUuIjytIH0H4RQzAJm/DN3hRGzg0gnftAGn7SO+qjgvRt2oxdW5GlnTH7B/PmbMK+tS
         TKEA==
X-Gm-Message-State: APjAAAVXIgDvO5ixhXhCLSOsjDT2OeEwra4dlmHYPXNUm7dmb7XvGrGd
        cfR11Ccz0c1kr2joL9nDqLitX7Lj
X-Google-Smtp-Source: APXvYqwtYktuITbQAU62vFAWxzrua3HjXLzO47Z6CfictjWFLfWkCpDp/SeyLqEG3j4uHV/d2tH/cQ==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr3939231wrw.373.1574358965869;
        Thu, 21 Nov 2019 09:56:05 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a26sm399076wmm.14.2019.11.21.09.56.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Nov 2019 09:56:05 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: size cpu map by last cpu id set
Date:   Thu, 21 Nov 2019 09:55:56 -0800
Message-Id: <20191121175556.18953-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently the lpfc driver sizes its cpu_map array based on
num_possible_cpus(). However, that can be a value that is less
than the highest cpu id bit that is set. As such, if a thread
runs on a cpu with a larger cpu id, or for_each_possible_cpu()
is used, the driver could index off the end of the array and
return garbage or GPF.

The driver maintains it's own internal copy of the "num_possible"
cpu value and sizes arrays by it.

Fix by setting the driver's value to the value of the last cpu id
bit set in the possible_mask - plus 1. Thus cpu_map will be sized
to allow access by any cpu id possible.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e9323889f199..cd83617354a1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6460,7 +6460,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	u32 if_fam;
 
 	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
-	phba->sli4_hba.num_possible_cpu = num_possible_cpus();
+	phba->sli4_hba.num_possible_cpu = cpumask_last(cpu_possible_mask) + 1;
 	phba->sli4_hba.curr_disp_cpu = 0;
 	lpfc_cpumask_of_node_init(phba);
 
-- 
2.13.7

