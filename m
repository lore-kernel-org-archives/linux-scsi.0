Return-Path: <SRS0=Y1L5=XE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E00C00307
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 05:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B6682196E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Sep 2019 05:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mitSbrQl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfIIFmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Sep 2019 01:42:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36548 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfIIFmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2019 01:42:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so8445565pfr.3;
        Sun, 08 Sep 2019 22:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=sNPKiG4f293O1xukhlprF97TRd4tQ/u8W2A8cgfAduc=;
        b=mitSbrQlq45lqe66coysoEZ9CZFcjROBTC6aTnCdZyTxToUM5CA+2gLVnBxUkmGyqQ
         GPx2LZlomyvyd846pVL3KcIXWqj6AeTuTTs5Ko32TVwVp9RYr1iJPUuDWDzs4guZI6xK
         EAiQ5qXNix9ANr5YqmjWHV7z+KIC2gabJEMmPX454jOvB+jx14DXK4rudT5/U0O0B2cs
         ZCZdv1g2n9Q+Rw05GaaYys7f/jTNDkOlfHL+HPMF9F4+2TLSuprpd2r8w24qv2XtdBcu
         EDNlW+SFrP8Ykm7ILmHfcB4oiiJ/tqGUbmPfhcOCCFJ8rLv8Biov/OTGqtAhB+2TbHoD
         BcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=sNPKiG4f293O1xukhlprF97TRd4tQ/u8W2A8cgfAduc=;
        b=mcsOXzgClALXSXi26aTEuBKLH0NnAUj6As8k6IEC/9XdKq/FKc2eWaDIPWrTSiZeCS
         kTxdRlT3IX0p9AMetbYk6o5qFHkV8dfNSfraoy/FLTy9Hvc7FnKJKNQvcD/NXr7+mGkZ
         HoY5O4wGQFR9/U9qaOpI7Jin8JGnArN63gjFwVB5qFnCp2PapHHwL0cCm6WQGgfxNJ4S
         uny4oKTON/QDvfko54G+HzXFIN6go+HlXZGRrmNuzr398E6dQyo/bFIzR9vRktByS+iJ
         uPzqmj7HMSxXHiYf+JWsAgIiUWD3bjEsaLBX4jXBOUWkkLFH0z0S01VuSLLDk+XaorZi
         EMFg==
X-Gm-Message-State: APjAAAWcD5iq8wl7iQbGyNPj0OeJUJm0zf3u02Y120dvVfJdF1A2z+nH
        IIGUr0z7pa8ynRnRCnjqP0M=
X-Google-Smtp-Source: APXvYqxoacRC+/vSFdUYCrCBb6ycMAA52BjDl92rD7oTqzhufwGKXKqEXJ0K/V3kYnY5i9wy7h1C6Q==
X-Received: by 2002:a63:b20f:: with SMTP id x15mr20450987pge.453.1568007744641;
        Sun, 08 Sep 2019 22:42:24 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id h66sm22763016pjb.0.2019.09.08.22.42.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 22:42:24 -0700 (PDT)
Date:   Mon, 9 Sep 2019 14:42:19 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: dpt_i2o: drop unnecessary comparison statement
Message-ID: <20190909054219.GA119246@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The type of 'chan' is u32 which contain non-negative value.
So 'chan < 0' is statment is always false.

Remove unnecessary comparison statement

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/scsi/dpt_i2o.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd..df48ef5 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1120,7 +1120,7 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
 {
 	struct adpt_device* d;
 
-	if(chan < 0 || chan >= MAX_CHANNEL)
+	if(chan >= MAX_CHANNEL)
 		return NULL;
 	
 	d = pHba->channel[chan].device[id];
-- 
2.6.2

