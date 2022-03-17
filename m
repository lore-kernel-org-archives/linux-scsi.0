Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E19C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 19:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiCQTta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 15:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiCQTt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 15:49:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70FBD3AE9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 12:48:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w4so7838355edc.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Itx9jQLKaxd3fokzdL8xpKFUPqIpkQCLT3Pe7HtyzII=;
        b=cNcpOyP8ZBeAiNj5TQzPy0x4J78qIOxKsVdcCKH3BqKXwzwv1WvxVlMCurf3JHE+IC
         VUT7mJsQjF/3XRswZKUGXnzsmoCjHoe7VCkjDY5gleTCXiYnB7oDPe8zHBbcp8gNEO36
         D60Q2b284WS5gX9cxpmhBS+HuRocVxRFeiBDaY9J4vNAMViw1CFszATxKbsyPdVP/ZoB
         OItEkC6/urD6cLNYbptvZfywfZJ2btJdc+Wc2tXZE8un2U9B6UbQO0XNgSFVoApcjWW5
         JtlL6OKadu8AVUyVaC2M0QyDItvnIkpLNVoPclgaL0wDlcWWgaQpIYWVMATEbxzLXom0
         BAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Itx9jQLKaxd3fokzdL8xpKFUPqIpkQCLT3Pe7HtyzII=;
        b=jQWyKhsQvGDpXJ/V3cwHOJ/C3rAUtIqwd6RTb+BrSgyW1q095Okw3oH/f77DiAPXYQ
         5+3wrFrQjN7ExA5GjAEOJGOJGfoaDDcdhFQmw26jPcDLdfx1/poDJcMK91cnxuWIpxjK
         OmF1m14DONswj+GvQ+aJo2q6ZFlpPD3qLORWCj4x4JBlUYQ33ccEajNMoQAy7Xu77xfO
         6umCYlVDK/fDocCzdyjIecS3KVVmsYtbCIUHhYQdUSZV3yV/DITcOWZnmfpPq4Npf32Z
         29C0E9cOIiw3oDkGhd8Pq6pWQ8yYCRF6vWT4puMEFtsAe/eAc2SohvdS33WCtpJDpwLZ
         myxg==
X-Gm-Message-State: AOAM530jchQV02qVD6rXnpkLeHs0HYsuGOrlpmLdDBYafgtiuWNgQOAt
        zmSwdgce0LD7N/Nkvuw+Jra12pLIdiA=
X-Google-Smtp-Source: ABdhPJwx6yjV4ryX8AvNcHg6Cwhftncfgkfq1dj8sP56hiWzq5xtKbaJuY8gSJP6m96iQGg++wAGDw==
X-Received: by 2002:a05:6402:845:b0:419:7b6:2e9b with SMTP id b5-20020a056402084500b0041907b62e9bmr1009084edz.283.1647546489247;
        Thu, 17 Mar 2022 12:48:09 -0700 (PDT)
Received: from nlaptop.localdomain (178-117-134-240.access.telenet.be. [178.117.134.240])
        by smtp.gmail.com with ESMTPSA id b14-20020a1709063f8e00b006ae0a666c02sm2824882ejj.96.2022.03.17.12.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 12:48:08 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] scsi: libfc: extend locking of ex_lock to seq.ssb_stat
Date:   Thu, 17 Mar 2022 20:47:00 +0100
Message-Id: <20220317194659.69970-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All other places where seq.ssb_stat is accessed happens when under the
lock ex_lock. Moreover, the struct definition has some documentation in
the comments telling that ex_lock protects seq.ssb_stat. Extend the
locking in fc_exch_recv_seq_resp to include that field access.

Disclaimer: I am currently working on a static analyser to detect
missing locks. This was a reported case. I manually verified the report
by looking at the code, so that I do not send wrong information or
patches. After concluding that this seems to be a true positive, I
created this patch. However, as I do not in fact have this particular
hardware, I was unable to test it.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 drivers/scsi/libfc/fc_exch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 841000445b9a..be5920526840 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1600,6 +1600,8 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	}
 	sof = fr_sof(fp);
 	sp = &ep->seq;
+
+	spin_lock_bh(&ep->ex_lock);
 	if (fc_sof_is_init(sof)) {
 		sp->ssb_stat |= SSB_ST_RESP;
 		sp->id = fh->fh_seq_id;
@@ -1608,7 +1610,6 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	f_ctl = ntoh24(fh->fh_f_ctl);
 	fr_seq(fp) = sp;
 
-	spin_lock_bh(&ep->ex_lock);
 	if (f_ctl & FC_FC_SEQ_INIT)
 		ep->esb_stat |= ESB_ST_SEQ_INIT;
 	spin_unlock_bh(&ep->ex_lock);
-- 
2.35.1

