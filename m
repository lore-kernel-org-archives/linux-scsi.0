Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ECCC433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 14:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8438C2251D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 14:23:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JMk16yBQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgGNOXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbgGNOX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 10:23:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F12C061794
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 07:23:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so21925247wrw.12
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 07:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+XB0FMKuppgq4ltckLknQrvpl9WV3rgpMyG5Av27BWg=;
        b=JMk16yBQUPUZ6gxqBeByLmVDx4mOjjb1cQBJz7HbdIRAau3VnH8I3fIB5KgOV9F428
         jVz+WcRwlk6q7PmehC9LV2k2R3Q239BZKoOp03NTTHlCoubklxgj4X9lx6Hv1DTi2veR
         6K+iWUCaicRDpcZr1orM7MTz7Lf2ieJCRSPJYj1NaPqRzdsMjsus5LZBSwAcPfnzqc65
         DCHBqYgBwUJ7V0UUZD9PS8RGH9USZvFwehH/HNEkwMPejvRM4mVUsU8GVM109mcQUxO1
         9UhyNCvlziedmeMebcDBeo22muADCSJiX0umqAJDV5EVQGp07JJmmuaAUIkOGAS03g0N
         q6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+XB0FMKuppgq4ltckLknQrvpl9WV3rgpMyG5Av27BWg=;
        b=OR99YWCnXgfxTkUCRuVkU19YtNnKysZaZoe05AjekX6fTAQJtPXO99Z3AR5IDlLCZH
         L1gZMDeZeRxB2W4juSFbJFvh1LWd3qQJ02s7DpKDcfTioUGD9M3DNRJW2FLGMTjyJe6U
         Gvrhhaz+1V+C4ts/eAk+0JzKXnWOUhTYmTJ5IdP5T5gajcm18w/KK3U/G+xmBjURfSD6
         dhlatR/+Gn3vbuXVWGE7B7JjZg+H+dNvCK/yHZnFZKMRYDlOTo+MA3wYE2ipiffTfeBv
         p9DYwxiyKSZgxBgkb144ianYaMpIdoVQQuNmxkEe/DqRdz7rBBQspjNTm6+1TKEbIWKT
         vWHw==
X-Gm-Message-State: AOAM530IP3uXLGohuYFJ5c72Re7frIWcERSc4SZQ6f98mIAyvkyZdubc
        RWVWF2L1q16idvv8mtZW+Nky1A==
X-Google-Smtp-Source: ABdhPJxhrqDOQ6E+DeR8LfASUhGAMwlZ4Mg3y3JEhR8OJgyB3KcvVv/uXU3ze5rXDoW8FSqffXqNyA==
X-Received: by 2002:adf:e908:: with SMTP id f8mr5844532wrm.3.1594736606613;
        Tue, 14 Jul 2020 07:23:26 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id j6sm29991962wro.25.2020.07.14.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:23:26 -0700 (PDT)
Date:   Tue, 14 Jul 2020 15:23:24 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
Message-ID: <20200714142324.GC1398296@dell>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-6-lee.jones@linaro.org>
 <yq1lfjmqji1.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1lfjmqji1.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020, Martin K. Petersen wrote:

> 
> Lee,

Ah, you are alive.  I was beginning to worry. :)

I have more fixes for you, but didn't want to send them until these
have been merged.

> > @@ -3015,9 +3016,8 @@ static void fcoe_ctlr_disc_recv(struct fc_lport *lport, struct fc_frame *fp)
> >  	fc_frame_free(fp);
> >  }
> >  
> > -/**
> > +/*
> >   * fcoe_ctlr_disc_recv - start discovery for VN2VN mode.
> > - * @fip: The FCoE controller
> >   *
> >   * This sets a flag indicating that remote ports should be created
> >   * and started for the peers we discover.  We use the disc_callback
> 
> s/fcoe_ctlr_disc_recv/fcoe_ctlr_disc_start/ ?

Yes, I spotted it.  Hence my earlier comment to Hannes:

 "Look at the function below it (in your local copy). ;)"

Do you want me to fix that up here as well?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
