Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38134C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 14:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1340D610A2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 14:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhICOMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 10:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhICOMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2021 10:12:40 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BEBC061575
        for <linux-scsi@vger.kernel.org>; Fri,  3 Sep 2021 07:11:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id q3so6877817iot.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Sep 2021 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sFLevf6p4HjurMaryx5OsTscTs68zB9kNma2BMpqvo8=;
        b=XW4ew0B786SJO1juipCJntR8kFnk+Ci8hOrVEHLEkSlhWdzByT9R6sPZOCjZnU5/Ip
         IPPDS+5L/u8sOghZiuNzJl+/63mSTXjxbzC64ygzUeWjD6QAUiCVf+XzMg/3+4oRfNA/
         Dpjw3C/uYjC3n3MI2fMJL8gMXE9ijWuTokKaQ/YQnRmahshZy1AxKvTXBHEV3uw/rjlI
         yORrUTVb5xdg0WE26YrwrLRA24KgkPBU5FI+BmEdTTNd3WA8NjnVVO7n3U3YCdUk3Rt9
         06xn0IzxSPSyCzEmYRpFU41HGMH/HjwtBYfo+u9368UNvVniVYm+knEUvwuF7pIWX25J
         uL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sFLevf6p4HjurMaryx5OsTscTs68zB9kNma2BMpqvo8=;
        b=iB3Sw1fE0OXhDUpRoSwuPwRTLLDLv7B5xwc+nzexHOMIjIVnkjTqwfxANp+GA4DlG7
         jo81Ab8Obz8QHE1Xfm4qfBTcVlvGUxVsqbxLyy+ejqU8rAT4jxmXRX7affQMq2X7gpbK
         3blwJMeGzjIjzhTfm4X1JWjft5Ms2ODjl5lJzQcIZnBb0K2vVdhkl5QkGWbC27TKRwhi
         Yjc9vHY37Dq1duhEANr0DmEr6i1QdiKqZ0Rc37s6uo2mfn9HbyQLTp5D7JLcffMLRYPc
         yk01Rt1u3u5+BziD0tLpVr3NiDSl9L9TZ2trexWGFni7inLysf2aniK7zS8NR6eSCQqX
         mrcg==
X-Gm-Message-State: AOAM530HxM2VXZ2qJMhGC0C/L1C1Y1C4SdGry65P62ccKfdUROChnB0u
        Lum9Z9+g6aYEMSPALFiEQ+u6aOr2IQWWuQ==
X-Google-Smtp-Source: ABdhPJyTdhRbhf78uaFIfnKo36dzlnEL3GPirqjIWQbjegGnDBlf1rAvDzDtHRntr+34Wb0phqHrow==
X-Received: by 2002:a02:ab87:: with SMTP id t7mr2792998jan.127.1630678300227;
        Fri, 03 Sep 2021 07:11:40 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x1sm2717088ilg.33.2021.09.03.07.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 07:11:39 -0700 (PDT)
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
Message-ID: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
Date:   Fri, 3 Sep 2021 08:11:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's little point in keeping this one separately maintained these
days, so just remove the entry and it'll fall under the SCSI subsystem
where it belongs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Please queue this one for 5.15, thanks.

diff --git a/MAINTAINERS b/MAINTAINERS
index fb1c48c34009..8c3aec73c4b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16616,13 +16616,6 @@ M:	Lubomir Rintel <lkundrak@v3.sk>
 S:	Supported
 F:	drivers/char/pcmcia/scr24x_cs.c
 
-SCSI CDROM DRIVER
-M:	Jens Axboe <axboe@kernel.dk>
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-W:	http://www.kernel.dk
-F:	drivers/scsi/sr*
-
 SCSI RDMA PROTOCOL (SRP) INITIATOR
 M:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-rdma@vger.kernel.org

-- 
Jens Axboe

