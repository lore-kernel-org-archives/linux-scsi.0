Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BCAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 01:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD6161242
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 01:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbhIXBlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243687AbhIXBlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 21:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D219261211;
        Fri, 24 Sep 2021 01:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632447598;
        bh=wS1vTfdanTeolFqG6+BwOprrXt9fA9ocCesCstsfaz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZOniup1k2WBdEvqe0zUTShI/0nU7LP+azNYTosMus0zFLH7Fq6fcCZ8wnsf79Pa+
         wBmx2Pqc2RaBXMCWDhaKXskn4qMGz2TQTy295735OXxCfQ0t7vWXmNiFkwUpBzakar
         AXEiT86ORr+UbhUTdPLHbhy9EYHzjIrOEY0DQgXzoLZ49ngS3mdqy6hv65XMSTmO8B
         DWHRAUGrr8hHPHGug+/N/Cfpdyc8vv+GKhFNYUR2hkMbP4IZXgS4DGw0O+xcQP52j+
         +DImiTrG6bdT1W3TUJWEQr2WOfxBqlbt1unriLklN5+HLo5ewI9oCWBSS3P8pS9H16
         PmZZpnYCCtf2Q==
Date:   Thu, 23 Sep 2021 18:39:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and
 registration status
Message-ID: <20210923183956.506bfde2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YU0JlzFOa7kpKgnd@unreal>
References: <cover.1632420430.git.leonro@nvidia.com>
        <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
        <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
        <YU0JlzFOa7kpKgnd@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Sep 2021 02:11:19 +0300 Leon Romanovsky wrote:
> > > @@ -835,9 +837,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
> > >  {
> > >         struct devlink *dl = bp->dl;
> > >
> > > -       if (!dl)
> > > -               return;
> > > -  
> > 
> > minor nit: There's obviously nothing incorrect about doing this (and
> > adding the additional error label in the cleanup code above), but bnxt
> > has generally adopted a style of having cleanup functions being
> > idempotent. It generally makes error handling simpler and less error
> > prone.  
> 
> I would argue that opposite is true. Such "impossible" checks hide unwind
> flow errors, missing releases e.t.c.

+1, fwiw
