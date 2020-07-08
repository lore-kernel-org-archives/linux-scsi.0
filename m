Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F8EC433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC94E2065C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q6uRu82j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgGHMDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgGHMC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:59 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405CCC08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so37394720wrl.8
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KFOnaZnxegDwLsJeWEMPqv4RGP3pzEUK9a4hgTT6mu8=;
        b=Q6uRu82jwSDeZ78JavUIgd2woRyBNcxJuhMq+FRLmC3XTYtoWv+51cU6IeO/mNUdBu
         oKgCZ+rrLCMxezQIxG4UkdQhPcRLfn549EONuRgoAqwxU2Lr2a3vvV3TwUJHWUimlYtQ
         Fo5TCNuXA+/fUYM1MYkQP7cbji9F6ZST/COLXUwJVI9oju8J31nfBlVBJVPFZlYaNSMw
         A0LRs9ID71Nuel55W0lc00rmDTKP7lQ7ohQVnrAOTlegM+uNCUKGrO+mWYXiSxuSWKCf
         5WeM7YG4vhzx7sfpYTrjL9cO9SNUxp5e4Yxzm44x6dYu5+HdWRTL0NztnI9axDpXk4HM
         ibvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KFOnaZnxegDwLsJeWEMPqv4RGP3pzEUK9a4hgTT6mu8=;
        b=grDOxt5eLrx+dIfCMqNa/YmTPd5fX6bCUUN9Fv8ty5CPhD4aKlA0ogT4wax4vTTAwq
         25YEvz/VhNkipDmJh9sWGhw55hA0U4ev41I5ONy2pFBBH0sws14iyeKkPz1ACUwDKxyw
         hLStt08Z1oEVyqUMhHm+KTIz7JB/UD9IdJ7xB4PcujI5KwHW9YKJpXB+Aj6bjjcpbESP
         P+aAz0gkecvRjgMS3i7LY0epq6jGFUWsAlg2JbARHs1a1+jxiOqJjZQ+BYPL9zHC2jjl
         dxyiOF6UfOyYXDOi+e+UErUqxlbA7oJYiX8iFPMMgPTjNxpeWXV9cIZ+owoSClLTUhss
         XtdA==
X-Gm-Message-State: AOAM533g9H6ER1erKBRyBh3+vR20gnmO+DTzO2li8egwLWfs6mKPtVaW
        cLuPDw9ryrcxUkQ0T418c4lU1w==
X-Google-Smtp-Source: ABdhPJw1vOTmcjZYF+x8I6snBJawVy908WIGOwoyXCv+bit3rfF8pDZRl4HJ6NWGVrs1Yb9JL2hEoQ==
X-Received: by 2002:a05:6000:111:: with SMTP id o17mr61713548wrx.178.1594209776960;
        Wed, 08 Jul 2020 05:02:56 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 22/30] scsi: aic7xxx: aic7xxx_osm: Fix 'amount_xferred' set but not used issue
Date:   Wed,  8 Jul 2020 13:02:13 +0100
Message-Id: <20200708120221.3386672-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'amount_xferred' is used, but only in certain circumstances.  Place
the same stipulations on the defining/allocating of 'amount_xferred'
as is placed when using it.

We've been careful not to change any of the ordering semantics here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_done’:
 drivers/scsi/aic7xxx/aic7xxx_osm.c:1725:12: warning: variable ‘amount_xferred’ set but not used [-Wunused-but-set-variable]
 1725 | uint32_t amount_xferred;
 | ^~~~~~~~~~~~~~

Cc: Hannes Reinecke <hare@suse.com>
Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index ed437c16de881..e7ccb8b80fc19 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1711,10 +1711,12 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 	 */
 	cmd->sense_buffer[0] = 0;
 	if (ahc_get_transaction_status(scb) == CAM_REQ_INPROG) {
+#ifdef AHC_REPORT_UNDERFLOWS
 		uint32_t amount_xferred;
 
 		amount_xferred =
 		    ahc_get_transfer_length(scb) - ahc_get_residual(scb);
+#endif
 		if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
 #ifdef AHC_DEBUG
 			if ((ahc_debug & AHC_SHOW_MISC) != 0) {
-- 
2.25.1

