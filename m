Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EFEECAAD3
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 08:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiIIIa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 04:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiIIIa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 04:30:57 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF0EEA412;
        Fri,  9 Sep 2022 01:30:56 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9B3A8568DC;
        Fri,  9 Sep 2022 08:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1662712253; x=1664526654; bh=v3844l841qywn+iFxh4j+yEguTEn6zAL1GU
        dmHL+FOQ=; b=PAckU0Ph6thM4nUdBV/1V44CQAQYsrVVBAgs6bSqNGf03xuobYw
        LziqZOBm6NpVL5RIvLm+mELRE4ituPVMhewBkf8hsRp5D4ikyNig3vycEXghZrdR
        h6+xXPJZrt00Sw2vg3zLTUoHYumyTLYm9iSZ6ciixOXcfba67nzPSbRQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9XfaM-cqh4Fk; Fri,  9 Sep 2022 11:30:53 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B06CA568F2;
        Fri,  9 Sep 2022 11:30:42 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 11:30:42 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 11:30:42 +0300
Date:   Fri, 9 Sep 2022 11:30:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Set MULTIP bit in INQUIRY
Message-ID: <20220909083042.GC9218@yadro.com>
References: <20220906074820.18685-1-d.bogdanov@yadro.com>
 <8b2da710-f878-7b80-a75a-6f7e95df3452@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8b2da710-f878-7b80-a75a-6f7e95df3452@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 07, 2022 at 03:06:04PM -0500, Mike Christie wrote:
> 
> On 9/6/22 2:48 AM, Dmitry Bogdanov wrote:
> >
> > diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> > index c14441c89bed..32fb38ce98f4 100644
> > --- a/drivers/target/target_core_spc.c
> > +++ b/drivers/target/target_core_spc.c
> > @@ -75,6 +75,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
> >       struct se_portal_group *tpg = lun->lun_tpg;
> >       struct se_device *dev = cmd->se_dev;
> >       struct se_session *sess = cmd->se_sess;
> > +     struct se_lun *tmp_lun;
> > +     size_t dev_ports = 0;
> >
> >       /* Set RMB (removable media) for tape devices */
> >       if (dev->transport->get_device_type(dev) == TYPE_TAPE)
> > @@ -115,6 +117,20 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
> >                       buf[5] |= 0x1;
> >       }
> >
> > +     spin_lock(&dev->se_port_lock);
> > +     list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
> > +             dev_ports++;
> > +             /* Exact number of ports does not matter for MULTIP bit */
> > +             if (dev_ports > 1)
> > +                     break;
> 
> Can you just check se_deice->export_count instead of looping?
Yes, of course, dev->export_count exactly fits here.
> 
> Also, setting the bit seems fine. I was just wondering what uses it?
There is no way to find it out. At least just to conform to the
standard. May be for some archaic users like AIX.
Btw, SCST reports MULTIP=1 always.

BR,
 Dmitry
