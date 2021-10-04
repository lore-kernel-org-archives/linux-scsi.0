Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89DEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49F86120C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhJDQam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 12:30:42 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38672 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbhJDQal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 12:30:41 -0400
Received: by mail-pj1-f54.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3137014pjc.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 09:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5AsdH3KzJmzJUZ07b9oWpIvHqBBCCuDKdQyND0UzE8=;
        b=ASCjERRDuZBoKyltxJj+3GJPsJq/V79I+KoA6h9hgBHEWzSXWuJbGfjDI/2qFY6Udg
         bngs8j13/KSzR34ucjxsqn8rB86CkTNKn7xZAR7KccKMr3rZurQQm+e8i/JJJG2sexIv
         uBHofIskDrfOHODeLNhlXztM/UnTMwHqUvBHOXBfm3OMuoaHSDo1EStLRMlj3aM86t9N
         /uAjnYS2RVcd/7s9/x7R06rRhwMma8MC6gRf8IayqEBluCuEgvFWGWiGf7yUTaAzdRwp
         Dy2yAzr4MG+pMbX9Wdj70fbEfOdKI/OqVkSi16IJXHJg1qrXU0iOdUtIWrYm7xEMhX/0
         28yA==
X-Gm-Message-State: AOAM533OgLjW/geZHcxgCxQq+gGdfUhNPib3ciBkoY4kxPfbZADZmmvl
        PXdmpGOrYm+fYb6hTKP1XSSJKOBLUoI=
X-Google-Smtp-Source: ABdhPJwJn6fT1BQkpuCcQI4cEi5vfxwnpXvIrE3JgZc0sQ/u+5rH7QoLXreD84Gyeequr8bYFJvnCw==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr4110084pjb.25.1633364932219;
        Mon, 04 Oct 2021 09:28:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:1e3d:a218:87c6:1612])
        by smtp.gmail.com with ESMTPSA id c12sm14850871pfc.161.2021.10.04.09.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:28:51 -0700 (PDT)
Subject: Re: [PATCH v2 57/84] nsp32: Call scsi_done() directly
To:     Masanori Goto <gotom@debian.or.jp>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-58-bvanassche@acm.org>
 <CALZLnaGvqNujPZz4KOZ7-SRvoYc5EvPwM0u2i5iVe7=9yiV0kA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <83febc0f-fa20-3270-f951-7782b768f9c4@acm.org>
Date:   Mon, 4 Oct 2021 09:28:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CALZLnaGvqNujPZz4KOZ7-SRvoYc5EvPwM0u2i5iVe7=9yiV0kA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/21 9:15 PM, Masanori Goto wrote:
> Indeed this is a no-op change, but in a different thread, one
> interesting question raised was to remove scsi_done* in the argument
> of queuecommand_lck, so that the change is much cleaner and generic.
> Could you conduct a research on whether it's removal or not?  I'd like
> to hear from the overall SCSI maintainer perspective too.
> Also, I'm curious why the IOPS was improved - what kind of device
> drives did you use?  Specifically, nsp32 was designed for PCI based
> devices so it cannot handle millions of QPS - so this change has
> unlikely an impact to the performance gain.  This comes back to the
> first scsi_done question on whether this overall framework should be
> changed or not.

Hi Masanori,

I will include a patch in the next version of this series that removes the
'done' argument from those SCSI LLDs that use DEF_SCSI_QCMD().

The script that I used to measure the performance difference is available
here: https://lore.kernel.org/linux-scsi/f293d333-3fd0-b62e-58d2-6ed388efa1de@acm.org/T/#m7ab39cf1c14016b833c935f897eb406e0011dafe

I do not expect this patch series to affect the performance of the nsp32
driver. All SCSI LLDs have to be modified because patch 84/84 removes the
scsi_done member from struct scsi_cmnd.

Thanks,

Bart.


