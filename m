Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96D8ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 11:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiIILcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 07:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIILcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 07:32:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C0212D566;
        Fri,  9 Sep 2022 04:32:38 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E270D56C82;
        Fri,  9 Sep 2022 11:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1662723155; x=1664537556; bh=9ZB3Oo9Ah6hmDgtVSjdV4vXbcL+DN2PSjy5
        4DiS9Twc=; b=A0MzoVbZoYeDzI/KVHpYyzTD9K9/tuEYPefpTlfqzDAIvyUsReG
        oXO32FgoZ0JA2DuZvE7vcsblgb3OgO3iDz1TZRtZzdDR+7pm6bzl9k5K4OVWNhGs
        oiijMxt6tNGpwVG41EarEJ+7FZTtlvQaPZvqssySynLOoKLESvrXnAQc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7h37vpLmRtmp; Fri,  9 Sep 2022 14:32:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7BBC856BF9;
        Fri,  9 Sep 2022 14:32:34 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 14:32:34 +0300
Received: from yadro.com (10.199.23.254) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 14:32:33 +0300
Date:   Fri, 9 Sep 2022 14:32:32 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
Message-ID: <YxskUBeZeMPi5By2@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
 <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
 <20220909112235.GD9218@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220909112235.GD9218@yadro.com>
X-Originating-IP: [10.199.23.254]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 09, 2022 at 02:22:35PM +0300, Dmitry Bogdanov wrote:
> On Wed, Sep 07, 2022 at 03:01:00PM -0500, Mike Christie wrote:
> > 
> > On 9/6/22 2:49 AM, Dmitry Bogdanov wrote:
> > > From: Roman Bolshakov <r.bolshakov@yadro.com>
> > >
> > > Default target port group is always returned in the list of port groups,
> > > even if the behaviour is unwanted, i.e. it has no members and
> > > non-default port groups are primary port groups.
> > >
> > > A new port group attribute - "hidden" can be used to hide empty port
> > > groups with no ports in REPORT TARGET PORT GROUPS, including default
> > > target port group:
> > >
> > >   echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden
> > >
> > 
> > How about "enable"? I think that fits how we handle other objects like
> > targets that are setup automatically but are not yet usable (can't login
> > or reported in discovery commands) and devices we have setup but are not
> > reported in commands like REPORT_LUNs (technically you need to enable and
> > map them but you get the idea I'm going for).
> There is already an enable semantic. It is pg_pt_gp_id field. Until it
> (id) is not set the port group is treated as disabled and it is not
> reported in RTPG. But the default_tg_pt_gp is enabled by default and can
> not be deleted.
> 
> The patch solves the presence of non-deletable empty default_tg_pt_gp
> in RTPG.
> May be, a global attribute like target/core/alua/hide_emtpy_tpg would
> fit better than an attribute per each port group?
> 
> I would always hide the empty default_lu_gp (not configurable) but I am
> afraid that it will be considered as not backward compatible change. :(

A module parameter perhaps? Or a CONFIG definition.
