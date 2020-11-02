Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE571C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DCCE22258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJYWDgNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKBQvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbgKBQvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:51:02 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE44CC0617A6;
        Mon,  2 Nov 2020 08:51:01 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t6so7085311plq.11;
        Mon, 02 Nov 2020 08:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cErhV76ENt4TSg24Fp7Ht7DEbiQDvH5TWJw2QAVKIhM=;
        b=nJYWDgNOZZtlxDlK5ueJ/5vxhAzGVJPLWbe9fkSlizduzmFLoZH0zqf9t3kk2HuA8U
         lE6tc3WYq/hvTZ0O/dieS6Q0bsdb+ZwDKBi/WGF+MNjDOGgMOOwl9I9+wvij52X2KOd+
         A0IfARUHoB8llo6o4QJGAa3UBP3gx5Ug2qQLazIjl9u7OejBgmdVtGzum+CTl/qIPohd
         vzbAFqVqxo9zbrtVnZ6LWqiAOk0nN93L8q48Eg1TSmA+c6G2URYTrBZxj+k7FnkjHTkB
         VKsFmh+7Foh3Owu1wa0QQ9xbX8EmHldsQpndxjyfW4Ou2OWc3Uwh/ljhBDnfv/MiEC+i
         DGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cErhV76ENt4TSg24Fp7Ht7DEbiQDvH5TWJw2QAVKIhM=;
        b=kpTTUbi7UjMnXl83hH/dgbBTL5cDeQUZXrZ+V7yLht+EE10nNp1iEuzA5ol3DUGSxc
         jkxNodkHunZkw7qr36u5w5rfiqVJujY4V7xaMfFXuyysfwkrLh8FljPkDy7PCQu+tmD0
         hIpXzQ1Idz0YeqiUs3ixdg9/EuFDqAmrapzSLnk5vCPUubEdppNtn0x8pdI8qPxz1QtO
         nEcwbdc8geztmujcjpWr0tMuQJu2i3RsDk6669y2AejmtwMygNUSId65JtTowtipvdFA
         JPktSfc+kAG91ZbqVnwRuBYJjBuc9vEvmy4MNrIzsNiowuX3rHG9b52eHJOzsGodzL/C
         BubQ==
X-Gm-Message-State: AOAM531uW3KBBSpiFNCYZDBnbiK6QoQr//K3HgdITY/RTOT+djnT/Jz4
        wn+kRVL9L8ghj9PumeCVihA=
X-Google-Smtp-Source: ABdhPJwp05t7yRIHJ8huQ7eLUfoMgxcmBsNLB9C02JBi8y2dAFVcKApcplQEaIPahN07b26OqEY6+Q==
X-Received: by 2002:a17:902:bb81:b029:d5:b437:edb4 with SMTP id m1-20020a170902bb81b02900d5b437edb4mr21167595pls.6.1604335861454;
        Mon, 02 Nov 2020 08:51:01 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:51:00 -0800 (PST)
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
        Xiang Chen <chenxiang66@hisilicon.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 04/29] scsi: aacraid: Drop pci_enable_wake() from .resume
Date:   Mon,  2 Nov 2020 22:17:05 +0530
Message-Id: <20201102164730.324035-5-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver calls pci_enable_wake(...., false) in aac_resume(), and there is
no corresponding pci_enable_wake(...., true) in aac_suspend(). Either it
should do enable-wake the device in .suspend() or should not invoke
pci_enable_wake() at all.

Concluding that this is a bug and PCI core calls
pci_enable_wake(pci_dev, PCI_D0, false) during resume, drop it from
aac_resume().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/aacraid/linit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8f3772480582..8c4dcb5ab329 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1938,7 +1938,6 @@ static int aac_resume(struct pci_dev *pdev)
 	int r;
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
 	pci_restore_state(pdev);
 	r = pci_enable_device(pdev);
 
-- 
2.28.0

