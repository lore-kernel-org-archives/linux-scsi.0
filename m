Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25EBC001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 21:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjHIVYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 17:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjHIVYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 17:24:06 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667FF1BD9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 14:24:05 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1bf08ca187cso194316fac.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 14:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1691616244; x=1692221044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpUiLjfSF0ntg9zJ9c/nIKTYsoCsGk3Y03Sx8JEa3Wo=;
        b=SBPAuTkrM4/QFGj4tjjc+QMMT/Xu3BbudNY8pyMR6qhlDVqsLVcFjskL7jSRq2Hci7
         6LhUC+oxziAP/SdQKu5z/cq3+ft/xPh2li7FDGlFwn3C/v2EKPBdtjGf5MqbtSxRGM7k
         FhHNAeMBAl8T9yyWLkzD2xfdcaFD7dJBGIUyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691616244; x=1692221044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZpUiLjfSF0ntg9zJ9c/nIKTYsoCsGk3Y03Sx8JEa3Wo=;
        b=RTH2uZDK9SKm5NJ3iu8QZI9faX3kNCrcT0YHtoksiENfsweyLyqbZRvGtABHUqzoHo
         wWDt0nr2Zr0IU8Px6WUQhx5HiOgbXgh/oV0zpSncENQMj9tU/B21uSQ1v2q5EYNBlzNP
         7sNP0mhBm7Reni3Id749QBEDYi1WywTvocIr3cd5OTJ+HqFInqX3isw01udD6qtloPB0
         Q9BZTNQGCQ9i1bv/784LOne7hPpPsGJOKJXwG71J5xKw5rCdVOalPvY7llOk8MdglvlY
         /s6O1PyquFc23aDp7lbBrVG4Q6KzWBVlOUotZ20zOX4GTysJlAn4KQzudqFnJ2wajZwX
         ud9Q==
X-Gm-Message-State: AOJu0YyTHn1ZIoaTnKcCK4DCClX1RiF+GG1H/PyAn2FLBcKgFdHcvhWr
        ycwBIuuS2hGcb6YyAgC0XfF2Dg==
X-Google-Smtp-Source: AGHT+IE2dgo88ceePfEfmg5R+KM3syyyZFlGCJ8FWRKpA0R92ZW3miFGDVnwpa0G++Ej6fvOFDtgsA==
X-Received: by 2002:a05:6870:9627:b0:1be:f383:2c3d with SMTP id d39-20020a056870962700b001bef3832c3dmr591330oaq.14.1691616244637;
        Wed, 09 Aug 2023 14:24:04 -0700 (PDT)
Received: from sunraycer.home ([2601:246:5d81:5e3b::100])
        by smtp.gmail.com with ESMTPSA id w9-20020a0dd409000000b00586ba973bddsm3372473ywd.110.2023.08.09.14.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 14:24:04 -0700 (PDT)
Received: from puyallup.home (localhost [127.0.0.1])
        by sunraycer.home (Postfix) with ESMTPA id 75E025C49F3;
        Wed,  9 Aug 2023 16:24:03 -0500 (CDT)
From:   Steve Magnani <magnani@ieee.org>
To:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, "Steven J. Magnani" <magnani@ieee.org>
Subject: [PATCH] scsi: qla2xxx: Fix overrun of PLOGI ELS template
Date:   Wed,  9 Aug 2023 16:23:40 -0500
Message-Id: <20230809212340.25242-1-magnani@ieee.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Steven J. Magnani" <magnani@ieee.org>

The code to save off values retrieved from the card firmware copies one
dword too many.

This patch depends on reversion of b68710a8094:
https://lore.kernel.org/linux-scsi/20230807120958.3730-10-njavali@marvell.com/

Fixes: 44f5a37d1e3e ("scsi: qla2xxx: Fix buffer-buffer credit extraction error")
Signed-off-by: "Steven J. Magnani" <magnani@ieee.org>
---
--- a/drivers/scsi/qla2xxx/qla_init.c	2023-08-07 03:46:21.727114453 -0500
+++ b/drivers/scsi/qla2xxx/qla_init.c	2023-08-09 15:18:46.475286995 -0500
@@ -5549,7 +5549,7 @@ qla_get_login_template(scsi_qla_host_t *vha)
 	__be32 *q;
 
 	memset(ha->init_cb, 0, ha->init_cb_size);
-	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
+	sz = min_t(int, LOGIN_TEMPLATE_SIZE, ha->init_cb_size);
 	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
 					    ha->init_cb, sz);
 	if (rval != QLA_SUCCESS) {
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
                                  Earthling, return my space modulator!"
 #include <standard.disclaimer>
