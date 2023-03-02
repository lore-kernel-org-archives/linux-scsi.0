Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555C9C678D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 23:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCBXqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCBXqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 18:46:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6548158B6B
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 15:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677800703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f11kuWZJE+NowQuTEKEOvpAfqWTae8R7Zq+zDIWjYdQ=;
        b=P/V++5OWsXMy5cecEiaBVYXBNQagD2vswAauYrd0xd3yOAGtGpuvImHjmfaw3soHC4ZIXC
        4FWoy7qlv0xjLrSO/X4fyPauxOkig1Y9y6djkmvuVir+a8mKnY/ayGrdjUHEsp0bjlyd3f
        R5aR9T1QGTTRMeykZx2n/ZhHJzFkgEc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-G7bR26UbMYWZQRHIUuDJvg-1; Thu, 02 Mar 2023 18:45:02 -0500
X-MC-Unique: G7bR26UbMYWZQRHIUuDJvg-1
Received: by mail-wm1-f71.google.com with SMTP id r7-20020a05600c35c700b003eb3f2c4fb4so250963wmq.6
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2023 15:45:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f11kuWZJE+NowQuTEKEOvpAfqWTae8R7Zq+zDIWjYdQ=;
        b=DWsUwWNpFR29iUdgGa0GdpTeYqIW7hGF9WXM7lv6q5a8Sq0uIe2Zv14ZktZQpZR9S6
         kuQC9JaMsWu/mVAjKqQbh3xwZ0rl9nBWO3mDZJS3BKHt0v9QMzhgMXH+tVYCmjwzGii6
         CVbgOgDrRYg0rwbNMmNcqzebSz5OdEw89QyIi725hRaYBpG9j0gqpgo8DbpeFLKC9m/0
         rLXnTqJeyVFvmgip0EW1pdl2rQ1gZ3jN0L3yp2Rq+inE+/IU1a2pPGj21LGIYkMdgqQ+
         Rj3+6JWXQpXy+PocCMDd6EW9xTDrZIQtP3iRSJVvvkXZbmsrtQMOP5rmc2ylOImbDuaE
         /auQ==
X-Gm-Message-State: AO0yUKWFdGYN/AENLf0JXdWc1M6SyscpLczUSQ14Z2fvdVOR2d8BPcv5
        PJsQEy26w93qOm2RvJNpF7LSmeND55bcUv4+DKV19bWE+z3ErFbUYgIh6KWQkaEXFtta+E/TK4v
        7Bh8If4f5Ympi7Hx4RXGTBgJ/6hn0LFntDbLJz3a92nkMnsxz5PwDD3nZQC0HmUf94M9rVxOUtX
        z/
X-Received: by 2002:a5d:4a51:0:b0:2ca:fd48:7c1e with SMTP id v17-20020a5d4a51000000b002cafd487c1emr41143wrs.48.1677800700142;
        Thu, 02 Mar 2023 15:45:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+CB1Cle2HQ6PRJvRiWtxygEhdNu4gsS45Ks7+UhiQh5L/z7EU/r+P5vDui6zHPFx4ySeqCVQ==
X-Received: by 2002:a5d:4a51:0:b0:2ca:fd48:7c1e with SMTP id v17-20020a5d4a51000000b002cafd487c1emr41132wrs.48.1677800699744;
        Thu, 02 Mar 2023 15:44:59 -0800 (PST)
Received: from [192.168.0.105] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002c7107ce17fsm626448wrq.3.2023.03.02.15.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 15:44:59 -0800 (PST)
Message-ID: <b6c3a711-5f55-b892-927e-bcaaafb43655@redhat.com>
Date:   Fri, 3 Mar 2023 00:44:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/6] scsi: mpi3mr: fix few resource leaks
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
References: <20230302154826.5862-1-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/23 16:48, Tomas Henzl wrote:
> The series applies on
> [PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
> from 2/24 posted by Ranjan.
> 
>  drivers/scsi/mpi3mr/mpi3mr.h           |  2 +
>  drivers/scsi/mpi3mr/mpi3mr_fw.c        | 62 ++++++++++++++++----------
>  drivers/scsi/mpi3mr/mpi3mr_os.c        | 24 ++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_transport.c |  5 +--
>  4 files changed, 65 insertions(+), 28 deletions(-)
> 
I've found a bug in 5/6 and sent a V2.

Please drop this one.

