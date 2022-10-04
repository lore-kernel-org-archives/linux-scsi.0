Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BBAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 16:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJDQl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJDQl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 12:41:58 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5F35F122;
        Tue,  4 Oct 2022 09:41:57 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4D03F4014D;
        Tue,  4 Oct 2022 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1664901715; x=1666716116; bh=Mn5n5/aLSFk9+XxZkn0JrBd8SKCv+h6JPfY
        9TH3SyjQ=; b=rKTcDviSw2wb6TKQjUUIPnV5FgRZigzC8NOUtygwHhg41lMW3RO
        rJBBa/3yKsMSBwusc4ZavFhsAcAZ3QXHEfoLEHfcXlm3wjS3+6ofbty+B3ybNPiA
        +fBO4rfXg5AYVdp+anFGtu4gj86Ufl+7dbWrE11ph52RzRMrIWGEx3f4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WxOFlWq5jGMK; Tue,  4 Oct 2022 19:41:55 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1CBE2400F8;
        Tue,  4 Oct 2022 19:41:54 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 4 Oct 2022 19:41:54 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 4 Oct 2022
 19:41:53 +0300
Date:   Tue, 4 Oct 2022 19:41:52 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 7/7] target: core: check RTPI uniquity for enabled TPG
Message-ID: <20221004164152.GE10901@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-8-d.bogdanov@yadro.com>
 <5f730538-6738-86b9-fefe-da09ad9e0a47@oracle.com>
 <f4d08857-204e-f0ff-600f-8e8c87b6a02d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f4d08857-204e-f0ff-600f-8e8c87b6a02d@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 01, 2022 at 11:19:45AM -0500, michael.christie@oracle.com wrote:
> 
> On 9/29/22 7:02 PM, Mike Christie wrote:
> > On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
> >> Garantee uniquity of RTPI only for enabled target port groups.
> >> Allow any RPTI for disabled tpg until it is enabled.
> >>
> >> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> >> ---
> >>  drivers/target/target_core_fabric_configfs.c | 29 +++++++++++++-
> >>  drivers/target/target_core_internal.h        |  2 +
> >>  drivers/target/target_core_tpg.c             | 40 +++++++++++++-------
> >>  3 files changed, 56 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> >> index a34b5db4eec5..fc1b8f54fb54 100644
> >> --- a/drivers/target/target_core_fabric_configfs.c
> >> +++ b/drivers/target/target_core_fabric_configfs.c
> >> @@ -857,6 +857,7 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
> >>                                                 size_t count)
> >>  {
> >>      struct se_portal_group *se_tpg = to_tpg(item);
> >> +    struct se_portal_group *tpg;
> >>      int ret;
> >>      bool op;
> >>
> >> @@ -867,11 +868,37 @@ static ssize_t target_fabric_tpg_base_enable_store(struct config_item *item,
> >>      if (se_tpg->enabled == op)
> >>              return count;
> >>
> >> +    spin_lock(&g_tpg_lock);
> >> +
> >> +    if (op) {
> >> +            tpg = core_get_tpg_by_rtpi(se_tpg->tpg_rtpi);
> >> +            if (tpg) {
> >> +                    spin_unlock(&g_tpg_lock);
> >> +
> >> +                    pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
> >> +                           se_tpg->se_tpg_tfo->fabric_name,
> >> +                           se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
> >> +                           se_tpg->tpg_rtpi,
> >> +                           tpg->se_tpg_tfo->fabric_name,
> >> +                           tpg->se_tpg_tfo->tpg_get_tag(tpg));
> >> +                    return -EINVAL;
> >> +            }
> >> +    }
> >> +
> >> +    se_tpg->enabled |= 0x10; /* transient state */
> >
> > Just use a mutex and hold it the entire time if
> I was looking at the configfs code and am now not sure what the transient state
> is for. It looks like when doing a read or write configfs holds the buffer->mutex,
> so I don't think userspace would ever see the transient state.
> 
> Can you just drop it?

sysfs lock is per file, so 'enable' and 'rtpi' files can be written in
parallel. But after rewriting of the patchset, this part will be
dropped.


