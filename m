Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8B9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 15:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CEE264E26
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 15:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhBIPtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 10:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhBIPtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 10:49:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1430C061574;
        Tue,  9 Feb 2021 07:48:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y8so24365595ede.6;
        Tue, 09 Feb 2021 07:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EHdc5MxxE9Sh4g9MhPbkHUF1trYkD5OS8srkwgeUE/A=;
        b=dOEoEnBnNq0hsnh5EgTbGQajS+vAqMzgKmSWgek8j6UlExwN3JflYY2vC34Kbtia5c
         BugzqI4ay47OnI8BwYmxKWKAWVKRfgsPVg7oNVtXxtT7bZA6NT2G1gW0BeLcSohk75jq
         FUp3EN72bqEEoRJn6y4x1+35yHl2lps9WgCDPa6eGa3QgB2G9J3PLIrlvrqOIlGlkT7t
         +o68kC5hPwfaqp8Ch+Lv6M8r7Ig2HWMndlW638GGIHee5nr+Z8qq1y1PI66yd91muddC
         PEjqQ++rhuKvDF4keh1m7/vQG+SipwHa2bWnjdMfLtHbHNMBIq8O3/wi9nV0jYCyXFHD
         ao3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EHdc5MxxE9Sh4g9MhPbkHUF1trYkD5OS8srkwgeUE/A=;
        b=dPB1xI35XTR9at4X19fVspbbD9P4SrIAcmeeV5nY2qC8ROZ0H7+5k/TQAqPlCdqhY7
         QxeEb70M/GasHwe4BH/VBTyYlNmolv0WzoWQDwCstd7OqM7LR+cie9Rn/W5XpOR4UmDb
         6SfQkM/8UwKyuSNgW1dLLJ06rA7gHJ7jbUOMwIPS7ZhOYQrdRnjez41ww4I94iXu56Hk
         rt5G3EPfMHl8cJcFyT/wV6D+bNue5zS7qwbc44HiB7fRVZSRFT9ZZxt3q0qFSSAvSpxc
         ZuEl+hPBj3SDB7x9WKckUSgOph+xm1bjydiD+v/5pltyYUITaHHZ9kwciu+pgsnM3bSg
         uqaA==
X-Gm-Message-State: AOAM530EBtKVjoJor8B+82rXrSuz/z6wDlaTbu2vSROUyJOhmnewylxm
        JdOmAblxQ3lpbQ2Ut6D+ThE=
X-Google-Smtp-Source: ABdhPJzxpLkfRbz2TBifas2PCPNxE2UnYMjPRVXkthKEk4fbHxsCLK4awEQ1I96GOy7HtIEukjwURg==
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr23644609edu.170.1612885704808;
        Tue, 09 Feb 2021 07:48:24 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id u17sm10849511ejr.59.2021.02.09.07.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 07:48:24 -0800 (PST)
Subject: Re: [PATCH 03/13] target: add workqueue based cmd submission
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-4-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <206a3f41-dea8-2152-4811-817138ffb580@gmail.com>
Date:   Tue, 9 Feb 2021 16:48:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209123845.4856-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 13:38, Mike Christie wrote:
>   
> +void target_queued_submit_work(struct work_struct *work)
> +{
> +	struct se_cmd_queue *sq = container_of(work, struct se_cmd_queue, work);
> +	struct se_cmd *se_cmd, *next_cmd;
> +	struct llist_node *cmd_list;
> +	unsigned char *cdb;
> +
> +	cmd_list = llist_del_all(&sq->cmd_list);
> +	if (!cmd_list)
> +		/* Previous call took what we were queued to submit */
> +		return;
> +
> +	cmd_list = llist_reverse_order(cmd_list);
> +	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list) {
> +		cdb = se_cmd->se_tfo->get_cdb(se_cmd);

If I got it right, get_cdb is a new, optional callback.
So, should we check, whether it is set?

Maybe the check better could be done early in target_queue_cmd_submit.

