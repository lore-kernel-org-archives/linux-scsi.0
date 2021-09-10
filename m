Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47824C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 22:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3000A611AD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 22:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhIJXAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbhIJXAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:00:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748BC061574
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 15:59:42 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m9so4762565wrb.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 15:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EUf54GbfrBTdWkr8FM55zeEhqbAwY7cxrNBrNZA6Z8M=;
        b=ZCaGP52FHRKJc8eeFXaYxYPjmLmuBdCkOWccDH/ew2qlubOweDt+BEG8vXp+bef/1Z
         6k+PWB4uklszfXMkVXcBOmQMmSVINe3f492zhatXI/Znn2sA/OyzzG1fOrP9+/+bbXgj
         fgwIOU5KsYQAOxGrupewYvFuXMonEmGPJzB8ssoYVqzWDDGbukwsz1Yn31KBUrLafuCO
         nDg57gqLhN/AjaVv8l8H1ZyPPNx1PPrv8Ax5f4Tv3nIZhJzYqR/gBLlmpcIFT3opaOns
         MpfOSRSgJGm9vNrfZfwxUKUl93wv4KLHJ5oG4SB6MvRqKnTv7kEnME3Cu1Q1baJFk78Q
         yxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EUf54GbfrBTdWkr8FM55zeEhqbAwY7cxrNBrNZA6Z8M=;
        b=m+wRUyV94GmfV8u5cQEzrHYA+tQVsxoDYUqtg/webAwik6ZYUh0uLZ0l+lkjC464b9
         IpAME9kvzawiCZtyPTIJ6m+wCigeSlXo95EAnjnstmflEvAUsdrqhCkwbU24d0fuXOox
         UeQuhyEYnY49hsFwe3o/phIeQxkrvoHSh7FaOEYSV5R9a3AjmKrvqyr0cSv+vtSsO6sf
         o+V/WGPKv18+bIZNT6jLQsYlF/v/3yBBB5MIUPcBtkl3/m5Df+vh365cq5NEnpDQO2b+
         /mlAjOZcuuNtSrHt4zF2ZSXQkyZKwSNQvmdKDLeO6CvchWGvE6d4W6Bhhx2/vk3vEv3p
         lDaw==
X-Gm-Message-State: AOAM530uBMjLhZeJNRX60kHPGQQAYSe3frbs9kD4hjuUsqItzTlFvHud
        BPz2/NHO/y/v+FYqktgzPOy4VkGgcWg=
X-Google-Smtp-Source: ABdhPJzYdZEIyx6+4/yqfrwQrrJPdYgEjg+KTqhm1qnRCCinzcKS1dFStqVdCSYf3N3394USw3EVSQ==
X-Received: by 2002:a05:6000:124a:: with SMTP id j10mr104327wrx.431.1631314780881;
        Fri, 10 Sep 2021 15:59:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:98d9:2e72:b22c:4c37? (p200300ea8f08450098d92e72b22c4c37.dip0.t-ipconnect.de. [2003:ea:8f08:4500:98d9:2e72:b22c:4c37])
        by smtp.googlemail.com with ESMTPSA id s10sm5900980wrg.42.2021.09.10.15.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 15:59:40 -0700 (PDT)
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Loehle <cloehle@hyperstone.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: sd_spinup_disk() now is a little noisy
Message-ID: <485ac2f7-e83a-6fcd-b849-c20608e26810@gmail.com>
Date:   Sat, 11 Sep 2021 00:59:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For my personal taste sd_spinup_disk() is a little bit noisy now.

[    1.942179] scsi 0:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
[    1.943651] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.943667] sd 0:0:0:0: [sda] Media removed, stopped polling
[    1.949970] sd 0:0:0:0: [sda] Media removed, stopped polling
[    1.950001] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    1.959266] sd 0:0:0:0: [sda] Media removed, stopped polling

There's not really a benefit in printing the same message multiple
times. The following helped for me, not sure however whether
that's the right way to deal with it.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cbd9999f9..af7e7b0da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2124,6 +2124,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		retries = 0;
 
 		do {
+			u8 media_was_present = sdkp->media_present;
+
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
@@ -2138,7 +2140,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * with any more polling.
 			 */
 			if (media_not_present(sdkp, &sshdr)) {
-				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
 				return;
 			}
 
-- 
2.33.0

