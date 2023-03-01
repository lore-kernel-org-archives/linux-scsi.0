Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2528DC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 08:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCAIc3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 03:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAIc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 03:32:28 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBB738EAE;
        Wed,  1 Mar 2023 00:32:27 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id E7763341BC0;
        Wed,  1 Mar 2023 11:32:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=mlw/6Y1zegKx9/xsZ+UqxbLlwjhnZQW4kT7qqxHyudk=; b=
        DW03oHAAE0pC1ePo/NCaFYezeZLHNaZKDiLvt6/oYDMXFK16BueVXqKQ324tiMu0
        keVCIM01Nzl2nMITJ45GP3ebdHOCzKXPZOyB0Dn2cLyPBGWn4gaQ7eAYqT/fiV2C
        D+QA1YKM/J8tq4V04lStDwSD9RKDljMpD4TqzqEc9E8=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id DDBA834177C;
        Wed,  1 Mar 2023 11:32:24 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 1 Mar 2023
 11:32:23 +0300
Date:   Wed, 1 Mar 2023 11:32:24 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v4 4/4] scsi: target: core: Add RTPI attribute for target
 port
Message-ID: <20230301083224.GA1340@yadro.com>
References: <20230221160622.7283-1-d.bogdanov@yadro.com>
 <20230221160622.7283-5-d.bogdanov@yadro.com>
 <a72558e0-04b9-d641-0703-63d2d348ff6b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a72558e0-04b9-d641-0703-63d2d348ff6b@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2023 at 03:41:20PM -0600, Mike Christie wrote:
> 
> On 2/21/23 10:06 AM, Dmitry Bogdanov wrote:
> > +static ssize_t target_fabric_tpg_base_rtpi_show(struct config_item *item, char *page)
> > +{
> > +     struct se_portal_group *se_tpg = attrib_to_tpg(item);
> 
> ..
> 
> > +
> > +static ssize_t target_fabric_tpg_base_rtpi_store(struct config_item *item,
> > +                                const char *page, size_t count)
> > +{
> > +     struct se_portal_group *se_tpg = attrib_to_tpg(item);
> 
> 
> This interface is nicer. It doesn't work for me though. I think
> it's because attrib_to_tpg is returning a bogus pointer. The rtpi
> file is not in the attrib group so I think you have to use to_tpg().
> Or, put the rtpi file in the attrib group if that's preferred (it
> doesn't matter to me).

Yes, I should use to_tpg. Forgot to change it after moving to tpgt_n
folder. Read after write was working for me so I didn't suspect
something was wrong.

