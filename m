Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C4AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 16:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJDQMx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 12:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJDQMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 12:12:52 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7B02AE0C;
        Tue,  4 Oct 2022 09:12:51 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2B60F40889;
        Tue,  4 Oct 2022 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1664899969; x=1666714370; bh=kIPRRbyt3qGM/NMvYlON7MaQycrVi5+Zacg
        a8WvGPXw=; b=RcwF8uzbKcIwl37mefcBJfYjxZOtElmM4yLFKXX3N0/e+hXzAQQ
        /RxrpNMjs0m1t61YQ/Dzp5t27FQZAhGkZnujIctvc+VsKZV0XyCwgM7ZaD6uGVnh
        rrpVImAyKSeJ0ePpuELepwTBZXrvBOcyEvie3ebLZj8x+1UyYpISf+sQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ohe9wtpq_5QH; Tue,  4 Oct 2022 19:12:49 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D5BD0400F8;
        Tue,  4 Oct 2022 19:12:48 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 4 Oct 2022 19:12:48 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 4 Oct 2022
 19:12:47 +0300
Date:   Tue, 4 Oct 2022 19:12:47 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 6/7] scsi: target: core: Add RTPI attribute for target
 port
Message-ID: <20221004161247.GC10901@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-7-d.bogdanov@yadro.com>
 <85c21e59-fda3-8b94-95c0-2483b4c5a05c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <85c21e59-fda3-8b94-95c0-2483b4c5a05c@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2022 at 07:03:52PM -0500, Mike Christie wrote:
> 
> On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
> > +
> > +static ssize_t core_tpg_rtpi_store(struct config_item *item,
> > +                                const char *page, size_t count)
> > +{
> > +     struct se_portal_group *se_tpg = attrib_to_tpg(item);
> > +     struct se_portal_group *tpg;
> > +     bool rtpi_changed = false;
> > +     u16 val;
> > +     int ret;
> > +
> > +     ret = kstrtou16(page, 0, &val);
> > +     if (ret < 0)
> > +             return ret;
> > +     if (val == 0)
> > +             return -EINVAL;
> > +
> > +     /* RTPI shouldn't conflict with values of existing ports */
> > +     spin_lock(&g_tpg_lock);
> > +
> > +     list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
> > +             if (se_tpg != tpg && val == tpg->tpg_rtpi) {
> > +                     spin_unlock(&g_tpg_lock);
> > +                     pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
> > +                            se_tpg->se_tpg_tfo->fabric_name,
> > +                            se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
> > +                            val,
> > +                            tpg->se_tpg_tfo->fabric_name,
> > +                            tpg->se_tpg_tfo->tpg_get_tag(tpg));
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +
> > +     if (se_tpg->tpg_rtpi != val) {
> > +             se_tpg->tpg_rtpi = val;
> > +             rtpi_changed = true;
> > +     }
> > +     spin_unlock(&g_tpg_lock);
> > +
> > +     if (rtpi_changed)
> > +             core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
> > +     ret = count;
> > +
> > +     return ret;
> 
> Just return count.

Yes, will do.


