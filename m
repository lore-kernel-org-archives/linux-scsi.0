Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01246C3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 07:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiG0Hgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 03:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiG0Hgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 03:36:40 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37B521275;
        Wed, 27 Jul 2022 00:36:38 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7C92F400F6;
        Wed, 27 Jul 2022 07:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1658907396; x=1660721797; bh=kgUS0xFxV00WTpEvdaLiL6E4GU4f69zp39u
        YRxTrSU4=; b=P5eWLlLkY+1TYmNHqH/XJlmFKlnj8AaZZ8rd4AVIHblDo8+Ae/D
        OR6JwmP28xEBQzow41QYXOgv97Gy8nh5RrsK98v65Viuzmy55aMUc0rAJCxlggtI
        Eg0k7ZT0YIBIJVYGyef65aFzyeRvQfz6QcDIXY+ubVUOMGrRrCGv/g6c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tBHjJVJ72TVi; Wed, 27 Jul 2022 10:36:36 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A7492412C5;
        Wed, 27 Jul 2022 10:36:25 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 27 Jul 2022 10:36:25 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 27 Jul
 2022 10:36:25 +0300
Date:   Wed, 27 Jul 2022 10:36:25 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 2/2] target: core: de-RCU of se_lun and se_lun acl
Message-ID: <20220727073625.GC31648@yadro.com>
References: <20220720112852.11440-1-d.bogdanov@yadro.com>
 <20220720112852.11440-3-d.bogdanov@yadro.com>
 <11b8cdf2-a41b-881f-0797-d2bfa4c45b8f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <11b8cdf2-a41b-881f-0797-d2bfa4c45b8f@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 26, 2022 at 05:38:52PM -0500, Mike Christie wrote:
> 
> On 7/20/22 6:28 AM, Dmitry Bogdanov wrote:
> > @@ -1437,34 +1435,26 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
> >
> >  static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
> >  {
> > -     struct se_lun_acl *lun_acl;
> > -
> >       /*
> >        * For nacl->dynamic_node_acl=1
> >        */
> > -     lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
> > -                             kref_read(&se_deve->pr_kref) != 0);
> > -     if (!lun_acl)
> > +     if (!se_deve->se_lun_acl)
> >               return 0;
> 
> Will se_lun_acl and se_lun ever be NULL now? Should this maybe be a
> WARN_ON or return a -EXYZ error code like when target_depend_item fails
> at the bottom of the function?
After the first patch from the patchset deve->se_lun_acl is always NULL
for deve on a dynamyc ACL, and always NOT NULL for deve on a configured
ACL, and deve->se_lun is never NULL.

> 
> I don't think it's a problem with your patch. I think we had issues
> before it. If they were NULL then I think we can hit issues like:
> 
> 1. __core_scsi3_alloc_registration calls core_scsi3_lunacl_depend_item.
> If se_lun_acl is NULL and we return 0.
> 
> 2. __core_scsi3_alloc_registration and other callers treat 0 as success.
> 
> 3. It then does:
> 
> dest_lun = deve_tmp->se_lun;
> 
> pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
>                                 nacl_tmp, dest_lun, deve_tmp,
>  
> 4. So if se_lun is also NULL then for __core_scsi3_do_alloc_registration's
> args we have:
> 
> dest_deve, as non-NULL
> lun as NULL
> 
> 5. __core_scsi3_do_alloc_registration will then do a
> 
>         pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
>         pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;
> 
> and since lun is NULL we will crash.

I think it was not possible even before my patches becasue deve->se_lun
NULLing was after waiting for deve->pr_kref == 0, which is incremented
in PR OUT handling under spinlock for lun->lun_deve_list. There
everything is safe.

> 
> 
> 
> >
> > -     return target_depend_item(&lun_acl->se_lun_group.cg_item);
> > +     return target_depend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
> >  }
> >
> >  static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
> >  {
> > -     struct se_lun_acl *lun_acl;
> > -
> > -     /*
> > +/*
> 
> Just drop the misformatting bit above.
oops, will drop it.

> >        * For nacl->dynamic_node_acl=1
> >        */
> > -     lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
> > -                             kref_read(&se_deve->pr_kref) != 0);
> > -     if (!lun_acl) {
> > +     if (!se_deve->se_lun_acl) {
> >               kref_put(&se_deve->pr_kref, target_pr_kref_release);
> >               return;
> >       }
> >
> > -     target_undepend_item(&lun_acl->se_lun_group.cg_item);
> > +     target_undepend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
> >       kref_put(&se_deve->pr_kref, target_pr_kref_release);
> >  }
