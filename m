Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD873C3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 12:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965D0217F5
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 12:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqeBFxGB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfHZMLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 08:11:11 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:43312 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbfHZMLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 08:11:10 -0400
Received: by mail-lf1-f51.google.com with SMTP id q27so2477962lfo.10;
        Mon, 26 Aug 2019 05:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BV/IlsUKGMhAgjp5fd7Cq0kDeM0uAXqt24wzuaQuZUE=;
        b=EqeBFxGBjs0+nYTQdXcjr78adW+Uda7TUOkKCp0HTxUUF6ueUjifewQLJQFwfqpk4I
         Q/sK7lcPF0M6/a8LRfoG8XOgzwDWIbhdUEeFl+s2v8SodHORwdUzQtw4HvUgq8AINSaD
         V/BY7gtQewk/p2Erd7u5D2N+Zz9abZwKhN5NNY79FvvA0ZdsaIX4CEiV206deSgU0SXm
         CkCLPfBESlN6HvP4FQbpLbM9j5UL6XkCQ1NqvV3lDMHIMOG5u20cH6sYBLIPsFPMKsF8
         CDosdvqn3iQZTQuUq2Nm0uJ3O5fDz8ujc1fJ0QL2fvTq+PwQCulyoXjHR0MDRapHxycV
         PN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BV/IlsUKGMhAgjp5fd7Cq0kDeM0uAXqt24wzuaQuZUE=;
        b=rJSnkpz8d1H+skH49FKhLxn2b7ekTgHG48Xx5DAhNjEU6O0Wj9UnbFOFFpB3dDexhg
         Y6HyxO4TUjvAqlMUvasraZHHy+4frCasLff0yQyDYgELwnsUdIxX70LdVLop0YC0Ufxm
         D1Xz+2C1ZVr0U4ztDWc5TNvRS0bJYPc1A9KTTGC2Sgz4pzSlLmu+kj4QZXJPsC3BVqA5
         cTnzm0kNXmVjLdPbDdw5IqwCqcwBB69S48kqsJaDrgvt+/mrqf1cZMbxnhukCW88OIkn
         3RQs0SG8O9jZ6n+wr0Ma6542xXWjWOPM9ApUg1rUV05pIFFNq4F7tfdkLKSrMCQIwrfq
         yxEA==
X-Gm-Message-State: APjAAAWlYXkYLX5gLS8xpahkne1eIys6+PWBvVAuPYR3CbZxI312oucD
        J+GSwifM22uRzwGBuvPpbDyDJcm6Nh33AFrW67sVKQ==
X-Google-Smtp-Source: APXvYqxRjNxEGEzIOclaUHa7MnLlX1jmEcrmNHFfpTmf2cc8dG+KY63nPCZb5yfBgbLsDc+EEy2d2AFhMOkG4kLU8yk=
X-Received: by 2002:a19:8c56:: with SMTP id i22mr10624244lfj.105.1566821468937;
 Mon, 26 Aug 2019 05:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <1566659302-3514-1-git-send-email-jrdr.linux@gmail.com> <1566808307.3089.2.camel@linux.ibm.com>
In-Reply-To: <1566808307.3089.2.camel@linux.ibm.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 26 Aug 2019 17:40:57 +0530
Message-ID: <CAFqt6zaCBEXVmyD8ZEA8x537CLeeNriSoSST3NqhPTbR8fg7Hw@mail.gmail.com>
Subject: Re: [PATCH] scsi: aic7xxx: Remove dead code
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     hare@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 26, 2019 at 2:03 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Sat, 2019-08-24 at 20:38 +0530, Souptick Joarder wrote:
> > These are dead code since 2.6.13. If there is no plan
> > to use it further, these can be removed forever.
>
> Unless you can articulate a clear useful reason for the removal I'd
> rather keep this and the other code.  Most of the documentation for
> this chip is lost in the mists of time, so code fragments like this are
> the only way we know how it was supposed to work.

Considering your feedback, let's keep this code :)
>
> A clear reason might be that it's impossible for aic7xxx ever to make
> use of IU and QAS because they're LVD parameters and it's a SE/HVD
> card, so the documentation in the code is actively wrong, but you'd
> need to research that.

I need to look further to come up with a clear reason.
