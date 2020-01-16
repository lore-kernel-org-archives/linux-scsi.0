Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948B8C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4EE246DD
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:47:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egYriVhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406349AbgAPRrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:47:06 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34466 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393883AbgAPRrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 12:47:06 -0500
Received: by mail-pl1-f195.google.com with SMTP id c9so3339538plo.1;
        Thu, 16 Jan 2020 09:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xUvWD2Y2DQW8StOa7xN9BwMTpDofp4EnC5k0h+mCkts=;
        b=egYriVhI2i26MRTmQsTVLvXzjcVpGy85W2S65p23KZFcaaLwjlDRvq7SkwPmSuey3p
         WtRlydA7HaBl+3JPPVcNt6LPXniz3kw88Of7Y4SrtpvNfizwCKk7cMwDJJcBXONARMpv
         0LWWQpug0h6qM6bwWjcrTeAfp+sJD5YW2smNLJvVvwwgcQFtkzB241nyGUEyX597qhp6
         t4Zb6hJzyYSMDbNtGlFPIJnhA+cYcYmy84hvWFob6lG0r9IhLDex9lLabVL5k9mQkpO/
         rMAOYo5NuIRVTtvxU6sATFcYgp+l1DmV+sxqC3D0gpYKDHUS94NloFaRZ2v4kLFwT4dW
         p5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xUvWD2Y2DQW8StOa7xN9BwMTpDofp4EnC5k0h+mCkts=;
        b=aAmLurokl9XIP0lPmpy8NlTu+KQ/nW7o8Tp54yQA0VwMVC3iydG7hzUytiVX58rHLg
         Go6iG8dcVsMGD+eeg2UJnCH2JYJQYysh9jwadkyN1gnCVhhY+3sWyU1D6evy3kjptyGo
         zQ3M+HXWh6xw7RwERtQvS2wk4HRwAMeNtlg22aLujcq5oFHcXj6KH/mEnixLZrx8CX+2
         CCnmsqvbEcTwzLEf6vctcZCuCTBxpL5rKR9vKz2VZ2vkxeimDyLUwIcv/6Hen4HoUG0V
         dUdNxGrdFGVRTFwrzXhhPGeQ/s/78pdquWZBSUjDBlbB8tuQ20/vSb1uq7izAYUxj41F
         FMIA==
X-Gm-Message-State: APjAAAXJnSaIFV4zOK9Ee6TBnHupN4bq75zSlJyYz0MMErghTJ8XsWGo
        MgWjq2G6/GjQL3dW0SZzBSA=
X-Google-Smtp-Source: APXvYqzTZocSoLTAjLkcHDaAQa2HCpnjxr8eJMORO7tRY3XWsND94JU6MUEHDbALJMqPpPFeATo9Vw==
X-Received: by 2002:a17:90a:a596:: with SMTP id b22mr342176pjq.28.1579196825226;
        Thu, 16 Jan 2020 09:47:05 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u26sm25167784pfn.46.2020.01.16.09.47.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jan 2020 09:47:04 -0800 (PST)
Date:   Thu, 16 Jan 2020 09:47:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
Message-ID: <20200116174703.GA7850@roeck-us.net>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com>
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com>
 <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
 <yq1r202spr9.fsf@oracle.com>
 <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
 <yq14kwwnioo.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq14kwwnioo.fsf@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 15, 2020 at 11:12:23PM -0500, Martin K. Petersen wrote:
> 
> Guenter,
> 
> > The hwmon-next branch is based on v5.5-rc1. It might be better to
> > either merge hwmon-next into mainline, or to apply the drivetemp patch
> > to mainline, and test the result. I have seen some (unrelated) weird
> > tracebacks in the driver core with v5.5-rc1, so that may not be the
> > best baseline for a test.
> 
> I'm afraid the warnings still happen with hwmon-next on top of
> linus/master.
> 
Can you by any chance provide a full traceback ?

The warning you reported suggests that a devm_ function was called on a
device pointer prior to a device registration. I don't immediately see
how that happens. A full traceback might give us an idea.

I suspect that the underlying problem is in hwmon_device_register_with_info(),
which uses devm_ functions to allocate memory associated with the device
pointer passed to it, in this case the SCSI device. This is inherently
wrong (independent of this driver), since the lifetime of the hardware
monitoring device does not necessarily match the lifetime of its parent.
The impact here is that we may get a memory leak under some circumstances.
I'll have to fix that in the hardware monitoring core.

Either case, I would like to track down how the warning happens, so any
information you can provide that lets me reproduce the problem would be
very helpful.

Thanks,
Guenter
