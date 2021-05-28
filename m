Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4338FC4708F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2399C613E3
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhE1SPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 14:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhE1SPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 14:15:16 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB277C061763
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:13:41 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m190so3144344pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mRXKn2a2TJxYpNg614xQbH+vgHW7yySJqcrC710VWeE=;
        b=JrEGdHhP7EFQ1SgkGbszsPMb+bl/KdtbyLCtWuYiqIWndBXagmFrCFffFHn12mBaFe
         v4mY9qlnt+JfEotilQMrF+en1bU+WoiUtTZUMtsQC2SsVufVCdjHQvfcnHwYSFMwkVQ4
         xaMcJ1hhe1R8fFbRNUStlFVu9RvgRLrPYVxSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mRXKn2a2TJxYpNg614xQbH+vgHW7yySJqcrC710VWeE=;
        b=OlZBuB7oHXCgFEpI/rfQ6pvmmuMSnywrT1dAqxGegpPPmf5fW66XCOuTywIAFkSyrm
         kWLO2eXZlHCYn6znNwIMtcvsOUBEyM7mQCpC50bAXFeI3h0kjYXc4WCr3EfsS43UuJ1e
         scWgIuiI8oCVcSYfOvsBXs5Ht9SpIXy24FVXKOej0Ez+EoUnh870RU8G4zupQ5hwyS6Q
         FQMJ6WNI5qWWJpshpWFYjv8gbBTw+8nf2uO9zHOAU+QCtQwrGCdGhilwKpYtQysx2BS6
         JiSmCKR1cTGgTXwQY5Js0vUeeFNaDLn8CGuq2G1MA1R3YVKrEqq7Dog/p/bDEAeRxqGj
         kXrQ==
X-Gm-Message-State: AOAM53269s7IDu1z6RV4+q/TKCUjlZixdZ9YZUC7Vf8C2ipJkiOlJNCp
        kD6+RQNM2PsGuVs/Ino1xetrGw==
X-Google-Smtp-Source: ABdhPJxONg4ZMLOBq2VKLCPpR2hd5Drqrxa8BYCsNQHzbr0Z55Qng5iRcr3wufgddr3PDf9/LyuVTQ==
X-Received: by 2002:a65:60da:: with SMTP id r26mr10169451pgv.133.1622225621525;
        Fri, 28 May 2021 11:13:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g8sm4637163pfo.85.2021.05.28.11.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 11:13:40 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 3/3] scsi: isci: Use correctly sized target buffer for memcpy()
Date:   Fri, 28 May 2021 11:13:37 -0700
Message-Id: <20210528181337.792268-4-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210528181337.792268-1-keescook@chromium.org>
References: <20210528181337.792268-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=62b6a772dcc28a3c942828f5b8f7820ee6d3a41f; i=YaeUnfBq3TJQDjDDQLTzHyZVVP6D3nm5nxLM0EpXtRA=; m=ctjrtOVcMtkveReIPPzBsDxfD/jI9YKdALG3fA7QedE=; p=3kYPPaGRNOcMgxn+oYl2l/LriCur9INYsJLjiNU5VNI=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmCxMtAACgkQiXL039xtwCZbHxAAhEo sXvA3Z4idNWsm6GyioGcjMQaWDbmW26hmGnFs3/evp3/s2LzULDQ9oYbjBZV5nFM69+nk7pvUMH4Z PbUr5phF7psaj/IF2tsE/J2DyuPnGATxV/9EeBHZdebDS1LAkpmMJQvb810y2bfiqq7zQRXml0erN j8LmuWaES5kiIO0jKBQskL1qBd1eJ+iSDj3EsW6xI7FPpHF6Jb8+hSgjcs6fM+WbI90Y2mxr+zlHb PAuhV+6i3HjVBEwIIVl0Wqm2m8xJEQJbD01mu0DB8y25QQlpBnPwvViurDDKdDnKfpnKR5zxXGGFw Ji9G4OiYP2RDaAVRbKBFOkHKr2BHWGssqcUoC52B+9krw3iAk/OYqQC1aX5dZivSVhoxbYeYUWDBU 7ro14x8WoYuEYUEoM3iGisb027eDktUbz34YA2aOdEO/KpIoMpIwMREmjQgVMbzA6mqzIhqgWaHTf r24DWjL5keQsYfJTu47AGMcrl40Q7U6kvXxYYPPqv87wrZBptj4MF9QlJiIfzB2VquFIiYKlf0d1V yzT94zTBjQECveM1CnVy/Yxj7zbjy6QGAduMN5qLnkP0GQtHpvQh8beMXVX9ZXe6hrMRaz8WZvH5J XrqaQ/KQrNIrwQj5lWHjFg6nVAeY2LqLd8FMhzIk9px3tH6W6Q7AcDJGWbJEDods=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), avoid intentionally writing across
neighboring array fields.

Switch from rsp_ui to resp_buf, since resp_ui isn't SSP_RESP_IU_MAX_SIZE
bytes in length. This avoids future compile-time warnings.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/isci/task.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 62062ed6cd9a..eeaec26ac324 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -709,8 +709,8 @@ isci_task_request_complete(struct isci_host *ihost,
 		tmf->status = completion_status;
 
 		if (tmf->proto == SAS_PROTOCOL_SSP) {
-			memcpy(&tmf->resp.resp_iu,
-			       &ireq->ssp.rsp,
+			memcpy(tmf->resp.rsp_buf,
+			       ireq->ssp.rsp_buf,
 			       SSP_RESP_IU_MAX_SIZE);
 		} else if (tmf->proto == SAS_PROTOCOL_SATA) {
 			memcpy(&tmf->resp.d2h_fis,
-- 
2.25.1

