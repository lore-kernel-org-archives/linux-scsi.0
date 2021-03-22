Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72568C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4534F6188B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhCVS6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:58:23 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:59046 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232010AbhCVS54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 14:57:56 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D0324411F9;
        Mon, 22 Mar 2021 18:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1616439472;
         x=1618253873; bh=tr1UKlUNTGiC/QyCSIj5c5k1h6ROJChOYuChgyeARUs=; b=
        XKGvZJVrtOX168L9a5kvWtLDwdBc8ye2+M+9/25aPh6CWQHs79sQVYJnuB+9QA79
        OhejYFnd+hmDBM6IFy/veYaR91cBAHl9osVXRJ4+ky0q7qpdrnfR/KcIfvjPJlWA
        /DtXdTPIuZykPvKXJyLJh4+WmLUE4jLi47H6hGdSR/Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sHPuiSZUF15R; Mon, 22 Mar 2021 21:57:52 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 666964122E;
        Mon, 22 Mar 2021 21:57:52 +0300 (MSK)
Received: from yadro.com (10.199.0.64) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 22
 Mar 2021 21:57:51 +0300
Date:   Mon, 22 Mar 2021 21:57:51 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>,
        <linux-scsi@vger.kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 1/2] target: Add the DUMMY flag to rd_mcp
Message-ID: <YFjor951E++2VcaR@yadro.com>
References: <20210318094224.17524-1-k.shelekhin@yadro.com>
 <20210318094224.17524-2-k.shelekhin@yadro.com>
 <83e2f363-978f-eba2-cff1-ff007cc139ca@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <83e2f363-978f-eba2-cff1-ff007cc139ca@oracle.com>
X-Originating-IP: [10.199.0.64]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 12:06:36PM -0500, Mike Christie wrote:
> > +static u32 rd_get_device_type(struct se_device *dev)
> > +{
> > +	if (RD_DEV(dev)->rd_flags & RDF_DUMMY)
> > +		return 0x3f; /* Unknown device type, not connected */
> > +	else
> > +		return TYPE_DISK;
> 
> Maybe have this call sbc_get_device_type here so it matches the other drivers
> and how this driver calls into lio core for other operations/fields like
> parse_cdb or the attrs.

Yeah, good point, I'll fix and send the next round. Are you okay with
the whole idea though?
