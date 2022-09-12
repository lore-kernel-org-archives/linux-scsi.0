Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05D6C6FA86
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 21:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiILVph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 17:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiILVp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 17:45:29 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2294CA1F;
        Mon, 12 Sep 2022 14:45:26 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2B5C6453FB;
        Mon, 12 Sep 2022 21:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1663019123; x=1664833524; bh=WSKVNR4FGtmMv1A/WBOW2mPDxo0uvT5H3b/
        DknNay8s=; b=hDXP6bypzZ1KeFcpSJNlHmt/mIFZEv/pzgNUkUvmIptwbrhKv4X
        CjjXIAXbUI03Pra+GYXtN46LQ+ozsCVhz8dGrtm7YH661OVxOXnJbXpc8BUr2wBI
        YZBH8p9oFhyamPqhghC9HsDynppQX/BapfN2E+h783Qhvp2XWqzZqALI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zIzBOjYIfvHP; Tue, 13 Sep 2022 00:45:23 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BB9B7453CC;
        Tue, 13 Sep 2022 00:45:22 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 13 Sep 2022 00:45:22 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 13 Sep
 2022 00:45:21 +0300
Date:   Tue, 13 Sep 2022 00:45:21 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2] scsi: target: alua: do not report emtpy port group
Message-ID: <20220912214521.GF9218@yadro.com>
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
 <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 12, 2022 at 12:49:22PM -0500, Mike Christie wrote:
> 
> On 9/12/22 7:54 AM, Dmitry Bogdanov wrote:
> > Default target port group is always returned in the list of port
> > groups, even if the behaviour is unwanted, i.e. it has no members and
> > non-default port groups are primary port groups.
> >
> > SPC-4 ("5.15.2.7 Target port asymmetric access state reporting")
> > states that a target MAY not provide info about port groups that do not
> > contain the current port through that the RTPG is received.
> >
> 
> Where is that? I see where it says the state value for a group might not
> be up to date when the RTPG is sent through a different port. Are you
> taking that to mean we don't have to report entire groups?

Yes, you are right, I mixed something up here. Actually, a target
do not MAY not send, it SHALL not send an empty port group:

SPC-4 "6.37 REPORT TARGET PORT GROUPS command":
 The TARGET PORT COUNT field indicates the number of target ports that
are in that target port group and the number of target port descriptors
in the target port group descriptor. Every target port group shall
contain at least one target port. The target port group descriptor
shall include one target port descriptor for each target port in the
target port group.

> 
> Note that I also don't see where it says we have to return every group.
> 
> Remember how ESX used to send a RTPG to one port and expect that it got
> every group and that the state info was all in sync (basically opposite
> if what's in the spec now)?
> 
> The spec and ESX were updated, but I don't know if other OSs did this and
> if/when everyone was updated. Do you know this info? Are the old ESX versions
> that worked like that end of life?

ESXi is kinda a pain. But fortunately it has nothing to do with that
patch :)
> 
> > This patch hides port groups with no ports in REPORT TARGET PORT GROUPS
> > response.
> >
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > ---
> > v2:
> >   new solution - just skip all empty groups
> > ---
> >  drivers/target/target_core_alua.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> > index fb91423a4e2e..c8470e7c0e10 100644
> > --- a/drivers/target/target_core_alua.c
> > +++ b/drivers/target/target_core_alua.c
> > @@ -164,6 +164,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
> >       spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> >       list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
> >                       tg_pt_gp_list) {
> > +             /* Skip empty port groups */
> > +             if (!tg_pt_gp->tg_pt_gp_members)
> > +                     continue;
> >               /*
> >                * Check if the Target port group and Target port descriptor list
> >                * based on tg_pt_gp_members count will fit into the response payload.
> 
