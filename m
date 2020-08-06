Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BDDC433E3
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79D782086A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596732936;
	bh=PkSDuxH4gMr1p5NNDOd+BJDUZltAi1MaFL/oUyq7+/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fmbW/xw4raIKpaXylBVkQLc0Jo4Y/mtIsdCEzJc45+C123qf4h9xNIjQ7Y9hRZpHm
	 yoXmEW2hiq/8Z/8hNelVYmtDYIaNpHTWzRf1aTOYawOHjJ2VCWEp/UrJz49kW5EAy8
	 LWAvcnUcGUQmLGsZVtYugDTn08YF//VlqYYluufw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgHFQz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 12:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbgHFQzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 12:55:08 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE10C0A8899;
        Thu,  6 Aug 2020 07:48:07 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so45138519qkc.6;
        Thu, 06 Aug 2020 07:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a1xsocRfe6PaWiMuQJu8Lspo4Zh0b85wGXl3XYk8ufs=;
        b=DMKMT69gRdPULPdCvILu5fKZXK70+z1rgY5ogLdV8VbwGZtnQc8y9cLFan536wfABn
         DVfDajuB5mXiiAWsvUqlFOQOOO2Qi6SUNGw18/LK7MVJUFjEBIMaxafZZ0sdzknW4xIK
         pVMGYG0AHuOuOrxCVK2p3JDBg/5z8+RniT8feKgFdZjPiJjl3RkisvxN7YgXaw0naN9n
         CetqkUtsJOy25/c33/B58UYx4OKSL0nfVRYYW42XMfpAmU0xnXvW+/TpYZsCagafQ9fp
         PzoMofciAzX6FGzTkgVgsoJeNJyAPJjKQXIO4E1nDKCseuKZoKxXXmgv8iVWc7uHFent
         ZOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=a1xsocRfe6PaWiMuQJu8Lspo4Zh0b85wGXl3XYk8ufs=;
        b=aTHyqXKUlz1qMSulCcfGVDg2rrgFx1ULJ1/ibSuy7opyIGLf+JkBAJRaFz0WchT3U0
         9zjeUFXV67b5LucvgDgXJ4lOu42jVAPGjCEOi7dxS1VK8gRAXREfrOMPFaP4ArrzMrNz
         34ERq5hKqupVTYncjH178p5SJ3PlUa4FfvgTLmJMGLposlZBBXRhecf2bd0tpb5+b461
         Fn3/xBjYOPQNk8Lz3z/qEUZjE/LOuGZb11cu9TjPSNFQK5n9GDn2797Gh2DS8zWeSqlB
         V8qnDmEPw2XgOgJTPRmCEYAqozI2YQvJDnbXPvrfFYy8arFEwkFDTxDMIhD5FYNEMP2L
         81aA==
X-Gm-Message-State: AOAM531puOaS6GooklbSR5mas+1sy16CFTfbIyGEBxJRzNvHVSxl5PMC
        vVydTUQ9E20b6xzg0i9jO7Y=
X-Google-Smtp-Source: ABdhPJzqxqP829yKSm2tdy3vJHzQovc/SVxhj1gDbLQ+qgZ78ZCFwI2dV72KHT0S/yb9vOyw37Et5g==
X-Received: by 2002:a37:9d53:: with SMTP id g80mr8575302qke.17.1596725286673;
        Thu, 06 Aug 2020 07:48:06 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2e8b])
        by smtp.gmail.com with ESMTPSA id r188sm4380302qkb.122.2020.08.06.07.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:48:05 -0700 (PDT)
Date:   Thu, 6 Aug 2020 10:48:04 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
Message-ID: <20200806144804.GD4520@mtj.thefacebook.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <20200806144135.GC4520@mtj.thefacebook.com>
 <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 04:46:45PM +0200, Paolo Bonzini wrote:
> On 06/08/20 16:41, Tejun Heo wrote:
> >> 1)	blkcg will have a new field to store driver specific information as
> >> "blkio_cg_ priv_data"(in the current patch it is app_identifier) as Tejun
> >> said he doesn’t mind cgroup data structs carrying extra bits for stuff.
> > 
> > I'd make it something more specific - lpfc_app_id or something along that
> > line.
> 
> Note that there will be support in other drivers in all likelihood.

Yeah, make it specific to the scope, whatever that may be. Just avoid names
like priv which doesn't indicate anything about the scope or usage.

Thanks.

-- 
tejun
