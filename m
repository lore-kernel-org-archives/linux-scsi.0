Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7CEC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Aug 2021 20:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C16604D7
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Aug 2021 20:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhHUUGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Aug 2021 16:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhHUUGn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Aug 2021 16:06:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B362CC061575
        for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2021 13:06:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r7so19465019wrs.0
        for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2021 13:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/nPJIgrtSoi2xzyu/KTJ6acfCjAalTX5bfN/S6ayHXs=;
        b=H4TO+oXfaZ29P911gud21axO50kkUayrauSo79HlBaWqFvmA7s5CtoPjccHllh5c0a
         yYMVPqveeGbbcqfe6sx36VCB1Wf1KmhKa2R2hGxv8NxumQyVNRGleC1H76gf/x1NnKm+
         p0EvpB0EicIhEJNcn1vk1rSrXo1q2VjEOuTf27xuCl8aHT5shKRVGrvcL7bMojknmXs6
         kaZ29d4HpNmIe1P/NRHLqW7FxRBJMfZgAR+jbXQvt1LphkOpCsimQBZi6zgH0F4QGr78
         w+ALOgk5g2Sp/O58FuhZItTUdcJakKnXpCjdEUhMyULSwpG3N0qdCqaiILxPzxW9vCxq
         tLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/nPJIgrtSoi2xzyu/KTJ6acfCjAalTX5bfN/S6ayHXs=;
        b=D2EjEXtJseWPhFJt7YQcQA3IsRrxtWBm18XQUooNFYsdpR22AKLobWghlNkKiS5iaG
         HHOB8zTIvZjhJZuhTThPGIk+ZfwVUNZCUulbWRCdLpYu4AxlUkvyPGIJuQHymhKaS5yw
         xkGajC4pRebW9Ip8oPF+G9QArFpaBTGlTDsouY8CbNVFVI8CY4CCMptV/BSIqyNNoqTl
         fiYdZeeh/gMDPgqaNTAQn/D8++vNr3rsNc6gsqPWsE/L5kLSuKJXetCYPD/cBkLsbgyj
         d0odUJwuoTSmkbjdALKJnIa58OWM5YBvQTfCOh9Fc2prLq9wpULMTzc8Q776AVy3337W
         M4UQ==
X-Gm-Message-State: AOAM530dIb+Z3YbaYWtjZd4uooPRgjs4cnFBywMdc04A4nIECw5s+Spz
        gTG8NYQ9FRa7KbT3IlwvD8DrFR3wI74Kgg==
X-Google-Smtp-Source: ABdhPJysXSa82o03gkcLqdhtdcOeFZOXRy0E+xpns8FzO2Iq6+mZATYgcyoV/oP3oYx6cUhwoF6paw==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr5384421wrj.340.1629576362161;
        Sat, 21 Aug 2021 13:06:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:61a6:d470:1a5d:2d8f? (p200300ea8f08450061a6d4701a5d2d8f.dip0.t-ipconnect.de. [2003:ea:8f08:4500:61a6:d470:1a5d:2d8f])
        by smtp.googlemail.com with ESMTPSA id g12sm12397703wri.18.2021.08.21.13.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 13:06:01 -0700 (PDT)
To:     "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Wrong usage of kstrtoul() parameter in cxlflash
Message-ID: <c29f9ccb-1230-7340-affa-3cc8e06b40a2@gmail.com>
Date:   Sat, 21 Aug 2021 22:05:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following code is used in drivers/scsi/cxlflash/main.c

		memcpy(tmp_buf, &vpd_data[i], WWPN_LEN);
		rc = kstrtoul(tmp_buf, WWPN_LEN, (ulong *)&wwpn[k]);

This seems to be a misinterpretation of kstrtoul parameters.
The second one is not a buffer length but the base for the conversion.
It may work just by chance because WWPN_LEN is 16, and the VPD string
may be a hex number. But definitely WWPN_LEN shouldn't be used here.
