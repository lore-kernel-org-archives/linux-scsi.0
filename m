Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABBDC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3D764E56
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhBIRCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhBIRBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 12:01:52 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71BFC061574;
        Tue,  9 Feb 2021 09:01:10 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id y9so32800874ejp.10;
        Tue, 09 Feb 2021 09:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HKQGutqsNJad57ADZUudBsFA2i/bHgO1qgxcmoZzwgE=;
        b=BEzKzyJLl8tAzO96+aBq9GPi7QYXzUILWp6aiuo9yjTp6Pl7RdyzZFAyeGzfA/MyqR
         ffEO/ngFyiGLFgSi4RIhpQZw4BeR0qUtRCEUtAkEQE7CpoLWP8iGOJudN90Wp++h8FkY
         Nds1YBCQrEM1PqZ8f62AMO6yFvGEVyJF69MevqMcIZgja0SOAVKX3godFb+21tY2PAxR
         EONd4G7zuJRhMH1Ueud+g0fv20uRhAzIBMp1R0ym5YTWaGqH12+uo5xj/N9lrlSrY3AG
         FGuw+CvzUOVPsYGkhvUixBY0XNz4Zm7Ttsxy3jbQe7wec5tZdxLKaZ00XRigz2Z4dLyt
         8JFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKQGutqsNJad57ADZUudBsFA2i/bHgO1qgxcmoZzwgE=;
        b=WEqPNAYJeyYtpZKM+whPsQN003fHJa0D2kAP+4qhRnvKcdJEoKb6P6lvzXzFQM54SY
         NIp2RbAGTfTNJ9qDky8T9AE6KAu1A5vOA5Y9WvbhgIAiSwh4DGs0VVmxX4OH22MPKkl2
         2suz4cZ6bLZuC0m5CpROe6WbYxfGjnnyq41I83ovXTSVdwBXqpX3EUa34XZgy/MX0H6O
         tmBGnhWI29ROc6lGAi3oV5uvwDyN9e0ME/DNPxzsT7YIcf55l/bceBiJnC7F9oqUyGWU
         +04co2mW8+iTR33aBpWHeIqliUoMdfuGnzwi6GVDfhyTaN4McnnwJnJk+bFxsU4kZajq
         ZhEA==
X-Gm-Message-State: AOAM531zbVRnd4cagh3cRzOjgRLzmtv43BBKjUuyjN8MVvieiKazaYjk
        fZoOpn7YMMTcjk4CxRq987bsuLtWdjo=
X-Google-Smtp-Source: ABdhPJzO0ayyMmhoSrE0o1a+9OkjhLj2DdII01nWLAF92uEzfA7AuUhP4dU5fqt8v4InSMYIXhLUiQ==
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr23680433ejd.119.1612890069599;
        Tue, 09 Feb 2021 09:01:09 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id e20sm6581093ejr.80.2021.02.09.09.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 09:01:08 -0800 (PST)
Subject: Re: [PATCH 11/13] target: replace work per cmd in completion path
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-12-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <3eda9fb4-1a9f-81b9-82e2-1c5bda1d7de4@gmail.com>
Date:   Tue, 9 Feb 2021 18:01:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209123845.4856-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 13:38, Mike Christie wrote:
>   
> +void target_queued_compl_work(struct work_struct *work)
> +{
> +	struct se_cmd_queue *cq = container_of(work, struct se_cmd_queue,
> +					       work);
> +	struct se_cmd *se_cmd, *next_cmd;
> +	struct llist_node *cmd_list;
> +
> +	cmd_list = llist_del_all(&cq->cmd_list);

Probably nit-picking: I'd like to reverse the list before processing like you did during submission.

> +	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)
> +		target_complete_cmd_work(se_cmd);
> +}
> +


