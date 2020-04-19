Return-Path: <SRS0=TURL=6D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC24C38A29
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 23:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24D0212CC
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Apr 2020 23:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSXpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Apr 2020 19:45:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43470 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgDSXpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2020 19:45:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id x26so4144108pgc.10;
        Sun, 19 Apr 2020 16:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CrqKnZ+k5l2QZX6/uqTqY1+c3SN6iLTRsy5dQjx1nY=;
        b=BMXAvLU0Php+k+1C9vsu3N+tnVN5bEBYCG8NdJgkI47MOifnwGpYWvbLUVEby+vJy0
         R27Hrsn5lyAxPwzEvLHyPqOmQ8JHywqo0o4EUud/ERHWEwbugEV+DesamNs8xlZd++D1
         rWVn0MIyI/6HKk3KO3wIp/hacyDVqpyzOLuUs2W8WvwFOgnJAgRNnkCqaJ4czOOiNs60
         4oK8sUvdwmG+LKam9Y9zT8bFifLs3YAGo7PnxHBvUJriacsqsDFZUnoWhElVAF7k3OHv
         4ha9YQHIQ+ZwCukfOpVBdjfm7IBfEYD+6JQIkbfYQQB9TuSWt4hLuw2c/KZ02Vk/RR5o
         N36w==
X-Gm-Message-State: AGi0PuawFQQEY/bgKikfi+SzIbgmjPuTYt2Ztg+a+jUwG7asUFgwFiTY
        RslqoOI78PXmdxNDAmpGoOA=
X-Google-Smtp-Source: APiQypJC7exq8K1F5J0DXSbzLCmQ+/tC4dIbASQPVLjtJ76EyLfdOLG+dAFnsM/N9s4pmZzoiN8o/A==
X-Received: by 2002:a63:7901:: with SMTP id u1mr13381801pgc.409.1587339918478;
        Sun, 19 Apr 2020 16:45:18 -0700 (PDT)
Received: from [100.124.11.78] ([104.129.198.54])
        by smtp.gmail.com with ESMTPSA id my14sm2573205pjb.48.2020.04.19.16.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 16:45:17 -0700 (PDT)
Subject: Re: [PATCH] scsi: target/iblock: fix WRITE SAME zeroing
To:     David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20200419163109.11689-1-ddiss@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8883020c-0575-bba6-0a6d-e858b1f83e79@acm.org>
Date:   Sun, 19 Apr 2020 16:45:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200419163109.11689-1-ddiss@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/20 9:31 AM, David Disseldorp wrote:
> SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
> "shall perform the specified write operation to each LBA specified by
> the command".
> 2237498f0b5c modified the iblock backend to call blkdev_issue_zeroout()
> when handling WRITE SAME requests with UNMAP=0 and a zero data segment.
> The iblock blkdev_issue_zeroout() call incorrectly provides a flags
> parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP. The bool
> false parameter reflects the blkdev_issue_zeroout() API prior to
> ee472d835c264, which was merged shortly before 2237498f0b5c.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
