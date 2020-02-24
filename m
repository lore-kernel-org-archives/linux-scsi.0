Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6466DC38BE7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C92A21744
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 20:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="SSIU4cLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBXUSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:18:43 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:50679 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgBXUSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 15:18:43 -0500
Received: by mail-pj1-f53.google.com with SMTP id r67so240029pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2020 12:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AsAkVqeBlUTVNMBFWbPGk3JGWoog8P01z4Gn0jtsTzU=;
        b=SSIU4cLlI2n2qbxmevdwvOEapG9ngx6Anv8KODNUhHrGmYkwT+Vofd9rZbxyHYkKrL
         OxIz6NSZEnenQmkNwJTqQ7MX59IDkoyi5+gbn6dZSi/Vmqw2XCm1CT1uozT+GL7ce+3I
         LkkDnNqFQ5GJLRTLckEy6NzC4iL9ezTOdrkohbZ8ObYNe5mKFiQ/hXG32lxMg3M7PXH6
         RwO3R25e38NobOg9yVRKix9CgSdWvD1Sk80l+Z5DSkfFYtF1zX3wjPB0Tx2vMiP8SPnd
         MiuDWaNOseXqsfnYBNDDkZWqHqMUP1nXomlnJbj5nzcgYwftoxxDbjvfAuOOH+hQ2PSr
         mD4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AsAkVqeBlUTVNMBFWbPGk3JGWoog8P01z4Gn0jtsTzU=;
        b=rPAVldF6wGfyFwZ0Qk1DlfHqlbZgFNmhBZbjBu2wbw65bbwX6F7M18tjj9kgA4qN4r
         v9dQ464v9kkGEw35OXCIvDFb0SqYnEZNm/A4Y+tkAUrH4lhZ3CIbbcCCCFvJdXCG9CO5
         8VaGN17wW04x3iWPFRB1TAoYl3NczbIxlr2JIe9Iad6RflQJU8xYEr0+NoF7hKEJSwJf
         YGbmCQWRACx2cYZ8s7fwckE1i4qXNCpH9JFuy/HHq1+Tc0AZlQ/0cc5dyrYl8UMWWHEw
         +lWWZpOxizc5OL5LpRCTazJAul9Vfz18O3OHLdoehMBCz9RbVhgJSXOeoCRXmbV2ZS8g
         IK0g==
X-Gm-Message-State: APjAAAU71z8WGLciS4F5F8IoKd3M4UADe7Ro/CxDsI7uIdayFVti5QZK
        hYfRbxcnkIRuVQphILqfierD43CuG2E=
X-Google-Smtp-Source: APXvYqzMuuqbYsAPQLvRqQa13jz2PshPPsaVA7gSaadKM9nV82v1GczAEn13xMLYijD8wngok8Dx/g==
X-Received: by 2002:a17:90b:11cd:: with SMTP id gv13mr955512pjb.94.1582575521719;
        Mon, 24 Feb 2020 12:18:41 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21c8::10cd? ([2620:10d:c090:400::5:9b45])
        by smtp.gmail.com with ESMTPSA id e2sm300316pjs.25.2020.02.24.12.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 12:18:41 -0800 (PST)
Subject: Re: [PATCH] compat_ioctl, cdrom: Replace .ioctl with .compat_ioctl in
 four appropriate places
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adam Williamson <awilliam@redhat.com>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Waugh <tim@cyberelk.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200219165139.3467320-1-arnd@arndb.de>
 <yq1eeujda1d.fsf@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9d25fda-e3c3-e6b6-0189-93fbe7c5f743@kernel.dk>
Date:   Mon, 24 Feb 2020 13:18:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <yq1eeujda1d.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/20 1:07 PM, Martin K. Petersen wrote:
> 
> Arnd,
> 
>> Arnd Bergmann inadvertently typoed these in d320a9551e394 and
>> 64cbfa96551a; they seem to be the cause of
>> https://bugzilla.redhat.com/show_bug.cgi?id=1801353 , invalid SCSI
>> commands when udev tries to query a DVD drive.
> 
> Applied to 5.6/scsi-fixes. Thanks!
> 
> Jens, I hope that's OK? I keep getting mail about this bug.

Yeah that's fine, thanks for picking this up.

-- 
Jens Axboe

