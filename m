Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4F1C77B73
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 17:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbjEBRG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjEBRGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 13:06:53 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78062D68
        for <linux-scsi@vger.kernel.org>; Tue,  2 May 2023 10:06:45 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f315712406so178695585e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 May 2023 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683047204; x=1685639204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gx8zKXoy8nZxQ0bzeuH4TsYA2xK19EtfTbcluKj4zzM=;
        b=etFLY0pfQT0Ff197Gvb1sk+TadBVcR6BXPJJ5hkZnWkuf0FGh9rc0SYx6sr6qoYttC
         CAeDoylwsgUecBnKj6yKJbwZd/ZGsYkOxffgglvQwLYTK/zl0bwzZtKjTB+8XNM5DI9N
         cGenD+QL2afDl2bbpPqjuSsamnz6B1IuvHAMc1uWJVXOb0+7Wt5ZKv5NwWNp03wn8nlH
         ATVYuJHbjF2/YSse+15avozsWzFnXS5ckXOI36uBR2GAz8LTK06pn2WTZY8UizmqKD2/
         1Y0wffiC/1mG0VuHk+XJKoutqGBUhqgcPNqE2r78DHr6ZgGk6fDJ9JWjeiZRvtOLi5bv
         CYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047204; x=1685639204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gx8zKXoy8nZxQ0bzeuH4TsYA2xK19EtfTbcluKj4zzM=;
        b=BGWD04GBaX42bBx9bb1zNQSsXNWTEajZfwlsIglN7zY2QnYK043cJ216JMwVQmloZj
         UoDQeHYYDk7Zysb9zqKiOx6Pj5amODuRF6ada/cByzKiSRM0536AlyzNWYP3MlIxyv8I
         XaFty78HNwl7gLwRraFampLdsJRmd18BqKeDENy+FPEmZY76ODX2eU6JmF7h8xajp3cK
         XNW78Y2t/QE06WRaU/2sap3XwEW4tEghnLT8g1MAhbjBfrRXxRz66cxDWxNr+g/HzPaU
         1U5okiCl9RrC8zvNqFS6dU3sYn+Pi9UJCafBANV26Y6MSxLH/OtXML2KL2RvqEt1l5Fs
         j51A==
X-Gm-Message-State: AC+VfDxrIc2Omb6ejiZsw7p53BKDyrIE0a4EXFcjhOoRByhM/I9g9oa3
        p4+JbQMZYmrvLQqb/TtVKPGhiw==
X-Google-Smtp-Source: ACHHUZ70mZGKbzAf13zjiuRRq8zx0iCo/1yfJzwrOZFSDtXSDO6GDq/owc2yPeIrjJmN4c1UdU3LAQ==
X-Received: by 2002:a5d:6704:0:b0:2ef:afe0:727a with SMTP id o4-20020a5d6704000000b002efafe0727amr12793931wru.12.1683047204088;
        Tue, 02 May 2023 10:06:44 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j17-20020adfe511000000b003063ec828a4sm179954wrm.117.2023.05.02.10.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:06:42 -0700 (PDT)
Date:   Tue, 2 May 2023 20:06:34 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     Jing Xu <U202112064@hust.edu.cn>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hust-os-kernel-patches@googlegroups.com,
        Dongliang Mu <dzm91@hust.edu.cn>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mpt3sas: mpt3sas_debugfs: return value check of
 `mpt3sas_debugfs_root`
Message-ID: <1484408f-f68e-4354-ab59-56af9cd1ef14@kili.mountain>
References: <20230423122535.31019-1-U202112064@hust.edu.cn>
 <6e69b57c-80ae-8b6e-cb5f-9e05da46ecd6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e69b57c-80ae-8b6e-cb5f-9e05da46ecd6@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 02, 2023 at 05:53:10PM +0200, Tomas Henzl wrote:
> On 4/23/23 14:25, Jing Xu wrote:
> > Smatch complains that:
> > mpt3sas_init_debugfs() warn: 'mpt3sas_debugfs_root' is an error 
> > pointer or valid
> > 
> > There is no need to check the return value of the debugfs_create_dir() 
> > function, just delete the dead code.
> > 
> > Fixes: 2b01b293f359 ("scsi: mpt3sas: Capture IOC data for debugging purposes")
> > Signed-off-by: Jing Xu <U202112064@hust.edu.cn>
> > Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> > index a6ab1db81167..c92e08c130b9 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> > @@ -99,8 +99,6 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
> >  void mpt3sas_init_debugfs(void)
> >  {
> >  	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
> > -	if (!mpt3sas_debugfs_root)
> > -		pr_info("mpt3sas: Cannot create debugfs root\n");
> Hi Jing,
> most drivers just ignore the return value but here the author wanted to
> have the information logged.
> Can you instead of removing the message modify the 'if' condition so it
> suits the author's intention?

This code was always just wrong.

The history of this is slightly complicated and boring.  These days it's
harmless dead code so I guess it's less bad than before.


regards,
dan carpenter
