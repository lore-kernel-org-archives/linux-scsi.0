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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDDEC4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B479021481
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjmVpbBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbgJAM34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAM34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:29:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDEC0613D0;
        Thu,  1 Oct 2020 05:29:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l18so1896619pjz.1;
        Thu, 01 Oct 2020 05:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RBZwp5x8UpGlk91TPxM4Ak8snRIr/reeIn72JiuDlp8=;
        b=gjmVpbBdrYV7W4vnPwxhllWyqLusqcAZ95Zx+Zd2FmqGRG0dCvxKZgF2FMcGXMJSH7
         vJoYsygMlkhCkudEegEdKdzXOEsUAPlfx0TqtBJCvCbcmLxzZ7cN63eHbzHmxd22janf
         mDL50Y9AgI7urwsCvgjfaeyddJ/12zOPntDQj3eSgwmFYm4XVrXQUujluccrOtX6fPOK
         BxTXuM4up0uq2P0keKubWPHsHHWvH0Jw3tfOeYtwa7QC2Go619cdQnRIfMDJjmSy+IOG
         G2xuxyDnWt3cXVJVOrRA1NkRlvF4s1rs4skM9h9i5LWySTvIcwn4AH95EhxX+WKQZnph
         Zs7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBZwp5x8UpGlk91TPxM4Ak8snRIr/reeIn72JiuDlp8=;
        b=NBiOnTmCsMAbj4FDT41vgIulrfHPA/SvJ1I299Qr9AsyZbxFZ4y1Tk6XzWnNK3LFNT
         Nd029oPut7LswqsSfsaIgrZ/xJFE9VoBpYYabsoqo6AF7DaVVWjA514EHOliKi1V4zPW
         YOJNC2jXr061QB0J5Me2NDedOi9mPbq+l5zd6msM7l7eIVT+Rlt+6O9H1doLTL2442XK
         g62xu5hgEQHJR2MsYTbAKXj9DDwpJUkO7uWsIynjHcOJGh1MWXzXA4M+713lU2+jIQwi
         b/+Eqi/r/0Eh8SJv1oUbDIJKIyyw8EVOEvHz+ZGOEmUXon02e1iBM8+xORf53jATCoBq
         tStA==
X-Gm-Message-State: AOAM5335wJjIVjiXkiQExKfE2X/umMtpsHBSBkjuDBcMDJbaWv2b8HiV
        b46qVKbX+RBCDbsAsZHlJmM=
X-Google-Smtp-Source: ABdhPJzlzAVFo+0pMkVbQhAIpkRbYBfJ7ypPdOHOuQMuDNfriSdjUytOJ3wyeXymJmbNtz8f8xsmww==
X-Received: by 2002:a17:90b:950:: with SMTP id dw16mr5141541pjb.200.1601555395535;
        Thu, 01 Oct 2020 05:29:55 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:29:55 -0700 (PDT)
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
Subject: [PATCH v3 12/28] scsi: hisi_sas_v3_hw: Drop PCI Wakeup calls from .resume
Date:   Thu,  1 Oct 2020 17:54:55 +0530
Message-Id: <20201001122511.1075420-13-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in hisi_sas_v3_resume(), and
there is no corresponding pci_enable_wake(...., true) in
hisi_sas_v3_suspend(). Either it should do enable-wake the device in
.suspend() or should not invoke pci_enable_wake() at all.

Concluding that this driver doesn't support enable-wake and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
hisi_sas_v3_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 55e2321a65bc..8f0f4084a054 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3431,7 +3431,6 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
 	dev_warn(dev, "resuming from operating state [D%d]\n",
 		 device_state);
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	rc = pci_enable_device(pdev);
 	if (rc) {
-- 
2.28.0

