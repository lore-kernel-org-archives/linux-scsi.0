Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EEBC47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F7F6128E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 16:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhFHQ0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 12:26:47 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:36695 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhFHQ0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 12:26:47 -0400
Received: by mail-pg1-f176.google.com with SMTP id 27so16938471pgy.3;
        Tue, 08 Jun 2021 09:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GKsAC5z/Iu/LTxX4655tHyqfNkomTOXhGmHwlaRCO+o=;
        b=UZkUAV+SIUqXeglvc4HABq8U2sDedEr9D9DWRl182kmvxj5dU27WFpC+Cmew3RYCl7
         gqVnQSHct63eCeZBZSs1FVoUEaJS56cJcd/yWbK1usrMM6yx7PKnXle81kYacvUcjPlK
         2fKal7DEhPLGAmpka5/DAwntAErVd9uDWiWDcxBcBktY+YfAZuEaa9iPb5PBXcF9OYZg
         KyAmO6BRdVqzUkTc5wrQtbZcgu2pV+f+51TAYEnT9yUW9OtUlYKIsSzumJZVsuplcs/i
         7IuV+TXy6YznU+muFD8l0TX+hgXb5+wmX/Dj2u0Vi7WJS7vkb9ukf+zQJV2Hv36hx5Dz
         foYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GKsAC5z/Iu/LTxX4655tHyqfNkomTOXhGmHwlaRCO+o=;
        b=RD8hPLvfSJCjZGmsjBCX8SlyRRiw+A2xXcZQJL81SFWlg09vR8GL1WTTvjk38rOgbA
         oQFsDsz+RjzvaGsAqdFG9/gg+jExy5uqLHPAODqPZ5Ay7hZ4Xy/+4O4J8nsvqj7ORiRF
         r9zoEWYs6us2xQCGq0MLcUHMiyhOnRjuzmYwgu0BzpzfixhgUEscTqCQAsF8nI2poizS
         1r3REeoQ/vaEefzsCH+P1ssbynq8J/vhoHphz2v3ak+Us7lDqgrFqYa1MKeZfaibbBbM
         gLWpBupAPxfEf69mAZ4RIfz1lOF7hZz5VUJryEMUa0tzUg0JtyvY9+fRTACTAtvTJn9Z
         03aQ==
X-Gm-Message-State: AOAM532G6tRMN5UMMOS6sxij7x/mYuABSRpmVdzAIOFWdcoASdTHWml9
        8qpxP+eUrJ5AnFa39dLMot8r7kyLGB8=
X-Google-Smtp-Source: ABdhPJw315v6BKrc0EkHUBxnLxXWpH6rTk3RHAxEa5ucSJ9hb6hB8LWOkXtFalPOux5WZlPNE2wepQ==
X-Received: by 2002:a63:f40d:: with SMTP id g13mr23827789pgi.290.1623169423657;
        Tue, 08 Jun 2021 09:23:43 -0700 (PDT)
Received: from [192.168.0.217] (ip98-167-23-218.lv.lv.cox.net. [98.167.23.218])
        by smtp.gmail.com with ESMTPSA id m5sm12233001pgl.75.2021.06.08.09.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 09:23:43 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: lpfc_nvmet: deleted the repeated word
To:     lijian_8010a29@163.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
References: <20210608072133.272091-1-lijian_8010a29@163.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <163450ca-7a73-bbfa-cb91-475bba9928f2@gmail.com>
Date:   Tue, 8 Jun 2021 09:23:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608072133.272091-1-lijian_8010a29@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/8/2021 12:21 AM, lijian_8010a29@163.com wrote:
> From: lijian <lijian@yulong.com>
>
> deleted the repeated word 'the' and 'received' in the comments.
>
> Signed-off-by: lijian <lijian@yulong.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>

looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

