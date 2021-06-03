Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCB4C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D3B600D3
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhFCRUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:20:30 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:40856 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbhFCRSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 13:18:20 -0400
Received: by mail-qt1-f170.google.com with SMTP id i12so4904973qtr.7;
        Thu, 03 Jun 2021 10:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w0exjtZ15/jxZ5appQWYmEfz/5/RSw8ZiyvtjDQDYXo=;
        b=Ukb4v1ha4SLkwCDpxPfZJx7IzOAC2os3Hte+6pTnbHFTHaZIoduzTVnSHvJ3C/8j28
         FwaMNxlAtxen75T/MAl8jz5/RvKNphj8Ul0idJtgnxFZTWrX5QSF4b6Wy9sc34wlQ0Gk
         eYZeaFBuN0CkOwrKbt9HTAktTb+GZjSCbgROnUvGCyMd3bXtCzDZiOHhS/BC1+Af0OT1
         I6oP1kNnbl/RVay52vQP8RUvl4SCvlwznmjx+pALToPP5MMDD3gp8/f36W89GodqVGz0
         HTz9iZcPVuik0CUoSeI2VK44O6D6is/Zj/7ugUkVp1yWiff3bMSOM03tKvW24SZgAKMT
         7HUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=w0exjtZ15/jxZ5appQWYmEfz/5/RSw8ZiyvtjDQDYXo=;
        b=qG2uVjllThRuPi362kDLyHo1R3xTLCjk6vxjcOuaELF8w22n3JfLJqu39n3qUd9wAV
         pQRwDmKbSS9bq754hsHEBOFbfZakiCJmH7AJcNEPzU139SN7vjTrSehhmd2TiNdbsVN/
         KlXBKlFWHrgs5D8mPe9w8rPi3itOTIRzFhJkDy0NRpxtBQiy0qHgsp8YUeEh0In3PHBF
         45nmQU2MQz8ae7d2rLTrrj1waXQHEpxLDDQrFdr3QBDJq9KXgE33CPvhRe6/AZZuzwVI
         T4j/cTZ8KGKV8GzT0VTz8T3hSIvG3AqSsEzgF0YosNpKs1WQDmtQ17X1+PSFBZTaWTnZ
         MnRQ==
X-Gm-Message-State: AOAM530qmgXJkh3pSmPX5azg8NRezoglGKwSt6a5gmrzQIz/IpfAmm3h
        4VOd7IXcSyVqZhp8M+CwtKA=
X-Google-Smtp-Source: ABdhPJzJlJJs0A63qDpwwMabAHWI5tlTd2iZpCNLj0CRyeDrkiQDV+LQGLgYlDXXdThf4pzCcwmgiA==
X-Received: by 2002:a05:622a:309:: with SMTP id q9mr497487qtw.320.1622740535479;
        Thu, 03 Jun 2021 10:15:35 -0700 (PDT)
Received: from localhost ([199.192.137.73])
        by smtp.gmail.com with ESMTPSA id o143sm2322483qke.16.2021.06.03.10.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 10:15:35 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 3 Jun 2021 13:15:34 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v10 02/13] blkcg: Added a app identifier support for blkcg
Message-ID: <YLkONg69icwTD+bD@slm.duckdns.org>
References: <1619562897-14062-1-git-send-email-muneendra.kumar@broadcom.com>
 <1619562897-14062-3-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619562897-14062-3-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Wed, Apr 28, 2021 at 04:04:46AM +0530, Muneendra wrote:
...
> +static inline int blkcg_set_fc_appid(char *app_id, u64 cgrp_id, size_t app_id_len)
> +{
...
> +	strlcpy(blkcg->fc_app_id, app_id, app_id_len);
> +}
...
> +static inline char *blkcg_get_fc_appid(struct bio *bio)
> +{
> +	if (bio && bio->bi_blkg &&
> +		(bio->bi_blkg->blkcg->fc_app_id[0] != '\0'))
> +		return bio->bi_blkg->blkcg->fc_app_id;
> +	return NULL;
> +}

So, there's reader-writer race here but if that's okay for the use case,
please note that with a comment. Otherwise:

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
