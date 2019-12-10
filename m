Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ED4C2D0BF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 18:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3EB20836
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 18:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLJSAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 13:00:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33668 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfLJSAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 13:00:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id d71so9228273qkc.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2019 10:00:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2RPEMTVZm8pY71xaGDdgN7I8E359aw97gycQfzKJFCI=;
        b=b5uCKQxJnaUu4FSqv7EoXDasSDM2J41WeoQOdCLdSHmetoT7kLEktF8o0aGYpT182+
         gtEnA2HAW5XxYLgU5lTUX7AwU3qRI1TbgK6UQBaz3DVDZAFtCZQtedkjx4FGlgSgz0yg
         OGqHGoDYOrgzmDyAjjd+Fl04p7t2tINTS13sTxuBuFFgX8mB5WTbzswVsf1I/Mn8uZN9
         lTWt+0uKaY0xOiyj/zTlYOk1Dc4yLPq4l/PdvL7JRnYWrrMMEDqXmi+Wabr3nodcZxCE
         zEYR6Bv3J1aWcqNZIqkYMUZ240zWwjOWeUjWWAxjI3Zf7/3ph0BTaKKWwoor6FWiWW3k
         j+LQ==
X-Gm-Message-State: APjAAAUKIBH6deMY1P9+XA0gyblNHXh1aWBaH+5baEKIQqK8qEuYSYuT
        dNlNFz/YsGu16sOwah6gxOU=
X-Google-Smtp-Source: APXvYqzWclVFNbtS1s8GnXOJwc6G5EYneIVFYZyDiwXF7sOWrtpDIBFBIFQ7cxmwn5B/Z7ExhQKBUg==
X-Received: by 2002:a37:7686:: with SMTP id r128mr32843640qkc.277.1576000823137;
        Tue, 10 Dec 2019 10:00:23 -0800 (PST)
Received: from ?IPv6:2620:0:1003:512:62e9:2658:28c:bd76? ([2620:0:1003:512:62e9:2658:28c:bd76])
        by smtp.gmail.com with ESMTPSA id k29sm31923qtu.54.2019.12.10.10.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 10:00:22 -0800 (PST)
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
To:     Martin Wilck <mwilck@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
 <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0c381a12-95c0-054a-a829-4adf3da25381@acm.org>
Date:   Tue, 10 Dec 2019 13:00:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/19 5:52 AM, Martin Wilck wrote:
> Hello Bart,
> 
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
>> Restore point-to-point for qla25xx and older. Although this patch
>> initializes
>> a field (s_id) that has been marked as "reserved" in the firmware
>> manual, it
>> works fine on my setup.
>>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Daniel Wagner <dwagner@suse.de>
>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value")
>> Fixes: edd05de19759 ("scsi: qla2xxx: Changes to support N2N logins")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/qla2xxx/qla_iocb.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> Having followed the discussion between you and Roman, I guess this is
> ok. However I'd like to understand better in what ways the N2N topology
> was broken for you. After all, this patch affects only the LOGO
> payload. Was it a logout / relogin issue? Were wrong ports being logged
> out?

Hi Martin,

Without this patch N2N login fails for 25xx adapters. With this patch
N2N login succeeds for 25xx adapters. You may have noticed that Martin
Petersen asked Himanshu for advice in another e-mail thread about how to
address this regression.

Bart.
