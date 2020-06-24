Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A46DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 10:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6D220CC7
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 10:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592994104;
	bh=ryw44Z/EPBxdhw94ATVsnEt+G9bd1yf/neM/xMmnjPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0yv5+7Y6oT0fJH71D8doIsZnjClHO4A6vvyLw7MwD4pqKv6DH0y8DMJQVc9NbCkzY
	 wNHVTj9c47A8A4egc84SxF+jCg6IwJ/Dr9HR+R0Jjh5zu8rU+MuwYZSEENlyt57Ag+
	 3ec4Hg3gryqSOpZ4ZZHBXMFChvhQNZsjODSP6XL8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390378AbgFXKVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387843AbgFXKVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 06:21:17 -0400
Received: from localhost (unknown [171.61.66.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD8C20706;
        Wed, 24 Jun 2020 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592994077;
        bh=ryw44Z/EPBxdhw94ATVsnEt+G9bd1yf/neM/xMmnjPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lFsxHbr3AxRhXpUmfNHF2DEskt3fDb/Un0y8cPDad7ymlHvAwylcK0tD8qT/uWprq
         TdmBEKTWtRRYV6V6ymLtsuJGau1fmnwWOWz9EXkMPyNYBCslK08B7IZ6ruxzRudj4q
         LX41T8W5TGpyFqB5PyztWwvOwayLiS4Q/PBtv02k=
Date:   Wed, 24 Jun 2020 15:51:12 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     'Kishon Vijay Abraham I' <kishon@ti.com>, robh@kernel.org,
        krzk@kernel.org, linux-samsung-soc@vger.kernel.org,
        avri.altman@wdc.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cang@codeaurora.org, devicetree@vger.kernel.org,
        kwmad.kim@samsung.com, linux-kernel@vger.kernel.org,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Message-ID: <20200624102112.GX2324254@vkoul-mobl>
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
 <20200528011658.71590-1-alim.akhtar@samsung.com>
 <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
 <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
 <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
 <000001d646a6$6cb5fd70$4621f850$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d646a6$6cb5fd70$4621f850$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20-06-20, 07:29, Alim Akhtar wrote:
> Hi Kishon,
> 
> > -----Original Message-----
> > From: Alim Akhtar <alim.akhtar@samsung.com>
> > Sent: 11 June 2020 20:49
> > To: 'Kishon Vijay Abraham I' <kishon@ti.com>; 'Martin K. Petersen'
> > > >>
> > > >> Applied [1,2,3,4,5,9] to 5.9/scsi-queue. The series won't show up
> > > >> in my
> > > > public
> > > >> tree until shortly after -rc1 is released.
> > > >>
> > > > Thanks Martin,
> > > > Hi Rob and Kishon/Vinod
> > > > Can you please pickup dt-bindings and PHY driver respectively?
> > >
> > > You might have CC'ed me only for the PHY patch. I don't have the
> > > dt-bindings in my inbox. Care to re-send what's missing again? This
> > > will be merged after -rc1 is tagged.
> > >
> 
> -rc1 is out, I do not see phy driver patch in your tree[1] yet, let me know if I am looking into right tree.
> [1] -> git://git.kernel.org/pub/scm/linux/kernel/git/phy/linux-phy.git

Right tree
> 
> Thanks! 
> 
> > Sure, will re-send this series.

But patches have not been sent right, pls send and me/Kishon will review

Thanks
-- 
~Vinod
