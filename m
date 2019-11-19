Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08831C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 16:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B1222365
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 16:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="LjBeUDlC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfKSQJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:09:03 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33308 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbfKSQJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 11:09:03 -0500
Received: by mail-il1-f194.google.com with SMTP id m5so706190ilq.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 08:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZjYxprU3IRLz/AX9U1vszJUIv5Bi18dcJPXiYw1DQ40=;
        b=LjBeUDlCfEO3O4aelb+WkQ2GjVpZtfEwUaFPNeWPzIpegb6vXNpN7mzFfUpicnPfP8
         JiYSZSlPie2HyP1Ox9rLQnLGnN98ArMCVGyFQSVNOEhvVrUxJhx+leEdOOl1ealpSBiW
         erlFvJmHF9M453HZEtZypzzM5B3HwDpjMS2YuLXkGEy33kQTGWNCkuklJdDdCl2FfllB
         xInWclGlt4APFPPdMkzUS7yQB/HKGRHFzVIXi/AUrMTclzvlsB2eb6SLwFODnpDUBk6T
         trUXjfmU8B3fL6QjSx0zqz+m/LyuTKwKcz6svaLonr/ZC3BrwvETvpATR3YD83cnRYY2
         a8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjYxprU3IRLz/AX9U1vszJUIv5Bi18dcJPXiYw1DQ40=;
        b=kqh99iPS0DHGPjAAQG+r9ld30MBdVO6BpLHZ39ywunD+Es3b8NCUvN9AY4R5N/TLtb
         Xb2fVAoEtW9W+Mwxaf98jxXNbCcNdvNsmV569Mvw3Lw1fovUmQfoFxLdP3pl4Vt/iWyR
         DlsDByTpto4/rHCJ28I+LigihXg0rOdGmjedSWYaqFG5ibF/E/C0fKucrPPZrGxda/di
         WIYAZXEFaqhRWrxYfdcGqxc9u2HxvdaHFgtOnzeXZt2kh3AK+/GzEtM/xR6AMODL2JOY
         ug6WgJIJaMpaTR/gphF9RHyTw9zAOCmcwNTBzV29KUkfOx7hqzD1PaAO8mT1VIdDexn0
         ALNw==
X-Gm-Message-State: APjAAAWJ0pvi8MMQ1g373XyVk1uqugRIh0/pYtAz3PqNMCFzAznQ2NRv
        jIAmTTSeptct4i0CCmkXCNs5WlKV8LY=
X-Google-Smtp-Source: APXvYqxLuCthviNHrCFlx8L+LbjSA1Ys0lX2ea/wib4VwEAeUoybGt7cWhE3VXAQV37wD3VaeLdv5Q==
X-Received: by 2002:a92:10d3:: with SMTP id 80mr22695151ilq.210.1574179740487;
        Tue, 19 Nov 2019 08:09:00 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h15sm5717598ilh.85.2019.11.19.08.08.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:08:59 -0800 (PST)
Subject: Re: [PATCH] cdrom: support Beurer GL50 evo CD-on-a-chip devices.
To:     =?UTF-8?Q?Diego_Elio_Petten=c3=b2?= <flameeyes@flameeyes.com>
Cc:     linux-scsi@vger.kernel.org
References: <20191111132955.19361-1-flameeyes@flameeyes.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <80f9668f-2c2f-e81f-54e5-c47da6f0d6f3@kernel.dk>
Date:   Tue, 19 Nov 2019 09:08:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111132955.19361-1-flameeyes@flameeyes.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/19 6:29 AM, Diego Elio Pettenò wrote:
> The Beurer GL50 evo uses a Cygnal/Cypress-manufactured CD-on-a-chip that
> only accepts a subset of SCSI commands.
> 
> Most of the not-implemented commands are fine to fail, but a few,
> particularly around the MMC or Audio commands, will put the device into an
> unrecoverable state, so they need to be avoided at all costs.
> 
> In addition to adding a new vendor entry to sr_vendor, this required gating
> a few functions in the cdrom driver to not even try sending the command
> when the capability is not present.

This is pretty horrible, but not really your fault. Just one minor note:

> @@ -1162,7 +1168,9 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
>   		ret = open_for_data(cdi);
>   		if (ret)
>   			goto err;
> -		cdrom_mmc3_profile(cdi);
> +		if (CDROM_CAN(CDC_GENERIC_PACKET)) {
> +			cdrom_mmc3_profile(cdi);
> +		}
>   		if (mode & FMODE_WRITE) {
>   			ret = -EROFS;
>   			if (cdrom_open_write(cdi))

Just make that:

		if (CDROM_CAN(CDC_GENERIC_PACKET))
			cdrom_mmc3_profile(cdi);

And you probably want to split this patch into two, one with the
necessary changes to cdrom.c, and one that adds the Beuer device to
sr_vendor.c.

-- 
Jens Axboe

