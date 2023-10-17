Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12589CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 13:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343843AbjJQNS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 09:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbjJQNS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 09:18:57 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4EAEA
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:18:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40684f53ef3so59648775e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697548731; x=1698153531; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BiDqW0By7aRN1psFWU94FCa13TcTJZJ745P7reIIh4s=;
        b=MC3Cxd0vHsyBoP8ZCY9649/8PuzhFnqYNHXaVV3w/4FLME5ExsT7bET/N5lqvU/8XO
         LQwWIOBPUPiF2UMrMIG2A9hvGF5U5tkVdPfFcao/LloroftTuwraJNKcIvzhUf14bh7q
         l/IQaEHE8d90rxuIH7sH4szPAdLRGONAkeJjUin4+OZjseT1FfBhvFrDglHJFIax2dRt
         43g6s2rGNJKH/WWAxfwxDgxZon5Oi/axLpptzQvx74s02jtP7Sv7pXXfzlY62qBs4w7Q
         k5rp+FilEJz9qCaFizudSPGnVrK6b+C8MB4xLy/s+TUK7ej4LPkKMbovwiOBcvMsAvyJ
         KQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697548731; x=1698153531;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiDqW0By7aRN1psFWU94FCa13TcTJZJ745P7reIIh4s=;
        b=fTWFZGjQny0Ac6QeAESSk64WcF+k5NjvfG9lvXph217HiSRRjaO8KyKvxeAs7kqw4E
         u0LFUxT3+uLBRu9Lkd49F9WPdPKXASjOgetlkK01Mu+XlfkUS+TIB09PbDu47tSOhPhh
         wmTgRkZcDfLhyfOH1+hEiOau6a8mz5UZeihg24M4tGGIFITYelcGGNA3I5Pie236LnF3
         PxrfT1hD2VHwJLIwW1IQozMfbL35TFnLNnme4otAb8i7gIInhbpYXVL/W3rDh+MSoOBG
         4WUo8BZOSN+PVvy2MJRaEQYwKGPxjGQQ8aJdsWd9lX8YvGjJNkbAErKLO2JRd6qQLPxJ
         ItUg==
X-Gm-Message-State: AOJu0YxdGrgEM9IQTcjqJjWzcxwAN+1NoAaJkTFBxCsXyDi2BOBW1+QU
        U020lRHPQQ7zYC4C+f+Yx0runK+X7Rv6zkU9kHU=
X-Google-Smtp-Source: AGHT+IHy+kVAYGh1v9tLPPLGP98yFlF1ce0Frxub5jfUvftUFj50imvSPFLkuU7p4lAsHHrhmmbZKw==
X-Received: by 2002:a05:600c:198d:b0:405:7400:1e4c with SMTP id t13-20020a05600c198d00b0040574001e4cmr1803037wmq.35.1697548731200;
        Tue, 17 Oct 2023 06:18:51 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o21-20020a05600c379500b003fee6e170f9sm1858587wmr.45.2023.10.17.06.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 06:18:50 -0700 (PDT)
Date:   Tue, 17 Oct 2023 16:18:46 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     hare@suse.de
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: message: fusion: Open-code
 mptfc_block_error_handler() for bus reset
Message-ID: <b684093c-7c05-49cc-b6f7-e3322fecbbfc@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch 17865dc2eccc: "scsi: message: fusion: Open-code
mptfc_block_error_handler() for bus reset" from Oct 2, 2023
(linux-next), leads to the following Smatch static checker warning:

	drivers/message/fusion/mptfc.c:281 mptfc_bus_reset()
	error: uninitialized symbol 'rtn'.

drivers/message/fusion/mptfc.c
    261 static int
    262 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
    263 {
    264         struct Scsi_Host *shost = SCpnt->device->host;
    265         MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
    266         int channel = SCpnt->device->channel;
    267         struct mptfc_rport_info *ri;
    268         int rtn;
    269 
    270         list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
    271                 if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
    272                         VirtTarget *vtarget = ri->starget->hostdata;
    273 
    274                         if (!vtarget || vtarget->channel != channel)
    275                                 continue;
    276                         rtn = fc_block_rport(ri->rport);

Are we always going to hit this assignment?

    277                         if (rtn != 0)
    278                                 break;
    279                 }
    280         }
--> 281         if (rtn == 0) {
    282                 dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
    283                         "%s.%d: %d:%llu, executing recovery.\n", __func__,
    284                         hd->ioc->name, shost->host_no,
    285                         SCpnt->device->id, SCpnt->device->lun));
    286                 rtn = mptscsih_bus_reset(SCpnt);
    287         }
    288         return rtn;
    289 }
    290 
    291 static void

regards,
dan carpenter
