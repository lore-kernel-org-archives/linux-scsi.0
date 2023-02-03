Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB93C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 20:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjBCUlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 15:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjBCUlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 15:41:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A459AFC2
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 12:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675456832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IBQSDFuvhcaEbSRlMGZfr7NqgjArybvGKWEozXmO8yw=;
        b=dskKv9kauFndGePLgFKlDkPZ2ESHV8iiBb6r+g3EAmra3aEjMcRpIpnChvQTbpp2IDYSoB
        4nSq7lrwoQcD4K3vk90GiIwWRWQlhuj5/Htn6nII/tEJaL9qjZhYxNxX0sD8Z7azKUWHaD
        +Wtb5cOjCsLFPqGiiFn992SslKyb5zM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-466-1RqKOdJqMT2dv2lFHrAgog-1; Fri, 03 Feb 2023 15:40:31 -0500
X-MC-Unique: 1RqKOdJqMT2dv2lFHrAgog-1
Received: by mail-qv1-f69.google.com with SMTP id l6-20020ad44446000000b00537721bfd2dso3396791qvt.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 12:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBQSDFuvhcaEbSRlMGZfr7NqgjArybvGKWEozXmO8yw=;
        b=GDBHZwfBz3DguXqzPY4QRFIgKjGkzesFbJg3JW86IXPmFxI/38tZ228UFHE4Ki0OoG
         agT+S/PWYPbblob0N66TUvfGeu+A1qq9BNRzbCmEuIaoh3xfnW9l503JyD2dCylJAjTR
         /tlKSWSjEcu8fOXHMMliRpYas3TW+ULNcTThCRnauXuOitmRoHfRIByV/BkJxnei6AGu
         0TgmWHpEwE9F5kAf7HCHpbmaJ8Laucji+beheQl0R5wY41mOVT6BlNBhZRXCa/VrF9sk
         ABgBW7JhdJcGXxwf88l5LwHeP6hhUrb9leAgsOA8/7U6b+B0siaPAit73l98/qZwbE2Y
         JZFw==
X-Gm-Message-State: AO0yUKWq7KjDhCDuGF9+LR69elQkjGQVHWiVhdKl5bLMBD0HQb7XomMS
        B78fxIHX7L10s1/2PlTq5WXw0lwLAlSu86+geSha+R7mdYHEN3bOrPI4Li7P8g+aHu49SLB3FHb
        VneHjt6HHBoFkHvF5PJe1CA==
X-Received: by 2002:ac8:7d88:0:b0:3b9:bf83:d5de with SMTP id c8-20020ac87d88000000b003b9bf83d5demr18037830qtd.26.1675456831466;
        Fri, 03 Feb 2023 12:40:31 -0800 (PST)
X-Google-Smtp-Source: AK7set/boUUuqApAW/OUfyZku6/f8SeX/etxBimQ8cfO2K2Ez+y6tLRIwqEa6HdkrNvxFlk/Entgxw==
X-Received: by 2002:ac8:7d88:0:b0:3b9:bf83:d5de with SMTP id c8-20020ac87d88000000b003b9bf83d5demr18037808qtd.26.1675456831269;
        Fri, 03 Feb 2023 12:40:31 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id k64-20020a37ba43000000b007023fc46b64sm2407385qkf.113.2023.02.03.12.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:40:30 -0800 (PST)
Date:   Fri, 3 Feb 2023 15:40:28 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Message-ID: <Y91xPMM+/BfaRLle@fedora>
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> Please find another solution, e.g. building devfreq and the ondemand
> governor into the kernel instead of as loadable kernel modules.

Another solution could be to change the kernel Kconfigs to force
DEVFREQ_GOV_SIMPLE_ONDEMAND (and possibly other devfreq-related options as
well) to be builtin when SCSI_UFSHCD is enabled (builtin or module). Is
that what you meant?

Best,

Adrien

