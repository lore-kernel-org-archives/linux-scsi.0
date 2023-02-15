Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D92FC636CC
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 13:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjBONxm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Feb 2023 08:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBONxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2023 08:53:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F86B5BBC
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2023 05:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676469170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mV6In0kxefiNzNjwdGvvcAOJFXvOqB+P5nRMf7lRHCQ=;
        b=bHpvB1Grsb3WGOj3ba/aDizSIAplw6u2clUC+TfAiT6BEl+itoET30nAF8optIfI6KF+o8
        kpBsD2gnj1qwLrEoKLphNephnMp92/P9IOrOLgZ7xLVdL7gSx66Rhr91gP8xt5/onLHBtS
        uJ8zYdyHZzRMpj87YK8ka7f3wJiBjPg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-K2h8DKG1N-K5zX18ltTt7g-1; Wed, 15 Feb 2023 08:52:49 -0500
X-MC-Unique: K2h8DKG1N-K5zX18ltTt7g-1
Received: by mail-qv1-f72.google.com with SMTP id ob12-20020a0562142f8c00b004c6c72bf1d0so10481113qvb.9
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2023 05:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV6In0kxefiNzNjwdGvvcAOJFXvOqB+P5nRMf7lRHCQ=;
        b=BIZ4FwZXCOdirzO9tfviUjui8tgFu3Pplw+ohR8JCkcURZvLqcv5ukIiGhaRn+vFar
         diAYMil6cu21IFIPaxdDEDZxBMs9BIcrIni3iB5IVQ9u/tIxWInz75yuWz1l6EWxtwDK
         mLDtnRjPYWL2PiPl91tsQ0Xm2DRR3YvZrORXHOexz3G/58SfMn0j0HjLsCaDtUo+3ycj
         Pnoj+Gm41tnSjrrVONS9Sw+P+guPpny8/6kHAjNbUV+arVDqX6y2+YKPvLo0ZojLGULv
         A+DpxaJkanJj661FEcOAYXO/APy1G9S1RhbNcw4RwSVxinXV44J+Bgfbc3Ky3ddJd936
         avFg==
X-Gm-Message-State: AO0yUKWwVnx8VSSPh1sZNIF191VKx93ltgjPU6YJOENGCjiLrND47ZWK
        VTKKtwA7AJnff1BB++AEExrPFnykvqdbNuftvwi0KvFOWO1ze9SN2ZZOdV+LRmXAnymnC3ntC5O
        HRNUoD5Lz4GApJ2x0fS6vgw==
X-Received: by 2002:a05:6214:2aa3:b0:56e:982c:30 with SMTP id js3-20020a0562142aa300b0056e982c0030mr6665782qvb.16.1676469168648;
        Wed, 15 Feb 2023 05:52:48 -0800 (PST)
X-Google-Smtp-Source: AK7set9qfR0YnIl5aGuny4q5RL9ktwDac37Duh2egeWAsWHNNxuRanDH0mP3oUEah8/PxMdDzFQEnw==
X-Received: by 2002:a05:6214:2aa3:b0:56e:982c:30 with SMTP id js3-20020a0562142aa300b0056e982c0030mr6665758qvb.16.1676469168424;
        Wed, 15 Feb 2023 05:52:48 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id s75-20020a37454e000000b006fa22f0494bsm14010779qka.117.2023.02.15.05.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 05:52:47 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:52:43 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Message-ID: <Y+zjq1yqU43TIjHU@fedora>
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
 <Y91xPMM+/BfaRLle@fedora>
 <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org>
 <Y914yu4rSqvpSoRZ@fedora>
 <Y+LWi3MrLQV/se/j@fedora>
 <5d293df3-6f94-d3a6-5bfb-35b191808582@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d293df3-6f94-d3a6-5bfb-35b191808582@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> Hi Adrien,
> 
> That sounds good to me. Thank you for having suggested an alternative
> solution.
> 
> Bart.

I posted a new patch [1]. Can you please give your feedback when you have
the chance to review?

Thank you,

Adrien

[1] https://lore.kernel.org/all/20230209211456.54250-1-athierry@redhat.com/

