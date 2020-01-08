Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27F5C33CA2
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 15:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A80EE20720
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 15:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hcH8Hddz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgAHPc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:32:26 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34180 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHPc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 10:32:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id s94so6437378pjc.1;
        Wed, 08 Jan 2020 07:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1SOA3Ah7Rg4qtqYtLQcb6jr3zIfhzYvMEvCqqOZp10s=;
        b=hcH8HddzSr1Lo2BeOG/EscmmwduKGPUQti+1Ls3aYlbDVwLieDuKmKNFQ7tZ5dur8p
         uCLBqkSgM+YmReBEn67r9b9fP3qU+se7HvNsNxWOmKKmED0dk3rcxbGGpUIEi7PLjwl9
         cW0D1BMPhGHhc7l7hHqpS3AC9E7JHvqe1UQxUZrFJEvUwZP3Kh6n6W90WhlHBgVIGSKc
         BXI0Ojcnlz5awvU8Al7d06rFjOvxJH/npCCtVZN3kpIhZQ/5bMSy6/3BfXAIZgrgj85o
         L2D/byLXUGhhEWVIZnGOGlm1r/J+gz6o/FpZDYOi9f2jdqIU2CmCbVik0tn8FqTUfQ8w
         COmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1SOA3Ah7Rg4qtqYtLQcb6jr3zIfhzYvMEvCqqOZp10s=;
        b=oZhu++31zZE5xQ/xr9iBQODsm/XFTOiDDY+X6euhLpEqk1XqszdkxontDNg1xjlNEc
         l7sCdKEM74csW0nQ/RlM4mvdtuqIY5SvyslC0IQllmXsqajdhZJ+o6gSfhl0Z5a21Cnc
         g4NKEh3e0pZ6BBo6yLjIhoYVoAc5o+VINY8MFJs3cD5+YTKxuDp5D5GlzkluzcRkqavb
         aBkSrw05ArgNVb3y2Nx78nJAWqt/Ldc/VCVGwb4aZzlN2vdli2tbNUlC40yRRF1Xjjp0
         p8oc538ZzWYYv01ZU0pGrtWNlOnEmKyDg0Tf7wGTN0akYKh0EdQYaSlcHQuOg71WPaUM
         fxug==
X-Gm-Message-State: APjAAAXOaDXIPCIcgpPoXTZO0KIWzaCzLMT8tdndnDbNegM8503etHG2
        kQRTAsSCIXMUOpg/vVuTwVA=
X-Google-Smtp-Source: APXvYqx0Zlx7AqZ48rQaShfquzyMapi4bxSa5qydlFyXVoGn4oFYV20TZyAhgNrStbY5tlGCbex9RA==
X-Received: by 2002:a17:90a:bd10:: with SMTP id y16mr5007799pjr.108.1578497545665;
        Wed, 08 Jan 2020 07:32:25 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l66sm3782432pga.30.2020.01.08.07.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 07:32:24 -0800 (PST)
Date:   Wed, 8 Jan 2020 07:32:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
Message-ID: <20200108153222.GA28530@roeck-us.net>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net>
 <yq1r211dvck.fsf@oracle.com>
 <20191219003256.GA28144@roeck-us.net>
 <yq17e233o0o.fsf@oracle.com>
 <d42990af-78e4-e6c4-37ae-8043d27e565a@roeck-us.net>
 <yq1o8ve20sb.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1o8ve20sb.fsf@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Tue, Jan 07, 2020 at 08:29:40PM -0500, Martin K. Petersen wrote:
> 
> Guenter,
> 
> > "scsi-8-140" is created by libsensors, so any change in that would
> > have to be made there, not in the kernel driver.
> 
> Yes. Something like the patch below which will produce actual SCSI
> device instance names:
> 
> 	drivetemp-scsi-7:0:29:0
> 	drivetemp-scsi-8:0:30:0
> 	drivetemp-scsi-8:0:15:0
> 	drivetemp-scsi-7:0:24:0
> 
> Instead of the current:
> 
> 	drivetemp-scsi-7-1d0
> 	drivetemp-scsi-8-1e0
> 	drivetemp-scsi-8-f0
> 	drivetemp-scsi-7-180
> 
> Other question: Does hwmon have any notion of sensor topology? As I
> mentioned earlier, SCSI installations typically rely on SAF-TE or SES
> instead of the physical drive sensors. SES also includes monitoring of
> fans, power supplies, etc. And more importantly, it provides a
> representation of the location of a given component. E.g.: Tray number
> #4, disk drive bay #5.
> 

Please go ahead and submit the patch for libsensors.

> So it would be helpful if libsensors had a way to represent sensors in a
> way that mimics the physical device layout reported by SES.
> 

I guess it would be up to you to come up with a proposal.

Thanks,
Guenter
