Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D3AECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 11:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiIILWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 07:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIILWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 07:22:42 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861691365CC;
        Fri,  9 Sep 2022 04:22:41 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 29FF156C65;
        Fri,  9 Sep 2022 11:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1662722558; x=1664536959; bh=BhyeHfAPNf2W6us4lzEiGV6NM5zWsAf+1ob
        4gjpjMZ0=; b=UKUWykX8Af4U3sZXZ5AmKm62f1xSm8B2A+F0Zn/bPdk/eS+CEmp
        YWMAyd2IvG9/B8H80prZwph/5EPV37tN9JMVvb2GZL84HEeDuTde+PWalnZiEuzi
        2dQ4Ztr04LQh+dd60xZaRDHJ9Bx2reGAhmLL+WxdGAiCfYKAoUNzWz/Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MdpTYhiSVOBN; Fri,  9 Sep 2022 14:22:38 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CE28F56A88;
        Fri,  9 Sep 2022 14:22:37 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 14:22:37 +0300
Received: from yadro.com (172.17.190.47) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 14:22:36 +0300
Date:   Fri, 9 Sep 2022 14:22:35 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
Message-ID: <20220909112235.GD9218@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
 <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
X-Originating-IP: [172.17.190.47]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 07, 2022 at 03:01:00PM -0500, Mike Christie wrote:
> 
> On 9/6/22 2:49 AM, Dmitry Bogdanov wrote:
> > From: Roman Bolshakov <r.bolshakov@yadro.com>
> >
> > Default target port group is always returned in the list of port groups,
> > even if the behaviour is unwanted, i.e. it has no members and
> > non-default port groups are primary port groups.
> >
> > A new port group attribute - "hidden" can be used to hide empty port
> > groups with no ports in REPORT TARGET PORT GROUPS, including default
> > target port group:
> >
> >   echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden
> >
> 
> How about "enable"? I think that fits how we handle other objects like
> targets that are setup automatically but are not yet usable (can't login
> or reported in discovery commands) and devices we have setup but are not
> reported in commands like REPORT_LUNs (technically you need to enable and
> map them but you get the idea I'm going for).
There is already an enable semantic. It is pg_pt_gp_id field. Until it
(id) is not set the port group is treated as disabled and it is not
reported in RTPG. But the default_tg_pt_gp is enabled by default and can
not be deleted.

The patch solves the presence of non-deletable empty default_tg_pt_gp
in RTPG.
May be, a global attribute like target/core/alua/hide_emtpy_tpg would
fit better than an attribute per each port group?

I would always hide the empty default_lu_gp (not configurable) but I am
afraid that it will be considered as not backward compatible change. :(

BR,
 Dmitry 
