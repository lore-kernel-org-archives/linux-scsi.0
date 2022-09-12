Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F09C6FA83
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 12:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiILMaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiILMaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 08:30:14 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05F3EE0B;
        Mon, 12 Sep 2022 05:30:11 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B28EC57E84;
        Mon, 12 Sep 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1662985808; x=1664800209; bh=ZOgukxGWg7DP
        dVGOSa7aV1kjMKfqVkLg8HhCD07XkGo=; b=qXfo8QA3SIv7/1x9LAraL5ciHJbZ
        5uYfYMBK7YgzkQyeU3wwiYhCFHupfLq/IMPGkaEsYV1clKmt1ql9gqH4mpJ6LqtS
        Dl4K51r+tC/RTePPqzXnD3BxlPIJ3N3H2qz1rNOJEhGUz8oYV0aBTpOwc1X3wbtZ
        qsdv0NV2s/exvKU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BML3nGlguWdj; Mon, 12 Sep 2022 15:30:08 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 915A657E76;
        Mon, 12 Sep 2022 15:30:07 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 12 Sep 2022 15:30:07 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 12 Sep
 2022 15:30:06 +0300
Date:   Mon, 12 Sep 2022 15:30:02 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
Message-ID: <20220912123002.GE9218@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
 <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
 <20220909112235.GD9218@yadro.com>
 <YxskUBeZeMPi5By2@yadro.com>
 <b5dc6104-04e1-c3f0-b22d-ff9043cd9f36@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5dc6104-04e1-c3f0-b22d-ff9043cd9f36@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 09, 2022 at 12:24:51PM -0500, Mike Christie wrote:
> 
> On 9/9/22 6:32 AM, Konstantin Shelekhin wrote:
> >> The patch solves the presence of non-deletable empty default_tg_pt_gp
> >> in RTPG.
> >> May be, a global attribute like target/core/alua/hide_emtpy_tpg would
> >> fit better than an attribute per each port group?
> >>
> >> I would always hide the empty default_lu_gp (not configurable) but I am
> >> afraid that it will be considered as not backward compatible change. 🙁
> > A module parameter perhaps? Or a CONFIG definition.
> 
> For the ceph iscsi project we wanted this same behavior for a while and
> we had to use distro kernels. There are probably others that need the same
> thing so a kernel config option wouldn't work for them.
> 
> Module param or a global attr in target/core/alua like Dimitry mentioned
> seem fine. If the new variable is set are you guys thinking that
> core_tpg_add_lun would just not call target_attach_tg_pt_gp? So the variable
> would be "make_default_tg_pt_gp"?
I thought it over one more time.

1. To not report empty port group is a completely backward compatible
change becasue there is no impact on userspace at all. The only change
is in the network response.

2. SPC-4 ("5.15.2.7 Target port asymmetric access state reporting")
tells that a target MAY not provide info about port groups that do not
contain the current port through that the RTPG is received. 

So, according to SPC it is expected behaviour to not report the empty
port groups.

I will prepare new version of the patch with always skipping any empty
port group in RTPG response.

BR,
 Dmitry

