Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CDAC4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD75721707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vfQtCC3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732195AbgJAM2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732048AbgJAM2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:28:14 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E9DC0613D0;
        Thu,  1 Oct 2020 05:28:14 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p21so1588532pju.0;
        Thu, 01 Oct 2020 05:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjwnmscz0yil9BJar/ERhlr5lRA/SIC3GZV8Duqsy+A=;
        b=vfQtCC3mxJnOwF7Ww2VeP/fhKLsh2irLqd/ZQ8ITsCJgrYxOgLin0hbbo8cZSq0TT8
         jzRUJjpfOM4ZrpyF4/liO267vI/XYDmKmlASwzlEOCG6Y+GBLpjxZaeXY0yBeMTdVLoK
         Q1MK7hjslVZZOCoOUiqIGkqzGaPM0CVxwLhJpkciwYC8uL5k8IvNfEhNFw+/740xrJLR
         PIoD9CN1ZP8LaqnR2eVLIPTlDgqV1422WtNZ6DFpJWAIa0rwluNMfFfpkZ2rvzpzffp/
         uL/JYr8aVeQM/I4doQid5rdOnASibwhknhfOI/AJL+5bupHavdROcP0eV1K6ZSTijO1N
         UKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjwnmscz0yil9BJar/ERhlr5lRA/SIC3GZV8Duqsy+A=;
        b=DRS4K/dhbYrrqfo1yo9I4NOsASqUyWH4PjtRzAejz+PQ6zjK+TOlEIPvnrbS8nbVPK
         uytUIQuC8z+WsWpYzX4/Ki5yPhCLpHayrHKvjOjxoxJPGM7YaviX00GvwARytRoPRAg9
         K5akgTGnLbY1IZusTQzhZBceBZNNcnUGZqWuq944m9M1YJRviAouzU7gN2/XQKZc52yf
         LTUuZFtFzqp5xEX7xtaK5szpbcVRt5hXtwOAGxw1W0irqxfIutmgNrzES/MuFoWe3wrl
         dHI8RuvVN56ZB32Ek7qONaNDOyIEzFnaYTTQIxs1WVMwf/m9Wbe685WuE7Rv3GaNTvMB
         VRbw==
X-Gm-Message-State: AOAM530b4p1+f27k8R7tVIAZJL4t9H1+p76PYTZT7LYsRgTU0R3NC7hQ
        xDlgaYOG6MdcQ/CRMsTD28c=
X-Google-Smtp-Source: ABdhPJytG0TtooA/ti7rplUndguiIZY51ru5WUO6GpxeViniX6/MzTPHWmXOYNKYwrUMrQtll7f/cg==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr6898644pjb.148.1601555293584;
        Thu, 01 Oct 2020 05:28:13 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:28:13 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 03/28] scsi: megaraid_sas: update function description
Date:   Thu,  1 Oct 2020 17:54:46 +0530
Message-Id: <20201001122511.1075420-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no "device" parameter in megasas_shutdown(). Instead there is
"pdev" which is not described.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 72aa7fabe051..63ff8b87fd18 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7904,7 +7904,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 /**
  * megasas_shutdown -	Shutdown entry point
- * @device:		Generic device structure
+ * @pdev:		PCI device structure
  */
 static void megasas_shutdown(struct pci_dev *pdev)
 {
-- 
2.28.0

