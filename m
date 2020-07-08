Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E15C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1169C20739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G220Ai4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgGHMCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgGHMCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:54 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB421C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:53 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z13so48673469wrw.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gv6x0VpkNH1KBubo4tbm9ETrzBqqoMdr5YdMKsMLhQk=;
        b=G220Ai4wYV+H9LPdaGJhcn08dRDAI9AZc/Sag2LiLOJpLSclfGTa1nEe8XtWtJQKQv
         Uzl3wfDFpi1fa9rWO/jY2L/m80DRo3XcKjxexcx/3WPL/NuvUbyiMWNIFBffi9ghjKTq
         JdOqkEjXw7xEJ3VkVQJGR1fwzHuXGIMfRDm8Bp/LG6Z55flahyb50r/hi/tT1Kh5Qr8F
         k6Z+Tnjc6b03u4VyL3sHc7jaaWOOM83IIPLihSYksQvwhhrYidTyn2eDM1xfyiATcsCz
         w8i2IMbw+BkePHEPgumwuveLujmIrM6NIQF4F2jOhVJbwGMaVuVwh4Wfq+tPeyEhNjRi
         Us4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gv6x0VpkNH1KBubo4tbm9ETrzBqqoMdr5YdMKsMLhQk=;
        b=le8JjniZoto/rN0G/QiU+4wxpegRKy8w7yVoXaNEaIFbgqKM6vuNvpJPgNi88a53Gr
         2FDmc21J22ovro7iRj9c+5rx5q/ght0ELs8pDS5PmeUphgSZ0vGwsdT4xhCpgSxFmCgQ
         ZvvecFGKMb9PiLoupslA96I2M5BOeaLrBsMU2r9fWT0dCyTAHRAuDgodPyVaRYW2/noQ
         UkHj5xhCylBIFccCqhO0SQXB/YwM0mwjgxUsgY9pTJaiWb1IHLbtCq04T/BhdV7jAWf9
         L+2FY+o32OqBjCkt+oW/wXx+/pU4vPkNE+qFrQggaL1oY8FvQwiv2CowmTNVSDxSaO1n
         Zvpg==
X-Gm-Message-State: AOAM53247/dAvp1w07Jg80Mt7qcDNhbsUMI/NOr9IOw/oMKRn+cVH9VD
        dgFVKWmVl33iKoxpbVJgabp/qA==
X-Google-Smtp-Source: ABdhPJxBZ5+wTaIVpUTRzBASxtW3kmeSXLXBjvGGO/osSrQr7g/mocW02GIZju2wbYKAuDeAP8ePCA==
X-Received: by 2002:adf:f711:: with SMTP id r17mr59508450wrp.409.1594209772642;
        Wed, 08 Jul 2020 05:02:52 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 19/30] scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'tinfo'
Date:   Wed,  8 Jul 2020 13:02:10 +0100
Message-Id: <20200708120221.3386672-20-lee.jones@linaro.org>
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

