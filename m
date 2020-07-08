Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1C2C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851262065C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zoWewV9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgGHMC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbgGHMC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54DDC08E81E
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so45654319wrw.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqbTOjU/FsSc/cHhe4oGvv9xN2ZDzn7IWu0NGLngM90=;
        b=zoWewV9d1ulJ/bH/jICQjHixsau47YCzAklx8ceOU84BPftiPxpMZF0f24A3uJifAy
         WR6EoM/eQTRGCgdtSKVlKcIRuPnEzVw0mCdXnbLrzEZM7aGAuFdowHp17GGw08nGupWS
         t+lpRdoDrh2caOBuiY3mb6YnMTarGIipSjHtUFInU29vKG58Cw/RLCWaZztfylzbEDOV
         wM37/e7+vMtJflYnxCy3AySMUfiPOXz5k8hYR0N4OBk4i1KQbXPv8K11gvvMY1D7mYhv
         lqHE5EJVJzm+zpA6G+2F0xspXaakloejilN2rTdeJ8DuwPcOUFqzbfLKfzMTVPdte2SB
         rTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqbTOjU/FsSc/cHhe4oGvv9xN2ZDzn7IWu0NGLngM90=;
        b=hpk7Du/oGM/6BqDYSEcom4/5BHaLkkh/PbgHuXq9F9R6wcskM2TC02pn7Gqalhn8J/
         keKHRi1Fe50lMtW4KbvuXpsrndv2LFO7jbBmft+kVuM0ieNeay5JcP7fMP+9AXGXeXRs
         N5wFPJUMvgPFJXvcI91cnJJhei2pPTxhTGOQZ7RK6zg4M5AtRRGOWGbPMaC7crHZu1Tl
         56abpxg2glBltvlEjtNDOsY5jssSN8pmNwg1KgdkuOHK3BohX4ou4NzKXyPHUYm0Yi0K
         2/DHH8bwjGhtXbnRpo56aArTXTmtqIZldLOXjYWUCnujweo2zl35u72YUdU3YQS8XoHJ
         hm9w==
X-Gm-Message-State: AOAM533h4W+DMDAdOyhQyMC7hNJpnye8791stIbAh20FXKQIOi3uO81x
        RXQbnh+rpCf9ZwkniCsYzLuHzA==
X-Google-Smtp-Source: ABdhPJxkrFhbMOxpEFlvwlI61CdCcGTb2RM1bzUiLziBTpCekYswKA7OwjDozO25mAUrHiZmJNolVA==
X-Received: by 2002:a5d:5651:: with SMTP id j17mr55771132wrw.145.1594209775563;
        Wed, 08 Jul 2020 05:02:55 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 21/30] scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'targ'
Date:   Wed,  8 Jul 2020 13:02:12 +0100
Message-Id: <20200708120221.3386672-22-lee.jones@linaro.org>
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

Looks like checking the 'targ' was removed in 2005.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_send_async’:
 drivers/scsi/aic7xxx/aic7xxx_osm.c:1604:28: warning: variable ‘targ’ set but not used [-Wunused-but-set-variable]
 1604 | struct ahc_linux_target *targ;
 | ^~~~

Cc: Hannes Reinecke <hare@suse.com>
Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index cc4c7b1781466..ed437c16de881 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1592,7 +1592,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 	case AC_TRANSFER_NEG:
 	{
 		struct	scsi_target *starget;
-		struct	ahc_linux_target *targ;
 		struct	ahc_initiator_tinfo *tinfo;
 		struct	ahc_tmode_tstate *tstate;
 		int	target_offset;
@@ -1626,7 +1625,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 		starget = ahc->platform_data->starget[target_offset];
 		if (starget == NULL)
 			break;
-		targ = scsi_transport_target_data(starget);
 
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
-- 
2.25.1

