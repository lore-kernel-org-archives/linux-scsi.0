Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29984C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC57520722
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6SlKrUX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCWQSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:18:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36087 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbgCWQSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2020 12:18:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so150332wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2020 09:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xF+PTlSsYmqirCLrR+uxHMJf7JcvtXd0AmnGJd/kXc8=;
        b=V6SlKrUXbvQqJNDb9S2E4usW44QLU5RGCijToCwmcP1NoM5o71HiK7Gu0SKax+Su12
         Mhj/CVT7Tshxa2UGmIB6+ThjFj+kCE+XavKICWD62vi0QcocfZ5wI0fdrvJyeicPuRJw
         Fz+mAdbuH4k3zpbuu87BQN/uV4sUhUNSn8YZ5y28qWAnBscx09gwGlfnGXIZZPUdeQk4
         q1pAn/JLqHxB/cVyb7zcjEX1BhPRVKd30nD2wrHIaVKXdQVdQCwKGNtwXqyWOXs2so0n
         XxGwACvNlQJCcEXoCF7ke8vJiD1D8gELPaPV7P170Xm6o34rBmZuHh/18422ofO0UffI
         +6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xF+PTlSsYmqirCLrR+uxHMJf7JcvtXd0AmnGJd/kXc8=;
        b=bIDiNt10Avl5/5qIpxpmadu8rsUClbPNYLGa7gla/NveG5E+RrBi6+N57s11dmXyyA
         ihaFje2iwgg25/OZ53I7FuTBQo+kDatSuqx/7dfInWmbqlRxyDlWOarx+LRlhECDoUe7
         U5g8OphNZotWTzzsZMEqJiEltMbTz4QXD0M60lEVEn9uf+6mzZfCbl32EQi2Jxm6lf0N
         G4qofXwoKDkUc5GkrAqWlMDulNzr3MPU/TzfA92aMw+qzf3PkNgTOQw+lidJMSwBxpce
         N1q+Q0fR64BqHzYwzns6f13GB3WXYenTIHVsrQzdeZnUkPSKbhy1upkFkadKYVpCfubT
         JVcA==
X-Gm-Message-State: ANhLgQ27GHwu5lP3/jlwiWLtyWhdxMA2dPMNmWDh+AOxvKU0TS9j8fb3
        eLBQwEqh5LdySrDVL8lxJOzjMWal
X-Google-Smtp-Source: ADFU+vvLcY+UH1e33Ief2ViBRngz0lDqDpsJQ5WXjjLIzRuu+qcOtgfknMDboC0+a0rII2lXqu/MwQ==
X-Received: by 2002:a05:600c:2943:: with SMTP id n3mr7153295wmd.119.1584980331706;
        Mon, 23 Mar 2020 09:18:51 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id a8sm40824wmb.39.2020.03.23.09.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:18:50 -0700 (PDT)
Subject: Re: [PATCH 09/12] lpfc: Change default SCSI LUN QD to 64
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
 <20200322181304.37655-10-jsmart2021@gmail.com>
 <20200323110506.2izkza66c35icact@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <31b05e5e-90b0-87a1-7e31-d54acccb2e12@gmail.com>
Date:   Mon, 23 Mar 2020 09:18:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323110506.2izkza66c35icact@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/2020 4:05 AM, Daniel Wagner wrote:
>>   # commands per FCP LUN. Value range is [1,512]. Default value is 30.
> 
> The documentation should also be updated here                      ^^^^
> 

yep - will repost this one patch.  Removing the values from the comment 
as it not really necessary. All values (min, max, default) are specified 
in the macro.

-- james

