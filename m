Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D0AC678D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCAXHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCAXHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:33 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6625650D
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:32 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id l13so16286917qtv.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6gvLxOzVNI5Fx692m3rWn9dH/1qatcHRsy6IAsmSMU=;
        b=eBAPlw29NLhT4NeQXRrb0kpoWgNgrYSsaRJtqZVJch6+3HulH82/zYaKtyv6uCWaay
         RXzqAW4eUknf/zLnkrE7OWFUh0TqLA+oTNlogEliqBV/p3uaywpC0XvBiCmoEQ8edEVl
         x8zeooK37t6UPlOpr90CYvM+8V0+U0aCobDvsRJlilFQf7pKezHY6DIcLN4s/+aJpuum
         Xl4ZjawDy30lURCL5nxx1weDeQQA93N2SNEv79hclx154NzIoYA1nC688oF47o4ObO+z
         JomsWdFivVCQMTftChN2rYybJ2LIU4g24oHEOzzKRqClO8Qt3XXSMBcrAUAlqI1KGdTz
         m7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6gvLxOzVNI5Fx692m3rWn9dH/1qatcHRsy6IAsmSMU=;
        b=UfCbLT2JG2pm3mBBe1OC+9JPInd/Wtpia1gm+gj8SIBwNTcXyFoL2r+PDiqOYxEB9U
         cRZychS5krcav9qvuw91O216PWEbM6OgkPoAXB+YA2W31wmMK/uxI9dzByhq5xO1Wa/C
         udZEw0GIFUqK45sYOlXDFueFpCUTPtPjOdumtBAvF8Kv5OjGF17FnzUcre7rThpY24Ji
         VtNlgX4FQQ+9btgzhGrNh3xkJgjS47UghvZsOHdpH/ITF8YPDLgN6sctjjKm9XoOdPTG
         M2WdXlbGT0vseBEx1bh6LW88M7hMw0M27qeEJMuUXmpalwpBqvMB74aSu7K/dvzOzQof
         VHzQ==
X-Gm-Message-State: AO0yUKWb3QCLnBq5jKq0t/AjYuBffqFy9EbFbK/QldITvBqhRYR7cBbH
        EW4wgdzC4XOMOpTJ0X3YgklNxKzLf2k=
X-Google-Smtp-Source: AK7set/gjS6DNVuYhOP8+dVL/jIqnyIXjJ/aMHZXmORRh2T8cRZEoCjQyw1Qxue6a+W0YB5Uu7yL0Q==
X-Received: by 2002:a05:622a:1391:b0:3bf:c458:5bac with SMTP id o17-20020a05622a139100b003bfc4585bacmr16252621qtk.0.1677712051679;
        Wed, 01 Mar 2023 15:07:31 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:31 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/10] lpfc: Update lpfc version to 14.2.0.11
Date:   Wed,  1 Mar 2023 15:16:25 -0800
Message-Id: <20230301231626.9621-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.11

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 0238208cdd11..c97411b0992e 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.10"
+#define LPFC_DRIVER_VERSION "14.2.0.11"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

