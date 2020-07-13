Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A748C433F1
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E0220720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E9Nk6MmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgGMHrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgGMHrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:10 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ADDC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so12318430wmj.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqbTOjU/FsSc/cHhe4oGvv9xN2ZDzn7IWu0NGLngM90=;
        b=E9Nk6MmLMhgrZz8qU9tuzg3glTjGkXnr/niB1TyY/fTrlnVs71sCgumacmSdGvGHkm
         ZA777PveMNU+wJKYfcxon91UkP+MxOFi15Tmgk8LvwGpo88LSBr9Zm/uwWWAAkAkc9K4
         1o8NeNKYjt+dRhvC2ui+sXHgTgE9LRDoGvNZB8IG4S+7BCNocIhR0xJLeni+TDiAgpj+
         I7rxuvHk3DcJSxLSDFT8lJ8qo0EVLaHRBFWkWAhDYtQmFp8euody7NnsN1D9liTfun4R
         QLdZxrsCDvyqeZhnRSuRNDiz1W+zDuZPnJYgBQDOkQuW9aILooI9eB9N9fpCxaSduIYv
         TUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqbTOjU/FsSc/cHhe4oGvv9xN2ZDzn7IWu0NGLngM90=;
        b=RxGEFIG5I1mE6EyEMW+Gs/seuUqpDcEb6795G2iHoZTXGJixcwEqcjS2DwXwLe1ZRj
         5OxIEugtpLFiCub5b3eM18sVidN/A3GG8ImVLMNXjlMJVavSZ6lBXUUXebzoPdaSwCAs
         RGmNW0oaiQeHQkL2NarUgeDMb/vDYFTbIlbzfmwt7mwuC3dIA3gXbKInflDLbxrffVPc
         uLqtPYAcueed4dI+2Rl1Hf8DxB53Sf09Mc/wq5vbvEszrGxRrw2Dfvl3HQFAclHL3R/a
         dIHq7GKk1+a+9pXmC5IxuNFW2n7yUg+UGUB35VdFGyVytzDB6mOMPuFiEydz8W4dX8C4
         +L8g==
X-Gm-Message-State: AOAM531f6l+rYLQokkVOTs4C4DjnqEXDMgBgFaXiRPHEvFMKXRKRgBda
        aaF0+s3oh6pdZZqmqJtfjWaihA==
X-Google-Smtp-Source: ABdhPJxiPjcTfkHVPcB5q845qkR0jjP5cBYwnnCidt2bZ8Thh385k/O+TNBtXG84YL2RHTiQBo7PSg==
X-Received: by 2002:a1c:5646:: with SMTP id k67mr18275780wmb.61.1594626429223;
        Mon, 13 Jul 2020 00:47:09 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH v2 20/29] scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'targ'
Date:   Mon, 13 Jul 2020 08:46:36 +0100
Message-Id: <20200713074645.126138-21-lee.jones@linaro.org>
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

