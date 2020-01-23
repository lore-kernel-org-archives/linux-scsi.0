Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070EBC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC1B1206D4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 22:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLTGDOZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgAWWYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:24:11 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:34032 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAWWYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 17:24:11 -0500
Received: by mail-pj1-f50.google.com with SMTP id f2so25103pjq.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 14:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OHsqfkM66Et0yHbJc48Vy9BExS+CkNAPI7mBLuUS5dk=;
        b=vLTGDOZ0aKkWOx+UJUxDViSEZvjQj7hZyD/MzEkzr9ikuzojAP8QOsmICdE4Zh7whC
         F6WCQcb/0AZ0fdXYszqU+aTi38v2CdB8rMLThdFfU+7Ycnlk0bRJLr9mRlUwGvLAkBx2
         M/0Ed6K3ek3t/hhLjfF7anJATxn2P3bm0vSjKJIE2XIoAaw54R1qqkDVzoe6Oor49aTE
         8iguo//t4b6oL45+RvsYfiHxp/27Y00g/oS8lNC0lXzxmY/lNNtctctCJHK1C5jGJTzG
         f1Y+kz2KM4/E5Uo88Ly+LSh+v6ZH1ravVkEj1NpzYw0SF061qzUtCMljSORPxhA9apJP
         5QXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHsqfkM66Et0yHbJc48Vy9BExS+CkNAPI7mBLuUS5dk=;
        b=po6ZZvFIWMmGI5jMwQK5+NhuhpgcRUmw7nh/d0l2/RFuKmUI7sDJ+BdfjUr4Q84uft
         JO1C9oeNqrG00bygP+8FNlfgYlDbth3fVvjjlfz4Xryhs9drJwwwktdPvnMMOQ8e8YTG
         jPGoQX3wo+Ipo+xbMUIeMpF70mabXA/4nIGSU8zNC0NCobwCReTsyBorw0lcBSuMzJav
         kRyBlde4XIbBq9Ark0G+o9BweUALt5X70xCjY1jQyezD3odQt5fyI37t+IE5r4XxU59y
         alu/YbPClPCZSLf8TGQJZ3x21ogu9FgjIry5+1TRz6TpDpU/uKd3J1uxKEPXrDkim58O
         b5uw==
X-Gm-Message-State: APjAAAVNGqmKNUmwXYFac5uSmyWAMd9LyZRpg77/HS6e8iyEKdcwi4M7
        RL61UCNxOTQ/ObeScdaM1PMweznL
X-Google-Smtp-Source: APXvYqy4eypW8goP0VJIXn7kpeq7+51EcmzSoFtGXL/2T46pRZGGvUEkTzVQKnvAsj07irjPonQtzA==
X-Received: by 2002:a17:902:6b82:: with SMTP id p2mr322035plk.259.1579818250424;
        Thu, 23 Jan 2020 14:24:10 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q25sm3641790pfg.41.2020.01.23.14.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 14:24:10 -0800 (PST)
Subject: Re: [PATCH] scsi: add attribute to set lun queue depth on all luns on
 shost
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <20200121235302.9955-1-jsmart2021@gmail.com>
 <eba0f027-f2d0-7209-c34d-78b0b93a9a78@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <ca8e0a93-6fa7-aa8a-b415-a611084b7aeb@gmail.com>
Date:   Thu, 23 Jan 2020 14:24:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <eba0f027-f2d0-7209-c34d-78b0b93a9a78@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Bart - please see the v2 patch set just posted.

-- james
