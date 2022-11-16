Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1124C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiKPBLA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKPBK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:10:57 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2B317FF
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:56 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id k2so10748527qkk.7
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USbEUbJbcHadAUeL/lHg6Lme0QD4ZZZ671pCyBh9AIg=;
        b=FuRYAa/+LibKN1NRgfql/RnorZF4EEECnN/zzPo8uXtKlN+xZ5pTlWZJm1E7Ta7CgD
         nvQLtHrUaZq8V6brhCGsv5bE5fmoOfxbdw2HK92CkxZuCVCa2qHBmSTaxcsUbDLgOwtP
         riBPZoQ4FuyqCg5U7iQu6xwbVIJ99Akgp1sezhZUaYQQB2K4FEeVleko/YWsaBGSIgRk
         GqAkk9NWTJlGRUxuFHIhMF6guCpyxKZBsBYjWg3sKTkx7CeaFOq/Refd4ggyeBougQkU
         TOgIWcaTFUI3/aQaqXgI2WEdqw0N2CF0od/aYNejka197BO+GRC6q0Df6IwI2Lb4LeJG
         jqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USbEUbJbcHadAUeL/lHg6Lme0QD4ZZZ671pCyBh9AIg=;
        b=r8dWzeHlM93ZSqdRpK93+P1Ypry4zC0drK31euy+v8V7OrnRlDBk2xsz0QWPKT7R1S
         uGofiOUfKnqIVCKMKv5PSBFZ0F6A2hnor4DO7lJTKrAcr6BlG3WEr4JMio38tL8o6B1W
         YLOx+SJm8hiI0GBkcu9M9/+GfRC1ygB3l+JiXb3Edwr6abIE8+wuluT411x/EOOrF7fv
         8JKiZihjq2ges1jnu/IQ9UyyNXdMb4k8pcC5EfscXQxF2OAhxlQ15H66k963/BZ5x2lc
         Ow+/2OdND9J4o2yCkR/deGWIIRN3/4aO1uPCiLy+fhpSRsqiRKoqbTXj5grgubOc5gQL
         +jgw==
X-Gm-Message-State: ANoB5pnJuzITd7fvuvLmddjQWDzSKc7lEEUJ969VA6P+2ffSpEk25ppW
        X47SNm0Av3ewT+o7uODsH5Ul7RoiwY4=
X-Google-Smtp-Source: AA0mqf6bsoS4O1HIlaJOo1BI7y4U66TkKEKGVN4bqWzP4tKZmAyxCBM8aFu30drbL6wZVDd0AXtvtw==
X-Received: by 2002:a37:bb82:0:b0:6cf:4460:fdd2 with SMTP id l124-20020a37bb82000000b006cf4460fdd2mr17496905qkf.543.1668561055999;
        Tue, 15 Nov 2022 17:10:55 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:10:55 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/6] lpfc: Correct bandwidth logging during receipt of congestion sync WCQE
Date:   Tue, 15 Nov 2022 17:19:17 -0800
Message-Id: <20221116011921.105995-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The lpfc_cmf_timer adjusts phba->cmf_link_byte_count periodically and
can artifically inflate bandwidth percent.

During bandwidth calculation, correct for this by setting a cap of logging
a maximum of 100%.

Bandwidth calculation is only used for display under LOG_CGN_MGMT so there
is no expectation of impacts on performance.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d25afc9dde14..a66026432572 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1848,6 +1848,12 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				  phba->cmf_link_byte_count);
 		bwpcent = div64_u64(bw * 100 + slop,
 				    phba->cmf_link_byte_count);
+		/* Because of bytes adjustment due to shorter timer in
+		 * lpfc_cmf_timer() the cmf_link_byte_count can be shorter and
+		 * may seem like BW is above 100%.
+		 */
+		if (bwpcent > 100)
+			bwpcent = 100;
 
 		if (phba->cmf_max_bytes_per_interval < bw &&
 		    bwpcent > 95)
-- 
2.38.0

