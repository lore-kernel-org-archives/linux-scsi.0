Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF38C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 17:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244775AbhK3RWf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:22:35 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:52178 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244730AbhK3RW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 12:22:29 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4J3TTm57hFz9w3m6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 17:19:08 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZZRWQptf9thY for <linux-scsi@vger.kernel.org>;
        Tue, 30 Nov 2021 11:19:08 -0600 (CST)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 4J3TTm30Mbz9w3ld
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 11:19:08 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p8.oit.umn.edu 4J3TTm30Mbz9w3ld
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p8.oit.umn.edu 4J3TTm30Mbz9w3ld
Received: by mail-pf1-f199.google.com with SMTP id m16-20020a628c10000000b004a282d715b2so13218788pfd.11
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 09:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFhArOyxQn5pjZYL9yNu46kO2Q7Wi3qiSk6NbXAyyM0=;
        b=DwwDjFZrzioL04V/Lb87rUAcaUDlq48oyaCgzLIjUaihJji3fpz48cDEumpK4d+k0i
         U7mmUS1VSfOnoUf/FsfjvPgQHf1Wmn/uGFx/FrRPWsxdk9E4fjHmD6anao8BGSEqWLbK
         iVWlof7W6Lm2vgk9XgUZ9cF+ONIBCwrMo0Fg+texL/BdJbisUHwZZW2qxzgtxOlxZ4RZ
         3/8Hm0kBtE038J15Cyh5WWhkmt9qG8RAuFbHzIX0RTY+NU2IVETtHPeMaeA9NHzHUx8v
         fObufUEFzYEVR2EowOmTT4HqF1JzSAp6QaLd5wZGv5q4vZ8z2NDW5Lr89fCYga8mAsQa
         sWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFhArOyxQn5pjZYL9yNu46kO2Q7Wi3qiSk6NbXAyyM0=;
        b=D3S7TygmWJRyPEgSFoKAE72Nl2AR/z0fQJgScWelhfuiosHKjWQDTpta+O9lx1kQsk
         5CRCcRy+2HUozluPkZzfNeAJ82I4YRJhBasFf3pyoofCWL0oQ6nuSaMICfPAezbQV93k
         4/x0OyBg76Bov94xeO6uqx2Ls1DtIEG3GWL842jU5HG061F0dFlVI+nHVJPmQnf6WzdR
         1OPCj2Ndu9cjclypXO6wK73tdUAQj4P2hpG+OxQ+La7ojF+dEefxCyJaTWKOpFOhJb/d
         a9qxdzQFUIulEbtB5aLh62Ng4sTZQy7ulOKckTjBcJEQudncElRB+cNQSKglAmr/LEhA
         n25A==
X-Gm-Message-State: AOAM531ul5nQ3d2K5oQIqtVX9R4hEiu9h+Wd//RUCnUPpfAMuLjm1GIV
        PvAAKLPLFm39pL19TBHO0aEQTMl1aiu4Lgme2eywOMVlAdi+grbMx3Ai+kmRIPwBBhwrRA9xbUE
        p+/uH3LdTzgnj968u0YIaMU22gg==
X-Received: by 2002:a63:778c:: with SMTP id s134mr366182pgc.289.1638292747704;
        Tue, 30 Nov 2021 09:19:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg8qDxsG9c58L5rijf8FS/fNzjxeNzfkQ8Ajjp/dGFQ3NjtBZe/4EeXghkDZwhOI/PccSaOA==
X-Received: by 2002:a63:778c:: with SMTP id s134mr366160pgc.289.1638292747459;
        Tue, 30 Nov 2021 09:19:07 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.7.42.137])
        by smtp.gmail.com with ESMTPSA id me7sm3988741pjb.9.2021.11.30.09.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:19:07 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matt Lupfer <mlupfer@ddn.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: virtio_scsi: Fix a NULL pointer dereference in virtscsi_rescan_hotunplug()
Date:   Wed,  1 Dec 2021 01:19:01 +0800
Message-Id: <20211130171901.202229-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In virtscsi_rescan_hotunplug(), kmalloc() is directly used in memset(),
which could lead to a NULL pointer dereference on failure of
kmalloc().

Fix this bug by adding a check of inq_result.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_SCSI_VIRTIO=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 5ff843721467 ("scsi: virtio_scsi: unplug LUNs when events missed")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
 drivers/scsi/virtio_scsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 28e1d98ae102..5309f2a3a4cb 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -337,7 +337,11 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int result, inquiry_len, inq_result_len = 256;
 	char *inq_result = kmalloc(inq_result_len, GFP_KERNEL);
-
+	if (!inq_result) {
+		pr_err("%s:no enough memory for inq_result\n",
+			__func__);
+		return;
+	}
 	shost_for_each_device(sdev, shost) {
 		inquiry_len = sdev->inquiry_len ? sdev->inquiry_len : 36;
 
-- 
2.25.1

