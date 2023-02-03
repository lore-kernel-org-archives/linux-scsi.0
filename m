Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C798C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 21:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjBCVNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 16:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjBCVNa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 16:13:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7209EAE
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 13:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675458766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PUi8tlfz1TdtfaLVvcZdwTO7hfcgODBjbNBiYOjkkYg=;
        b=BfRqSH9cv22OC3AYmIKOL7CYiCfXFiz+P7wnptk5RJAc7ynpOzZTmG5HX0ITtd9vh3D7RC
        aAR6gJYAhfhjiuEzEw9w+HttjdH7EIIYBLoZKGKyQP9+GfXTfa3Woig4oR1K0e6LIoNtG6
        1UHDOaDTQTHIrUDlp6Ox6KE+mMiwUwU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-KHXU3EwtMrSbR2YEx35vdg-1; Fri, 03 Feb 2023 16:12:45 -0500
X-MC-Unique: KHXU3EwtMrSbR2YEx35vdg-1
Received: by mail-qv1-f72.google.com with SMTP id j12-20020a056214032c00b0053782e42278so3381512qvu.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 13:12:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUi8tlfz1TdtfaLVvcZdwTO7hfcgODBjbNBiYOjkkYg=;
        b=7zOg6NW6RSbcMEzoa0M4IAmVEUYCWlTnRijq10oqzU0tKCO0lHoi3j5bQDEtHVu2K8
         N0GYHI/nMcmAE3+7ubhhrAIWlitmKbfG9D22t3Ycv+PgKn8ZRWxt1plhS87ArG+N7EOL
         YM3wRe5nJgLmJF0lhmEkxH64KVxUqYTiriwF616d/jZ7PRAvCGz/POupp0AQCGVmpnhn
         0+v5pBAk41Lp99DO4gy6HZ7HTOUPEuJna4LO7Dyumd/jC5atUVcDT3AaXv4kw35eJEmO
         /DOpp3bFTF1anJBe3A5T95j9owlm+4D3JpGWuqeys5P2HY+ennEH1+TKa8RD/rONSqm/
         1XKg==
X-Gm-Message-State: AO0yUKW4ZWzoVtvuJo2fFwzLeTVwAM7lpPT5OjDgpZ/e4ZG4rftvYN7s
        vsTqydSyFW5Jdklwek1pHVZp7lL73JBNKkOPwG90ICeHBiEJYgQANTSk9vxH+JQlnHgBfMeDDBK
        VXWNLgenrCd2yBTYNkqOXSQ==
X-Received: by 2002:ac8:7f03:0:b0:3ab:a047:58ee with SMTP id f3-20020ac87f03000000b003aba04758eemr19910909qtk.25.1675458765232;
        Fri, 03 Feb 2023 13:12:45 -0800 (PST)
X-Google-Smtp-Source: AK7set8/ICbqNhBVhFaPLRObaw0hiG+xNWvVl8ygMGMvCgamDRk/n8ModWxzt2z/hIMNH26hrE11qA==
X-Received: by 2002:ac8:7f03:0:b0:3ab:a047:58ee with SMTP id f3-20020ac87f03000000b003aba04758eemr19910893qtk.25.1675458764986;
        Fri, 03 Feb 2023 13:12:44 -0800 (PST)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id q1-20020ac84101000000b003b86d9a3700sm2223167qtl.78.2023.02.03.13.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 13:12:44 -0800 (PST)
Date:   Fri, 3 Feb 2023 16:12:42 -0500
From:   Adrien Thierry <athierry@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Message-ID: <Y914yu4rSqvpSoRZ@fedora>
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org>
 <Y91xPMM+/BfaRLle@fedora>
 <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Are all UFS users using the devfreq framework? Otherwise this sounds good to me.

The warning originates from the UFS core :

ufshcd_init() -> ufshcd_async_scan() -> ufshcd_add_lus() ->
ufshcd_devfreq_init()

ufshcd_devfreq_init() is called as long as
ufshcd_is_clkscaling_supported(hba) returns true, i.e.
UFSHCD_CAP_CLK_SCALING is set. This is not the case for all UFS users, but
it could potentially be if they start supporting clock scaling. Moreover,
in the current Kconfigs, DEVFREQ_GOV_SIMPLE_ONDEMAND is already selected
when SCSI_UFSHCD is enabled. We just need to force it to be builtin.

Best,

Adrien

