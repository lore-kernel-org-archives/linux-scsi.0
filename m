Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD47C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiAXRau (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:30:50 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:59028 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbiAXRat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2022 12:30:49 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2022 12:30:49 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 4JjGyM4wVVz9vCBC
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2022 17:22:35 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r1WCbD_wAnNz for <linux-scsi@vger.kernel.org>;
        Mon, 24 Jan 2022 11:22:35 -0600 (CST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 4JjGyM2vXxz9vCBQ
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2022 11:22:35 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 4JjGyM2vXxz9vCBQ
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 4JjGyM2vXxz9vCBQ
Received: by mail-pj1-f72.google.com with SMTP id x4-20020a17090ab00400b001b58c484826so2617691pjq.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2022 09:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vF2fJlNmkwltSc0OR3AIOEuqnVr6sggA/rInxG0v7nA=;
        b=Yf8BnyP70J3zZ+qyndL20aJT2U8I9ToajN4PBdtxQasG/aAXHhRCIg0jRGBqS6fQY8
         RtQMY8TaJ791JxjlCUR5zTpYwO0MWe55lkNuhSq0L0JEm9zLtA5GlI1Ia/ascECJtlpa
         qojMzEpxA8KgJ19GjWWArLyNjVtsoBXaYsfT9fJw/Ukez7878s1JvJjGshReJ3df4S2/
         PNAsPZAMyj4R5T5Va3FhueenTt7XAfdMwQjdznznQ5hKoOFk/gy3qiAbvTbKtKLB8X1Y
         DLK73a5L+rj+jPDXgr8XQwqGRXbcAAfIpLHIJMEdl8Z7acX4QrVdPymIt5OeAWAYVFFE
         YDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vF2fJlNmkwltSc0OR3AIOEuqnVr6sggA/rInxG0v7nA=;
        b=zyho95Pa1WGU//vmR3qi9AeohUSfld0AhOysMzPtgVquMnVKcQoYK8gIETri5yrM6t
         O10IQInu9yEPPJ7T3Dl1cNBDVtFLDxBV7hpWY+H2zGInyCaqYKy1/7qGUel5LAC8RK0t
         oY1+ymsPEIiFCci2pY3QJKvCB6B+NJdY6udjM7AFX1LH9pDIvp6xUBkzmVL73EqModX9
         4XUJAmAtRWVFLnt+56I1yAMQgKkmjlItV3dc+lcs7iUtjM6Ae9NYNhEuNtngxYx/QB0/
         3Umdex1+s4pAGWlRjpQWkXuzbNl+1b19r0/V1v8q2rssFpTsHntr1zSh/dsKpwi8aIyQ
         rJRg==
X-Gm-Message-State: AOAM532c9A8nLpZ/64Xn95rkI2pk0QxvV/pqnhkI3i9tfztvWPQ39E/I
        9MEovCLIaaN94UcUy+9FH4yME59LkpLpyXsqJ2cGlcC9+4/54Wue3eQOapfnwHWckZqdW0q8GUg
        DA4DyjQwaDPPsw5r6qjoXCoLGvA==
X-Received: by 2002:a17:90b:3e89:: with SMTP id rj9mr2835558pjb.91.1643044954585;
        Mon, 24 Jan 2022 09:22:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwVYIlsxxKPhOwLx6Y538/G0Ur+T0jMdT68g/yxhxWRf5Og9AScrTI+fLaX8CMn7nQku5HzqA==
X-Received: by 2002:a17:90b:3e89:: with SMTP id rj9mr2835546pjb.91.1643044954385;
        Mon, 24 Jan 2022 09:22:34 -0800 (PST)
Received: from zqy787-GE5S.lan ([36.4.61.248])
        by smtp.gmail.com with ESMTPSA id me4sm20786965pjb.26.2022.01.24.09.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:22:34 -0800 (PST)
From:   Zhou Qingyang <zhou1615@umn.edu>
To:     zhou1615@umn.edu
Cc:     kjlu@umn.edu, Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: FIx a NULL pointer dereference bug in mpt3sas_transport_port_add()
Date:   Tue, 25 Jan 2022 01:21:20 +0800
Message-Id: <20220124172120.62828-1-zhou1615@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpt3sas_transport_port_add(), sas_end_device_alloc() is assigned to rphy
and there is a dereference of it. sas_end_device_alloc() could return NULL
on failure of allocation, which could introduce a NULL pointer dereference
bug.

The same as sas_expander_alloc().

Fix this bug by adding a NULL check of rphy.

This bug was found by a static analyzer.

Builds with 'make allyesconfig' show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: f92363d12359 ("mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
---
The analysis employs differential checking to identify inconsistent 
security operations (e.g., checks or kfrees) between two code paths 
and confirms that the inconsistent operations are not recovered in the
current function or the callers, so they constitute bugs. 

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 0681daee6c14..1caa929cf8bc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -823,6 +823,11 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			hba_port->sas_address =
 			    mpt3sas_port->remote_identify.sas_address;
 	}
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 
 	rphy->identify = mpt3sas_port->remote_identify;
 
-- 
2.25.1

