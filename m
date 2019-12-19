Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D94C2D0D2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B7432176D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 00:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sD+yWKkJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLSAdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:33:00 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39845 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLSAdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 19:33:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so2154673pfs.6;
        Wed, 18 Dec 2019 16:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p0q8QxoTzBEMo9IJAgQ5mnM7oqp1lTPhY1a2DTeSNu0=;
        b=sD+yWKkJaSLMn9+NH4JWR4Z0jpYCBDVtGUkIH10gaoa7OL7HVyppH63hIoT2oQe6pJ
         lIHzlt8Uf1qSKtfuyFCSE+pO8KK9a+g+niJedeIWeNOMyx+8NxpLrbLGzQJURTtZ3a+T
         bH6kLI3J0wDK6BjzTP2mvy6Ia6SKtpNYZZEoUREttZ3yXKf1JleHpjQ/PMQZEiZp4/zX
         rB6ugqXcbdfFyDE3810WjOcxmZ+iNF7niJXmrCilZGtWYc9+pkAqXvj0DsjwnPeOix93
         v4RXWOG52PjLGIjYf9SiW0Z1/Ai2Bt/EST23feB8ihwNkeK7QbmceuuheRWsJNKvRFcM
         LsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=p0q8QxoTzBEMo9IJAgQ5mnM7oqp1lTPhY1a2DTeSNu0=;
        b=N49HwNz4dIsCn8yVG1hteSc5hZal1geekdn7/mUyFDSlWe4+bg4Y1ovKgyScu+QkH0
         A7rFaVU7B3yzcDWMvZI32d10o53ff7N5LBzGREHLnnpG1IhXACaMUNzVx2izoGILG/3W
         eTu5OQudbgRrNllVVWNSfKPBLeSbdoDoFb32YLDHL8PtQq1GbLcAqbBGyxkIW4GfvDmC
         fOhMMTZSQ00DxFkzNo1zO1PxgJZI/PGyfVR7WNWGuPrZriUyTekGZaumivdBo+t2TLt3
         PGByk9bdUd2Esx4VRKe0xSaVtwdYVTdPT+XAJEe08GcBHhdAuquz9bujX2i/EDRJubk8
         1Fmg==
X-Gm-Message-State: APjAAAW2vEe2VRBhFmDz2GBE7OBEq7c/BNTIuRF2L6I2kOhVa+pzIupJ
        8MNIS6zLGKUrzoPqvfpwFVaXICNn
X-Google-Smtp-Source: APXvYqypzKHQBv3aT4OD6iC5R4Mscfj9bYi5rG9iGuw5KdGufEgvY8n/CeRjJtyduSIT1Ue24HnQDw==
X-Received: by 2002:a63:4d5e:: with SMTP id n30mr6072905pgl.275.1576715579176;
        Wed, 18 Dec 2019 16:32:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g10sm4524960pgh.35.2019.12.18.16.32.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Dec 2019 16:32:58 -0800 (PST)
Date:   Wed, 18 Dec 2019 16:32:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
Message-ID: <20191219003256.GA28144@roeck-us.net>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1r211dvck.fsf@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 07:15:07PM -0500, Martin K. Petersen wrote:
> 
> Guenter,
> 
> > This driver solves this problem by adding support for reading the
> > temperature of SATA drives from the kernel using the hwmon API and
> > by adding a temperature zone for each drive.
> 
> My working tree is available here:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=5.6/drivetemp
> 
> A few notes:
> 
>  - Before applying your patch I did s/satatemp/drivetemp/
> 
>  - I get a crash in the driver core during probe if the drivetemp module
>    is loaded prior to loading ahci or a SCSI HBA driver. This crash is
>    unrelated to my changes. Haven't had time to debug.
> 
>  - I tweaked your ATA detection heuristics and now use the cached VPD
>    page 0x89 instead of fetching one from the device.
> 
>  - I also added support for reading the temperature log page on SCSI
>    drives.
> 
>  - Tested with a mixed bag of about 40 SCSI and SATA drives attached.
> 
>  - I still think sensor naming needs work. How and where are the
>    "drivetemp-scsi-8-140" names generated?
> 
Quick one: In libsensors, outside the kernel. The naming is generic,
along the line of <driver name>-<bus name>-<bus index>-<slot>.

> I'll tinker some more but thought I'd share what I have for now.
> 
Thanks for sharing. I'll be out on vacation until January 1. I'll look
at the code after I am back.

Guenter

> -- 
> Martin K. Petersen	Oracle Linux Engineering
