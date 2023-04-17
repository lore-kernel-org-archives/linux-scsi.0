Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C959C77B72
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDQTGW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjDQTGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:06:19 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C135BB3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:09 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b875d0027so587681b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758369; x=1684350369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKhXi+iyEvxzRcipT/f2A4QIc1t/0KyNVutF7WgeQJM=;
        b=fLw7dASH0J2UnDGrydIxRsad5YviDEoOdmUmJoP3IcNkhL29R8a1fDu81Nd+TPehro
         XbBvngRtHwq+9qHjl3ftR2y4RmwMDIxEivV7b1tCOqy+ol5FMmQnVKLuw/X3nhArpXm8
         pxJUZIz0KSy/y32kRD1kCSrarOzUrp5sT5tT48EFVQsAU2cMC7h3G2p60RTPsCzLD4je
         8ru6gXiiqAQzNOjLwtngE8aPnywicYX+lQGnnznYBlEffeab5OlXvLPu6g1kouLrgCWp
         V7+LHWRuCHQpqtsHAYIieC5P45Ss7m8M+3kREBEh0jTBxJ9FvluM7KsDItvjICmlyR8o
         8i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758369; x=1684350369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKhXi+iyEvxzRcipT/f2A4QIc1t/0KyNVutF7WgeQJM=;
        b=hHUOlLduNMziF5HRTpdZCtQSVPccp0n36uDa7h8fe5TUTr9NDDxUlz+8YWjfbWMiBt
         K93Abt3rjBRvInuR1NPiFd4Be1e+hRxc2VGEp9a90Efnevp7FNxUvkbzVAERdefbPbjW
         VIFGuxR03RBpG9suqJ5Fd4h5zylIjpHXMIy88TkgaZdxJSRqhVBqf7nvO8qv6dxmpPnI
         JT5iKKiEr2gQVjziQ+nKSgUKfsaQLm3WXP1SgvBqMRiEMpyCLY+Hmz+JPNOEyf8sXsgo
         lIbc0nBi2Q7QF4vTRVGhW1PaWlM8TGMADBof7Rxfr5CUaAKvgUiI0aTxtLrTaDUPM+lG
         BoNg==
X-Gm-Message-State: AAQBX9efbusKTAFj7wlg3Yohhh9xagTaeRwKyo5KLyrsKbssaUKKnhoF
        bK+3RWuaVZCIdtIaE25kPc4dk9WI4eE=
X-Google-Smtp-Source: AKy350bfTQfFHCXRqUWB28Q7HVOPmAomMJXvr50EL9fdZrXFkQAvxujW9Usu/fWcNsFB3Oa2JJN+VA==
X-Received: by 2002:a05:6a00:1c9e:b0:63d:344c:f123 with SMTP id y30-20020a056a001c9e00b0063d344cf123mr704898pfw.1.1681758368972;
        Mon, 17 Apr 2023 12:06:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:06:08 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/7] lpfc: Update lpfc version to 14.2.0.12
Date:   Mon, 17 Apr 2023 12:15:58 -0700
Message-Id: <20230417191558.83100-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.12

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c97411b0992e..5fda8ac6b883 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.11"
+#define LPFC_DRIVER_VERSION "14.2.0.12"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

