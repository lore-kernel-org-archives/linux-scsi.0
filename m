Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69AAC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 19:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986EE204EC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 19:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lfkmiNvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbgHQT2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 15:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbgHQT2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 15:28:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B68C061343
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2020 12:28:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d4so8123132pjx.5
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2020 12:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/K/jgK8f2b3gfIxZCz2aodMs51/j1UmWIbA0xQ4Rg4o=;
        b=lfkmiNvf7aWyMq4W/ABS66AbSGwPDK4/gSe7KpUo1u+V3ZDzJYaa4SZCJM35LFoSeq
         uypWUeCVnbtPuTlC6Lv32YnGX41etwb0Tro5sTqJv62MgvvHNClJfRyjsQ85Ou5LahfA
         L3x2mLvPon1Pa5RiuLmxjerV4ytCXX9sKlZ2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/K/jgK8f2b3gfIxZCz2aodMs51/j1UmWIbA0xQ4Rg4o=;
        b=gElDQEwSlNYRj1zFQrAjI3wkjDKwfmOVre2MIpUEEE+N8niZhlCxpvBFCaEHxCxNAx
         VECcofpBf4lxXlF9MqCxKqkzfldWjO7H6CZ3K9bNR8r0RxB+517ksdeRBM6pLPZi1u78
         lONH50ZAQTOXznGottDBanQ0sO4aOjTFwx8MhIqtOzVdngH1R9ptCQADyYhN3HtFg+rI
         erl8YCjIIojCf5r5oCQHlH8ngLZP2zHq+3xz99GmdnegiYuOv5rfuMYbFN8obFeE/Bc8
         NMcbIR/ZnfBhoAkHiqBbmljc9veZcJM6HaojIDbYkjZ+rFhLvg8vVZ7xzoPfo4Q+LcMD
         8h+g==
X-Gm-Message-State: AOAM532onBjmXfJXv211NHWv3zyCE56uCSphc1biIxcXoxYt0fjmHgRR
        bV+cvxSu7lGf3ireAry7Yo5Gyop6A3hsDQ==
X-Google-Smtp-Source: ABdhPJxQXWN+Ph7ND4lvHYfqN6PVhgPAKtkPfn8HjEia6Dm6hV0gw3K3eYh80/xzuqoQhRxCjmbyAw==
X-Received: by 2002:a17:902:8210:: with SMTP id x16mr12901228pln.166.1597692494753;
        Mon, 17 Aug 2020 12:28:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b25sm20700960pft.134.2020.08.17.12.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:28:13 -0700 (PDT)
Date:   Mon, 17 Aug 2020 12:28:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Allen Pais <allen.cryptic@gmail.com>, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>
Subject: Re: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
Message-ID: <202008171227.D3A4F454D8@keescook>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
 <1597675318.4475.11.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597675318.4475.11.camel@linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 17, 2020 at 07:41:58AM -0700, James Bottomley wrote:
> On Mon, 2020-08-17 at 14:24 +0530, Allen Pais wrote:
> > From: Allen Pais <allen.lkml@gmail.com>
> > 
> > Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> > introduced a new tasklet initialization API. This series converts 
> > all the scsi drivers to use the new tasklet_setup() API
> 
> I've got to say I agree with Jens, this was a silly obfuscation:
> 
> +#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
> +       container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
> 
> Just use container_of directly since we all understand what it does.

But then the lines get really long, wrapped, etc. This is what the
timer_struct conversion did too (added a container_of wrapper), so I
think it makes sense here too.

-- 
Kees Cook
