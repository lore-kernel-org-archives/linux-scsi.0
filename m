Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820F3C35247
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 19:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B3B214AF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 19:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfXohbah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBETB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 14:01:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33318 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgBETB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 14:01:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id u6so4137063wrt.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2020 11:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U+qJxb3ZXp1zqQtiF6fh5l4Kvo4Iu9S8mR3S3VxATHE=;
        b=XfXohbah7kftp10hrZhMqtLLNiuZHgY5qnOFOeVILoPUrXJewOvqTHub4IrBVa/3QY
         phR67NhSI5koWAbdFFycozLHYVULe7MIu3AsABsTo/Nz1dMZ0A3GH1t0fKzGWR70OJW3
         jBGcnZLJkaXf9M2XZRghnuYanNbvSm9Zitwb3M8IQWxMjtx3eiME7xwnONzyjAziFKOK
         A16F+ZF8dzBkqSx6grRIQscYYZlWBS5xZQtDtzwgGH9Juh4j/I8hOADk8zhHRKSjx2+o
         aYiJ85Hsx/RUKJeG9NviGEOeHxdfeIiPkI+0qMS5DW0y0440TdLXJk+MKMouK6n59ItZ
         JOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U+qJxb3ZXp1zqQtiF6fh5l4Kvo4Iu9S8mR3S3VxATHE=;
        b=fvQ6i3XSRf7ePEFXgRDj5pxiq2nUuIl7v+Zryr+BceAsPb/W33lIcpWS/dsr1KbKgr
         ldMgnv9W7+OAydz3sIQMUmHtNTpl2+woxc+SVl4pW/KOQ6fryatUNSR5fPvHROzSb9YJ
         BQTBk/kh2sM+FcWthz247glsWTKj8+Zn98lGktiH4AvGXj8v6PoTZ4JOssNBdmAsUrpu
         wHXY83e5FsqKOuxrK5hxOaVAm7FaaxYS07NAQjjXq37L1SP4gwXW78EHRKy3Mv/6VY9a
         zftTHS0d1W+PtwYAM6g8XHrnQo+L710TeDvjbgtUUCI6ljo/26WK6iLECDPIO4YgXUF1
         Df3A==
X-Gm-Message-State: APjAAAVbCBw/gwwTe1UxyQDVSbHTSZYZc4XnsBROUuZ0l41YNN3PiUN4
        4Jsui43f/++/h/zG9d0xBHXwJ++U
X-Google-Smtp-Source: APXvYqxTLl37BTAau+Y5h5LS/D6Rl5efex4jP0XAJa05v7T7DdjGRbUU/LvQfcLw9ZEVIcfEQrrSjA==
X-Received: by 2002:a5d:4702:: with SMTP id y2mr21212236wrq.37.1580929317695;
        Wed, 05 Feb 2020 11:01:57 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t5sm893004wrr.35.2020.02.05.11.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 11:01:57 -0800 (PST)
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 12.6.0.4
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20200128002312.16346-1-jsmart2021@gmail.com>
 <yq1r1z9zqjr.fsf@oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <7781d8bb-4ca6-c4bb-ab20-46e82a0fbea1@gmail.com>
Date:   Wed, 5 Feb 2020 11:01:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <yq1r1z9zqjr.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/2020 7:00 PM, Martin K. Petersen wrote:
> 
> James,
> 
>> Update lpfc to revision 12.6.0.4
>>
>> Patch set contains mainly fixes and a few cleanups.
> 
> I applied everything except patch #10 because I'd like to dig into the
> queue depth stuff a bit more. Especially given the recent concerns about
> device_busy contention.

I replied to the other thread.   It is independent of the discussion 
being used with the megaraid guys.  Just a way for the lldd to tune the 
max for the existing algorithm at run time vs at 1st discovery.

-- james


