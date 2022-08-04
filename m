Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E73C19F2D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 11:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiHDLCV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 07:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239574AbiHDLB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 07:01:59 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FA16612D;
        Thu,  4 Aug 2022 04:01:38 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id F3EB441206;
        Thu,  4 Aug 2022 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1659610895; x=1661425296; bh=4LHLeSZvBaOL3ruRawlZj7v11csL/h6O70X
        nB/lr6vw=; b=mOYD69kUDGHDan5UaYQogwuqvjAIyhs45NAF7bZIdHq7dgJtlul
        1QIe8ZB1OVflSdjJzUuDifL3ldPncfNu+cq5cSn5CczKP5ZQHfHQxYc7/YRph4/m
        me+J0HqlQgmfw2JW82zrw3QIayKxkhj+gT9+sL2cOw5zFBGuuIB5lOg4=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ELsdAdG9ANfU; Thu,  4 Aug 2022 14:01:35 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D95A041243;
        Thu,  4 Aug 2022 14:01:21 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 4 Aug 2022 14:01:22 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 4 Aug 2022
 14:01:21 +0300
Date:   Thu, 4 Aug 2022 14:01:21 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [RFC PATCH 00/48] Target cluster implementation over DLM
Message-ID: <20220804110121.GA26907@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
 <21a0a64b-ad8b-f6c3-a958-9d4806ce9fc4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <21a0a64b-ad8b-f6c3-a958-9d4806ce9fc4@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 03, 2022 at 12:36:56PM -0500, Mike Christie wrote:
> 
> On 8/3/22 11:04 AM, Dmitry Bogdanov wrote:
> > Hi linux target comminity.
> >
> > Let's me present RFC of an implementation of cluster features for Target
> > Core that needs for backstore devices shared through cluster nodes.
> >
> > The patchset is big and of several subsets, but it contains some arguable
> > things and it would take too much time to discsuss them separatelly.
> >
> > Patches 1-9:
> > Make RTPI be part of se_tpg instead of se_lun. That is a must because
> > there is no possibility to assign RTPI on a LUN.
> > That data model is different from SCST and current in LIO but still does
> > not contradict with SAM and even is more according to SAM - a whole TCM
> > is a SCSI Device, and all its ports are SCSI Ports with unique RTPIs.
> >  + unique identification of TPG through the cluster.
> >  + possibility of assignment of RPTI.
> >  - number of all TPGs will be limited to 65535.
> > This patchset was published first time 2 years ago [1]. In previous
> > version the peers RTPIs were put in <device>/alua/... folder. In this
> > version the peers RTPIs are part of TPGs on the remote fabric (patch 35).
> >
> > Patches 10-29:
> > Fixes some bugs and deviations from the standard in PR code.
> > Undepend pr_reg from se_nacl and se_tpg to be just a registration holder.
> > Make APTPL registrations (not linked to se_dev_entry) be full-fledged
> > registrations.
> 
> 
> What are the arguable parts? Do you think it will be the DLM part
> and coordinating it with nvmet developers? Or was it patches 1-9
> and the multi-node support? Or both :)
In fact every subset can be a subject to argue :) 
* RTPI patchset - changing data model from RTPI-set on backstore device
to RTPI-set on a whole node.
* PR refactoring - to much changes, may be APTPL changes are not
  backward compatible
* remote/dummy fabric - name 
* DLM_CKV - name, place and even a meaning of the module
* tcm_cluster - too much new exported symbols, not resistant to
  node death in between of storing PR data in DLM_CKV and other error
  cases.

> Is it possible and would it be valuable to at least kind of break this
> up a little?
> 
> I would break this up and post the fixes in one set. I'll help you get
> them in as soon as possible.
After approve of the idea I can break the patch set to several ones
and start to post it without RFC prefix. The only problem is that they
all depend on previous ones. So I have to post each after the previous
gets merged.
> 
> For patches 1-9, I think I remember you posting them before, but I was in
> the middle of starting a new job so I didn't review them. I really needed
> something like that at my last 2 jobs so I think it's a valuable feature
> and I'll review that as well.
> 
> If we could at least get those 2 chunks separated then it would make the DLM
> parts below easier to get eyeballs on. I'm ok with the idea in general. I
> think every nvmet developer will see the massive patchset and not even look at
> this first 0/48 email :)
I am not going to share this patchset to nvmet dev list :)
nvmet does not yet have a local version of CompareAndWrite and
Reservations features, so it is too early for them.
> 
> 
> >
> > Patches 30-34:
> > DLM_CKV module that uses DLM and provides:
> >  * Cluster Lock service (pure wrapper over DLM).
> >  * Cluster Key-Value service in memory storage.
> >  * Cluster Notification service with a blocking acknowledge.
> >  * Cluster membership callbacks.
> > This module is supposed to be used by TCM and nvmet to implement cluster
> > operations.
> >
> > Patch 35:
> > New 'remote' (in fact dummy) fabric module. Configuration on this fabric will
> > provide to TCM a view of TPG/LUN/ACL configuration on a peer nodes.
> >
> > Patche 36:
> > Introduce cluster ops and functions to register a cluster ops
> > implementation modules. There could be a several different modules.
> > The device attrib cluster_impl regulates which implementation to use
> > for that device. 'single' is for default (no cluster) implementation.
> >
> > Patches 37-48:
> > TCM Cluster over DLM module implementation inspired by SCST.
> >  * Use DLM_CKV Lock service to serialize order of PR OUT commands
> >  * Use DLM_CKV Key-Value storage service to store PR cluster data.
> > Sync it after successful execution of PR OUT command.
> >  * Use DLM_CKV Notification service to notify (in blocking manner) other
> > nodes to fetch PR cluster data. The handling of PR OUT command is
> > blocked until other nodes read the cluster PR data.
> >
> > It provides:
> >  * Cluster lock per LBA for Compare And Write.
> >  * Full support of SCSI-3 Persistent Reservations including
> >    PREEMPT AND ABORT and REGISTER AND MOVE.
> >  * Normal PR APTPL imlementation (persistanse over power loss)
> >  * Shared LUN RESET
> >  * Shared SCSI-2 Reservations.
> >  * Unit Attentions for all TPGs in cluster
> >
