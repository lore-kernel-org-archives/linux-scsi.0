Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704D9C433F4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D1562072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h3We5EGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgGMHsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgGMHrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72002C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so14622284wrp.7
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gv6x0VpkNH1KBubo4tbm9ETrzBqqoMdr5YdMKsMLhQk=;
        b=h3We5EGHY+d73i7DGq8hIsezjttX0RldsdM2Yb4yPAS1BlvU/qFrpOkgTss/FWe7Dv
         6voHcFczh90xSmIleS/eYO89Qg7sqQckZf0piP9gSqthJGj98l171XUTuGnhqBSgqYe/
         N0iIhOrIkGDgxsZ5WgdCPONgiy1JoTVuFbge9QHmmiQsZmdnIDImXhCVAQChL8amLvYl
         PjnFBKVTWWPb1mMYh7td9UhT3Pp2CWWmbob+cMNtvMysWZsFw9jyxx07ycfj8ah31Vfv
         2biKDBl+wvt/VDSse3BwCum18kWXqe8YNxXwfnkPHOipZYnidqr8RVSvfDh777Swxlr6
         RxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gv6x0VpkNH1KBubo4tbm9ETrzBqqoMdr5YdMKsMLhQk=;
        b=S60Miu7gEqF5IdpAepaQ7nh43O3s7xCXw71J6RGl0uQ9tYTRNrkcPm3VJo3mwH9ALN
         Fy0n4AQp83zT+mrxIKNUCV9fb2OsFGv+OSY5iP3jhwxR/CY8bkZLdUPZu5pl74DJmW0e
         25Us7X3ZUHw0z1qIX3djcuuTaN2Z1m9otbn0yJmahl1Fu6YgBIEY9qDtCJjwz493Wt+4
         dbuLbqiw4oHZMEZ3GmDC7jeLZN9K1B+gAFNJODTlaxbakNfO462XjAq/P0rB6bKSi1eQ
         46akCoPYpj19HjoIgoqHn+acs8wytzvASY/S3gIG8O05ZiJnvgpBwOeStFE8Z8f3wyxa
         ynmA==
X-Gm-Message-State: AOAM530GTQiPCywrVex6MWzT33mPZijI40ZlCd6OAncnWAc47m6WPawa
        u6V27hgW2EF7Lqkj27mVqlraZw==
X-Google-Smtp-Source: ABdhPJwuQZGC6O7FHTpaqPf6Xxya9WoxijPmSij2dtUtqbf9Nwq9tugkzVqsD3tXy1EuD9J+sp3WrQ==
X-Received: by 2002:a5d:664e:: with SMTP id f14mr78871515wrw.6.1594626427249;
        Mon, 13 Jul 2020 00:47:07 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH v2 18/29] scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'tinfo'
Date:   Mon, 13 Jul 2020 08:46:34 +0100
Message-Id: <20200713074645.126138-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks like none of the artifact from  ahc_fetch_transinfo() are used anymore.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_linux_target_alloc’:
 drivers/scsi/aic7xxx/aic7xxx_osm.c:567:30: warning: variable ‘tinfo’ set but not used [-Wunused-but-set-variable]
 567 | struct ahc_initiator_tinfo *tinfo;
 | ^~~~~

Cc: Hannes Reinecke <hare@suse.com>
Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2edfa0594f183..32bfe20d79cc1 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -564,8 +564,6 @@ ahc_linux_target_alloc(struct scsi_target *starget)
 	struct scsi_target **ahc_targp = ahc_linux_target_in_softc(starget);
 	unsigned short scsirate;
 	struct ahc_devinfo devinfo;
-	struct ahc_initiator_tinfo *tinfo;
-	struct ahc_tmode_tstate *tstate;
 	char channel = starget->channel + 'A';
 	unsigned int our_id = ahc->our_id;
 	unsigned int target_offset;
@@ -612,9 +610,6 @@ ahc_linux_target_alloc(struct scsi_target *starget)
 			spi_max_offset(starget) = 0;
 		spi_min_period(starget) = 
 			ahc_find_period(ahc, scsirate, maxsync);
-
-		tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
-					    starget->id, &tstate);
 	}
 	ahc_compile_devinfo(&devinfo, our_id, starget->id,
 			    CAM_LUN_WILDCARD, channel,
-- 
2.25.1

