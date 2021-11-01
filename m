Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C6FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E402E60EFF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhKAXba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 19:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhKAXb2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 19:31:28 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0706CC061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 16:28:55 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h10-20020a63df4a000000b002a6ba425b58so5888828pgj.17
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=21+ejev/noq+kYk89380VQS6wIIOK6ew/iH0Z8kMFjc=;
        b=Rv9g20+Fow2hNqn8xJNdw6YbM1c7l1W1DnK2zDR3mwBXZiKdBkvtuE3oUlnxcJBTUb
         UQD/OYEpgg99YstmSRIeo1cqLkZFPM9x7xvgruTIcOit+rY4n1oEevQ9nu0Y7W9LGhFR
         N7/kQlKCZirB/hhNpLibF8/inr1K3iFwEWkoyxsBJ7VU3n02FLCF04bZ0vqE5js5WNMh
         9I4UpDBePYNkkX/PQBKVEuOIM/IWT3GCssdyz9JWi3GpIBTaHFZJmLY9390QjebDMPgf
         yqK2V3OQ4i8tbd0ScMfnzATh1/GVYFhk+nuwztvc0yF/fgDuKQLNuu9IfDNycSkEGhWV
         EA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=21+ejev/noq+kYk89380VQS6wIIOK6ew/iH0Z8kMFjc=;
        b=olIkY3lwNhu0x0UJ1RHf8XLRyTeSGfJDSXFGngF6KKtQzD6qvl9ZqX2PXSflUrMwK0
         5aGIHlDbEZe5oANyXyA18mZL+p9cUuolPzFppOAvb0bP+6waSSKrJsq5AvYIkYL0BY/l
         tETN08oZIK9yOpDF4p+fBqI5USqJdJg2QzTbeP49q6HPxyN+h+DDmWqCT2pXvYGs8TWF
         JdDws/IjGTJpeDvMJSYVg+THe8a3LUSPtZJk5jlQSVvsuxUdQXTKq8cJNmY+vtDjD3/1
         jy09Lh6Np1dk3XQE87vzEDPQzjeqR1Up3S1gI6uaywznMDL7Nr+3FXk6KNk5OmoXLsvK
         xhMA==
X-Gm-Message-State: AOAM5334fx/jtlZaFdAkCG1pbcqWtdojZ7NQq0LNYTt4rDb8mrOlSZea
        e44Ss+bqVfpLDgr5u68pqUneJoJpat5sOg==
X-Google-Smtp-Source: ABdhPJxmzkgUQFwJrP54t7h0Sff/yh62kQ0SPT46cqgt3IEG4SWyQSTSdOw2NYlTMRFzULQ9fUTjFixL6z0mRg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3684:4dd2:e6b6:ef66])
 (user=ipylypiv job=sendgmr) by 2002:a17:90b:1c05:: with SMTP id
 oc5mr2267896pjb.179.1635809334527; Mon, 01 Nov 2021 16:28:54 -0700 (PDT)
Date:   Mon,  1 Nov 2021 16:28:22 -0700
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com>
Message-Id: <20211101232825.2350233-2-ipylypiv@google.com>
Mime-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 1/4] scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Phy id is located in the least significant byte of the 4-byte field.
mpi_phy_stop_resp() already applies such mask.

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6ffe17b849ae..4f887925c9d2 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3481,7 +3481,7 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 status =
 		le32_to_cpu(pPayload->status);
 	u32 phy_id =
-		le32_to_cpu(pPayload->phyid);
+		le32_to_cpu(pPayload->phyid) & 0xFF;
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 
 	pm8001_dbg(pm8001_ha, INIT,
-- 
2.33.1.1089.g2158813163f-goog

