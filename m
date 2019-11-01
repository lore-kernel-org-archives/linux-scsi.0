Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB70CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 12:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 423002067D
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 12:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6DPO1+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfKAMfN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 08:35:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38837 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfKAMfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 08:35:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id c13so6984491pfp.5;
        Fri, 01 Nov 2019 05:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=JrQpRLrI0AXjDn7h5/imwTuVbTmOR/egWWcExOPFss8=;
        b=c6DPO1+dJWaR5QwK5nITdiQa2VSCzKU0UJyzM52uZfJImnUT8znF/v1Z7fehu7ljzX
         O6Ip6olUXWGHvKGJubiCywGulBq2cwaG1/GdUjlFMUYp1dVqrvI+47su7liqpbLo9Y/c
         kVhIIexHaGvj7SIEEho4OEFnFBe59YCzC7m7g9SPFUwDTYM+ngM1dkB5goMnyD3/jDue
         GWGh9bmQtv0XtdEScK9NTd6Ja5sXhF5Pz/s2NIfnr9la7/UAPlWpEXhotxVblLNrT9Sh
         8xMGgDKVtRPU096775ABViaSa9SQOhh1AmN+ZbPpKFSkHW4ey8cSiaJscwcuMPFfn+8o
         LU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=JrQpRLrI0AXjDn7h5/imwTuVbTmOR/egWWcExOPFss8=;
        b=TNSPv/h2NAeOirwv6Y/441UsadGIGRp0ZcCBawzxoe7MjM/cGfaVTBhANglxMZxw7X
         z1ztZ43QkELTsmPDpHOmBDCMsmCO4RiNehViBwh3Uz8s2n0rPhqTVhuN4flez5c57dyj
         1pk9hBPAwS+6ykuUvqbAKjiC4+GMix2jSFC3q2TUc7VXyAakr25WJhHXlEtbEV2zwQBZ
         3KJdRVQyDTLnYkdtD0CUpTFrmzuCiteMgqorcbb3vmARxD1E/AXjvpACU56RWPZ37zm8
         sJQFsZ4BOMfYrypg0bUHYBeVTbenvziz5GvfY7XV2eizPsUR6mjuiT821C65BP9TqPfu
         k+MQ==
X-Gm-Message-State: APjAAAWOQexuLPBlG8H/pC5PiDVzbvEpsMZVXWx6IKt6Zy3wARfDHKB6
        0K+J9DHXlm7EKpFSHKBDZBM=
X-Google-Smtp-Source: APXvYqwchZ6piwRCYF/jZ4yGwFTa6igUGC6aCHKEwPMGqPkQaHu6ZhJXRtktRNJlTRM0R8WwMaIlgA==
X-Received: by 2002:a63:7247:: with SMTP id c7mr13095692pgn.311.1572611711190;
        Fri, 01 Nov 2019 05:35:11 -0700 (PDT)
Received: from saurav ([117.232.233.44])
        by smtp.gmail.com with ESMTPSA id q23sm7703887pjd.2.2019.11.01.05.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:35:10 -0700 (PDT)
Date:   Fri, 1 Nov 2019 18:05:03 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     mikecyr@linux.ibm.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] scsi: ibmvscsi_tgt: Remove unneeded variable rc
Message-ID: <20191101120407.GA9369@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable rc is not modified in ibmvscsis_srp_i_logout function.
So remove unneeded variable rc.

Issue found using coccicheck tool.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 7f9535392a93..09a4dbd0a9e5 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2353,7 +2353,6 @@ static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
 {
 	struct iu_entry *iue = cmd->iue;
 	struct srp_i_logout *log_out = &vio_iu(iue)->srp.i_logout;
-	long rc = ADAPT_SUCCESS;
 
 	if ((vscsi->debit > 0) || !list_empty(&vscsi->schedule_q) ||
 	    !list_empty(&vscsi->waiting_rsp)) {
@@ -2369,7 +2368,7 @@ static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
 		ibmvscsis_post_disconnect(vscsi, WAIT_IDLE, 0);
 	}
 
-	return rc;
+	return ADAPT_SUCCESS;
 }
 
 /* Called with intr lock held */
-- 
2.20.1

