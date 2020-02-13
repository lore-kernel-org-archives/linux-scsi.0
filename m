Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC179C352A3
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 22:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEBB420873
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 22:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9hX9Dgc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBMWkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 17:40:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46987 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 17:40:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so2898525pll.13
        for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2020 14:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=voJlDhemiKgdQlPlMyGmEyFFS62qPjx7Ahz5Mhyc9nw=;
        b=P9hX9DgckOjdGJ5lFNNxSfClHYd6F8TQOtfHhdCMRzR9tNToP+J/627OAdfzjTD/wm
         g9eMZExcFES5Kr5jvGu6K40RKNIlr/KwqYIJzJllf/XkDiAbaTTIcrXN8tapUA/5fkEH
         zahpIEytAEq67l7CYgJ5o0/Jqjq6tLNPO13l3HT6o+IWPK+TfwpQ2RhxaAknnTl2xvgU
         rBYx44FN1ftISb6wO5L9kpzcEF9YhRn0WzslSvhe8CAhkDipFO8Pzdj3omNRltMFpXVm
         3SLGln8338gir9bb0oS1N7jtUSURWAqAp/YcfQY7AHg8NBf0Z/6m/7w9NWniRbH+hnpW
         bMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=voJlDhemiKgdQlPlMyGmEyFFS62qPjx7Ahz5Mhyc9nw=;
        b=krpWs3m+cSNcvdfPHznfK0cpgBrKPx3B6EeS1NJKMc/ZTa2pTeLD0V3X1JUe3vU5LU
         KzopT6qk42sKwVpATKmo+lILEu8Tn6OphfgMAOuA9Fg2iTlcPMS9TrOqNXfMEwGT0KM6
         TBXMlf+Sgox9xXkvKo0th4i15eixxUSJQy4tknFCXOrDPmDgzR9Z+cu23tGsnjG6OBJy
         dvSB0EWlxQ3E0w2EYgJ2GLnjHsp0iJ5el/j43vdHa+ro6XtNwGAAaIelOBUahzWj5lOm
         zcmDpXeHiMnvQSecWD97Ra2EqVppjucGOSekW0fp/30gxWsy4Ee9dQtC3SUFeY6c5frt
         TfrQ==
X-Gm-Message-State: APjAAAVF0zscHjprk/8icDfASKk86ShGue/ek8j6W1w9REf2dydVXvc1
        WyDZxX3cLK2E/Cf+CcaG7uLbr5f/
X-Google-Smtp-Source: APXvYqwfxibnjBpHyJSnvAX/uA1F1Ten9IpawO+6bKYFEnEwtk4XSyLtxp/4uzfv8aN6IwKfjzAFvQ==
X-Received: by 2002:a17:90a:8547:: with SMTP id a7mr8191271pjw.0.1581633649907;
        Thu, 13 Feb 2020 14:40:49 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 11sm4371079pfz.25.2020.02.13.14.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Feb 2020 14:40:49 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH] fc: fix fpin_els build breakage
Date:   Thu, 13 Feb 2020 14:40:42 -0800
Message-Id: <20200213224042.26986-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kbuild reported the following error:

All error/warnings (new ones prefixed by >>):

   In file included from <command-line>:32:0:
   ./usr/include/scsi/fc/fc_els.h: In function 'fc_tlv_next_desc':
>> ./usr/include/scsi/fc/fc_els.h:274:4: error: implicit declaration of
    function 'be32_to_cpu'; did you mean '__be32_to_cpu'?
    [-Werror=implicit-function-declaration]
      (be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
       ^
>> ./usr/include/scsi/fc/fc_els.h:286:17: note: in expansion of macro
    'FC_TLV_DESC_SZ_FROM_LENGTH'
     return (desc + FC_TLV_DESC_SZ_FROM_LENGTH(tlv));
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Fix by converting fc_tlv_next_desc to use __be32_to_cpu().

Signed-off-by: James Smart <jsmart2021@gmail.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 include/uapi/scsi/fc/fc_els.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 10b609a2f863..66318c44acd7 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -271,7 +271,7 @@ struct fc_tlv_desc {
 
 /* Macro, used on received payloads, to return the descriptor length */
 #define FC_TLV_DESC_SZ_FROM_LENGTH(tlv)		\
-		(be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
+		(__be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
 
 /*
  * This helper is used to walk descriptors in a descriptor list.
-- 
2.13.7

