Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53022C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA1A64D9F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhCANUr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbhCANUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:20:34 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0CAC061756;
        Mon,  1 Mar 2021 05:19:54 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id d20so15379169qkc.2;
        Mon, 01 Mar 2021 05:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXw0zUB4V26WpLNROVKNFQyeOrOBkkYV5mywYnR1B9Q=;
        b=VXKXSRJv/IMgWRmYoQQ8w0gvEbgimbxesZArfc8uSKyE/DMxFgWTWM8BY5F4xfpDGf
         mhod3gbQQu46YlqVvViXyrQzRipsy9VbkIG8VmCIHo9VCX5I9wXCif9E819yd4bMTGT8
         fxcI9vZ24Z8TYX/ve6OD11vdNN20cbYGr6cw4U41sraO2hEQDaNrnw9qC6uqx1ffIFue
         qCpLInEMGugQrq4lnbkRrE1asqkYPSccixaf/9MXm+HRJlXNQk921hueF96PESKGwUcm
         fvvVOz12mebSSmkkmOM+hEhd7cWmINTlCA5UY3eD93mtr5XXJ/n7B7eiDj/HLpmwHDjl
         WRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XXw0zUB4V26WpLNROVKNFQyeOrOBkkYV5mywYnR1B9Q=;
        b=ZnRlsujfozQpMfd75AHidOnRUYeUUSxR5G4UZEO/0NDGGjG/6Ipbo27NTRDvKGYNmS
         WXpyhc8jWkw7fpRQiqt2ABnNy/g4P2QfYJaUJp/iZnw+Eck8GyxKEnrUaihRpXxj/3RH
         5LAvy+R8y3ifI9R5dJ55dLqCChx+SwV1gACCljI7tN81vpfHn+mxndeCmIfXS09mvGun
         XcCyEkWT37g5YwVnrbL+ad9U0UkWcHdOmMIuMWd/0JKhwC2ePlkjdB3n65YviJSTERNz
         D+dP4gAlCPqj2CVyJMBnF30y5j9XLNFG6o1FDD3EwJFPNxBofgxa9f+w3DWPkTO5xuDJ
         rrVw==
X-Gm-Message-State: AOAM532XomPZB602r5pPYVf8DQ2LkbmKNHdOPCv/YBp/Rh2Zm+JtVPjh
        ZYzQsDiGBCp2uOFZMKSJK0I=
X-Google-Smtp-Source: ABdhPJxOQBN9h0/uEPnLp5sQ5q4sk0AmOIAnLqBZVXyi3USI21rSkcv+l4lPaJ4LbNuRkX7m4zF75A==
X-Received: by 2002:a37:87c4:: with SMTP id j187mr14370357qkd.408.1614604793883;
        Mon, 01 Mar 2021 05:19:53 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.198])
        by smtp.gmail.com with ESMTPSA id o11sm10606159qta.1.2021.03.01.05.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:19:53 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: scsi: qla4xxx: Fix a spello in the file qla4xxx/ql4_os.c
Date:   Mon,  1 Mar 2021 18:47:36 +0530
Message-Id: <20210301131736.14236-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/circuting/circuiting/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a4b014e1cd8c..716a5827588c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6961,7 +6961,7 @@ static int qla4xxx_sess_conn_setup(struct scsi_qla_host *ha,
 	if (is_reset == RESET_ADAPTER) {
 		iscsi_block_session(cls_sess);
 		/* Use the relogin path to discover new devices
-		 *  by short-circuting the logic of setting
+		 *  by short-circuiting the logic of setting
 		 *  timer to relogin - instead set the flags
 		 *  to initiate login right away.
 		 */
--
2.26.2

