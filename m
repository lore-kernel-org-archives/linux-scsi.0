Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF00DC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 17:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F5661D8E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 17:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhF2RXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 13:23:22 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:42920 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhF2RXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2021 13:23:22 -0400
Received: by mail-pg1-f169.google.com with SMTP id d12so19123300pgd.9
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 10:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QTB0HCn7Zcyl81LM2rOgVGcP9OEJYSGuZeueg/pgmGE=;
        b=oyI6zoc4o0asI20woR0P+DmVW2KITxym+OfbFcwUkKLl1Jz7rVidN3UZ+o0pMPsErf
         1U9qt92FY4IcBxnMkX77kJtF4zxd/3e6qzvze6ZoLvnfuPhn4MxCbZGTiFWF75AoXbj+
         ApJ08X7RF9K3iehn+cN6MGWnCvDQe42Wo77XRcT4z9lHQQiDXWSPXAFQ0zAiGehAuTT6
         A6UzqSfbqwDJkR0nBTJfjvTz84EMYVA77xgqiu37HGOkjwLl9fW1WrtP/QBJfwirfUYy
         FA9UR15GGDJtjzb1CzeEh+wTK+epRq0toxSP8392EN8Akj+vtu9wPsNrtoYj4ZxMsl7Y
         Opjw==
X-Gm-Message-State: AOAM531Rdlq33oyr4eFA4tmGxoTNh+gPH+q2Bo9BGKz3jIoXoY03YoS5
        aYbcrr1WwWohkfMJA0MciRy+3lhTuCE=
X-Google-Smtp-Source: ABdhPJz/t5UZ7WtCY2qaCPNw1I8HjruGgeq4T74munl73ZI5kzq5/DH4RUePY868N2aFUFZQbSF4Ww==
X-Received: by 2002:a63:fe51:: with SMTP id x17mr19405848pgj.58.1624987254202;
        Tue, 29 Jun 2021 10:20:54 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r14sm19173594pgm.28.2021.06.29.10.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 10:20:53 -0700 (PDT)
Subject: Re: [PATCH] scsi: Retry I/O for Notify (Enable Spinup) Required
 error.
To:     Quat Le <quat.le@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20210629155826.48441-1-quat.le@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <53010dd3-7ec6-3e32-1dfb-3608483f62a0@acm.org>
Date:   Tue, 29 Jun 2021 10:20:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629155826.48441-1-quat.le@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/21 8:58 AM, Quat Le wrote:
> If the device is power-cycled, it takes time for the initiator to
> transmit the periodic NOTIFY (ENABLE SPINUP) SAS primitive, and for the
> device to respond to the primitive to become ACTIVE. Retry the I/O
> request to allow the device time to become ACTIVE.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
