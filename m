Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5242FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 14:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiJSOih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 10:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiJSOiV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 10:38:21 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34591C208A;
        Wed, 19 Oct 2022 07:23:02 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CF8FE404AD;
        Wed, 19 Oct 2022 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1666189298; x=1668003699; bh=fOf+n0Eq6Vvj1OFSrqrF45xGxZIANs2Sdf0
        r03/6lDQ=; b=a89I/IKLr8e4qOlHFoTbPdBNH8EUarnck0Lmte248VGIIUVM530
        cxl6B7G9uV9ouq2qOGsztaCmuSaSdBUMVP91V1uBCo5CkHeM4StNeb6+mbczaxDi
        EZF61dQ3c/kreYa/GVDqfu719HI2tozXFQA245DxIOqng0lldf2V3iok=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IHbcqPYN0yTY; Wed, 19 Oct 2022 17:21:38 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 22AC5400F8;
        Wed, 19 Oct 2022 17:21:38 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 19 Oct 2022 17:21:37 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 19 Oct
 2022 17:21:37 +0300
Date:   Wed, 19 Oct 2022 17:21:36 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2 1/5] scsi: target: core: Add RTPI field to target port
Message-ID: <20221019142136.GF10901@yadro.com>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
 <20221006105057.30184-2-d.bogdanov@yadro.com>
 <Y00Giu7q4M/jb6mG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y00Giu7q4M/jb6mG@infradead.org>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2022 at 12:38:50AM -0700, Christoph Hellwig wrote:
> 
> > +DEFINE_XARRAY_ALLOC(tpg_xa);
> 
> I think this wants to be marked static.

Agree.

> > +static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
> 
> Can you use target_ instead of the weird historic core_ prefixes for
> everything here?

Every function in this file is with core_ prefix, but OK, I will change
name of new functions to target_*.

> > +int core_tpg_enable(struct se_portal_group *se_tpg, bool enable)
> > +{
> > +     int ret;
> > +
> > +     if (enable) {
> > +             ret = core_tpg_register_rtpi(se_tpg);
> > +             if (ret)
> > +                     return ret;
> > +     } else {
> > +             core_tpg_deregister_rtpi(se_tpg);
> > +     }
> > +     ret = se_tpg->se_tpg_tfo->fabric_enable_tpg(se_tpg, enable);
> > +     if (ret) {
> > +             core_tpg_deregister_rtpi(se_tpg);
> > +             return ret;
> > +     }
> > +
> > +     se_tpg->enabled = enable;
> 
> This bool enable logic is a bit weird and splitting the enable and
> disable case would seem more sensible to me, but maybe there is
> something later on that makes it more relevant.

Ok, will split this function to enable/disable functions.

BR,
 Dmitry
