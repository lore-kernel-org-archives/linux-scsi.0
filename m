Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D08ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 06:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIOGIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 02:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIOGIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 02:08:46 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACC4923E3;
        Wed, 14 Sep 2022 23:08:45 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 801754540D;
        Thu, 15 Sep 2022 06:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1663222122; x=1665036523; bh=PdApB1kMEyqu
        pzQ/4fpOS0LO0BizTf0W/oH4UuXKdSc=; b=gjs0NK6nxSVlF2/37JsbGPtg9NMx
        1KtR1paYJL2yXVdkJuth+g34VumkxArSzGO0WsnIcRWlG7GERXtRA8UxrKiBtmTz
        V96dYbaQgZwp89VAKIOD/ACOQ9ZjMUfJguqjM6OYAB4eHyQ2oAnlJ7wCGGq6KOYz
        73AHFc6/ON3yBVg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2y9JOqWYMKYi; Thu, 15 Sep 2022 09:08:42 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D689045409;
        Thu, 15 Sep 2022 09:08:40 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 15 Sep 2022 09:08:40 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 15 Sep
 2022 09:08:40 +0300
Date:   Thu, 15 Sep 2022 09:08:40 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2] scsi: target: alua: do not report emtpy port group
Message-ID: <20220915060840.GG9218@yadro.com>
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
 <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
 <20220912214521.GF9218@yadro.com>
 <82d31d9d-700c-d961-d284-a5a117487adc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82d31d9d-700c-d961-d284-a5a117487adc@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 14, 2022 at 02:18:40PM -0500, Mike Christie wrote:
> 
> On 9/12/22 4:45 PM, Dmitry Bogdanov wrote:
> >> Remember how ESX used to send a RTPG to one port and expect that it got
> >> every group and that the state info was all in sync (basically opposite
> >> if what's in the spec now)?
> >>
> >> The spec and ESX were updated, but I don't know if other OSs did this and
> >> if/when everyone was updated. Do you know this info? Are the old ESX versions
> >> that worked like that end of life?
> > ESXi is kinda a pain. But fortunately it has nothing to do with that
> > patch 😄
> 
> I didn't get why that is. How do you set up a distributed/cluster/HA target? I'm
> probably missing that part.
> 
> Software drivers like iscsi I get, but for HW drivers I didn't see how you do it.
> 
> For example, if you have 2 systems/nodes running LIO which each export the same
> device via 1 port each where one is active/optimized and the other is standby and you
> are using qla2xxx, then on the local node would you create 2 groups:
> 
> [root@ol8n4 alua]# pwd
> /sys/kernel/config/target/core/iblock_0/device0/alua
> 
> [root@ol8n4 alua]# ls
> default_tg_pt_gp  local  remote
> 
> Then under the mapped lun:
> 
> [root@ol8n4 lun_0]# pwd
> /sys/kernel/config/target/..../tpgt_1/lun/lun_0
> 
> in the alua_tg_pt_gp file you set that to local. That would then have tg_pt_gp_members
> set, but remote would not.
> 
> Before your patch, windows and ESX could do a RTPG to just one port/path and we would
> return the default, local and remote groups. We don't want the default group, but we
> wanted the local and remote one returned. With your patch we only return the the local
> one now. I wasn't sure how that works for drivers like qla2xxx.
> 
> For iscsi, you could just mirror the remote node locally, so you would have a second
> tpg:
> 
> [root@ol8n4 lun_0]# pwd
> /sys/kernel/config/target/..../tpgt_2/lun/lun_0
> 
> and in there set alua_tg_pt_gp to remote. Your patch works fine for that because both
> groups then have tg_pt_gp_members set so if the OS just does a RTPG to one path/port
> you get all the groups.
>
I use a virtual remote fabric driver to configure wwn/iqn-tpg-lun of
remote peers at each local node. In that way 'remote' alua port group
will have ports(RTPI) too. That allows RTPG (and other discovery-like
commands) report all ports in all port groups in the cluster.
I sent it within the RFC patchset:
https://patchwork.kernel.org/project/target-devel/patch/20220803162857.27770-36-d.bogdanov@yadro.com/

BR,
 Dmitry
